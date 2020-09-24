import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class NestedScrollSliver extends StatefulWidget {
  const NestedScrollSliver({
    Key key,
    Axis scrollDirection,
    DragStartBehavior dragStartBehavior,
    bool reverse,
    bool floatHeaderSlivers,
    Clip clipBehavior,
    List<StretchMode> stretchModes,
    CollapseMode collapseMode,
    double titleSpacing,
    bool expanded,
    bool primary,
    bool centerTitle,
    bool snap,
    bool pinned,
    bool floating,
    bool stretch,
    double stretchTriggerOffset,
    Brightness brightness,
    double elevation,
    bool haveSliverHeader,
    bool haveSliverAppBar,
    bool automaticallyImplyLeading,
    bool forceElevated,
    Duration duration,
    this.physics,
    this.body,
    this.controller,
    this.title,
    this.actions,
    this.backgroundColor,
    this.iconTheme,
    this.textTheme,
    this.actionsIconTheme,
    this.onStretchTrigger,
    this.leading,
    this.bottom,
    this.titlePadding,
    this.flexibleSpaceTitle,
    this.preferredSize,
    this.headerSliverBuilder,
    this.foldBody,
    this.slivers,
  })  : reverse = reverse ?? false,
        expanded = expanded ?? false,
        haveSliverAppBar = haveSliverAppBar ?? false,
        haveSliverHeader = haveSliverHeader ?? false,
        pinned = pinned ?? false,
        floating = floating ?? false,
        floatHeaderSlivers = floatHeaderSlivers ?? true,
        clipBehavior = clipBehavior ?? Clip.hardEdge,
        automaticallyImplyLeading = automaticallyImplyLeading ?? true,
        forceElevated = forceElevated ?? false,
        centerTitle = centerTitle ?? true,
        snap = snap ?? false,
        primary = primary ?? true,
        stretch = stretch ?? false,
        brightness = brightness ?? Brightness.light,
        elevation = elevation ?? 0.5,
        duration = duration ?? const Duration(milliseconds: 400),
        stretchTriggerOffset = stretchTriggerOffset ?? 100,
        stretchModes = stretchModes ?? const <StretchMode>[StretchMode.zoomBackground],
        collapseMode = collapseMode ?? CollapseMode.parallax,
        titleSpacing = titleSpacing ?? NavigationToolbar.kMiddleSpacing,
        dragStartBehavior = dragStartBehavior ?? DragStartBehavior.start,
        scrollDirection = scrollDirection ?? Axis.vertical,
        super(key: key);

  ///
  ///NestedScrollView
  final bool floatHeaderSlivers;
  final Clip clipBehavior;
  final bool reverse;
  final ScrollPhysics physics;
  final Axis scrollDirection;
  final DragStartBehavior dragStartBehavior;
  final Widget body;
  final ScrollController controller;
  final NestedScrollViewHeaderSliversBuilder headerSliverBuilder;
  final List<Widget> slivers;
  final bool expanded;

  ///当组件内有异步延时渲染时 传递此参数将延时计算高度
  final Duration duration;

  ///
  ///SliverAppBar
  final bool haveSliverAppBar;
  final bool automaticallyImplyLeading;
  final Widget title;
  final List<Widget> actions;
  final bool forceElevated;
  final Color backgroundColor;
  final IconThemeData iconTheme;
  final TextTheme textTheme;
  final IconThemeData actionsIconTheme;
  final double titleSpacing;

  ///是否预留高度
  final bool primary;
  final bool centerTitle;

  final bool stretch;
  final double stretchTriggerOffset;
  final Brightness brightness;
  final AsyncCallback onStretchTrigger;
  final double elevation;
  final Widget leading;

  ///title是否固定在顶部不消失
  final bool pinned;

  ///floating和snap同时为true body在滚动时 foldBody 是否悬浮于body之上
  ///floating:true AppBar会在下拉时就立即展开
  final bool floating;
  final bool snap;

  // final Widget flexibleSpace;
  final PreferredSizeWidget bottom;

  ///
  /// FlexibleSpaceBar
  final EdgeInsetsGeometry titlePadding;
  final CollapseMode collapseMode;
  final List<StretchMode> stretchModes;
  final Widget flexibleSpaceTitle;

  ///
  ///SliverPersistentHeader
  final bool haveSliverHeader;
  final Size preferredSize;

  ///需要折叠隐藏的区域
  final Widget foldBody;

  @override
  _NestedScrollSliverState createState() => _NestedScrollSliverState();
}

