import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/widgets/carousel/controller.dart';

typedef CarouselOnTap = void Function(int index);

///  Default auto play transition duration
const Duration kDefaultAutoPlayTransitionDuration = Duration(milliseconds: 400);

///  default auto play Duration
const Duration kDefaultAutoPlayDelay = Duration(seconds: 3);

class Carousel extends StatefulWidget {
  Carousel.builder({
    Key key,
    @required this.itemBuilder,
    @required this.itemCount,
    this.autoPlay = false,
    CarouselLayout layout,
    Duration duration,
    Duration transitionDuration,
    List<CarouselPlugin> pagination,
    this.onChanged,
    this.index,
    this.onTap,
    this.loop = true,
    this.curve = Curves.ease,
    this.scrollDirection = Axis.horizontal,
    this.controller,
    this.itemHeight,
    this.itemWidth,
  })  : assert(itemCount != null),
        assert(itemBuilder != null),
        pagination = pagination ?? <CarouselPlugin>[],
        layout = layout ?? CarouselLayout.stack,
        duration = duration ?? kDefaultAutoPlayDelay,
        transitionDuration =
            transitionDuration ?? kDefaultAutoPlayTransitionDuration,
        transformer = ScaleAndFadeTransformer(),
        physics = null,
        pageSnapping = true,
        pageController = null,
        viewportFraction = 1.0,
        super(key: key);

  Carousel.pageView({
    Key key,
    @required this.itemCount,
    this.itemBuilder,
    this.transformer,
    Duration duration,
    bool pageSnapping,
    bool autoPlay,
    this.curve = Curves.ease,
    this.viewportFraction = 1.0,
    this.scrollDirection = Axis.horizontal,
    this.physics,
    this.onChanged,
    this.pageController,
    this.controller,
    this.loop = true,
  })  : assert(itemCount != null),
        assert(itemBuilder != null || transformer != null),
        pagination = <CarouselPlugin>[],
        pageSnapping = pageSnapping ?? true,
        autoPlay = autoPlay ?? false,
        duration = duration ?? kDefaultAutoPlayTransitionDuration,
        itemHeight = 0,
        itemWidth = 0,
        onTap = null,
        transitionDuration = null,
        index = 0,
        layout = null,
        super(key: key);

  ///  Inner item height, this property is valid if layout=stack or layout=tinder or LAYOUT=custom,
  final double itemHeight;

  ///  Inner item width, this property is valid if layout=stack or layout=tinder or LAYOUT=custom,
  final double itemWidth;

  ///  Build item on index
  final IndexedWidgetBuilder itemBuilder;

  ///  count of the display items
  final int itemCount;

  ///  当用户手动拖拽或者自动播放引起下标改变的时候调用
  final ValueChanged<int> onChanged;

  ///  auto play config
  ///  自动播放开关.
  final bool autoPlay;

  ///  Animation duration
  final Duration duration;

  ///  play transition duration
  final Duration transitionDuration;

  ///  horizontal/vertical
  final Axis scrollDirection;

  ///  transition curve
  final Curve curve;

  ///  Set to false to disable continuous loop mode.
  ///  无限轮播模式开关
  final bool loop;

  ///  Index number of initial slide.
  ///  If not set , the `Carousel` is 'uncontrolled', which means manage index by itself
  ///  If set , the `Carousel` is 'controlled', which means the index is fully managed by parent widget.
  ///  初始的时候下标位置
  final int index;

  ///  Called when tap
  ///  当用户点击某个轮播的时候调用
  final CarouselOnTap onTap;

  ///  other plugins, you can custom your own plugin
  final List<CarouselPlugin> pagination;

  ///  控制器
  final CarouselController controller;

  ///  Build in layouts
  final CarouselLayout layout;
  final PageTransformer transformer;

  ///  Same as [PageView.scrollDirection]

  ///  Same as [PageView.physics]
  final ScrollPhysics physics;

  ///  Set to false to disable page snapping, useful for custom scroll behavior.
  ///  Same as [PageView.pageSnapping]
  final bool pageSnapping;

  final TransformerController pageController;

