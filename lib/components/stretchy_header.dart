import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

enum StretchyHeaderAlignment { bottom, center, top }

class StretchyHeader extends StretchyHeaderBase {
  StretchyHeader.singleChild({
    Key? key,
    required HeaderData headerData,
    required Widget child,
    double? displacement,
    VoidCallback? onRefresh,
  }) : super(
            key: key,
            headerData: headerData,
            displacement: displacement,
            onRefresh: onRefresh,
            listBuilder: (BuildContext context,
                    ScrollController controller,
                    EdgeInsets padding,
                    ScrollPhysics physics,
                    Widget topWidget) =>
                ListView(
                    controller: controller,
                    padding: EdgeInsets.zero,
                    physics: physics,
                    children: <Widget>[topWidget, child]));

  StretchyHeader.listView({
    Key? key,
    required HeaderData headerData,
    required List<Widget> children,
    double? displacement,
    VoidCallback? onRefresh,
  }) : super(
            key: key,
            headerData: headerData,
            displacement: displacement,
            onRefresh: onRefresh,
            listBuilder: (BuildContext context,
                    ScrollController controller,
                    EdgeInsets padding,
                    ScrollPhysics physics,
                    Widget topWidget) =>
                ListView(
                  controller: controller,
                  padding: EdgeInsets.zero,
                  physics: physics,
                  children: <Widget>[topWidget].followedBy(children).toList(),
                ));

  StretchyHeader.listViewBuilder({
    Key? key,
    required HeaderData headerData,
    required IndexedWidgetBuilder itemBuilder,
    double? displacement,
    VoidCallback? onRefresh,
    int? itemCount,
  }) : super(
            key: key,
            headerData: headerData,
            displacement: displacement,
            onRefresh: onRefresh,
            listBuilder: (BuildContext context,
                    ScrollController controller,
                    EdgeInsets padding,
                    ScrollPhysics physics,
                    Widget topWidget) =>
                ListView.builder(
                    controller: controller,
                    padding: EdgeInsets.zero,
                    physics: physics,
                    itemCount: itemCount == null ? null : itemCount + 1,
                    itemBuilder: (BuildContext context, int index) => index == 0
                        ? topWidget
                        : itemBuilder(context, index - 1)));
}

@immutable
class HeaderData {
  const HeaderData({
    required this.header,
    required this.headerHeight,
    this.highlightHeader,
    this.blurContent = true,
    this.highlightHeaderAlignment = StretchyHeaderAlignment.bottom,
    this.overlay,
    this.blurColor,
    this.backgroundColor,
  }) : assert(headerHeight >= 0.0);

  ///  Header Widget that will be stretched, it will appear at the top of the page
  ///  标题小部件，将被拉伸，它将出现在页面的顶部
  final Widget header;

  ///  Height of your header widget
  ///  小工具标题高度
  final double headerHeight;

  ///  highlight header that will be placed on the header,  this widget always be visible without blurring effect
  ///  突出显示将放置在页眉上的标题，此小部件始终可见而不模糊效果
  final Widget? highlightHeader;

  ///  alignment for the highlight header
  ///  突出显示标题的对齐方式
  final StretchyHeaderAlignment highlightHeaderAlignment;

  final Widget? overlay;

  ///  The color of the blur, white by default
  ///  模糊的颜色，默认为白色
  final Color? blurColor;

  ///  Background Color of all of the content
  ///  所有内容的背景色
  final Color? backgroundColor;

  ///  If you want to blur the content when scroll. True by default
  ///  如果你想模糊滚动时的内容。默认为True
  final bool blurContent;
}

class StretchyHeaderBase extends StatefulWidget {
  const StretchyHeaderBase({
    Key? key,
    required this.headerData,
    required this.listBuilder,
    double? displacement,
    this.onRefresh,
  })  : displacement = displacement ?? 40.0,
        super(key: key);

  ///  Header parameters describing how the header will be displayed
  ///  描述标题显示方式的标题参数
  final HeaderData headerData;

  ///  This function should build a ListView
  ///  passing to it provided controller, padding, physics
  ///  and make provided topWidget its first child
  ///  这个函数应该建立一个ListView
  ///  传递给它的是控制器，填充物，物理
  ///  并将提供的topWidget作为其第一个子级
  final HeaderListViewBuilder listBuilder;

  ///  The distance from the child's top or bottom edge to where the refresh
  ///  indicator will settle. During the drag that exposes the refresh indicator,
  ///  its actual displacement may significantly exceed this value.
  ///  从子对象的上边缘或下边缘到刷新位置的距离
  ///  指示器将稳定。在显示刷新指示器的拖动过程中，
  ///  其实际位移可能大大超过该值。
  final double displacement;

