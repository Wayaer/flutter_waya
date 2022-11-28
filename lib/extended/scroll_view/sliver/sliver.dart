import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 瀑布流 添加empty视图
class SliverWaterfallFlow extends StatelessWidget {
  const SliverWaterfallFlow(
      {super.key,
      this.itemBuilder,
      this.itemCount,
      this.findChildIndexCallback,
      this.semanticIndexCallback,
      this.addAutomaticKeepALives = false,
      this.addRepaintBoundaries = false,
      this.addSemanticIndexes = true,
      this.mainAxisSpacing = 0,
      this.crossAxisSpacing = 0,
      this.maxCrossAxisExtent,
      this.crossAxisCount,
      this.placeholder = const PlaceholderChild()})
      : assert(maxCrossAxisExtent != null || crossAxisCount != null),
        aligned = false,
        children = null;

  const SliverWaterfallFlow.count(
      {super.key,
      this.children,
      this.semanticIndexCallback,
      this.addAutomaticKeepALives = false,
      this.addRepaintBoundaries = false,
      this.addSemanticIndexes = true,
      this.mainAxisSpacing = 0,
      this.crossAxisSpacing = 0,
      this.maxCrossAxisExtent,
      this.crossAxisCount,
      this.placeholder = const PlaceholderChild()})
      : assert(maxCrossAxisExtent != null || crossAxisCount != null),
        aligned = false,
        itemBuilder = null,
        itemCount = null,
        findChildIndexCallback = null;

  const SliverWaterfallFlow.aligned(
      {super.key,
      this.itemBuilder,
      this.itemCount,
      this.findChildIndexCallback,
      this.semanticIndexCallback,
      this.addAutomaticKeepALives = false,
      this.addRepaintBoundaries = false,
      this.addSemanticIndexes = true,
      this.mainAxisSpacing = 0,
      this.maxCrossAxisExtent,
      this.crossAxisSpacing = 0,
      this.crossAxisCount,
      this.placeholder = const PlaceholderChild()})
      : assert(maxCrossAxisExtent != null || crossAxisCount != null),
        assert(itemBuilder != null),
        children = null,
        aligned = true;

  final ChildIndexGetter? findChildIndexCallback;
  final SemanticIndexCallback? semanticIndexCallback;
  final bool addAutomaticKeepALives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;

  /// 渲染子组件
  final IndexedWidgetBuilder? itemBuilder;
  final int? itemCount;

  /// 少量子组件可使用 children
  final List<Widget>? children;

  /// 主轴元素之间的距离
  final double mainAxisSpacing;

  /// 横轴元素之间的距离
  final double crossAxisSpacing;

  /// 横轴元素单个最大距离
  final double? maxCrossAxisExtent;

  /// 横轴的等长度元素数量
  final int? crossAxisCount;

  /// itemCount==0 || children.isisEmpty 时 显示的组件
  final Widget placeholder;

  /// use [SliverAlignedGrid]
  final bool aligned;

  @override
  Widget build(BuildContext context) {
    late Widget current = SliverToBoxAdapter(child: placeholder);
    SliverChildDelegate? delegate;
    SliverSimpleGridDelegate? gridDelegate;
    if (maxCrossAxisExtent != null) {
      gridDelegate = SliverSimpleGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: maxCrossAxisExtent!);
    } else if (crossAxisCount != null) {
      gridDelegate = SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount!);
    }
    if (aligned &&
        itemCount != null &&
        itemCount! > 0 &&
        gridDelegate != null) {
      current = SliverAlignedGrid(
          itemBuilder: itemBuilder!,
          itemCount: itemCount,
          gridDelegate: gridDelegate,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          addAutomaticKeepAlives: addAutomaticKeepALives,
          addRepaintBoundaries: addRepaintBoundaries);
    } else {
      if (itemBuilder != null && itemCount != null && itemCount! > 0) {
        delegate = SliverChildBuilderDelegate(itemBuilder!,
            childCount: itemCount,
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
      }
      if (delegate != null && gridDelegate != null) {
        current = SliverMasonryGrid(
            delegate: delegate,
            gridDelegate: gridDelegate,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing);
      }
    }
    return current;
  }
}

