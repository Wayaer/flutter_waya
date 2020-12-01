import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef CarouselOnTap = void Function(int index);

typedef CarouselDataBuilder = Widget Function(
    BuildContext context, dynamic data, int index);

///  default auto play delay
const int kDefaultAutoPlayDelayMs = 3000;

///  Default auto play transition duration (in millisecond)
const int kDefaultAutoPlayTransactionDuration = 300;

class Carousel extends StatefulWidget {
  const Carousel({
    Key key,
    this.itemBuilder,
    this.indicatorLayout = IndicatorType.none,
    this.transformer,
    @required this.itemCount,
    this.autoPlay = false,
    this.layout = CarouselLayout.none,
    this.autoPlayDelay = kDefaultAutoPlayDelayMs,
    this.autoPlayDisableOnInteraction = true,
    this.duration = kDefaultAutoPlayTransactionDuration,
    this.onIndexChanged,
    this.index,
    this.onTap,
    this.control,
    this.loop = true,
    this.curve = Curves.ease,
    this.scrollDirection = Axis.horizontal,
    this.pagination,
    this.plugins,
    this.physics,
    this.controller,
    this.customLayoutOption,
    this.containerHeight,
    this.containerWidth,
    this.viewportFraction = 1.0,
    this.itemHeight,
    this.itemWidth,
    this.outer = false,
    this.scale,
    this.fade,
  })  : assert(itemBuilder != null || transformer != null,
            'itemBuilder and transformItemBuilder must not be both null'),
        assert(
            !loop ||
                ((loop &&
                        layout == CarouselLayout.none &&
                        (indicatorLayout == IndicatorType.scale ||
                            indicatorLayout == IndicatorType.color ||
                            indicatorLayout == IndicatorType.none)) ||
                    (loop && layout != CarouselLayout.none)),
            'Only support `IndicatorType.scale` and `IndicatorType.color`when layout==CarouselLayout.DEFAULT in loop mode'),
        super(key: key);

  factory Carousel.children({
    @required List<Widget> children,
    bool autoPlay = false,
    PageTransformer transformer,
    int autoPlayDelay = kDefaultAutoPlayDelayMs,
    bool autoPlayDisableOnInteraction = true,
    int duration = kDefaultAutoPlayTransactionDuration,
    ValueChanged<int> onIndexChanged,
    int index,
    CarouselOnTap onTap,
    bool loop = true,
    Curve curve = Curves.ease,
    Axis scrollDirection = Axis.horizontal,
    CarouselPlugin pagination,
    CarouselPlugin control,
    List<CarouselPlugin> plugins,
    CarouselController controller,
    Key key,
    CustomLayoutOption customLayoutOption,
    ScrollPhysics physics,
    double containerHeight,
    double containerWidth,
    double viewportFraction = 1.0,
    double itemHeight,
    double itemWidth,
    bool outer = false,
    double scale = 1.0,
  }) =>
      Carousel(
          transformer: transformer,
          customLayoutOption: customLayoutOption,
          containerHeight: containerHeight,
          containerWidth: containerWidth,
          viewportFraction: viewportFraction,
          itemHeight: itemHeight,
          itemWidth: itemWidth,
          outer: outer,
          scale: scale,
          autoPlay: autoPlay,
          autoPlayDelay: autoPlayDelay,
          autoPlayDisableOnInteraction: autoPlayDisableOnInteraction,
          duration: duration,
          onIndexChanged: onIndexChanged,
          index: index,
          onTap: onTap,
          curve: curve,
          scrollDirection: scrollDirection,
          pagination: pagination,
          control: control,
          controller: controller,
          loop: loop,
          plugins: plugins,
          physics: physics,
          key: key,
          itemBuilder: (BuildContext context, int index) => children[index],
          itemCount: children.length);

