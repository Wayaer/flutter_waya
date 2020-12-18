import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class NestedScrollAuto extends StatefulWidget {
  const NestedScrollAuto(
      {Key key,
      this.sliverAutoAppBar,
      this.expanded = false,
      this.flex,
      this.headerSliverBuilder,
      this.floatHeaderSlivers = true,
      this.clipBehavior = Clip.hardEdge,
      this.reverse = false,
      this.physics,
      this.scrollDirection = Axis.vertical,
      this.dragStartBehavior = DragStartBehavior.start,
      this.body,
      this.controller,
      this.restorationId,
      this.slivers,
      this.persistentHeader,
      this.headerPinned = false,
      this.headerFloating = false,
      this.headerMinHeight})
      : super(key: key);

  /// SliverPersistentHeader
  final Widget persistentHeader;
  final bool headerPinned;
  final double headerMinHeight;
  final bool headerFloating;

  ///  SliverAppBar
  final SliverAutoAppBar sliverAutoAppBar;

  ///  NestedScrollView 外嵌套Expanded
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

  @override
  _NestedScrollAutoState createState() => _NestedScrollAutoState();
}

class _NestedScrollAutoState extends State<NestedScrollAuto> {
  bool showNestedScroll = false;
  GlobalKey persistentHeaderKey = GlobalKey();
  Size persistentHeaderSize;
  GlobalKey flexibleSpaceKey = GlobalKey();
  Size flexibleSpaceSize;

  GlobalKey bottomKey = GlobalKey();
  Size bottomSize;

  @override
  void initState() {
    super.initState();
    Ts.addPostFrameCallback((Duration duration) {
      persistentHeaderSize =
          persistentHeaderKey?.currentContext?.size ?? const Size(0, 0);
      flexibleSpaceSize =
          flexibleSpaceKey?.currentContext?.size ?? const Size(0, 0);
      bottomSize = bottomKey?.currentContext?.size ?? const Size(0, 0);
      if (bottomSize.height > kToolbarHeight)
        bottomSize = Size(bottomSize.width, kToolbarHeight);
      showNestedScroll = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!showNestedScroll) {
      final List<Widget> column = <Widget>[];
      if (widget.sliverAutoAppBar != null) {
        final Widget flexibleSpace = widget.sliverAutoAppBar.flexibleSpace;
        if (flexibleSpace != null) {
          final List<Widget> stack = <Widget>[];
          if (flexibleSpace is FlexibleSpaceBar) {
            final FlexibleSpaceBar space = flexibleSpace;
            if (space.title != null) stack.add(space.title);
            if (space.background != null) stack.add(space.background);
          } else {
            stack.add(flexibleSpace);
          }
          column.add(Stack(key: flexibleSpaceKey, children: stack));
        }
        if (widget.sliverAutoAppBar.bottom != null) {
          column.add(
              Container(key: bottomKey, child: widget.sliverAutoAppBar.bottom));
        }
      }

      if (widget.persistentHeader != null) {
        column.add(Container(
            key: persistentHeaderKey, child: widget.persistentHeader));
      }
      return Column(children: column);
    }
    final NestedScrollView nestedScroll = NestedScrollView(
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
                headerSliverBuilder);
    if (widget.expanded)
      return Expanded(flex: widget.flex, child: nestedScroll);
    return nestedScroll;
  }

  List<Widget> get headerSliverBuilder {
    final List<Widget> children = <Widget>[];
    if (widget.sliverAutoAppBar != null) children.add(sliverAppBar);
    if (widget.persistentHeader != null) children.add(persistentHeader);
    if (widget.slivers != null && widget.slivers.isNotEmpty)
      children.addAll(widget.slivers);
    return children;
  }

  Widget get persistentHeader => SliverPersistentHeader(
        pinned: widget.headerPinned,
        floating: widget.headerFloating,
        delegate: widget.headerPinned
            ? PinnedPersistentHeaderDelegate(
                height: persistentHeaderSize.height,
                child: widget.persistentHeader)
            : NoPinnedPersistentHeaderDelegate(
                child: widget.persistentHeader,
                minHeight:
                    widget.headerMinHeight ?? persistentHeaderSize.height,
                maxHeight: persistentHeaderSize.height),
      );

  Widget get sliverAppBar => SliverAppBar(
      automaticallyImplyLeading:
          widget.sliverAutoAppBar.automaticallyImplyLeading,
      title: widget.sliverAutoAppBar.title,
      actions: widget.sliverAutoAppBar.actions,
      forceElevated: widget.sliverAutoAppBar.forceElevated,
      backgroundColor: widget.sliverAutoAppBar.backgroundColor,
      iconTheme: widget.sliverAutoAppBar.iconTheme,
      actionsIconTheme: widget.sliverAutoAppBar.actionsIconTheme,
      textTheme: widget.sliverAutoAppBar.textTheme,
      primary: widget.sliverAutoAppBar.primary,
      centerTitle: widget.sliverAutoAppBar.centerTitle,
      titleSpacing: widget.sliverAutoAppBar.titleSpacing,
      snap: widget.sliverAutoAppBar.snap,
      stretch: widget.sliverAutoAppBar.stretch,
      stretchTriggerOffset: widget.sliverAutoAppBar.stretchTriggerOffset,
      onStretchTrigger: widget.sliverAutoAppBar.onStretchTrigger,
      elevation: widget.sliverAutoAppBar.elevation,
      brightness: widget.sliverAutoAppBar.brightness,
      leading: widget.sliverAutoAppBar.leading,
      pinned: widget.sliverAutoAppBar.pinned,
      floating: widget.sliverAutoAppBar.floating,
      expandedHeight: math.max(flexibleSpaceSize.height, kToolbarHeight),
      shape: widget.sliverAutoAppBar.shape,
      toolbarHeight: widget.sliverAutoAppBar.toolbarHeight,
      leadingWidth: widget.sliverAutoAppBar.leadingWidth,
      bottom: widget.sliverAutoAppBar.bottom == null
          ? null
          : PreferredSize(
              child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: bottomSize.height),
                  child: widget.sliverAutoAppBar.bottom),
              preferredSize: bottomSize),
      flexibleSpace: widget.sliverAutoAppBar.flexibleSpace);
}