  ///  This value is only valid when `pageController` is not set,
  final double viewportFraction;

  @override
  State<StatefulWidget> createState() =>
      layout == null ? _CarouselPageViewState() : _CarouselState();
}

class _CarouselPageViewState extends State<Carousel> {
  Size _size;
  int _activeIndex;
  double _currentPixels;
  bool _done = false;
  int _fromIndex;

  PageTransformer _transformer;
  TransformerController _pageController;
  CarouselController _controller;

  @override
  void initState() {
    _transformer = widget.transformer;
    _pageController = TransformerController(
        itemCount: widget.itemCount ?? widget?.pageController?.itemCount,
        reverse: widget?.pageController?.reverse ?? false,
        loop: widget?.loop ?? widget?.pageController?.loop ?? true);
    _fromIndex = _activeIndex = _pageController.initialPage;
    _controller = widget.controller ?? CarouselController();
    _controller.autoPlay = widget.autoPlay;
    _controller?.addListener(onChangeNotifier);
    super.initState();
  }

  Widget buildItemNormal(BuildContext context, int index) {
    final int renderIndex = _pageController.getRenderIndexFromRealIndex(index);
    final Widget child = widget.itemBuilder(context, renderIndex);
    return child;
  }

  Widget buildItem(BuildContext context, int index) => AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext c, Widget w) {
        final int renderIndex =
            _pageController.getRenderIndexFromRealIndex(index);
        final Widget child = widget.itemBuilder != null
            ? widget.itemBuilder(context, renderIndex)
            : Container();
        if (_size == null) return Container();
        final double page = _pageController.realPage;
        double position = _transformer.reverse ? page - index : index - page;
        position *= widget.viewportFraction;
        final TransformInfo info = TransformInfo(
            index: renderIndex,
            width: _size.width,
            height: _size.height,
            position: position.clamp(-1.0, 1.0).toDouble(),
            activeIndex:
                _pageController.getRenderIndexFromRealIndex(_activeIndex),
            fromIndex: _fromIndex,
            forward: _pageController.position.pixels - _currentPixels >= 0,
            done: _done,
            scrollDirection: widget.scrollDirection,
            viewportFraction: widget.viewportFraction);
        return _transformer.transform(child, info);
      });

  void calcCurrentPixels() => _currentPixels =
      _pageController.getRenderIndexFromRealIndex(_activeIndex) *
          _pageController.position.viewportDimension *
          widget.viewportFraction;

  @override
  Widget build(BuildContext context) {
    final IndexedWidgetBuilder builder =
        _transformer == null ? buildItemNormal : buildItem;
    Widget child = PageView.builder(
        itemBuilder: builder,
        itemCount: _pageController.getRealItemCount(),
        onPageChanged: (int index) {
          _activeIndex = index;
          if (widget.onChanged != null)
            widget
                .onChanged(_pageController.getRenderIndexFromRealIndex(index));
        },
        controller: _pageController,
        scrollDirection: widget.scrollDirection,
        physics: widget.physics,
        pageSnapping: widget.pageSnapping,
        reverse: _pageController.reverse);
    if (_transformer != null) {
      child = NotificationListener<ScrollNotification>(
          child: child,
          onNotification: (ScrollNotification notification) {
            if (notification is ScrollStartNotification) {
              calcCurrentPixels();
              _done = false;
              _fromIndex = _activeIndex;
            } else if (notification is ScrollEndNotification) {
              calcCurrentPixels();
              _fromIndex = _activeIndex;
              _done = true;
            }
            return false;
          });
    }
    if (widget.pagination.isEmpty) return child;
    final List<Widget> children = <Widget>[child];
    widget?.pagination?.map((CarouselPlugin plugin) {
      children.add(plugin.build(
          context,
          CarouselPluginConfig(
              itemCount: widget.itemCount,
              activeIndex: _activeIndex,
              scrollDirection: widget.scrollDirection,
              controller: _controller,
              loop: widget.loop)));
    })?.toList();
    return Stack(children: children);
  }

  void _onGetSize(Duration timeStamp) {
    Size size;
    if (context == null) {
      onGetSize(size);
      return;
    }
    final RenderObject renderObject = context.findRenderObject();
    if (renderObject != null) {
      final Rect bounds = renderObject.paintBounds;
      if (bounds != null) size = bounds.size;
    }
    calcCurrentPixels();
    onGetSize(size);
  }

  void onGetSize(Size size) {
    if (mounted) {
      _size = size;
      setState(() {});
    }
  }

  int calcNextIndex(bool next) {
    int currentIndex = _activeIndex;
    if (_pageController.reverse) {
      next ? currentIndex-- : currentIndex++;
    } else {
      next ? currentIndex++ : currentIndex--;
    }
    if (!_pageController.loop) {
      if (currentIndex >= _pageController.itemCount) {
        currentIndex = 0;
      } else if (currentIndex < 0) {
        currentIndex = _pageController.itemCount - 1;
      }
    }
    return currentIndex;
  }

  void onChangeNotifier() {
    final CarouselEvent event = _controller.event;
    int index;
    switch (event) {
      case CarouselEvent.move:
        index = _pageController
            .getRealIndexFromRenderIndex(widget.controller.index);
        break;
      case CarouselEvent.previous:
      case CarouselEvent.next:
        index = calcNextIndex(event == CarouselEvent.next);
        break;
      default:
        return;
    }
    if (_controller.animation) {
      _pageController
          .animateToPage(index,
              duration: widget.duration, curve: widget.curve ?? Curves.ease)
          .whenComplete(_controller.complete);
    } else {
      _pageController.jumpToPage(index);
      _controller.complete();
    }
  }

  @override
  void didChangeDependencies() {
    if (_transformer != null) Ts.addPostFrameCallback(_onGetSize);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller?.removeListener(onChangeNotifier);
    super.dispose();
  }
}