  ///  A function that's called when the user has dragged the stretchy header
  ///  far enough to demonstrate that they want the app to refresh.
  ///  当用户拖动Stretchy标头时调用的函数
  ///  足以证明他们希望应用程序刷新。
  final VoidCallback? onRefresh;

  @override
  _StretchyHeaderBaseState createState() => _StretchyHeaderBaseState();
}

typedef HeaderListViewBuilder = ListView Function(
    BuildContext context,
    ScrollController controller,
    EdgeInsets padding,
    ScrollPhysics physics,
    Widget topWidget);

class _StretchyHeaderBaseState extends State<StretchyHeaderBase> {
  late ScrollController _scrollController;
  final GlobalKey _keyHighlightHeader = GlobalKey();
  double _offset = 0.0;
  double _headerSize = 0.0;
  double _highlightHeaderSize = 0.0;
  bool canTriggerRefresh = true;

  void _onLayoutDone(Duration duration) {
    final RenderBox renderBox =
        _keyHighlightHeader.currentContext!.findRenderObject() as RenderBox;
    _highlightHeaderSize = renderBox.size.height;
    setState(() {});
  }

  @override
  void didUpdateWidget(StretchyHeaderBase oldWidget) {
    if (widget.headerData.highlightHeader != null)
      addPostFrameCallback(_onLayoutDone);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _headerSize = widget.headerData.headerHeight;
    if (widget.headerData.highlightHeader != null)
      addPostFrameCallback(_onLayoutDone);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double highlightPosition = 0.0;
    if (widget.headerData.highlightHeaderAlignment ==
        StretchyHeaderAlignment.top) {
      highlightPosition = _offset >= 0.0 ? -_offset : 0.0;
    } else if (widget.headerData.highlightHeaderAlignment ==
        StretchyHeaderAlignment.center) {
      highlightPosition = _headerSize / 2 -
          (_offset >= 0.0 ? _offset : _offset / 2) -
          _highlightHeaderSize / 2;
    } else if (widget.headerData.highlightHeaderAlignment ==
        StretchyHeaderAlignment.bottom) {
      highlightPosition = _headerSize - _offset - _highlightHeaderSize;
    }
    final Widget highlightHeader = widget.headerData.highlightHeader != null
        ? Positioned(
            key: _keyHighlightHeader,
            top: highlightPosition,
            child: widget.headerData.highlightHeader!)
        : const SizedBox.shrink();

    return Universal(
      isStack: true,
      color: widget.headerData.backgroundColor,
      children: <Widget>[
        SizedBox(
            child: ClipRect(
                clipper: HeaderClipper(_headerSize - _offset),
                child: widget.headerData.header),
            height: _scrollController.hasClients &&
                    _scrollController.position.extentAfter == 0.0
                ? _headerSize
                : _offset <= _headerSize
                    ? _headerSize - _offset
                    : 0.0,
            width: deviceWidth),
        IgnorePointer(
          child: widget.headerData.blurContent
              ? ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: _offset < 0.0 ? _offset.abs() * 0.1 : 0.0,
                        sigmaY: _offset < 0.0 ? _offset.abs() * 0.1 : 0.0),
                    child: Container(
                      height:
                          _offset <= _headerSize ? _headerSize - _offset : 0.0,
                      decoration: BoxDecoration(
                          color: (widget.headerData.blurColor ??
                                  Colors.grey.shade200)
                              .withOpacity(_offset < 0.0 ? 0.15 : 0.0)),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (widget.onRefresh != null) {
              final double currentDisplacement = notification.metrics.pixels;
              if (currentDisplacement >= 0) {
                canTriggerRefresh = true;
              } else if (currentDisplacement <= -widget.displacement &&
                  canTriggerRefresh) {
                widget.onRefresh!();
                canTriggerRefresh = false;
              }
            }
            if (notification is ScrollUpdateNotification &&
                notification.metrics.axis == Axis.vertical) {
              _offset = notification.metrics.pixels;
              setState(() {});
            }
            return false;
          },
          child: widget.listBuilder(
              context,
              _scrollController,
              EdgeInsets.zero,
              const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              SizedBox(height: _headerSize, child: widget.headerData.overlay)),
        ),
        highlightHeader,
      ],
    );
  }
}

class HeaderClipper extends CustomClipper<Rect> {
  HeaderClipper(this.height);

  @override
  Rect getClip(Size size) => Rect.fromLTRB(0.0, 0.0, size.width, height);

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;

  final double height;
}