/// 组合[SliverList]、[SliverGrid]、[SliverFixedExtentList]
class SliverListGrid extends StatelessWidget {
  const SliverListGrid({
    super.key,

    /// 多列最大列数 [crossAxisCount]>1 固定列
    this.crossAxisCount = 1,

    /// 水平子Widget之间间距
    this.mainAxisSpacing = 0,

    /// 垂直子Widget之间间距
    this.crossAxisSpacing = 0,

    /// 子 Widget 宽高比例 [crossAxisCount]>1是 有效
    this.childAspectRatio = 1,

    /// 是否开启列数自适应
    /// [crossAxisFlex]=true 为多列 且宽度自适应
    /// [maxCrossAxisExtent]设置最大宽度
    this.crossAxisFlex = false,

    /// [crossAxisFlex]=true 单个子Widget的水平最大宽度
    this.maxCrossAxisExtent = 10,
    this.mainAxisExtent,
    this.itemBuilder,
    this.itemCount,
    this.separatorBuilder,
    this.findChildIndexCallback,
    this.semanticIndexCallback,
    this.itemExtent,
    this.addAutomaticKeepALives = false,
    this.addRepaintBoundaries = false,
    this.addSemanticIndexes = true,
    this.placeholder = const PlaceholderChild(),
    this.prototypeItem,
  })  : assert(itemBuilder != null && itemCount != null),
        children = null;

  const SliverListGrid.count({
    super.key,

    /// 多列最大列数 [crossAxisCount]>1 固定列
    this.crossAxisCount = 1,

    /// 水平子Widget之间间距
    this.mainAxisSpacing = 0,

    /// 垂直子Widget之间间距
    this.crossAxisSpacing = 0,

    /// 子 Widget 宽高比例 [crossAxisCount]>1是 有效
    this.childAspectRatio = 1,

    /// 是否开启列数自适应
    /// [crossAxisFlex]=true 为多列 且宽度自适应
    /// [maxCrossAxisExtent]设置最大宽度
    this.crossAxisFlex = false,

    /// [crossAxisFlex]=true 单个子Widget的水平最大宽度
    this.maxCrossAxisExtent = 10,
    this.mainAxisExtent,
    this.children,
    this.semanticIndexCallback,
    this.addAutomaticKeepALives = false,
    this.addRepaintBoundaries = false,
    this.addSemanticIndexes = true,
    this.placeholder = const PlaceholderChild(),
    this.prototypeItem,
    this.itemExtent,
  })  : assert(children != null),
        itemBuilder = null,
        itemCount = null,
        separatorBuilder = null,
        findChildIndexCallback = null;

  /// 横轴的等长度元素数量
  final int crossAxisCount;

  /// 主轴元素之间的距离
  final double mainAxisSpacing;

  /// 横轴元素之间的距离
  final double crossAxisSpacing;
  final double childAspectRatio;

  /// 开启宽度自适应 需设置 [maxCrossAxisExtent]
  final bool crossAxisFlex;

  /// 横轴元素最大的大小
  final double maxCrossAxisExtent;
  final double? mainAxisExtent;

  /// 渲染子组件
  final IndexedWidgetBuilder? itemBuilder;
  final int? itemCount;
  final IndexedWidgetBuilder? separatorBuilder;

  /// 少量子组件可使用 children
  final List<Widget>? children;

  /// [prototypeItem]!=null 使用 [SliverPrototypeExtentList]
  final Widget? prototypeItem;

  /// [itemExtent]!=null && [prototypeItem]!=null 使用 [SliverFixedExtentList]
  /// [itemExtent]!=null 使用 [SliverFixedExtentList]
  final double? itemExtent;

  final ChildIndexGetter? findChildIndexCallback;
  final SemanticIndexCallback? semanticIndexCallback;
  final bool addAutomaticKeepALives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;

  /// itemCount==0 || children.isisEmpty 时 显示的组件
  final Widget placeholder;

  @override
  Widget build(BuildContext context) {
    late Widget current = SliverToBoxAdapter(child: placeholder);
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
              if (widget == null) {
                throw FlutterError('separatorBuilder cannot return null.');
              }
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
      return current;
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
      if (itemExtent != null) {
        current =
            SliverFixedExtentList(delegate: delegate, itemExtent: itemExtent!);
      } else if (prototypeItem != null) {
        current = SliverPrototypeExtentList(
            delegate: delegate, prototypeItem: prototypeItem!);
      } else {
        current = SliverList(delegate: delegate);
      }
    }
    return current;
  }

  int _computeActualChildCount(int itemCount) => math.max(0, itemCount * 2 - 1);
}