abstract class _CarouselTimerMixin extends State<Carousel> {
  Timer _timer;

  CarouselController _controller;

  @override
  void initState() {
    _controller = widget.controller ?? CarouselController();
    _controller.addListener(_onController);
    _handleAutoPlay();
    super.initState();
  }

  void _onController() {
    switch (_controller.event) {
      case CarouselEvent.start:
        if (_timer == null) _startAutoPlay();
        break;
      case CarouselEvent.stop:
        if (_timer != null) _stopAutoPlay();
        break;
      case CarouselEvent.move:
        break;
      case CarouselEvent.next:
        break;
      case CarouselEvent.previous:
        break;
    }
  }

  void _handleAutoPlay() {
    if (_autoPlayEnabled() && _timer != null) return;
    _stopAutoPlay();
    if (_autoPlayEnabled()) _startAutoPlay();
  }

  @override
  void didUpdateWidget(Carousel oldWidget) {
    if (_controller != oldWidget.controller && oldWidget.controller != null) {
      oldWidget.controller.removeListener(_onController);
      _controller = oldWidget.controller;
      _controller.addListener(_onController);
    }
    _handleAutoPlay();
    super.didUpdateWidget(oldWidget);
  }

  bool _autoPlayEnabled() => _controller.autoPlay ?? widget.autoPlay;

  void _startAutoPlay() {
    _timer = Ts.timerPeriodic(
        widget.duration, (Timer timer) => _controller.next(animation: true));
  }

  void _stopAutoPlay() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopAutoPlay();
    super.dispose();
  }
}

class _CarouselState extends _CarouselTimerMixin {
  int _activeIndex;

  @override
  void initState() {
    _activeIndex = widget.index ?? 0;
    super.initState();
  }