class _NestedScrollSliverState extends State<NestedScrollSliver> {
  double headerHeight = 0;
  bool showNestedScrollView = false;
  GlobalKey foldKey = GlobalKey();
  Size foldSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration callback) {
      Timer(widget.duration, () {
        foldSize = foldKey.currentContext.size;
        showNestedScrollView = true;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!showNestedScrollView)
      return Column(
          mainAxisSize: MainAxisSize.min, children: <Widget>[Container(key: foldKey, child: widget.foldBody)]);
    final NestedScrollView nestedScroll = NestedScrollView(
        floatHeaderSlivers: widget.floatHeaderSlivers,
        clipBehavior: widget.clipBehavior,
        scrollDirection: widget.scrollDirection,
        reverse: widget.reverse,
        physics: widget.physics,
        dragStartBehavior: widget.dragStartBehavior,
        body: widget.body,
        controller: widget.controller,
        headerSliverBuilder:
            widget.headerSliverBuilder ?? (BuildContext context, bool innerBoxIsScrolled) => headerSliverBuilder());
    if (widget.expanded) return Expanded(child: nestedScroll);
    return nestedScroll;
  }

  List<Widget> headerSliverBuilder() {
    final List<Widget> children = <Widget>[];
    if (widget.haveSliverAppBar) children.add(sliverAppBar());
    if (widget.haveSliverHeader) children.add(sliverPersistentHeader());
    if (widget.slivers != null && widget.slivers.isNotEmpty) children.addAll(widget.slivers);
    return children;
  }

  Widget sliverAppBar() => SliverAppBar(
        automaticallyImplyLeading: widget.automaticallyImplyLeading,
        title: widget.title,
        actions: widget.actions,
        forceElevated: widget.forceElevated,
        backgroundColor: widget.backgroundColor,
        iconTheme: widget.iconTheme,
        actionsIconTheme: widget.actionsIconTheme,
        textTheme: widget.textTheme,
        primary: widget.primary,
        centerTitle: widget.centerTitle,
        titleSpacing: widget.titleSpacing,
        snap: widget.snap,
        stretch: widget.stretch,
        stretchTriggerOffset: widget.stretchTriggerOffset,
        onStretchTrigger: widget.onStretchTrigger,
        elevation: widget.elevation,
        brightness: widget.brightness,
        leading: widget.leading,
        pinned: widget.pinned,
        floating: widget.floating,
        expandedHeight: foldSize.height,
        flexibleSpace: FlexibleSpaceBar(
            title: widget.flexibleSpaceTitle,
            centerTitle: widget.centerTitle,
            titlePadding: widget.titlePadding,
            collapseMode: widget.collapseMode,
            stretchModes: widget.stretchModes,
            background: widget.foldBody),
        bottom: widget.bottom == null ? null : PreferredSize(child: widget.bottom, preferredSize: foldSize),
      );

  Widget sliverPersistentHeader() => SliverPersistentHeader(
      delegate: FoldPersistentHeader(child: PreferredSize(child: widget.foldBody, preferredSize: foldSize)),
      pinned: widget.pinned,
      floating: widget.floating);
}

class FoldPersistentHeader extends SliverPersistentHeaderDelegate {
  FoldPersistentHeader({@required this.child});

  final PreferredSize child;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
