import 'dart:async';

import 'package:flutter/material.dart';

/// 轮播内容构建器：传入控制器与真实 item 数量（无限循环时为 null）。
typedef FlPageViewBuilder = Widget Function(FlPageViewController pageController, int? itemCount);

/// 翻页来源：自动播放 timed、用户手动 manual、控制器调用 controller。
enum FlPageViewSource { timed, manual, controller }

/// 支持无限循环、自动播放和切换动画的轮播组件。
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

  /// 页码控制器，不传则由内部创建并自动管理。
  final FlPageViewController? controller;

  /// 轮播内容构建器。
  final FlPageViewBuilder builder;

  /// 轮播项数量，需大于 0。
  final int itemCount;

  /// 固定高度（像素），设置后忽略 [aspectRatio]。
  final double? height;

  /// 未设置 [height] 时使用的宽高比，默认 16/9。
  final double aspectRatio;

  /// 无限循环时是否就近跳转到目标页，默认 true。
  final bool animateToClosest;

  /// 是否开启自动播放，默认 false。
  final bool autoPlay;

  /// 自动播放的间隔时间，默认 3 秒。
  final Duration autoPlayInterval;

  /// 自动播放单次切换的动画时长，默认 800 毫秒。
  final Duration autoPlayAnimationDuration;

  /// 自动播放切换的动画曲线，默认 [Curves.fastOutSlowIn]。
  final Curve autoPlayCurve;

  /// 用户拖动时是否暂停自动播放，松手后恢复，默认 true。
  final bool pauseAutoPlayOnScrolling;

  /// 调用 next/previous/animate 时是否暂停自动播放，默认 true。
  final bool pauseAutoPlayOnManualNavigate;

  /// 非循环滚动到末页时是否停止自动播放，默认 false。
  final bool pauseAutoPlayInFiniteScroll;

  /// 是否在组件销毁时自动销毁 controller，默认 true。
  final bool disposeController;

  @override
  State<FlPageView> createState() => _FlPageViewState();
}

class _FlPageViewState extends State<FlPageView> with WidgetsBindingObserver {
  late FlPageViewController controller;

  @override
  void initState() {
    controller = widget.controller ?? FlPageViewController();
    controller._bindState(this);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    handleAutoPlay();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 应用退到后台时停止计时，回到前台后按当前配置恢复，避免后台空转。
    if (state == AppLifecycleState.resumed) {
      handleAutoPlay();
    } else {
      controller._clearTimer();
    }
  }

