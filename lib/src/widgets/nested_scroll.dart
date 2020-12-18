import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

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
    double toolbarHeight,
    bool expanded,
    bool primary,
    bool centerTitle,
    bool flexibleCenterTitle,
    bool snap,
    bool pinned,
    bool floating,
    bool stretch,
    double stretchTriggerOffset,
    Brightness brightness,
    double elevation,
    bool hasSliverAppBar,
    bool automaticallyImplyLeading,
    bool forceElevated,
    bool autoHeight,
    bool backgroundPaddingBottom,
    Duration duration,
    int flex,
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
    this.slivers,
    this.sliverAppBar,
    this.sliverPersistentHeader,
    this.restorationId,
    this.leadingWidth,
    this.shape,
    this.background,
    this.persistentHeader,
  })  : reverse = reverse ?? false,
        expanded = expanded ?? false,
        backgroundPaddingBottom = backgroundPaddingBottom ?? true,
        autoHeight = autoHeight ?? false,
        hasSliverAppBar = hasSliverAppBar ?? false,
        pinned = pinned ?? true,
        floating = floating ?? false,
        floatHeaderSlivers = floatHeaderSlivers ?? true,
        clipBehavior = clipBehavior ?? Clip.hardEdge,
        automaticallyImplyLeading = automaticallyImplyLeading ?? true,
        forceElevated = forceElevated ?? false,
        centerTitle = centerTitle ?? true,
        flexibleCenterTitle = flexibleCenterTitle ?? true,
        snap = snap ?? false,
        primary = primary ?? true,
        stretch = stretch ?? false,
        brightness = brightness ?? Brightness.light,
        elevation = elevation ?? 0.5,
        toolbarHeight = toolbarHeight ?? kToolbarHeight,
        flex = flex ?? 1,
        duration = duration ?? const Duration(milliseconds: 100),
        stretchTriggerOffset = stretchTriggerOffset ?? 100,
        stretchModes =
            stretchModes ?? const <StretchMode>[StretchMode.zoomBackground],
        collapseMode = collapseMode ?? CollapseMode.parallax,
        titleSpacing = titleSpacing ?? NavigationToolbar.kMiddleSpacing,
        dragStartBehavior = dragStartBehavior ?? DragStartBehavior.start,
        scrollDirection = scrollDirection ?? Axis.vertical,
        super(key: key);

  ///  当组件内有异步延时渲染时 传递此参数将延时计算高度
  final Duration duration;

  /// 是否自动计算高度
  final bool autoHeight;

  ///NestedScrollView 外嵌套Expanded
  final bool expanded;
  final int flex;

  ///  NestedScrollView
  ///
  /// 使用此参数是[sliverAppBar]、[sliverPersistentHeader]、[slivers] 均无效
  final NestedScrollViewHeaderSliversBuilder headerSliverBuilder;
  final bool floatHeaderSlivers;
  final Clip clipBehavior;
  final bool reverse;
  final ScrollPhysics physics;
  final Axis scrollDirection;
  final DragStartBehavior dragStartBehavior;
  final Widget body;
  final ScrollController controller;
  final String restorationId;

  /// headerSliverBuilder 添加额外组件
  final List<Widget> slivers;

  /// **** SliverAppBar **** ///
  ///  是否显示[sliverAppBar]
  final bool hasSliverAppBar;
  final SliverAppBar sliverAppBar;

  final bool automaticallyImplyLeading;
  final Widget title;
  final List<Widget> actions;
  final bool forceElevated;
  final Color backgroundColor;
  final IconThemeData iconTheme;
  final TextTheme textTheme;
  final IconThemeData actionsIconTheme;
  final double titleSpacing;

  ///  是否预留高度
  final bool primary;
  final bool centerTitle;

  final bool stretch;
  final double stretchTriggerOffset;
  final Brightness brightness;
  final AsyncCallback onStretchTrigger;
  final double elevation;
  final Widget leading;
  final double leadingWidth;

  ///  title是否固定在顶部不消失
  final bool pinned;

  ///  floating和snap同时为true body在滚动时  是否悬浮于body之上
  ///  floating:true AppBar会在下拉时就立即展开
  final bool floating;
  final bool snap;
  final ShapeBorder shape;

  final Widget bottom;
  final bool backgroundPaddingBottom;
  final double toolbarHeight;

  /// **** FlexibleSpaceBar **** ///
  final EdgeInsetsGeometry titlePadding;
  final CollapseMode collapseMode;
  final List<StretchMode> stretchModes;
  final Widget flexibleSpaceTitle;
  final Widget background;
  final bool flexibleCenterTitle;

  /// **** FlexibleSpaceBar **** ///

  /// **** SliverAppBar **** ///

  /// **** SliverPersistentHeader **** ///
  ///  SliverPersistentHeader
  final SliverPersistentHeader sliverPersistentHeader;
  final Size preferredSize;

  /// 译为 一直存在 不会随着滚动消失
  final Widget persistentHeader;

  /// **** SliverPersistentHeader **** ///

  @override
  _NestedScrollSliverState createState() => _NestedScrollSliverState();
}

