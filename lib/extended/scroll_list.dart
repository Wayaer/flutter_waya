import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ScrollList extends RefreshScrollView {
  /// 滑动类型设置 [physics]
  /// AlwaysScrollableScrollPhysics() 总是可以滑动
  /// NeverScrollableScrollPhysics() 禁止滚动
  /// BouncingScrollPhysics()  内容超过一屏 有回弹效果
  /// ClampingScrollPhysics()  包裹内容 不会有回弹

  const ScrollList({
    super.key,
    super.reverse = false,
    super.shrinkWrap = false,
    super.noScrollBehavior = false,
    super.primary,
    super.scrollDirection = Axis.vertical,
    super.clipBehavior = Clip.hardEdge,
    super.dragStartBehavior = DragStartBehavior.start,
    super.restorationId,
    super.cacheExtent,
    super.physics,
    super.padding,
    super.refreshConfig,
    super.controller,
    required this.sliver,
    this.header,
    this.footer,
  });

  ScrollList.builder({
    super.key,
    super.reverse = false,
    super.shrinkWrap = false,
    super.noScrollBehavior = false,
    super.primary,
    super.scrollDirection = Axis.vertical,
    super.clipBehavior = Clip.hardEdge,
    super.dragStartBehavior = DragStartBehavior.start,
    super.restorationId,
    super.cacheExtent,
    super.physics,
    super.padding,
    super.refreshConfig,
    super.controller,
    ChildIndexGetter? findChildIndexCallback,
    SemanticIndexCallback semanticIndexCallback = kDefaultSemanticIndexCallback,
    bool addAutomaticKeepALives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    GridStyle gridStyle = GridStyle.none,
    required IndexedWidgetBuilder itemBuilder,
    IndexedWidgetBuilder? separatorBuilder,
    int? itemCount,

    /// use [SliverFixedExtentList]、[itemExtent] 优先 [prototypeItem]
    double? itemExtent,

    /// use [SliverPrototypeExtentList]、[itemExtent] 优先 [prototypeItem]
    Widget? prototypeItem,

    /// 横轴子元素的数量 自适应最大像素
    /// use [SliverGridDelegateWithFixedCrossAxisCount] or [SliverSimpleGridDelegateWithFixedCrossAxisCount]
    int crossAxisCount = 1,

    /// 横轴元素最大像素 自适应列数
    /// use [SliverGridDelegateWithMaxCrossAxisExtent] or [SliverSimpleGridDelegateWithMaxCrossAxisExtent]
    double? maxCrossAxisExtent,

    /// 主轴方向子元素的间距
    double mainAxisSpacing = 0,

    /// 横轴方向子元素的间距
    double crossAxisSpacing = 0,

    /// 子元素在横轴长度和主轴长度的比例
    double childAspectRatio = 1,

    /// 子元素在主轴上的长度。[mainAxisExtent] 优先 [childAspectRatio]
    double? mainAxisExtent,
    Widget placeholder = const PlaceholderChild(),
    this.header,
    this.footer,
  }) : sliver = [
          SliverListGrid.builder(
              placeholder: placeholder,
              mainAxisExtent: mainAxisExtent,
              maxCrossAxisExtent: maxCrossAxisExtent,
              childAspectRatio: childAspectRatio,
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              addSemanticIndexes: addSemanticIndexes,
              addRepaintBoundaries: addRepaintBoundaries,
              addAutomaticKeepALives: addAutomaticKeepALives,
              findChildIndexCallback: findChildIndexCallback,
              semanticIndexCallback: semanticIndexCallback,
              gridStyle: gridStyle,
              itemBuilder: itemBuilder,
              separatorBuilder: separatorBuilder,
              itemCount: itemCount,
              itemExtent: itemExtent,
              prototypeItem: prototypeItem)
        ];

  ScrollList.count({
    super.key,
    super.reverse = false,
    super.shrinkWrap = false,
    super.noScrollBehavior = false,
    super.primary,
    super.scrollDirection = Axis.vertical,
    super.clipBehavior = Clip.hardEdge,
    super.dragStartBehavior = DragStartBehavior.start,
    super.restorationId,
    super.cacheExtent,
    super.physics,
    super.padding,
    super.refreshConfig,
    super.controller,
    SemanticIndexCallback semanticIndexCallback = kDefaultSemanticIndexCallback,
    bool addAutomaticKeepALives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    GridStyle gridStyle = GridStyle.none,
    required List<Widget> children,

    /// use [SliverFixedExtentList]、[itemExtent] 优先 [prototypeItem]
    double? itemExtent,

    /// use [SliverPrototypeExtentList]、[itemExtent] 优先 [prototypeItem]
    Widget? prototypeItem,

    /// 横轴子元素的数量 自适应最大像素
    /// use [SliverGridDelegateWithFixedCrossAxisCount] or [SliverSimpleGridDelegateWithFixedCrossAxisCount]
    int crossAxisCount = 1,

    /// 横轴元素最大像素 自适应列数
    /// use [SliverGridDelegateWithMaxCrossAxisExtent] or [SliverSimpleGridDelegateWithMaxCrossAxisExtent]
    double? maxCrossAxisExtent,

    /// 主轴方向子元素的间距
    double mainAxisSpacing = 0,

    /// 横轴方向子元素的间距
    double crossAxisSpacing = 0,

    /// 子元素在横轴长度和主轴长度的比例
    double childAspectRatio = 1,

    /// 子元素在主轴上的长度。[mainAxisExtent] 优先 [childAspectRatio]
    double? mainAxisExtent,
    Widget placeholder = const PlaceholderChild(),
    this.header,
    this.footer,
  }) : sliver = [
          SliverListGrid.count(
              semanticIndexCallback: semanticIndexCallback,
              placeholder: placeholder,
              mainAxisExtent: mainAxisExtent,
              maxCrossAxisExtent: maxCrossAxisExtent,
              childAspectRatio: childAspectRatio,
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              addSemanticIndexes: addSemanticIndexes,
              addRepaintBoundaries: addRepaintBoundaries,
              addAutomaticKeepALives: addAutomaticKeepALives,
              itemExtent: itemExtent,
              prototypeItem: prototypeItem,
              gridStyle: gridStyle,
              children: children)
        ];

  /// 添加多个 [Widget]
  final List<Widget> sliver;

  /// 添加头部 Sliver 组件
  final Widget? header;

  /// 添加底部 Sliver 组件
  final Widget? footer;

  @override
  List<Widget> buildSlivers() {
    final List<Widget> slivers = [];
    if (sliver.isNotEmpty) slivers.addAll(sliver);
    if (header != null) slivers.insert(0, header!);
    if (footer != null) slivers.add(footer!);
    return slivers;
  }
}

int kDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

enum GridStyle {
  none,
  masonry,
  aligned,
}

/// 组合[SliverList]、[SliverGrid]、[SliverFixedExtentList]、[SliverPrototypeExtentList]、[SliverMasonryGrid]、[SliverAlignedGrid]
class SliverListGrid extends StatelessWidget {
  const SliverListGrid.builder({
    super.key,
    required this.itemBuilder,
    this.separatorBuilder,
    this.itemCount,
    this.gridStyle = GridStyle.none,
    this.crossAxisCount = 1,
    this.maxCrossAxisExtent,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.childAspectRatio = 1,
    this.mainAxisExtent,
    this.findChildIndexCallback,
    this.semanticIndexCallback = kDefaultSemanticIndexCallback,
    this.itemExtent,
    this.prototypeItem,
    this.addAutomaticKeepALives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.placeholder = const PlaceholderChild(),
  }) : children = null;

  const SliverListGrid.count({
    super.key,
    required this.children,
    this.gridStyle = GridStyle.none,
    this.crossAxisCount = 1,
    this.maxCrossAxisExtent,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.childAspectRatio = 1,
    this.mainAxisExtent,
    this.semanticIndexCallback = kDefaultSemanticIndexCallback,
    this.itemExtent,
    this.prototypeItem,
    this.addAutomaticKeepALives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.placeholder = const PlaceholderChild(),
  })  : assert(children != null),
        assert(gridStyle != GridStyle.aligned),
        itemBuilder = null,
        itemCount = null,
        separatorBuilder = null,
        findChildIndexCallback = null;