  factory Carousel.list({
    PageTransformer transformer,
    List<dynamic> list,
    CustomLayoutOption customLayoutOption,
    CarouselDataBuilder builder,
    bool autoPlay = false,
    int autoPlayDelay = kDefaultAutoPlayDelayMs,
    bool autoPlayDisableOnInteraction = true,
    int duration = kDefaultAutoPlayTransactionDuration,
    ValueChanged<int> onIndexChanged,
    int index,
    CarouselOnTap onTap,
    bool loop = true,
    Curve curve = Curves.ease,
    Axis scrollDirection = Axis.horizontal,
    CarouselPlugin pagination,
    CarouselPlugin control,
    List<CarouselPlugin> plugins,
    CarouselController controller,
    Key key,
    ScrollPhysics physics,
    double containerHeight,
    double containerWidth,
    double viewportFraction = 1.0,
    double itemHeight,
    double itemWidth,
    bool outer = false,
    double scale = 1.0,
  }) =>
      Carousel(
          transformer: transformer,
          customLayoutOption: customLayoutOption,
          containerHeight: containerHeight,
          containerWidth: containerWidth,
          viewportFraction: viewportFraction,
          itemHeight: itemHeight,
          itemWidth: itemWidth,
          outer: outer,
          scale: scale,
          autoPlay: autoPlay,
          autoPlayDelay: autoPlayDelay,
          autoPlayDisableOnInteraction: autoPlayDisableOnInteraction,
          duration: duration,
          onIndexChanged: onIndexChanged,
          index: index,
          onTap: onTap,
          curve: curve,
          key: key,
          scrollDirection: scrollDirection,
          pagination: pagination,
          control: control,
          controller: controller,
          loop: loop,
          plugins: plugins,
          physics: physics,
          itemBuilder: (BuildContext context, int index) =>
              builder(context, list[index], index),
          itemCount: list.length);

  ///  If set true , the pagination will display 'outer' of the 'content' container.
  final bool outer;

  ///  Inner item height, this property is valid if layout=stack or layout=tinder or LAYOUT=custom,
  final double itemHeight;

  ///  Inner item width, this property is valid if layout=stack or layout=tinder or LAYOUT=custom,
  final double itemWidth;

  ///  height of the inside container,this property is valid when outer=true,otherwise the inside container size is controlled by parent widget
  final double containerHeight;

  ///  width of the inside container,this property is valid when outer=true,otherwise the inside container size is controlled by parent widget
  final double containerWidth;

  ///  Build item on index
  final IndexedWidgetBuilder itemBuilder;

  ///  Support transform like Android PageView did
  ///  `itemBuilder` and `transformItemBuilder` must have one not null
  final PageTransformer transformer;

  ///  count of the display items
  final int itemCount;

  ///  当用户手动拖拽或者自动播放引起下标改变的时候调用
  final ValueChanged<int> onIndexChanged;

  ///  auto play config
  ///  自动播放开关.
  final bool autoPlay;

  ///  Duration of the animation between transactions (in millisecond).
  ///  自动播放延迟毫秒数.
  final int autoPlayDelay;

  ///  disable auto play when interaction
  ///  当用户拖拽的时候，是否停止自动播放.
  final bool autoPlayDisableOnInteraction;

  ///  auto play transition duration (in millisecond)
  ///  动画时间，单位是毫秒
  final int duration;

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

  ///  The carousel pagination plugin
  ///  底部指示器
  final CarouselPlugin pagination;

  ///  the carousel control button plugin
  ///  控制按钮组件(左右添加箭头)
  final CarouselPlugin control;

  ///  other plugins, you can custom your own plugin
  final List<CarouselPlugin> plugins;

  ///  控制器
  final CarouselController controller;

  final ScrollPhysics physics;

  ///
  final double viewportFraction;

  ///  Build in layouts
  final CarouselLayout layout;

  ///  this value is valid when layout == CarouselLayout.CUSTOM
  final CustomLayoutOption customLayoutOption;

  ///  This value is valid when viewportFraction is set and < 1.0
  final double scale;

  ///  This value is valid when viewportFraction is set and < 1.0
  final double fade;

  ///  底部指示器样式
  final IndicatorType indicatorLayout;

  @override
  _CarouselState createState() => _CarouselState();
}

abstract class _CarouselTimerMixin extends State<Carousel> {
  Timer _timer;

  CarouselController _controller;

  @override
  void initState() {
    _controller = widget.controller;
    _controller ??= CarouselController();
    _controller.addListener(_onController);
    _handleAutoPlay();
    super.initState();
  }

  void _onController() {
    switch (_controller.event) {
      case CarouselController.START_AUTOPLAY:
        if (_timer == null) _startAutoPlay();
        break;
      case CarouselController.STOP_AUTOPLAY:
        if (_timer != null) _stopAutoPlay();
        break;
    }
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

  @override
  void dispose() {
    if (_controller != null) _controller.removeListener(_onController);
    _stopAutoPlay();
    super.dispose();
  }

  bool _autoPlayEnabled() => _controller.autoPlay ?? widget.autoPlay;

  void _handleAutoPlay() {
    if (_autoPlayEnabled() && _timer != null) return;
    _stopAutoPlay();
    if (_autoPlayEnabled()) _startAutoPlay();
  }

  void _startAutoPlay() {
    assert(_timer == null, 'Timer must be stopped before start!');
    _timer =
        Timer.periodic(Duration(milliseconds: widget.autoPlayDelay), _onTimer);
  }

  void _onTimer(Timer timer) => _controller.next(animation: true);

  void _stopAutoPlay() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }
}