class FlexibleSpaceAutoBar extends StatelessWidget {
  const FlexibleSpaceAutoBar(
      {this.title,
      this.background,
      this.centerTitle = true,
      this.titlePadding,
      this.collapseMode = CollapseMode.parallax,
      this.stretchModes = const <StretchMode>[StretchMode.zoomBackground]})
      : super();

  final Widget title;
  final Widget background;
  final EdgeInsetsGeometry titlePadding;
  final bool centerTitle;
  final CollapseMode collapseMode;
  final List<StretchMode> stretchModes;

  @override
  Widget build(BuildContext context) => FlexibleSpaceBar(
      title: title,
      centerTitle: centerTitle,
      titlePadding: titlePadding,
      collapseMode: collapseMode,
      stretchModes: stretchModes,
      background: background);
}

class SliverAutoAppBar extends SliverAppBar {
  SliverAutoAppBar(
      {Key key,
      bool automaticallyImplyLeading = true,
      Widget title,
      List<Widget> actions,
      bool forceElevated = false,
      Color backgroundColor,
      IconThemeData iconTheme,
      TextTheme textTheme,
      IconThemeData actionsIconTheme,
      double titleSpacing = NavigationToolbar.kMiddleSpacing,
      bool primary = true,
      bool centerTitle = true,
      bool stretch = false,
      double stretchTriggerOffset = 100,
      Brightness brightness,
      AsyncCallback onStretchTrigger,
      double elevation,
      Widget leading,
      double leadingWidth,
      bool pinned = false,
      bool floating = false,
      bool snap = false,
      ShapeBorder shape,
      double toolbarHeight = kToolbarHeight,
      double collapsedHeight,
      Widget bottom,
      Widget flexibleSpace,
      Size bottomSize,

      /// FlexibleSpaceBar
      Widget flexibleSpaceTitle,
      Widget background,
      bool flexibleCenterTitle = true,
      EdgeInsetsGeometry titlePadding,
      CollapseMode collapseMode = CollapseMode.parallax,
      List<StretchMode> stretchModes = const <StretchMode>[
        StretchMode.zoomBackground
      ]})
      : super(
            key: key,
            title: title,
            actions: actions,
            forceElevated: forceElevated,
            backgroundColor: backgroundColor,
            iconTheme: iconTheme,
            textTheme: textTheme,
            actionsIconTheme: actionsIconTheme,
            titleSpacing: titleSpacing,
            primary: primary,
            centerTitle: centerTitle,
            stretch: stretch,
            stretchTriggerOffset: stretchTriggerOffset,
            brightness: brightness,
            onStretchTrigger: onStretchTrigger,
            elevation: elevation,
            leading: leading,
            leadingWidth: leadingWidth,
            pinned: pinned,
            floating: floating,
            snap: snap,
            shape: shape,
            toolbarHeight: toolbarHeight,
            collapsedHeight: collapsedHeight,
            automaticallyImplyLeading: automaticallyImplyLeading,
            bottom: bottom == null
                ? null
                : PreferredSize(child: bottom, preferredSize: bottomSize),
            flexibleSpace: flexibleSpace ??
                FlexibleSpaceBar(
                    title: flexibleSpaceTitle,
                    centerTitle: flexibleCenterTitle,
                    titlePadding: titlePadding,
                    collapseMode: collapseMode,
                    stretchModes: stretchModes,
                    background: background));
}

/// SliverPersistentHeader 固定
class PinnedPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  PinnedPersistentHeaderDelegate({
    @required this.child,
    @required this.height,
  });

  final Widget child;
  final double height;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      child;

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

/// SliverPersistentHeader 不固定
class NoPinnedPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  NoPinnedPersistentHeaderDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      child;

  @override
  bool shouldRebuild(NoPinnedPersistentHeaderDelegate oldDelegate) =>
      maxHeight != oldDelegate.maxHeight ||
      minHeight != oldDelegate.minHeight ||
      child != oldDelegate.child;
}