class _NestedScrollSliverState extends State<NestedScrollSliver> {
  double headerHeight = 0;
  bool showNestedScrollView = false;
  GlobalKey backgroundKey = GlobalKey();
  GlobalKey bottomKey = GlobalKey();
  GlobalKey persistentHeaderKey = GlobalKey();
  GlobalKey flexibleSpaceTitleKey = GlobalKey();

  Size backgroundSize;
  Size bottomSize;
  Size persistentHeaderSize;
  Size flexibleSpaceTitleSize;

  @override
  void initState() {
    super.initState();
    if (widget.autoHeight)
      Ts.addPostFrameCallback((Duration callback) => Timer(widget.duration, () {
            showNestedScrollView = true;
            backgroundSize =
                backgroundKey?.currentContext?.size ?? const Size(0, 0);
            bottomSize = bottomKey?.currentContext?.size ?? const Size(0, 0);
            persistentHeaderSize =
                persistentHeaderKey?.currentContext?.size ?? const Size(0, 0);
            flexibleSpaceTitleSize =
                flexibleSpaceTitleKey?.currentContext?.size ?? const Size(0, 0);
            log(backgroundSize);
            log(bottomSize);
            log(persistentHeaderSize);
            setState(() {});
          }));
  }

  @override
  Widget build(BuildContext context) {
    log(backgroundSize);
    log(bottomSize);
    log(persistentHeaderSize);
    Widget child;
    if (!showNestedScrollView &&
        widget.autoHeight &&
        widget.headerSliverBuilder == null) {
      log('先计算了宽高');
      final List<Widget> column = [];
      if (widget.background != null)
        column.add(Container(key: backgroundKey, child: widget.background));
      if (widget.bottom != null)
        column.add(Container(key: bottomKey, child: widget.bottom));
      if (widget.persistentHeader != null)
        column.add(Container(
            key: persistentHeaderKey, child: widget.persistentHeader));
      if (widget.flexibleSpaceTitle != null)
        column.add(Container(
            key: flexibleSpaceTitleKey, child: widget.flexibleSpaceTitle));
      child = Column(mainAxisSize: MainAxisSize.min, children: column);
    } else {
      log('然后在初始化数据');
      log(persistentHeaderKey?.currentContext?.size);
      child = NestedScrollView(
          floatHeaderSlivers: widget.floatHeaderSlivers,
          clipBehavior: widget.clipBehavior,
          scrollDirection: widget.scrollDirection,
          reverse: widget.reverse,
          physics: widget.physics,
          dragStartBehavior: widget.dragStartBehavior,
          body: widget.body,
          restorationId: widget.restorationId,
          controller: widget.controller,
          headerSliverBuilder: widget.headerSliverBuilder ??
              (BuildContext context, bool innerBoxIsScrolled) =>
                  headerSliverBuilder());
      if (widget.expanded) child = Expanded(flex: widget.flex, child: child);
    }
    return child;
  }