class _CarouselState extends _CarouselTimerMixin {
  int _activeIndex;

  TransformerPageController _pageController;

  Widget _wrapTap(BuildContext context, int index) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => widget.onTap(index),
        child: widget.itemBuilder(context, index));
  }

  @override
  void initState() {
    _activeIndex = widget.index ?? 0;
    if (_isPageViewLayout()) {
      bool reverse = false;
      if (widget.transformer != null) reverse = widget.transformer.reverse;
      _pageController = TransformerPageController(
          initialPage: widget.index,
          loop: widget.loop,
          itemCount: widget.itemCount,
          reverse: reverse,
          viewportFraction: widget.viewportFraction);
    }
    super.initState();
  }

  bool _isPageViewLayout() =>
      widget.layout == null || widget.layout == CarouselLayout.none;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  bool _getReverse(Carousel widget) {
    if (widget.transformer != null) return widget.transformer.reverse;
    return false;
  }

  @override
  void didUpdateWidget(Carousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isPageViewLayout()) {
      if (_pageController == null ||
          (widget.index != oldWidget.index ||
              widget.loop != oldWidget.loop ||
              widget.itemCount != oldWidget.itemCount ||
              widget.viewportFraction != oldWidget.viewportFraction ||
              _getReverse(widget) != _getReverse(oldWidget))) {
        _pageController = TransformerPageController(
            initialPage: widget.index,
            loop: widget.loop,
            itemCount: widget.itemCount,
            reverse: _getReverse(widget),
            viewportFraction: widget.viewportFraction);
      }
    } else {
      scheduleMicrotask(() {
        ///  So that we have a chance to do `removeListener` in child widgets.
        if (_pageController != null) {
          _pageController.dispose();
          _pageController = null;
        }
      });
    }
    if (widget.index != null && widget.index != _activeIndex)
      _activeIndex = widget.index;
  }

  void _onIndexChanged(int index) {
    _activeIndex = index;
    setState(() {});
    if (widget.onIndexChanged != null) widget.onIndexChanged(index);
  }

  Widget _buildCarousel() {
    final IndexedWidgetBuilder itemBuilder =
        widget.onTap == null ? widget.itemBuilder : _wrapTap;
    if (widget.layout == CarouselLayout.stack) {
      return _StackCarousel(
        loop: widget.loop,
        itemWidth: widget.itemWidth,
        itemHeight: widget.itemHeight,
        itemCount: widget.itemCount,
        itemBuilder: itemBuilder,
        index: _activeIndex,
        curve: widget.curve,
        duration: widget.duration,
        onIndexChanged: _onIndexChanged,
        controller: _controller,
        scrollDirection: widget.scrollDirection,
      );
    } else if (_isPageViewLayout()) {
      PageTransformer transformer = widget.transformer;
      if (widget.scale != null || widget.fade != null)
        transformer =
            ScaleAndFadeTransformer(scale: widget.scale, fade: widget.fade);

      final Widget child = CarouselPageView(
        pageController: _pageController,
        loop: widget.loop,
        itemCount: widget.itemCount,
        itemBuilder: itemBuilder,
        transformer: transformer,
        viewportFraction: widget.viewportFraction,
        index: _activeIndex,
        duration: Duration(milliseconds: widget.duration),
        scrollDirection: widget.scrollDirection,
        onPageChanged: _onIndexChanged,
        curve: widget.curve,
        physics: widget.physics,
        controller: _controller,
      );
      if (widget.autoPlayDisableOnInteraction && widget.autoPlay) {
        ///  ignore: always_specify_types
        return NotificationListener(
          child: child,
          onNotification: (ScrollNotification notification) {
            if (notification is ScrollStartNotification) {
              if (notification.dragDetails != null) {
                /// by human
                if (_timer != null) _stopAutoPlay();
              }
            } else if (notification is ScrollEndNotification) {
              if (_timer == null) _startAutoPlay();
            }
            return false;
          },
        );
      }
      return child;
    } else if (widget.layout == CarouselLayout.tinder) {
      return _TinderCarousel(
        loop: widget.loop,
        itemWidth: widget.itemWidth,
        itemHeight: widget.itemHeight,
        itemCount: widget.itemCount,
        itemBuilder: itemBuilder,
        index: _activeIndex,
        curve: widget.curve,
        duration: widget.duration,
        onIndexChanged: _onIndexChanged,
        controller: _controller,
        scrollDirection: widget.scrollDirection,
      );
    } else if (widget.layout == CarouselLayout.custom) {
      return _CustomLayoutCarousel(
        loop: widget.loop,
        option: widget.customLayoutOption,
        itemWidth: widget.itemWidth,
        itemHeight: widget.itemHeight,
        itemCount: widget.itemCount,
        itemBuilder: itemBuilder,
        index: _activeIndex,
        curve: widget.curve,
        duration: widget.duration,
        onIndexChanged: _onIndexChanged,
        controller: _controller,
        scrollDirection: widget.scrollDirection,
      );
    } else {
      return Container();
    }
  }

  CarouselPluginConfig _ensureConfig(CarouselPluginConfig config) =>
      config ??
      CarouselPluginConfig(
          outer: widget.outer,
          itemCount: widget.itemCount,
          layout: widget.layout,
          indicatorLayout: widget.indicatorLayout,
          pageController: _pageController,
          activeIndex: _activeIndex,
          scrollDirection: widget.scrollDirection,
          controller: _controller,
          loop: widget.loop);

  List<Widget> _ensureListForStack(
      Widget carousel, List<Widget> listForStack, Widget widget) {
    if (listForStack == null) {
      listForStack = <Widget>[carousel, widget];
    } else {
      listForStack.add(widget);
    }
    return listForStack;
  }

  @override
  Widget build(BuildContext context) {
    final Widget carousel = _buildCarousel();
    List<Widget> listForStack;
    CarouselPluginConfig config;
    if (widget.control != null) {
      config = _ensureConfig(config);
      listForStack = _ensureListForStack(
          carousel, listForStack, widget.control.build(context, config));
    }

    if (widget.plugins != null) {
      config = _ensureConfig(config);
      for (final CarouselPlugin plugin in widget.plugins) {
        listForStack = _ensureListForStack(
            carousel, listForStack, plugin.build(context, config));
      }
    }
    if (widget.pagination != null) {
      config = _ensureConfig(config);
      if (widget.outer) {
        return _buildOuterPagination(
            widget.pagination,
            listForStack == null ? carousel : Stack(children: listForStack),
            config);
      } else {
        listForStack = _ensureListForStack(
            carousel, listForStack, widget.pagination.build(context, config));
      }
    }
    if (listForStack != null) return Stack(children: listForStack);
    return carousel;
  }

  Widget _buildOuterPagination(
      CarouselPlugin pagination, Widget carousel, CarouselPluginConfig config) {
    final List<Widget> list = <Widget>[];

    /// Only support bottom yet!
    list.add((widget.containerHeight != null || widget.containerWidth != null)
        ? carousel
        : Expanded(child: carousel));
    list.add(Align(
        alignment: Alignment.center, child: pagination.build(context, config)));
    return Column(
        children: list,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min);
  }
}

