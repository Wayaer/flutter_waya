import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_waya/flutter_waya.dart';

class NestedScroll extends StatefulWidget {
  final ScrollController controller;
  final Widget tabBarBody;
  final Widget body;

  final double expandedHeight;
  final Size preferredSize;
  final ScrollPhysics physics;

  ///折叠模式
  final CollapseMode collapseMode;
  final bool containsStatusBar;
  final List<Widget> slivers;

  ///flexibleSpace 底部有文字，向上滑动后自动缩小至顶部
  final Widget flexibleSpaceTitle;
  final EdgeInsetsGeometry flexibleSpaceTitlePadding;

  ///背景色
  final Color backgroundColor;

  ///左侧标题
  final Widget leading;
  final bool automaticallyImplyLeading;

  ///标题
  final Widget title;

  ///标题是否居中
  final bool centerTitle;

  ///是否固定在顶部
  final bool pinned;

  ///是否随着滑动隐藏标题
  final bool floating;

  ///主题明亮
  final Brightness brightness;
  final AsyncCallback onStretchTrigger;

  ///右侧菜单
  final List<Widget> actions;

  ///阴影
  final double elevation;

  ///是否预留高度
  final bool primary;

  ///文字主题
  final TextTheme textTheme;
  final IconThemeData actionsIconTheme;

  ///图标主题
  final IconThemeData iconTheme;
  final bool forceElevated;

  ///与floating结合使用
  final bool snap;
  final bool stretch;
  final double stretchTriggerOffset;

  ///可以展开区域，可以填入tabBar
  final Widget flexibleSpace;
  final DragStartBehavior dragStartBehavior;
  final Axis scrollDirection;
  final bool reverse;

  ///整个头部 是否显示
  final bool sliverAppBar;
  final List<StretchMode> stretchModes;

  NestedScroll(
      {Key key,
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
      Color backgroundColor,
      this.tabBarBody,
      this.physics,
      this.expandedHeight,
      this.preferredSize,
      @required this.body,
      this.leading,
      this.controller,
      this.onStretchTrigger,
      this.actions,
      this.elevation,
      this.textTheme,
      this.actionsIconTheme,
      this.iconTheme,
      this.stretchTriggerOffset,
      @required this.flexibleSpace,
      this.slivers,
      this.dragStartBehavior,
      this.scrollDirection,
      bool sliverAppBar,
      this.flexibleSpaceTitle,
      this.flexibleSpaceTitlePadding})
      : this.pinned = pinned ?? true,
        this.backgroundColor = backgroundColor ?? getColors(white),
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
        this.stretchModes = stretchModes ?? const <StretchMode>[StretchMode.zoomBackground],
        this.collapseMode = collapseMode ?? CollapseMode.parallax,
        super(key: key);

  @override
  _NestedScrollState createState() => _NestedScrollState();
}

class _NestedScrollState extends State<NestedScroll> {
  GlobalKey containerKey = GlobalKey();
  GlobalKey preferredSizeKey = GlobalKey();
  bool showNestedScrollView = false;
  double expandedHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      double containerHeight = containerKey.currentContext.findRenderObject().paintBounds.size.height;
      double preferredSizeHeight = preferredSizeKey.currentContext.findRenderObject().paintBounds.size.height;
      expandedHeight = widget.containsStatusBar
          ? containerHeight + preferredSizeHeight - MediaQueryTools.getStatusBarHeight()
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

  Widget calculateFlexibleSpaceHeight() => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(key: containerKey, child: widget.flexibleSpace),
          Container(
              key: preferredSizeKey,
              child: widget.tabBarBody == null
                  ? null
                  : PreferredSize(child: widget.tabBarBody, preferredSize: widget.preferredSize))
        ],
      );

  Widget sliverAppBarWidget() => SliverAppBar(
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
        bottom: widget.tabBarBody == null
            ? null
            : PreferredSize(child: widget.tabBarBody, preferredSize: widget.preferredSize),
      );
}
