import 'dart:async';
import 'package:flutter/material.dart';

typedef FlPageViewBuilder = Widget Function(
    FlPageViewController pageController, int? itemCount);

enum FlPageViewSource { timed, manual, controller }

class FlPageView extends StatefulWidget {
  const FlPageView({
    super.key,
    required this.itemCount,
    required this.builder,
    this.controller,
    this.height,
    this.aspectRatio = 16 / 9,
    this.animateToClosest = true,
    this.disposeController = true,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
    this.autoPlayCurve = Curves.fastOutSlowIn,
    this.pauseAutoPlayOnScrolling = true,
    this.pauseAutoPlayOnManualNavigate = true,
    this.pauseAutoPlayInFiniteScroll = false,
  });

  /// The page controller to use.
  final FlPageViewController? controller;

  /// Widget builder for the entire carousel.
  final FlPageViewBuilder builder;

  /// Number of items in the carousel.
  final int itemCount;

  /// Set carousel height and overrides any existing [aspectRatio].
  final double? height;

  /// Aspect ratio is used if no height have been declared.
  /// Defaults to 16:9 aspect ratio.
  final double aspectRatio;

  ///Determines if carousel should loop to the closest occurence of requested page.
  ///Defaults to true.
  final bool animateToClosest;

  /// Enables auto play, sliding one page at a time.
  /// Use [autoPlayInterval] to determent the frequency of slides.
  /// Defaults to false.
  final bool autoPlay;

  /// Sets Duration to determent the frequency of slides when
  /// [autoPlay] is set to true.
  /// Defaults to 3 seconds.
  final Duration autoPlayInterval;

  /// Animation duration when auto play slides to the next page.   Defaults to 800 ms.
  final Duration autoPlayAnimationDuration;

  /// Animation curve when auto play slides to the next page. defaults to [Curves.fastOutSlowIn].
  final Curve autoPlayCurve;

  /// If `true`, the auto play function will be paused when user is interacting with
  /// the page view, and will be resumed when user finish interacting.
  /// Default to `true`.
  final bool pauseAutoPlayOnScrolling;

  /// If `true`, the auto play function will be paused when user is calling
  /// controller's `next` or `previous` or `animate` method.
  /// And after the animation complete, the auto play will be resumed.
  /// Default to `true`.
  final bool pauseAutoPlayOnManualNavigate;

  /// If `true`, the auto play function will be paused when user is scrolling
  /// to the edge of the page view.
  final bool pauseAutoPlayInFiniteScroll;

  /// Dispose the controller when the widget is disposed
  final bool disposeController;

  @override
  State<FlPageView> createState() => _FlPageViewState();
}

class _FlPageViewState extends State<FlPageView> with TickerProviderStateMixin {
  late FlPageViewController controller;

  @override
  void initState() {
    controller = widget.controller ?? FlPageViewController();
    controller._bindState(this);
    super.initState();
    handleAutoPlay();
  }

  @override
  void didUpdateWidget(FlPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    handleAutoPlay();
  }

  void handleAutoPlay() {
    bool autoPlay = widget.autoPlay;
    if (autoPlay && controller._timer != null) return;
    controller._clearTimer();
    if (autoPlay) controller._resumeTimer();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget current =
        widget.builder(controller, controller.isLoop ? null : widget.itemCount);
    if (widget.height != null) {
      current = SizedBox(height: widget.height, child: current);
    } else {
      current = AspectRatio(aspectRatio: widget.aspectRatio, child: current);
    }
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollStartNotification ||
            notification is ScrollUpdateNotification) {
          controller._isScrolling = true;
        }
        if (notification is ScrollEndNotification) {
          controller._isScrolling = false;
        }
        if (notification is UserScrollNotification && widget.autoPlay) {
          controller._source = FlPageViewSource.manual;
          if (widget.pauseAutoPlayOnScrolling) {
            if (controller._isScrolling) {
              controller._clearTimer();
            } else {
              controller._resumeTimer();
            }
          }
        }
        return false;
      },
      child: current,
    );
  }
}

class FlPageViewController extends PageController {
  FlPageViewController({
    this.initial = 0,
    this.realPage = 100000,
    this.isLoop = false,
    super.keepPage = true,
    super.viewportFraction = 1.0,
    super.onAttach,
    super.onDetach,
  }) : super(initialPage: isLoop ? realPage + initial : initial);

  /// The real page
  final int realPage;

  /// Determines the initial page to display.
  final int initial;

  ///Determines if carousel should loop infinitely or be limited to item length.
  ///
  ///Defaults to true, i.e. infinite loop.
  final bool isLoop;

  /// Whether the page view is currently scrolling
  bool _isScrolling = false;

  bool get isScrolling => _isScrolling;

