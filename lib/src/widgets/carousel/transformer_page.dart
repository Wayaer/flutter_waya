import 'package:flutter/widgets.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/widgets/carousel/controller.dart';
import 'package:flutter_waya/src/widgets/carousel/transformers.dart';

typedef PageTransformerBuilderCallback = Widget Function(
    Widget child, TransformInfo info);

const int kMaxValue = 2000000000;
const int kMiddleValue = 1000000000;

///  默认自动播放转换持续时间（毫秒）
const int kDefaultTransactionDuration = 300;

class TransformerPageView extends StatefulWidget {
  const TransformerPageView({
    Key key,
    this.index,
    Duration duration,
    bool loop,
    bool pageSnapping,
    this.curve = Curves.ease,
    this.viewportFraction = 1.0,
    this.scrollDirection = Axis.horizontal,
    this.physics,
    this.onChanged,
    this.transformer,
    this.itemBuilder,
    this.pageController,
    @required this.itemCount,
    this.controller,
  })  : pageSnapping = pageSnapping ?? true,
        loop = loop ?? false,
        assert(itemCount != null),
        assert(itemCount == 0 || itemBuilder != null || transformer != null),
        duration = duration ??
            const Duration(milliseconds: kDefaultTransactionDuration),
        super(key: key);

  final PageTransformer transformer;

  ///  Same as [PageView.scrollDirection]
  ///
  ///  Defaults to [Axis.horizontal].
  final Axis scrollDirection;

  ///  Same as [PageView.physics]
  final ScrollPhysics physics;

  ///  Set to false to disable page snapping, useful for custom scroll behavior.
  ///  Same as [PageView.pageSnapping]
  final bool pageSnapping;

  ///  Called whenever the page in the center of the viewport changes.
  ///  Same as [PageView.onChanged]
  final ValueChanged<int> onChanged;

  final IndexedWidgetBuilder itemBuilder;

  ///  See [CarouselController.next],[CarouselController.previous]
  final CarouselController controller;

  ///  Animation duration
  final Duration duration;

  ///  Animation curve
  final Curve curve;

  final TransformerController pageController;

  ///  Set true to open infinity loop mode.
  final bool loop;

  ///  This value is only valid when `pageController` is not set,
  final int itemCount;

  ///  This value is only valid when `pageController` is not set,
  final double viewportFraction;

  ///  If not set, it is controlled by this widget.
  final int index;

  @override
  _TransformerPageViewState createState() => _TransformerPageViewState();
}

class _TransformerPageViewState extends State<TransformerPageView> {
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
    _pageController = _pageController ??
        TransformerController(
            initialPage: widget.index,
            itemCount: widget.itemCount,
            loop: widget.loop,
            reverse: _transformer?.reverse);
    _fromIndex = _activeIndex = _pageController.initialPage;
    _controller = widget.controller;
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
        Widget child;
        if (widget.itemBuilder != null)
          child = widget.itemBuilder(context, renderIndex);
        child ??= Container();
        if (_size == null) return child ?? Container();
        double position;
        final double page = _pageController.realPage;
        position = _transformer.reverse ? page - index : index - page;
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
    final Widget child = PageView.builder(
      itemBuilder: builder,
      itemCount: _pageController.getRealItemCount(),
      onPageChanged: (int index) {
        _activeIndex = index;
        if (widget.onChanged != null)
          widget.onChanged(_pageController.getRenderIndexFromRealIndex(index));
      },
      controller: _pageController,
      scrollDirection: widget.scrollDirection,
      physics: widget.physics,
      pageSnapping: widget.pageSnapping,
      reverse: _pageController.reverse,
    );
    if (_transformer == null) return child;
    return NotificationListener<ScrollNotification>(
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
        },
        child: child);
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

  @override
  void didUpdateWidget(TransformerPageView oldWidget) {
    _transformer = widget.transformer;
    final int index = widget.index ?? 0;
    bool created = false;
    if (_pageController != widget.pageController) {
      created = widget.pageController == null;
      _pageController = widget.pageController ??
          TransformerController(
              initialPage: widget.index,
              itemCount: widget.itemCount,
              loop: widget.loop,
              reverse: widget?.transformer?.reverse ?? false);
    }
    if (_pageController.getRenderIndexFromRealIndex(_activeIndex) != index) {
      _fromIndex = _activeIndex = _pageController.initialPage;
      if (!created) {
        final int initPage = _pageController.getRealIndexFromRenderIndex(index);
        _pageController.animateToPage(initPage,
            duration: widget.duration, curve: widget.curve);
      }
    }
    if (_transformer != null) {
      Ts.addPostFrameCallback(_onGetSize);
      _controller?.removeListener(onChangeNotifier);
      _controller = widget.controller;
      _controller?.addListener(onChangeNotifier);
    }
    super.didUpdateWidget(oldWidget);
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
    super.dispose();
    _controller?.removeListener(onChangeNotifier);
    _controller?.dispose();
  }
}