  @override
  void didUpdateWidget(FlPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      final FlPageViewController oldController = controller;
      if (oldWidget.disposeController || oldWidget.controller == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => oldController.dispose());
      } else {
        oldController._unbindState();
      }
      controller = widget.controller ?? FlPageViewController();
      controller._bindState(this);
    }
    final bool autoPlayChanged =
        oldWidget.autoPlay != widget.autoPlay ||
        oldWidget.autoPlayInterval != widget.autoPlayInterval ||
        oldWidget.controller != widget.controller;
    if (!oldWidget.autoPlay && widget.autoPlay) controller._userStoppedAutoPlay = false;
    if (autoPlayChanged) handleAutoPlay();
  }

  /// 按当前配置重置或恢复自动播放计时器。
  void handleAutoPlay() {
    controller._clearTimer();
    if (widget.autoPlay) controller._resumeTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final bool shouldDispose = widget.disposeController || widget.controller == null;
    if (shouldDispose) {
      controller.dispose();
    } else {
      controller._unbindState();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget current = widget.builder(controller, controller.isLoop ? null : widget.itemCount);
    if (widget.height != null) {
      current = SizedBox(height: widget.height, child: current);
    } else {
      current = AspectRatio(aspectRatio: widget.aspectRatio, child: current);
    }
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollStartNotification || notification is ScrollUpdateNotification) {
          controller._isScrolling = true;
        }
        if (notification is ScrollEndNotification) {
          controller._isScrolling = false;
          // 部分平台上结束通知会先于 idle 的 UserScrollNotification 到达，
          // 这里直接恢复计时，避免自动播放停住。
          if (widget.autoPlay && widget.pauseAutoPlayOnScrolling) controller._resumeTimer();
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

/// 轮播控制器，在 [PageController] 基础上提供循环换算与自动播放控制。
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

  /// 循环模式下的基准页码，用于无限循环偏移，默认 100000。
  final int realPage;

  /// 初始显示的真实 item 索引，默认 0。
  final int initial;

  /// 是否无限循环，默认 false（不循环时受 itemCount 限制）。
  final bool isLoop;

  /// Whether the page view is currently scrolling
  bool _isScrolling = false;

  /// 是否正在滚动。
  bool get isScrolling => _isScrolling;

  /// The source of the page change
  FlPageViewSource _source = FlPageViewSource.controller;

  /// 最近一次翻页的来源。
  FlPageViewSource get source => _source;

  /// The current state
  _FlPageViewState? _state;

  /// Bind state
  void _bindState(_FlPageViewState state) {
    _state = state;
  }

  /// 解除与 [FlPageView] 的绑定（控制器由外部管理时使用）
  void _unbindState() {
    _clearTimer();
    _state = null;
  }

  /// 是否已绑定且具备可用的页面位置。
  bool get _canNavigate => hasClients && _state != null && page != null;

  /// 手动翻页前暂停自动播放，返回结束后是否需要恢复计时。
  bool _pauseAutoPlayForManualNavigation() {
    final bool needResetTimer = _state!.widget.pauseAutoPlayOnManualNavigate;
    if (needResetTimer) _clearTimer();
    return needResetTimer;
  }

  /// 当前物理页与真实索引信息，无法获取时返回 null。
  ({int itemCount, int current, int index})? _currentPageInfo() {
    if (_state == null || !hasClients) return null;
    final int itemCount = _state!.widget.itemCount;
    if (itemCount <= 0) return null;
    final double? currentPage = page;
    if (currentPage == null) return null;
    final int current = currentPage.toInt();
    return (itemCount: itemCount, current: current, index: _toItemIndex(current, itemCount));
  }

  /// 动画切换到下一页，默认 300 毫秒、线性曲线。
  Future<void> next({Duration duration = const Duration(milliseconds: 300), Curve curve = Curves.linear}) async {
    if (!_canNavigate) return;
    final bool needResetTimer = _pauseAutoPlayForManualNavigation();
    _source = FlPageViewSource.controller;
    await nextPage(duration: duration, curve: curve);
    if (needResetTimer) _resumeTimer();
  }

  /// 动画切换到上一页，默认 300 毫秒、线性曲线。
  Future<void> previous({Duration duration = const Duration(milliseconds: 300), Curve curve = Curves.linear}) async {
    if (!_canNavigate) return;
    final bool needResetTimer = _pauseAutoPlayForManualNavigation();
    _source = FlPageViewSource.controller;
    await previousPage(duration: duration, curve: curve);
    if (needResetTimer) _resumeTimer();
  }

  /// 无动画跳转到真实索引 [page] 对应的页面。
  void jump(int page) {
    final info = _currentPageInfo();
    if (info == null) return;
    final bool needResetTimer = _pauseAutoPlayForManualNavigation();
    _source = FlPageViewSource.controller;
    int pageToJump = info.current + page - info.index;
    if (!isLoop) pageToJump = pageToJump.clamp(0, info.itemCount - 1);
    jumpToPage(pageToJump);
    if (needResetTimer) _resumeTimer();
  }

  /// 动画切换到真实索引 [page] 对应的页面。
  Future<void> animate(
    int page, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
  }) async {
    final info = _currentPageInfo();
    if (info == null) return;
    final bool needResetTimer = _pauseAutoPlayForManualNavigation();
    int smallestMovement = page - info.index;
    if (isLoop && _state!.widget.animateToClosest) {
      if ((page - info.index).abs() > (page + info.itemCount - info.index).abs()) {
        smallestMovement = page + info.itemCount - info.index;
      } else if ((page - info.index).abs() > (page - info.itemCount - info.index).abs()) {
        smallestMovement = page - info.itemCount - info.index;
      }
    }
    _source = FlPageViewSource.controller;
    int target = info.current + smallestMovement;
    if (!isLoop) target = target.clamp(0, info.itemCount - 1);
    await animateToPage(target, duration: duration, curve: curve);
    if (needResetTimer) _resumeTimer();
  }

  /// 把底层 page 位置换算为真实 item 索引。
  int getIndex(int index) {
    if (_state == null) return index;
    return _toItemIndex(index, _state!.widget.itemCount);
  }

  /// 把底层 page 位置换算为真实 item 索引
  int _toItemIndex(int position, int itemCount) {
    if (itemCount <= 0) return 0;
    if (!isLoop) return position.clamp(0, itemCount - 1);
    final int result = (position - realPage) % itemCount;
    return result < 0 ? result + itemCount : result;
  }

  /// 当前真实页码（含小数进度），未绑定或数据为空时返回 null。
  double? getPage() {
    if (_state == null || !hasClients) return null;
    final int itemCount = _state!.widget.itemCount;
    if (itemCount <= 0) return null;
    final double? currentPage = page;
    if (currentPage == null) return null;
    double result = isLoop ? currentPage - realPage : currentPage;
    if (isLoop) {
      result = result % itemCount;
      if (result < 0) result += itemCount;
    }
    if (result < 0) result = 0;
    if (result > itemCount - 1) result = itemCount - 1;
    return result;
  }

  /// 恢复自动播放。
  void startAutoPlay() {
    _userStoppedAutoPlay = false;
    _resumeTimer();
  }

  /// 停止自动播放。
  void stopAutoPlay() {
    _userStoppedAutoPlay = true;
    _clearTimer();
  }

  /// The timer used to automatically advance the carousel
  Timer? _timer;

  bool _userStoppedAutoPlay = false;

  /// Clear the timer
  void _clearTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Resume the timer
  void _resumeTimer() {
    if (_state == null || !_state!.widget.autoPlay || _userStoppedAutoPlay || _timer != null) return;
    if (_state!.widget.pauseAutoPlayOnScrolling && _isScrolling) return;
    _timer = Timer(_state!.widget.autoPlayInterval, _handleAutoPlayTick);
  }

  Future<void> _handleAutoPlayTick() async {
    _timer = null;
    if (_state == null || !hasClients || !_state!.context.mounted) return;
    if (!_state!.widget.autoPlay || _userStoppedAutoPlay) return;
    if (_state!.widget.pauseAutoPlayOnScrolling && _isScrolling) return;
    final route = ModalRoute.of(_state!.context);
    if (route?.isCurrent == false) {
      _resumeTimer();
      return;
    }
    final FlPageViewSource previousReason = _source;
    _source = FlPageViewSource.timed;
    final double? currentPage = page;
    if (currentPage == null) {
      _source = previousReason;
      _resumeTimer();
      return;
    }
    int nextPage = currentPage.round() + 1;
    bool wrapToStart = false;
    if (nextPage >= _state!.widget.itemCount && !isLoop) {
      if (_state!.widget.pauseAutoPlayInFiniteScroll) {
        _clearTimer();
        return;
      }
      nextPage = 0;
      wrapToStart = true;
    }
    try {
      if (wrapToStart) {
        jumpToPage(0);
      } else {
        await animateToPage(
          nextPage,
          duration: _state!.widget.autoPlayAnimationDuration,
          curve: _state!.widget.autoPlayCurve,
        );
      }
    } on Exception {
      // 动画被打断（如外部调用 animate）时继续走后续的恢复逻辑，
      // 避免自动播放永久停止。
    }
    if (_state == null) return;
    if (_source == FlPageViewSource.timed) _source = previousReason;
    _resumeTimer();
  }

  @override
  void dispose() {
    _clearTimer();
    _state = null;
    super.dispose();
  }
}
