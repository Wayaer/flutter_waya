import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_waya/src/tools/MediaQueryTools.dart';

class CustomNestedScrollView extends StatefulWidget {
  final ScrollController controller;
  final Widget tabBarBody;
  final Widget body;

  final double expandedHeight;
  final Size preferredSize;
  final ScrollPhysics physics;
  final CollapseMode collapseMode; //折叠模式
  final bool containsStatusBar;
  final List<Widget> slivers;
  final Widget flexibleSpaceTitle; //flexibleSpace 底部有文字，向上滑动后自动缩小至顶部
  final EdgeInsetsGeometry flexibleSpaceTitlePadding;

  //
  final Color backgroundColor; //背景色
  final Widget leading; //左侧标题
  final bool automaticallyImplyLeading;
  final Widget title; //标题
  final bool centerTitle; //标题是否居中
  final bool pinned; //是否固定在顶部
  final bool floating; //是否随着滑动隐藏标题
  final Brightness brightness; //主题明亮
  final AsyncCallback onStretchTrigger;
  final List<Widget> actions; //右侧菜单
  final double elevation; //阴影
  final bool primary; //是否预留高度
  final TextTheme textTheme; //文字主题
  final IconThemeData actionsIconTheme;
  final IconThemeData iconTheme; //图标主题
  final bool forceElevated;
  final bool snap; //与floating结合使用
  final bool stretch;
  final double stretchTriggerOffset;
  final Widget flexibleSpace; //可以展开区域，可以填入tabBar
  final DragStartBehavior dragStartBehavior;
  final Axis scrollDirection;
  final bool reverse;
  final bool sliverAppBar;
  final List<StretchMode> stretchModes;

  CustomNestedScrollView({
    Key key,
    bool pinned,
    bool floating,
    Brightness brightness,
    bool containsStatusBar,
    CollapseMode collapseMode,
    bool centerTitle,
    bool snap,
    bool primary,
    bool reverse,
    bool stretch,
    bool forceElevated,
    bool automaticallyImplyLeading,
    List<StretchMode> stretchModes,
    this.title,
    this.backgroundColor,
    this.tabBarBody,
    this.physics,
    this.expandedHeight,
    this.preferredSize,
    @required this.body,
    this.leading,
    this.controller,
    this.onStretchTrigger, this.actions,
    this.elevation,
    this.textTheme, this.actionsIconTheme,
    this.iconTheme,
    this.stretchTriggerOffset, @required this.flexibleSpace,
    this.slivers, this.dragStartBehavior,
    this.scrollDirection, bool sliverAppBar, this.flexibleSpaceTitle, this.flexibleSpaceTitlePadding})
      : this.pinned = pinned ?? true,
        this.sliverAppBar = sliverAppBar ?? true,
        this.automaticallyImplyLeading = automaticallyImplyLeading ?? true,
        this.floating = floating ?? true,
        this.reverse = reverse ?? false,
        this.forceElevated = forceElevated ?? false,
        this.stretch = stretch ?? false,
        this.centerTitle = centerTitle ?? true,
        this.snap = snap ?? true,
        this.primary = primary ?? true,
        this.brightness = brightness ?? Brightness.light,
        this.containsStatusBar = containsStatusBar ?? true,
        this.stretchModes = stretchModes ??
            const <StretchMode>[StretchMode.zoomBackground],
        this.collapseMode = collapseMode ?? CollapseMode.parallax,
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CustomNestedScrollViewState();
  }
}

class CustomNestedScrollViewState extends State<CustomNestedScrollView> {
  GlobalKey containerKey = GlobalKey();
  GlobalKey preferredSizeKey = GlobalKey();
  bool showNestedScrollView = false;
  double expandedHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      double containerHeight = containerKey.currentContext
          .findRenderObject()
          .paintBounds
          .size
          .height;
      double preferredSizeHeight = preferredSizeKey.currentContext
          .findRenderObject()
          .paintBounds
          .size
          .height;
      expandedHeight = widget.containsStatusBar
          ? containerHeight + preferredSizeHeight -
          MediaQueryTools.getStatusBarHeight()
          : containerHeight + preferredSizeHeight;
      setState(() {
        showNestedScrollView = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> sliverWidget = List();
    if (widget.sliverAppBar) {
      sliverWidget.add(sliverAppBarWidget());
    }
    if (widget.slivers != null && widget.slivers.length > 1) {
      widget.slivers.map((value) {
        sliverWidget.add(value);
      }).toList();
    }
    return !showNestedScrollView
        ? calculateFlexibleSpaceHeight()
        : NestedScrollView(
      scrollDirection: widget.scrollDirection ?? Axis.vertical,
      reverse: widget.reverse,
      physics: widget.physics,
      dragStartBehavior: widget.dragStartBehavior ?? DragStartBehavior.start,
      body: widget.body,
      controller: widget.controller,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return sliverWidget;
      },
    );
  }

  Widget calculateFlexibleSpaceHeight() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(key: containerKey, child: widget.flexibleSpace),
        Container(
            key: preferredSizeKey,
            child: widget.tabBarBody == null ? null : PreferredSize(
                child: widget.tabBarBody, preferredSize: widget.preferredSize))
      ],
    );
  }

  Widget sliverAppBarWidget() {
    return SliverAppBar(
      automaticallyImplyLeading: widget.automaticallyImplyLeading ?? true,
      title: widget.title,
      actions: widget.actions,
      forceElevated: widget.forceElevated,
      backgroundColor: widget.backgroundColor,
      iconTheme: widget.iconTheme,
      actionsIconTheme: widget.actionsIconTheme,
      textTheme: widget.textTheme,
      primary: widget.primary,
      centerTitle: widget.centerTitle,
      titleSpacing: NavigationToolbar.kMiddleSpacing,
      snap: widget.snap,
      stretch: widget.stretch,
      stretchTriggerOffset: widget.stretchTriggerOffset ?? 100.0,
      onStretchTrigger: widget.onStretchTrigger,
      elevation: widget.elevation,
      brightness: widget.brightness,
      leading: widget.leading,
      pinned: widget.pinned,
      floating: widget.floating,
      expandedHeight: expandedHeight,
      flexibleSpace: FlexibleSpaceBar(
          title: widget.flexibleSpaceTitle,
          centerTitle: widget.centerTitle,
          titlePadding: widget.flexibleSpaceTitlePadding,
          collapseMode: widget.collapseMode,
          stretchModes: widget.stretchModes,
          background: widget.flexibleSpace),
      bottom: widget.tabBarBody == null ? null : PreferredSize(
          child: widget.tabBarBody, preferredSize: widget.preferredSize),
    );
  }

}