abstract class _SubCarousel extends StatefulWidget {
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
      this.onIndexChanged})
      : super(key: key);

  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final int index;
  final ValueChanged<int> onIndexChanged;
  final CarouselController controller;
  final int duration;
  final Curve curve;
  final double itemWidth;
  final double itemHeight;
  final bool loop;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState();

  int getCorrectIndex(int indexNeedsFix) {
    if (itemCount == 0) return 0;
    int value = indexNeedsFix % itemCount;
    if (value < 0) value += itemCount;
    return value;
  }
}

class _TinderCarousel extends _SubCarousel {
  const _TinderCarousel({
    Key key,
    Curve curve,
    int duration,
    CarouselController controller,
    ValueChanged<int> onIndexChanged,
    @required double itemHeight,
    @required double itemWidth,
    IndexedWidgetBuilder itemBuilder,
    int index,
    bool loop,
    int itemCount,
    Axis scrollDirection,
  }) : super(
            loop: loop,
            key: key,
            itemWidth: itemWidth,
            itemHeight: itemHeight,
            itemBuilder: itemBuilder,
            curve: curve,
            duration: duration,
            controller: controller,
            index: index,
            onIndexChanged: onIndexChanged,
            itemCount: itemCount,
            scrollDirection: scrollDirection);

  @override
  State<StatefulWidget> createState() => _TinderState();
}