  /// 横轴子元素的数量 自适应最大像素
  /// use [SliverGridDelegateWithFixedCrossAxisCount] or [SliverSimpleGridDelegateWithFixedCrossAxisCount]
  final int crossAxisCount;

  /// 横轴元素最大像素 自适应列数
  /// use [SliverGridDelegateWithMaxCrossAxisExtent] or [SliverSimpleGridDelegateWithMaxCrossAxisExtent]
  final double? maxCrossAxisExtent;

  /// 主轴方向子元素的间距
  final double mainAxisSpacing;

  /// 横轴方向子元素的间距
  final double crossAxisSpacing;

  /// 子元素在横轴长度和主轴长度的比例
  final double childAspectRatio;

  /// 子元素在主轴上的长度。[mainAxisExtent] 优先 [childAspectRatio]
  final double? mainAxisExtent;

  /// 大量子组件
  final IndexedWidgetBuilder? itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final int? itemCount;

  /// 少量子组件可使用 children
  final List<Widget>? children;

  /// use [SliverFixedExtentList]、[itemExtent] 优先 [prototypeItem]
  final double? itemExtent;

  /// use [SliverPrototypeExtentList]、[itemExtent] 优先 [prototypeItem]
  final Widget? prototypeItem;

  final ChildIndexGetter? findChildIndexCallback;
  final SemanticIndexCallback semanticIndexCallback;
  final bool addAutomaticKeepALives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;

  /// itemCount==0 || children.isisEmpty 时 显示的组件
  final Widget placeholder;

  final GridStyle gridStyle;

  @override
  Widget build(BuildContext context) {
    if (children.isEmptyOrNull && itemCount == 0) {
      return SliverToBoxAdapter(child: placeholder);
    }
    late SliverChildDelegate delegate;
    if (itemBuilder != null) {
      int? childCount = itemCount;
      IndexedWidgetBuilder item = itemBuilder!;
      if (separatorBuilder != null && childCount != null) {
        item = (BuildContext context, int index) {
          final int itemIndex = index ~/ 2;
          return index.isEven
              ? itemBuilder!(context, itemIndex)
              : separatorBuilder!(context, itemIndex);
        };
        childCount = _computeActualChildCount(childCount);
      }
      delegate = SliverChildBuilderDelegate(item,
          childCount: childCount,
          findChildIndexCallback: findChildIndexCallback,
          addAutomaticKeepAlives: addAutomaticKeepALives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: semanticIndexCallback);
    } else if (children != null) {
      delegate = SliverChildListDelegate(children!,
          addAutomaticKeepAlives: addAutomaticKeepALives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: semanticIndexCallback);
    }

    if (crossAxisCount > 1 || maxCrossAxisExtent != null) {
      SliverSimpleGridDelegate? simpleGridDelegate;
      SliverGridDelegate? gridDelegate;
      if (maxCrossAxisExtent != null) {
        simpleGridDelegate = SliverSimpleGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: maxCrossAxisExtent!);
        gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisExtent: mainAxisExtent,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio,
            maxCrossAxisExtent: maxCrossAxisExtent!);
      } else if (crossAxisCount > 1) {
        simpleGridDelegate = SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount);
        gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: mainAxisExtent,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio,
            crossAxisCount: crossAxisCount);
      }
      switch (gridStyle) {
        case GridStyle.none:
          return SliverGrid(delegate: delegate, gridDelegate: gridDelegate!);
        case GridStyle.masonry:
          return SliverMasonryGrid(
              delegate: delegate,
              gridDelegate: simpleGridDelegate!,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing);
        case GridStyle.aligned:
          return SliverAlignedGrid(
              itemBuilder: itemBuilder!,
              itemCount: itemCount,
              gridDelegate: simpleGridDelegate!,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              addAutomaticKeepAlives: addAutomaticKeepALives,
              addRepaintBoundaries: addRepaintBoundaries);
      }
    } else if (itemExtent != null) {
      return SliverFixedExtentList(delegate: delegate, itemExtent: itemExtent!);
    } else if (prototypeItem != null) {
      return SliverPrototypeExtentList(
          delegate: delegate, prototypeItem: prototypeItem!);
    } else {
      return SliverList(delegate: delegate);
    }
  }

  int _computeActualChildCount(int itemCount) => math.max(0, itemCount * 2 - 1);
}
