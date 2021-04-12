import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_waya/flutter_waya.dart';

import 'element.dart';
import 'render.dart';

abstract class SliverPinnedPersistentHeaderDelegate {
  SliverPinnedPersistentHeaderDelegate({
    required this.minExtentProtoType,
    required this.maxExtentProtoType,
  });

  final Widget minExtentProtoType;

  final Widget maxExtentProtoType;

  Widget build(BuildContext context, double shrinkOffset, double? minExtent,
      double maxExtent, bool overlapsContent);

  bool shouldRebuild(
      covariant SliverPinnedPersistentHeaderDelegate oldDelegate);
}

class SliverPinnedPersistentHeader extends StatelessWidget {
  const SliverPinnedPersistentHeader({required this.delegate});

  final SliverPinnedPersistentHeaderDelegate delegate;

  @override
  Widget build(BuildContext context) =>
      SliverPinnedPersistentHeaderRenderObjectWidget(delegate);
}

class SliverPinnedPersistentHeaderRenderObjectWidget
    extends RenderObjectWidget {
  const SliverPinnedPersistentHeaderRenderObjectWidget(this.delegate);

  final SliverPinnedPersistentHeaderDelegate delegate;

  @override
  RenderObjectElement createElement() =>
      SliverPinnedPersistentHeaderElement(this);

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderSliverPinnedPersistentHeader();
}

class SliverPinnedToBoxAdapter extends SingleChildRenderObjectWidget {
  const SliverPinnedToBoxAdapter({
    Key? key,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  RenderSliverPinnedToBoxAdapter createRenderObject(BuildContext context) =>
      RenderSliverPinnedToBoxAdapter();
}

class CustomSliverAppbar extends StatelessWidget {
  const CustomSliverAppbar({
    this.leading,
    this.title,
    this.actions,
    this.background,
    this.toolBarColor,
    this.onBuild,
    this.statusBarHeight,
    this.toolbarHeight,
    this.isOpacityFadeWithToolbar = true,
    this.isOpacityFadeWithTitle = true,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final Widget? leading;

  final Widget? title;

  final Widget? actions;

  final Widget? background;

  final Color? toolBarColor;

  final OnSliverPinnedPersistentHeaderDelegateBuild? onBuild;

  final double? toolbarHeight;

  final double? statusBarHeight;

  final bool isOpacityFadeWithToolbar;

  final bool isOpacityFadeWithTitle;

  final MainAxisAlignment mainAxisAlignment;

  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final SafeArea? safeArea =
        context.findAncestorWidgetOfExactType<SafeArea>();
    double? height = statusBarHeight;
    final double toolbarHeight = this.toolbarHeight ?? kToolbarHeight;
    if (height == null && (safeArea == null || !safeArea.top)) {
      height = MediaQuery.of(context).padding.top;
    }
    height ??= 0;
    final Widget toolbar = SizedBox(height: toolbarHeight + height);
    return SliverPinnedPersistentHeader(
        delegate: _CustomSliverAppbarDelegate(
      minExtentProtoType: toolbar,
      maxExtentProtoType: background ?? toolbar,
      title: title,
      leading: leading,
      actions: actions,
      background: background,
      statusBarHeight: height,
      toolbarHeight: toolbarHeight,
      toolBarColor: toolBarColor,
      onBuild: onBuild,
      isOpacityFadeWithToolbar: isOpacityFadeWithToolbar,
      isOpacityFadeWithTitle: isOpacityFadeWithTitle,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    ));
  }
}

class _CustomSliverAppbarDelegate extends SliverPinnedPersistentHeaderDelegate {
  _CustomSliverAppbarDelegate({
    required Widget minExtentProtoType,
    required Widget maxExtentProtoType,
    this.leading,
    this.title,
    this.actions,
    this.background,
    this.toolBarColor,
    this.onBuild,
    this.statusBarHeight,
    this.toolbarHeight,
    this.isOpacityFadeWithToolbar = true,
    this.isOpacityFadeWithTitle = true,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(
            minExtentProtoType: minExtentProtoType,
            maxExtentProtoType: maxExtentProtoType);

  final Widget? leading;

  final Widget? title;

  final Widget? actions;

  final Widget? background;

  final Color? toolBarColor;

  final OnSliverPinnedPersistentHeaderDelegateBuild? onBuild;

  final double? toolbarHeight;

  final double? statusBarHeight;

  final bool isOpacityFadeWithToolbar;

  final bool isOpacityFadeWithTitle;

  final MainAxisAlignment mainAxisAlignment;

  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context, double shrinkOffset, double? minExtent,
      double maxExtent, bool overlapsContent) {
    onBuild?.call(context, shrinkOffset, minExtent, maxExtent, overlapsContent);
    final double opacity =
        (shrinkOffset / (maxExtent - minExtent!)).clamp(0.0, 1.0);
    Widget? titleWidget = title;
    if (titleWidget != null) {
      if (isOpacityFadeWithTitle) {
        titleWidget = Opacity(opacity: opacity, child: titleWidget);
      }
    } else {
      titleWidget = Container();
    }
    final ThemeData theme = Theme.of(context);

    Color toolBarColor = this.toolBarColor ?? theme.primaryColor;
    if (isOpacityFadeWithToolbar) {
      toolBarColor = toolBarColor.withOpacity(opacity);
    }

    final Widget toolbar = Universal(
        height: toolbarHeight! + statusBarHeight!,
        padding: EdgeInsets.only(top: statusBarHeight!),
        color: toolBarColor,
        direction: Axis.horizontal,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: <Widget>[
          leading ?? const BackButton(onPressed: null),
          titleWidget,
          actions ?? Container(width: 100)
        ]);

    return Material(
        child: Universal(isClipRect: true, isStack: true, children: <Widget>[
      Positioned(
          child: maxExtentProtoType,
          top: -shrinkOffset,
          bottom: 0,
          left: 0,
          right: 0),
      Positioned(child: toolbar, top: 0, left: 0, right: 0),
    ]));
  }

  @override
  bool shouldRebuild(SliverPinnedPersistentHeaderDelegate oldDelegate) {
    if (oldDelegate.runtimeType != runtimeType) {
      return true;
    }

    return oldDelegate is _CustomSliverAppbarDelegate &&
        (oldDelegate.minExtentProtoType != minExtentProtoType ||
            oldDelegate.maxExtentProtoType != maxExtentProtoType ||
            oldDelegate.leading != leading ||
            oldDelegate.title != title ||
            oldDelegate.actions != actions ||
            oldDelegate.background != background ||
            oldDelegate.statusBarHeight != statusBarHeight ||
            oldDelegate.toolBarColor != toolBarColor ||
            oldDelegate.toolbarHeight != toolbarHeight ||
            oldDelegate.onBuild != onBuild ||
            oldDelegate.isOpacityFadeWithTitle != isOpacityFadeWithTitle ||
            oldDelegate.isOpacityFadeWithToolbar != isOpacityFadeWithToolbar ||
            oldDelegate.mainAxisAlignment != mainAxisAlignment ||
            oldDelegate.crossAxisAlignment != crossAxisAlignment);
  }
}

typedef OnSliverPinnedPersistentHeaderDelegateBuild = void Function(
  BuildContext context,
  double shrinkOffset,
  double? minExtent,
  double maxExtent,
  bool overlapsContent,
);