  @override
  void didUpdateWidget(Carousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != null && widget.index != _activeIndex)
      _activeIndex = widget.index;
  }

  Widget get buildCarousel {
    final IndexedWidgetBuilder itemBuilder = widget.onTap == null
        ? widget.itemBuilder
        : (BuildContext context, int index) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => widget.onTap(index),
            child: widget.itemBuilder(context, index));
    return _SubCarousel(
        loop: widget.loop,
        layout: widget.layout,
        itemWidth: widget.itemWidth,
        itemHeight: widget.itemHeight,
        itemCount: widget.itemCount,
        itemBuilder: itemBuilder,
        index: _activeIndex,
        curve: widget.curve,
        duration: widget.transitionDuration,
        onChanged: (int index) {
          _activeIndex = index;
          setState(() {});
          if (widget.onChanged != null) widget.onChanged(index);
        },
        controller: _controller,
        scrollDirection: widget.scrollDirection);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pagination.isEmpty) return buildCarousel;
    final List<Widget> children = <Widget>[buildCarousel];
    widget?.pagination?.map((CarouselPlugin plugin) {
      children.add(plugin.build(
          context,
          CarouselPluginConfig(
              itemCount: widget.itemCount,
              activeIndex: _activeIndex,
              scrollDirection: widget.scrollDirection,
              controller: _controller,
              loop: widget.loop)));
    })?.toList();
    return Stack(children: children);
  }
}

class _SubCarousel extends StatefulWidget {
  const _SubCarousel(
      {Key key,
      this.loop,
      this.itemHeight,
      this.itemWidth,
      this.duration,
      this.curve,
      this.itemBuilder,
      this.controller,
      this.index,
      this.itemCount,
      this.scrollDirection = Axis.horizontal,
      this.onChanged,
      this.layout})
      : super(key: key);

  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final int index;
  final ValueChanged<int> onChanged;
  final CarouselController controller;
  final Duration duration;
  final Curve curve;
  final double itemWidth;
  final double itemHeight;
  final bool loop;
  final Axis scrollDirection;
  final CarouselLayout layout;

  @override
  State<StatefulWidget> createState() =>
      layout == CarouselLayout.tinder ? _TinderState() : _StackState();

  int getCorrectIndex(int indexNeedsFix) {
    if (itemCount == 0) return 0;
    int value = indexNeedsFix % itemCount;
    if (value < 0) value += itemCount;
    return value;
  }
}

class _TinderState extends _LayoutState<_SubCarousel> {
  List<double> scales;
  List<double> offsetsX;
  List<double> offsetsY;
  List<double> opacity;
  List<double> rotates;

  double getOffsetY(double scale) =>
      widget.itemHeight - widget.itemHeight * scale;

  @override
  void didUpdateWidget(_SubCarousel oldWidget) {
    _updateValues();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void afterRender() {
    super.afterRender();
    _startIndex = -3;
    _animationCount = 5;
    opacity = <double>[0.0, 0.9, 0.9, 1.0, 0.0, 0.0];
    scales = <double>[0.80, 0.80, 0.85, 0.90, 1.0, 1.0, 1.0];
    rotates = <double>[0.0, 0.0, 0.0, 0.0, 20.0, 25.0];
    _updateValues();
  }

  void _updateValues() {
    if (widget.scrollDirection == Axis.horizontal) {
      offsetsX = <double>[0.0, 0.0, 0.0, 0.0, _carouselWidth, _carouselWidth];
      offsetsY = <double>[0.0, 0.0, -5.0, -10.0, -15.0, -20.0];
    } else {
      offsetsX = <double>[0.0, 0.0, 5.0, 10.0, 15.0, 20.0];
      offsetsY = <double>[0.0, 0.0, 0.0, 0.0, _carouselHeight, _carouselHeight];
    }
  }

  @override
  Widget _buildItem(int i, int realIndex, double animationValue) {
    final double s = _getValue(scales, animationValue, i);
    final double f = _getValue(offsetsX, animationValue, i);
    final double fy = _getValue(offsetsY, animationValue, i);
    final double o = _getValue(opacity, animationValue, i);
    final double a = _getValue(rotates, animationValue, i);
    final Alignment alignment = widget.scrollDirection == Axis.horizontal
        ? Alignment.bottomCenter
        : Alignment.centerLeft;
    return Opacity(
        opacity: o,
        child: Transform.rotate(
            angle: a / 180.0,
            child: Transform.translate(
              key: ValueKey<int>(_currentIndex + i),
              offset: Offset(f, fy),
              child: Transform.scale(
                  scale: s,
                  alignment: alignment,
                  child: SizedBox(
                    width: widget.itemWidth ?? double.infinity,
                    height: widget.itemHeight ?? double.infinity,
                    child: widget.itemBuilder(context, realIndex),
                  )),
            )));
  }
}

double _getValue(List<double> values, double animationValue, int index) {
  double s = values[index];
  if (animationValue >= 0.5) {
    if (index < values.length - 1)
      s = s + (values[index + 1] - s) * (animationValue - 0.5) * 2.0;
  } else {
    if (index != 0)
      s = s - (s - values[index - 1]) * (0.5 - animationValue) * 2.0;
  }
  return s;
}

class _StackState extends _LayoutState<_SubCarousel> {
  List<double> scales;
  List<double> offsets;
  List<double> opacity;

