import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_waya/constant/src/way.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef OnSliverPinnedPersistentHeaderDelegateBuild = void Function(
  BuildContext context,
  double shrinkOffset,
  double? minExtent,
  double maxExtent,
  bool overlapsContent,
);

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

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
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

/// 组合[SliverList]、[SliverGrid]、[SliverFixedExtentList]
class SliverListGrid extends StatelessWidget {
  const SliverListGrid({
    Key? key,

    /// 多列最大列数 [crossAxisCount]>1 固定列
    int? crossAxisCount = 1,

    /// 水平子Widget之间间距
    double? mainAxisSpacing = 0,

    /// 垂直子Widget之间间距
    double? crossAxisSpacing = 0,

    /// 子 Widget 宽高比例 [crossAxisCount]>1是 有效
    double? childAspectRatio = 1,

    /// 是否开启列数自适应
    /// [crossAxisFlex]=true 为多列 且宽度自适应
    /// [maxCrossAxisExtent]设置最大宽度
    bool? crossAxisFlex = false,

    ///  [crossAxisFlex]=true 单个子Widget的水平最大宽度
    double? maxCrossAxisExtent,
    this.mainAxisExtent,
    this.itemBuilder,
    this.itemCount,
    this.separatorBuilder,
    this.children,
    this.findChildIndexCallback,
    this.semanticIndexCallback,
    this.itemExtent,
    bool? addAutomaticKeepALives,
    bool? addRepaintBoundaries,
    bool? addSemanticIndexes,
    Widget? placeholder,
  })  : assert(children != null || (itemBuilder != null && itemCount != null)),
        placeholder = placeholder ?? const PlaceholderChild(),
        addAutomaticKeepALives = addAutomaticKeepALives ?? true,
        addRepaintBoundaries = addRepaintBoundaries ?? true,
        addSemanticIndexes = addSemanticIndexes ?? true,
        crossAxisCount = crossAxisCount ?? 1,
        mainAxisSpacing = mainAxisSpacing ?? 0,
        crossAxisSpacing = crossAxisSpacing ?? 0,
        childAspectRatio = childAspectRatio ?? 1,
        crossAxisFlex = crossAxisFlex ?? false,
        maxCrossAxisExtent = maxCrossAxisExtent ?? 10,
        super(key: key);

  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final bool crossAxisFlex;
  final double maxCrossAxisExtent;
  final double? mainAxisExtent;

  final IndexedWidgetBuilder? itemBuilder;
  final int? itemCount;
  final IndexedWidgetBuilder? separatorBuilder;
  final List<Widget>? children;

  final ChildIndexGetter? findChildIndexCallback;
  final SemanticIndexCallback? semanticIndexCallback;
  final bool addAutomaticKeepALives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? itemExtent;

  /// 无数据时的组件
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    late Widget current;
    late SliverChildDelegate delegate;
    if (itemBuilder != null && itemCount != null && itemCount! > 0) {
      int childCount = itemCount!;
      IndexedWidgetBuilder item = itemBuilder!;
      if (separatorBuilder != null) {
        item = (BuildContext context, int index) {
          final int itemIndex = index ~/ 2;
          Widget? widget;
          if (index.isEven) {
            widget = itemBuilder!(context, itemIndex);
          } else {
            widget = separatorBuilder!(context, itemIndex);
            assert(() {
              if (widget == null)
                throw FlutterError('separatorBuilder cannot return null.');
              return true;
            }());
          }
          return widget;
        };
        childCount = _computeActualChildCount(itemCount!);
      }
      delegate = SliverChildBuilderDelegate(item,
          childCount: childCount,
          findChildIndexCallback: findChildIndexCallback,
          addAutomaticKeepAlives: addAutomaticKeepALives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: semanticIndexCallback ??
              (Widget _, int localIndex) => localIndex);
    } else if (children != null && children!.isNotEmpty) {
      delegate = SliverChildListDelegate(children!,
          addAutomaticKeepAlives: addAutomaticKeepALives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: semanticIndexCallback ??
              (Widget _, int localIndex) => localIndex);
    } else {
      return SliverToBoxAdapter(child: placeholder);
    }

    if (crossAxisCount > 1 || crossAxisFlex) {
      current = SliverGrid(
          delegate: delegate,
          gridDelegate: crossAxisFlex
              ? SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisExtent: mainAxisExtent,
                  mainAxisSpacing: mainAxisSpacing,
                  crossAxisSpacing: crossAxisSpacing,
                  childAspectRatio: childAspectRatio,
                  maxCrossAxisExtent: maxCrossAxisExtent)
              : SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: mainAxisSpacing,
                  crossAxisSpacing: crossAxisSpacing,
                  childAspectRatio: childAspectRatio,
                  crossAxisCount: crossAxisCount,
                  mainAxisExtent: mainAxisExtent));
    } else {
      current = itemExtent != null
          ? SliverFixedExtentList(delegate: delegate, itemExtent: itemExtent!)
          : SliverList(delegate: delegate);
    }
    return current;
  }

  /// Helper method to compute the actual child count for the separated constructor.
  int _computeActualChildCount(int itemCount) => math.max(0, itemCount * 2 - 1);
}