  /// The source of the page change
  FlPageViewSource _source = FlPageViewSource.controller;

  FlPageViewSource get source => _source;

  /// The current state
  _FlPageViewState? _state;

  /// Bind state
  void _bindState(_FlPageViewState state) {
    _state = state;
  }

  /// Animate to the next page
  Future<void> next(
      {Duration duration = const Duration(milliseconds: 300),
      Curve curve = Curves.linear}) async {
    if (page == null || _state == null) return;
    final isNeedResetTimer = _state!.widget.pauseAutoPlayOnManualNavigate;
    if (isNeedResetTimer) {
      _resumeTimer();
    }
    _source = FlPageViewSource.controller;
    await nextPage(duration: duration, curve: curve);
    if (isNeedResetTimer) {
      _resumeTimer();
    }
  }

  /// Animate to the previous page
  Future<void> previous(
      {Duration duration = const Duration(milliseconds: 300),
      Curve curve = Curves.linear}) async {
    if (page == null || _state == null) return;
    final isNeedResetTimer = _state!.widget.pauseAutoPlayOnManualNavigate;
    if (isNeedResetTimer) {
      _clearTimer();
    }
    _source = FlPageViewSource.controller;
    await previousPage(duration: duration, curve: curve);
    if (isNeedResetTimer) {
      _resumeTimer();
    }
  }

  /// Jump to a page
  void jump(int page) {
    if (this.page == null || _state == null) return;
    final index = _getIndex(
        this.page!.toInt(), (realPage - initial), _state!.widget.itemCount);
    _source = FlPageViewSource.controller;
    final pageToJump = this.page!.toInt() + page - index;
    return jumpToPage(pageToJump);
  }

  /// Animate to a page
  Future<void> animate(
    int page, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
  }) async {
    if (this.page == null || _state == null) return;
    final bool isNeedResetTimer = _state!.widget.pauseAutoPlayOnManualNavigate;
    if (isNeedResetTimer) {
      _clearTimer();
    }
    final itemCount = _state!.widget.itemCount;
    final index = _getIndex(this.page!.toInt(), realPage - initial, itemCount);
    int smallestMovement = page - index;
    if (isLoop && _state!.widget.animateToClosest) {
      if ((page - index).abs() > (page + itemCount - index).abs()) {
        smallestMovement = page + itemCount - index;
      } else if ((page - index).abs() > (page - itemCount - index).abs()) {
        smallestMovement = page - itemCount - index;
      }
    }
    _source = FlPageViewSource.controller;
    await animateToPage(this.page!.toInt() + smallestMovement,
        duration: duration, curve: curve);
    if (isNeedResetTimer) {
      _resumeTimer();
    }
  }

  /// Returns the index of the page
  int getIndex(int index) {
    if (_state == null) return index;
    final itemCount = _state!.widget.itemCount;
    return _getIndex(index + initial, realPage, itemCount);
  }

  /// Returns the real index of the page
  int _getIndex(int position, int base, int? length) {
    final int offset = position - base;
    if (length == 0) return 0;
    final int result = offset % length!;
    return result < 0 ? length + result : result;
  }

  double? getPage() {
    if (_state == null || page == null) return null;
    final itemCount = _state!.widget.itemCount;
    final double offset = page! + initial - realPage;
    double result = offset % itemCount;
    if (result < 0) result += itemCount;
    if (result > itemCount - 1) {
      result = itemCount - 1;
    }
    return result;
  }

  /// Start auto play
  void startAutoPlay() {
    _resumeTimer();
  }

  /// Stop auto play
  void stopAutoPlay() {
    _clearTimer();
  }

  /// The timer used to automatically advance the carousel
  Timer? _timer;

  /// Clear the timer
  void _clearTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Resume the timer
  void _resumeTimer() {
    if (_state == null || !_state!.widget.autoPlay) return;
    _timer ??= Timer.periodic(_state!.widget.autoPlayInterval, (_) {
      if (page == null || _state == null) return;
      if (!_state!.context.mounted) {
        _clearTimer();
        return;
      }
      final route = ModalRoute.of(_state!.context);
      if (route?.isCurrent == false) return;
      FlPageViewSource previousReason = _source;
      _source = FlPageViewSource.timed;
      int nextPage = page!.round() + 1;
      if (nextPage >= _state!.widget.itemCount && !isLoop) {
        if (_state!.widget.pauseAutoPlayInFiniteScroll) {
          _clearTimer();
          return;
        }
        nextPage = 0;
      }
      animateToPage(
        nextPage,
        duration: _state!.widget.autoPlayAnimationDuration,
        curve: _state!.widget.autoPlayCurve,
      ).then((_) => _source = previousReason);
    });
  }

  @override
  void dispose() {
    _clearTimer();
    _state = null;
    super.dispose();
  }
}