  void _updateValues() {
    if (widget.scrollDirection == Axis.horizontal) {
      final double space = (_carouselWidth - widget.itemWidth) / 2;
      offsets = <double>[
        -space,
        -space / 3 * 2,
        -space / 3,
        0.0,
        _carouselWidth
      ];
    } else {
      final double space = (_carouselHeight - widget.itemHeight) / 2;
      offsets = <double>[
        -space,
        -space / 3 * 2,
        -space / 3,
        0.0,
        _carouselHeight
      ];
    }
  }

  @override
  void didUpdateWidget(_SubCarousel oldWidget) {
    _updateValues();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void afterRender() {
    super.afterRender();
    _animationCount = 5;

    /// Array below this line, '0' index is 1.0 ,witch is the first item show in carousel.
    _startIndex = -3;
    scales = <double>[0.7, 0.8, 0.9, 1.0, 1.0];
    opacity = <double>[0.0, 0.5, 1.0, 1.0, 1.0];
    _updateValues();
  }

  @override
  Widget _buildItem(int i, int realIndex, double animationValue) {
    final double s = _getValue(scales, animationValue, i);
    final double f = _getValue(offsets, animationValue, i);
    final double o = _getValue(opacity, animationValue, i);
    final Offset offset = widget.scrollDirection == Axis.horizontal
        ? Offset(f, 0.0)
        : Offset(0.0, f);
    final Alignment alignment = widget.scrollDirection == Axis.horizontal
        ? Alignment.centerLeft
        : Alignment.topCenter;
    return Opacity(
        opacity: o,
        child: Transform.translate(
          key: ValueKey<int>(_currentIndex + i),
          offset: offset,
          child: Transform.scale(
              scale: s,
              alignment: alignment,
              child: SizedBox(
                width: widget.itemWidth ?? double.infinity,
                height: widget.itemHeight ?? double.infinity,
                child: widget.itemBuilder(context, realIndex),
              )),
        ));
  }
}

///  _LayoutState
abstract class _LayoutState<T extends _SubCarousel> extends State<T>
    with SingleTickerProviderStateMixin {
  double _carouselWidth;
  double _carouselHeight;
  Animation<double> _animation;
  AnimationController _animationController;
  int _startIndex;
  int _animationCount;
  int _currentIndex = 0;

  @override
  void initState() {
    if (widget.itemWidth == null)
      throw Exception(
          '==============\n\nwidget.itemWith must not be null when use stack layout.\n========\n');
    _createAnimationController();
    widget.controller.addListener(_onController);
    super.initState();
  }

  void _createAnimationController() {
    _animationController = AnimationController(vsync: this, value: 0.5);
    final Tween<double> tween = Tween<double>(begin: 0.0, end: 1.0);
    _animation = tween.animate(_animationController);
  }

  @override
  void didChangeDependencies() {
    Ts.addPostFrameCallback((Duration duration) => afterRender());
    super.didChangeDependencies();
  }

  @mustCallSuper
  void afterRender() {
    final RenderObject renderObject = context.findRenderObject();
    final Size size = renderObject.paintBounds.size;
    _carouselWidth = size.width;
    _carouselHeight = size.height;
    setState(() {});
  }

  @override
  void didUpdateWidget(T oldWidget) {
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_onController);
      widget.controller.addListener(_onController);
    }
    if (widget.loop != oldWidget.loop && !widget.loop)
      _currentIndex = _ensureIndex(_currentIndex);
    super.didUpdateWidget(oldWidget);
  }