  List<Widget> headerSliverBuilder() {
    final List<Widget> children = <Widget>[];
    if (widget.hasSliverAppBar)
      children.add(widget.sliverAppBar ?? sliverAppBar());
    if (widget.sliverPersistentHeader != null ||
        widget.persistentHeader != null)
      children.add(widget.sliverPersistentHeader ?? sliverPersistentHeader());
    if (widget.slivers != null && widget.slivers.isNotEmpty)
      children.addAll(widget.slivers);
    return children;
  }

  Widget sliverPersistentHeader() => SliverPersistentHeader(
      delegate: FoldPersistentHeader(
          child: PreferredSize(
        child: widget.persistentHeader,
        preferredSize: persistentHeaderSize,
      )),
      pinned: widget.pinned,
      floating: widget.floating);

  Widget sliverAppBar() {
    double expandedHeight =
        backgroundSize.height > flexibleSpaceTitleSize.height
            ? backgroundSize.height
            : flexibleSpaceTitleSize.height;
    Widget background = widget.background;
    Widget flexibleSpaceTitle = widget.flexibleSpaceTitle;
    if (widget.backgroundPaddingBottom) {
      expandedHeight += bottomSize.height;
      background = Padding(
          padding: EdgeInsets.only(bottom: bottomSize.height),
          child: background);
      flexibleSpaceTitle = Padding(
          padding: EdgeInsets.only(bottom: bottomSize.height),
          child: flexibleSpaceTitle);
    }

    return SliverAppBar(
        automaticallyImplyLeading: widget.automaticallyImplyLeading,
        title: widget.title,
        actions: widget.actions,
        forceElevated: widget.forceElevated,
        backgroundColor: widget.backgroundColor,
        iconTheme: widget.iconTheme,
        actionsIconTheme: widget.actionsIconTheme,
        textTheme: widget.textTheme,
        primary: widget.primary,
        // centerTitle: widget.centerTitle,
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
        expandedHeight: expandedHeight,
        shape: widget.shape,
        toolbarHeight: widget.toolbarHeight,
        leadingWidth: widget.leadingWidth,
        bottom: widget.bottom == null
            ? null
            : PreferredSize(child: widget.bottom, preferredSize: bottomSize),
        flexibleSpace: FlexibleSpaceBar(
            title: flexibleSpaceTitle,
            centerTitle: widget.flexibleCenterTitle,
            titlePadding: widget.titlePadding,
            collapseMode: widget.collapseMode,
            stretchModes: widget.stretchModes,
            background: background));
  }
}

class FlexibleSpaceAutoBar extends FlexibleSpaceBar {
  const FlexibleSpaceAutoBar({
    Widget title,
    Widget background,
    bool centerTitle,
    EdgeInsetsGeometry titlePadding,
    CollapseMode collapseMode,
    List<StretchMode> stretchModes,
  }) : super(
            title: title,
            centerTitle: centerTitle,
            titlePadding: titlePadding,
            collapseMode: collapseMode,
            stretchModes: stretchModes,
            background: background);
}

class SliverAutoAppBar extends StatefulWidget {
  const SliverAutoAppBar({Key key, this.bottom}) : super(key: key);

  final Widget bottom;

  @override
  _SliverAutoAppBarState createState() => _SliverAutoAppBarState();
}

class _SliverAutoAppBarState extends State<SliverAutoAppBar> {
  Size boxSize;
  GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
    Ts.addPostFrameCallback((duration) {
      boxSize = key.currentContext.size;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (boxSize == null) {
      return SliverAutoAppBar();
    } else
      return SliverAppBar(
        bottom: widget.bottom == null
            ? null
            : PreferredSize(child: widget.bottom, preferredSize: boxSize),
      );
  }
}

class FoldPersistentHeader extends SliverPersistentHeaderDelegate {
  FoldPersistentHeader({@required this.child});

  final PreferredSize child;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      child;

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