class _StackCarousel extends _SubCarousel {
  const _StackCarousel({
    Key key,
    Curve curve,
    int duration,
    CarouselController controller,
    ValueChanged<int> onIndexChanged,
    double itemHeight,
    double itemWidth,
    IndexedWidgetBuilder itemBuilder,
    int index,
    bool loop,
    int itemCount,
    Axis scrollDirection,
  }) : super(
            loop: loop,
            key: key,
            itemWidth: itemWidth,
            itemHeight: itemHeight,
            itemBuilder: itemBuilder,
            curve: curve,
            duration: duration,
            controller: controller,
            index: index,
            onIndexChanged: onIndexChanged,
            itemCount: itemCount,
            scrollDirection: scrollDirection);

  @override
  State<StatefulWidget> createState() => _StackViewState();
}

class _TinderState extends _CustomLayoutStateBase<_TinderCarousel> {
  List<double> scales;
  List<double> offsetsX;
  List<double> offsetsY;
  List<double> opacity;
  List<double> rotates;

  double getOffsetY(double scale) =>
      widget.itemHeight - widget.itemHeight * scale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(_TinderCarousel oldWidget) {
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

class _StackViewState extends _CustomLayoutStateBase<_StackCarousel> {
  List<double> scales;
  List<double> offsets;
  List<double> opacity;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

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
  void didUpdateWidget(_StackCarousel oldWidget) {
    _updateValues();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void afterRender() {
    super.afterRender();

    /// length of the values array below
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

class ScaleAndFadeTransformer extends PageTransformer {
  ScaleAndFadeTransformer({double fade = 0.3, double scale = 0.8})
      : _fade = fade,
        _scale = scale;
  final double _scale;
  final double _fade;

  @override
  Widget transform(Widget child, TransformInfo info) {
    final double position = info.position;
    Widget widget = child;
    if (_scale != null) {
      final double scaleFactor = (1 - position.abs()) * (1 - _scale);
      final double scale = _scale + scaleFactor;
      widget = Transform.scale(scale: scale, child: child);
    }
    if (_fade != null) {
      final double fadeFactor = (1 - position.abs()) * (1 - _fade);
      final double opacity = _fade + fadeFactor;
      widget = Opacity(opacity: opacity, child: widget);
    }
    return widget;
  }
}

///  /CustomLayout
abstract class _CustomLayoutStateBase<T extends _SubCarousel> extends State<T>
    with SingleTickerProviderStateMixin {
  double _carouselWidth;
  double _carouselHeight;
  Animation<double> _animation;
  AnimationController _animationController;
  int _startIndex;
  int _animationCount;

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
    Tools.addPostFrameCallback((Duration duration) => afterRender());
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
    widget.controller.removeListener(_onController);
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
          duration: Duration(milliseconds: widget.duration),
          curve: widget.curve);
      if (nextIndex != null) {
        widget.onIndexChanged(widget.getCorrectIndex(nextIndex));
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
      case IndexController.PREVIOUS:
        final int prevIndex = _prevIndex();
        if (prevIndex == _currentIndex) return;
        _move(1.0, nextIndex: prevIndex);
        break;
      case IndexController.NEXT:
        final int nextIndex = _nextIndex();
        if (nextIndex == _currentIndex) return;
        _move(0.0, nextIndex: nextIndex);
        break;
      case IndexController.MOVE:
        throw Exception(
            'Custom layout does not support CarouselControllerEvent.MOVE_INDEX yet!');
      case CarouselController.STOP_AUTOPLAY:
      case CarouselController.START_AUTOPLAY:
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

  int _currentIndex = 0;
}

double _getValue(List<double> values, double animationValue, int index) {
  double s = values[index];
  if (animationValue >= 0.5) {
    if (index < values.length - 1) {
      s = s + (values[index + 1] - s) * (animationValue - 0.5) * 2.0;
    }
  } else {
    if (index != 0) {
      s = s - (s - values[index - 1]) * (0.5 - animationValue) * 2.0;
    }
  }
  return s;
}

Offset _getOffsetValue(List<Offset> values, double animationValue, int index) {
  final Offset s = values[index];
  double dx = s.dx;
  double dy = s.dy;
  if (animationValue >= 0.5) {
    if (index < values.length - 1) {
      dx = dx + (values[index + 1].dx - dx) * (animationValue - 0.5) * 2.0;
      dy = dy + (values[index + 1].dy - dy) * (animationValue - 0.5) * 2.0;
    }
  } else {
    if (index != 0) {
      dx = dx - (dx - values[index - 1].dx) * (0.5 - animationValue) * 2.0;
      dy = dy - (dy - values[index - 1].dy) * (0.5 - animationValue) * 2.0;
    }
  }
  return Offset(dx, dy);
}

abstract class TransformBuilder<T> {
  TransformBuilder({this.values});

  List<T> values;

  Widget build(int i, double animationValue, Widget widget);
}

class ScaleTransformBuilder extends TransformBuilder<double> {
  ScaleTransformBuilder(
      {List<double> values, this.alignment = Alignment.center})
      : super(values: values);

  final Alignment alignment;

  @override
  Widget build(int i, double animationValue, Widget widget) {
    final double s = _getValue(values, animationValue, i);
    return Transform.scale(scale: s, child: widget);
  }
}

class OpacityTransformBuilder extends TransformBuilder<double> {
  OpacityTransformBuilder({List<double> values}) : super(values: values);

  @override
  Widget build(int i, double animationValue, Widget widget) {
    final double v = _getValue(values, animationValue, i);
    return Opacity(opacity: v, child: widget);
  }
}

class RotateTransformBuilder extends TransformBuilder<double> {
  RotateTransformBuilder({List<double> values}) : super(values: values);

  @override
  Widget build(int i, double animationValue, Widget widget) {
    final double v = _getValue(values, animationValue, i);
    return Transform.rotate(angle: v, child: widget);
  }
}

class TranslateTransformBuilder extends TransformBuilder<Offset> {
  TranslateTransformBuilder({List<Offset> values}) : super(values: values);

  @override
  Widget build(int i, double animationValue, Widget widget) {
    final Offset s = _getOffsetValue(values, animationValue, i);
    return Transform.translate(offset: s, child: widget);
  }
}

class CustomLayoutOption {
  CustomLayoutOption({this.stateCount, @required this.startIndex})
      : assert(startIndex != null, stateCount != null);

  final List<TransformBuilder<dynamic>> builders =
      <TransformBuilder<dynamic>>[];
  final int startIndex;
  final int stateCount;

  CustomLayoutOption addOpacity(List<double> values) {
    builders.add(OpacityTransformBuilder(values: values));
    return this;
  }

  CustomLayoutOption addTranslate(List<Offset> values) {
    builders.add(TranslateTransformBuilder(values: values));
    return this;
  }

  CustomLayoutOption addScale(List<double> values, Alignment alignment) {
    builders.add(ScaleTransformBuilder(values: values, alignment: alignment));
    return this;
  }

  CustomLayoutOption addRotate(List<double> values) {
    builders.add(RotateTransformBuilder(values: values));
    return this;
  }
}

class _CustomLayoutCarousel extends _SubCarousel {
  const _CustomLayoutCarousel(
      {@required this.option,
      double itemWidth,
      bool loop,
      double itemHeight,
      ValueChanged<int> onIndexChanged,
      Key key,
      IndexedWidgetBuilder itemBuilder,
      Curve curve,
      int duration,
      int index,
      int itemCount,
      Axis scrollDirection,
      CarouselController controller})
      : super(
            loop: loop,
            onIndexChanged: onIndexChanged,
            itemWidth: itemWidth,
            itemHeight: itemHeight,
            key: key,
            itemBuilder: itemBuilder,
            curve: curve,
            duration: duration,
            index: index,
            itemCount: itemCount,
            controller: controller,
            scrollDirection: scrollDirection);

  final CustomLayoutOption option;

  @override
  _CustomLayoutState createState() => _CustomLayoutState();
}

class _CustomLayoutState extends _CustomLayoutStateBase<_CustomLayoutCarousel> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startIndex = widget.option.startIndex;
    _animationCount = widget.option.stateCount;
  }

  @override
  void didUpdateWidget(_CustomLayoutCarousel oldWidget) {
    _startIndex = widget.option.startIndex;
    _animationCount = widget.option.stateCount;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget _buildItem(int index, int realIndex, double animationValue) {
    final List<TransformBuilder<dynamic>> builders = widget.option.builders;

    Widget child = SizedBox(
        width: widget.itemWidth ?? double.infinity,
        height: widget.itemHeight ?? double.infinity,
        child: widget.itemBuilder(context, realIndex));

    for (int i = builders.length - 1; i >= 0; --i) {
      final TransformBuilder<dynamic> builder = builders[i];
      child = builder.build(index, animationValue, child);
    }
    return child;
  }
}