  int _ensureIndex(int index) {
    index = index % widget.itemCount;
    if (index < 0) index += widget.itemCount;
    return index;
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Widget _buildItem(int i, int realIndex, double animationValue);

  Widget _buildContainer(List<Widget> list) => Stack(children: list);

  Widget _buildAnimation(BuildContext context, Widget w) {
    final List<Widget> list = <Widget>[];
    final double animationValue = _animation.value;
    for (int i = 0; i < _animationCount; ++i) {
      int realIndex = _currentIndex + i + _startIndex;
      realIndex = realIndex % widget.itemCount;
      if (realIndex < 0) realIndex += widget.itemCount;
      list.add(_buildItem(i, realIndex, animationValue));
    }
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: _onPanStart,
        onPanEnd: _onPanEnd,
        onPanUpdate: _onPanUpdate,
        child: ClipRect(child: Center(child: _buildContainer(list))));
  }

  @override
  Widget build(BuildContext context) {
    if (_animationCount == null) return Container();
    return AnimatedBuilder(
        animation: _animationController, builder: _buildAnimation);
  }

  double _currentValue;
  double _currentPos;
  bool _lockScroll = false;

  Future<void> _move(double position, {int nextIndex}) async {
    if (_lockScroll) return;
    try {
      _lockScroll = true;
      await _animationController.animateTo(position,
          duration: widget.duration, curve: widget.curve);
      if (nextIndex != null) {
        widget.onChanged(widget.getCorrectIndex(nextIndex));
      }
    } catch (e) {
      print(e);
    } finally {
      if (nextIndex != null) {
        try {
          _animationController.value = 0.5;
        } catch (e) {
          print(e);
        }
        _currentIndex = nextIndex;
      }
      _lockScroll = false;
    }
  }

  int _nextIndex() {
    final int index = _currentIndex + 1;
    if (!widget.loop && index >= widget.itemCount - 1)
      return widget.itemCount - 1;
    return index;
  }

  int _prevIndex() {
    final int index = _currentIndex - 1;
    if (!widget.loop && index < 0) return 0;
    return index;
  }

  void _onController() {
    switch (widget.controller.event) {
      case CarouselEvent.previous:
        final int prevIndex = _prevIndex();
        if (prevIndex == _currentIndex) return;
        _move(1.0, nextIndex: prevIndex);
        break;
      case CarouselEvent.next:
        final int nextIndex = _nextIndex();
        if (nextIndex == _currentIndex) return;
        _move(0.0, nextIndex: nextIndex);
        break;
      case CarouselEvent.move:
      case CarouselEvent.start:
      case CarouselEvent.stop:
        break;
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_lockScroll) return;
    final double velocity = widget.scrollDirection == Axis.horizontal
        ? details.velocity.pixelsPerSecond.dx
        : details.velocity.pixelsPerSecond.dy;
    if (_animationController.value >= 0.75 || velocity > 500.0) {
      if (_currentIndex <= 0 && !widget.loop) return;
      _move(1.0, nextIndex: _currentIndex - 1);
    } else if (_animationController.value < 0.25 || velocity < -500.0) {
      if (_currentIndex >= widget.itemCount - 1 && !widget.loop) return;
      _move(0.0, nextIndex: _currentIndex + 1);
    } else {
      _move(0.5);
    }
  }

  void _onPanStart(DragStartDetails details) {
    if (_lockScroll) return;
    _currentValue = _animationController.value;
    _currentPos = widget.scrollDirection == Axis.horizontal
        ? details.globalPosition.dx
        : details.globalPosition.dy;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_lockScroll) return;
    double value = _currentValue +
        ((widget.scrollDirection == Axis.horizontal
                    ? details.globalPosition.dx
                    : details.globalPosition.dy) -
                _currentPos) /
            _carouselWidth /
            2;
    if (!widget.loop) {
      if (_currentIndex >= widget.itemCount - 1) {
        if (value < 0.5) value = 0.5;
      } else if (_currentIndex <= 0) {
        if (value > 0.5) value = 0.5;
      }
    }
    _animationController.value = value;
  }
}
