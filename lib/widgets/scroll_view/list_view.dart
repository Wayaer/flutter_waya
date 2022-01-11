import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ScrollList extends RefreshScrollView {
  /// 滑动类型设置 [physics]
  /// AlwaysScrollableScrollPhysics() 总是可以滑动
  /// NeverScrollableScrollPhysics() 禁止滚动
  /// BouncingScrollPhysics()  内容超过一屏 有回弹效果
  /// ClampingScrollPhysics()  包裹内容 不会有回弹

  ScrollList({
    Key? key,
    Clip? clipBehavior,
    bool? reverse,
    double? cacheExtent,
    bool? primary,
    ScrollPhysics? physics,
    Axis? scrollDirection,
    DragStartBehavior? dragStartBehavior,
    ScrollController? controller,
    String? restorationId,
    bool? shrinkWrap = false,
    RefreshConfig? refreshConfig,
    bool? noScrollBehavior = false,
    EdgeInsetsGeometry? padding,
    required this.sliver,
    this.header,
    this.footer,
  }) : super(
            key: key,
            padding: padding,
            refreshConfig: refreshConfig,
            noScrollBehavior: noScrollBehavior,
            controller: controller,
            scrollDirection: scrollDirection ?? Axis.vertical,
            shrinkWrap: shrinkWrap,
            reverse: reverse ?? false,
            clipBehavior: clipBehavior ?? Clip.hardEdge,
            dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
            cacheExtent: cacheExtent,
            restorationId: restorationId,
            physics: physics,
            primary: primary);

  ScrollList.builder({
    Key? key,
    Clip? clipBehavior,
    bool? reverse,
    double? cacheExtent,
    bool? primary,
    ScrollPhysics? physics,
    Axis? scrollDirection,
    DragStartBehavior? dragStartBehavior,
    ScrollController? controller,
    String? restorationId,
    bool? shrinkWrap = false,
    double? itemExtent,
    required IndexedWidgetBuilder itemBuilder,
    required int itemCount,
    ChildIndexGetter? findChildIndexCallback,
    SemanticIndexCallback? semanticIndexCallback,
    bool addAutomaticKeepALives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    RefreshConfig? refreshConfig,
    bool? noScrollBehavior = false,
    EdgeInsetsGeometry? padding,

    /// 多列最大列数 [crossAxisCount]>1 固定列
    int crossAxisCount = 1,

    /// 水平子Widget之间间距
    double mainAxisSpacing = 0,

    /// 垂直子Widget之间间距
    double crossAxisSpacing = 0,

    /// 子 Widget 宽高比例 [crossAxisCount]>1是 有效
    double childAspectRatio = 1,

    /// 是否开启列数自适应
    /// [crossAxisFlex]=true 为多列 且宽度自适应
    /// [maxCrossAxisExtent]设置最大宽度
    bool crossAxisFlex = false,

    /// 单个子Widget的水平最大宽度
    double maxCrossAxisExtent = 10,
    double? mainAxisExtent,
    Widget placeholder = const PlaceholderChild(),
    this.header,
    this.footer,
  })  : sliver = <SliverListGrid>[
          SliverListGrid(
              placeholder: placeholder,
              mainAxisExtent: mainAxisExtent,
              maxCrossAxisExtent: maxCrossAxisExtent,
              crossAxisFlex: crossAxisFlex,
              childAspectRatio: childAspectRatio,
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              addSemanticIndexes: addSemanticIndexes,
              addRepaintBoundaries: addRepaintBoundaries,
              addAutomaticKeepALives: addAutomaticKeepALives,
              findChildIndexCallback: findChildIndexCallback,
              semanticIndexCallback: semanticIndexCallback,
              itemBuilder: itemBuilder,
              itemCount: itemCount,
              itemExtent: itemExtent)
        ],
        super(
            key: key,
            padding: padding,
            refreshConfig: refreshConfig,
            noScrollBehavior: noScrollBehavior,
            controller: controller,
            scrollDirection: scrollDirection,
            shrinkWrap: shrinkWrap,
            reverse: reverse,
            clipBehavior: clipBehavior,
            dragStartBehavior: dragStartBehavior,
            cacheExtent: cacheExtent,
            restorationId: restorationId,
            physics: physics,
            primary: primary);

  ScrollList.waterfall({
    Key? key,
    Clip? clipBehavior,
    bool? reverse,
    double? cacheExtent,
    bool? primary,
    ScrollPhysics? physics,
    Axis? scrollDirection,
    DragStartBehavior? dragStartBehavior,
    ScrollController? controller,
    String? restorationId,
    bool? shrinkWrap = false,
    required IndexedWidgetBuilder itemBuilder,
    required int itemCount,
    ChildIndexGetter? findChildIndexCallback,
    SemanticIndexCallback? semanticIndexCallback,
    bool addAutomaticKeepALives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    RefreshConfig? refreshConfig,
    bool? noScrollBehavior = false,
    EdgeInsetsGeometry? padding,

    /// 最大列数 [crossAxisCount]>1 固定列
    int? crossAxisCount,

    /// 单个子Widget的水平最大宽度 宽度自适应列数
    double? maxCrossAxisExtent,

    /// 水平子Widget之间间距
    double mainAxisSpacing = 0,

    /// 垂直子Widget之间间距
    double crossAxisSpacing = 0,
    Widget placeholder = const PlaceholderChild(),
    this.header,
    this.footer,
  })  : assert(crossAxisCount != null || maxCrossAxisExtent != null),
        sliver = <SliverWaterfallFlow>[
          SliverWaterfallFlow(
              placeholder: placeholder,
              maxCrossAxisExtent: maxCrossAxisExtent,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: crossAxisSpacing,
              addSemanticIndexes: addSemanticIndexes,
              addRepaintBoundaries: addRepaintBoundaries,
              addAutomaticKeepALives: addAutomaticKeepALives,
              findChildIndexCallback: findChildIndexCallback,
              semanticIndexCallback: semanticIndexCallback,
              itemBuilder: itemBuilder,
              itemCount: itemCount)
        ],
        super(
            key: key,
            padding: padding,
            refreshConfig: refreshConfig,
            noScrollBehavior: noScrollBehavior,
            controller: controller,
            scrollDirection: scrollDirection,
            shrinkWrap: shrinkWrap,
            reverse: reverse,
            clipBehavior: clipBehavior,
            dragStartBehavior: dragStartBehavior,
            cacheExtent: cacheExtent,
            restorationId: restorationId,
            physics: physics,
            primary: primary);

  ScrollList.separated({
    Key? key,
    Clip? clipBehavior,
    bool? reverse,
    double? cacheExtent,
    bool? primary,
    ScrollPhysics? physics,
    Axis? scrollDirection,
    DragStartBehavior? dragStartBehavior,
    ScrollController? controller,
    String? restorationId,
    bool? shrinkWrap = false,
    double? itemExtent,
    required IndexedWidgetBuilder itemBuilder,
    required int itemCount,
    required IndexedWidgetBuilder separatorBuilder,
    bool addAutomaticKeepALives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    RefreshConfig? refreshConfig,
    bool? noScrollBehavior = false,
    EdgeInsetsGeometry? padding,
    Widget placeholder = const PlaceholderChild(),
    ChildIndexGetter? findChildIndexCallback,
    SemanticIndexCallback? semanticIndexCallback,
    this.header,
    this.footer,
  })  : sliver = <SliverListGrid>[
          SliverListGrid(
              findChildIndexCallback: findChildIndexCallback,
              semanticIndexCallback: semanticIndexCallback,
              placeholder: placeholder,
              addSemanticIndexes: addSemanticIndexes,
              addRepaintBoundaries: addRepaintBoundaries,
              addAutomaticKeepALives: addAutomaticKeepALives,
              itemBuilder: itemBuilder,
              separatorBuilder: separatorBuilder,
              itemCount: itemCount,
              itemExtent: itemExtent)
        ],
        super(
            key: key,
            padding: padding,
            refreshConfig: refreshConfig,
            noScrollBehavior: noScrollBehavior,
            controller: controller,
            scrollDirection: scrollDirection,
            shrinkWrap: shrinkWrap,
            reverse: reverse,
            clipBehavior: clipBehavior,
            dragStartBehavior: dragStartBehavior,
            cacheExtent: cacheExtent,
            restorationId: restorationId,
            physics: physics,
            primary: primary);

  ScrollList.count({
    Key? key,
    Clip? clipBehavior,
    bool? reverse,
    double? cacheExtent,
    bool? primary,
    ScrollPhysics? physics,
    Axis? scrollDirection,
    DragStartBehavior? dragStartBehavior,
    ScrollController? controller,
    String? restorationId,
    bool? shrinkWrap = false,
    double? itemExtent,
    required List<Widget> children,
    bool addAutomaticKeepALives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    RefreshConfig? refreshConfig,
    bool? noScrollBehavior = false,
    EdgeInsetsGeometry? padding,

    /// 多列最大列数 [crossAxisCount]>1 固定列
    int crossAxisCount = 1,

    /// 水平子Widget之间间距
    double mainAxisSpacing = 0,

    /// 垂直子Widget之间间距
    double crossAxisSpacing = 0,

    /// 子Widget 宽高比例 [crossAxisCount]>1是 有效
    double childAspectRatio = 1,

    /// 是否开启列数自适应
    /// [crossAxisFlex]=true 为多列 且宽度自适应
    /// [maxCrossAxisExtent]设置最大宽度
    bool crossAxisFlex = false,

    /// 单个子Widget的水平最大宽度
    double maxCrossAxisExtent = 10,
    double? mainAxisExtent,
    Widget placeholder = const PlaceholderChild(),
    SemanticIndexCallback? semanticIndexCallback,
    this.header,
    this.footer,
  })  : sliver = <SliverListGrid>[
          SliverListGrid.count(
              semanticIndexCallback: semanticIndexCallback,
              placeholder: placeholder,
              mainAxisExtent: mainAxisExtent,
              maxCrossAxisExtent: maxCrossAxisExtent,
              crossAxisFlex: crossAxisFlex,
              childAspectRatio: childAspectRatio,
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              addSemanticIndexes: addSemanticIndexes,
              addRepaintBoundaries: addRepaintBoundaries,
              addAutomaticKeepALives: addAutomaticKeepALives,
              children: children,
              itemExtent: itemExtent)
        ],
        super(
            key: key,
            padding: padding,
            refreshConfig: refreshConfig,
            noScrollBehavior: noScrollBehavior,
            controller: controller,
            scrollDirection: scrollDirection,
            shrinkWrap: shrinkWrap,
            reverse: reverse,
            clipBehavior: clipBehavior,
            dragStartBehavior: dragStartBehavior,
            cacheExtent: cacheExtent,
            restorationId: restorationId,
            physics: physics,
            primary: primary);

  /// 添加多个 [Widget]
  final List<Widget> sliver;

  /// 添加头部 Sliver 组件
  final Widget? header;

  /// 添加底部 Sliver 组件
  final Widget? footer;

  @override
  List<Widget> buildSlivers(BuildContext context) {
    final List<Widget> slivers = <Widget>[];
    if (sliver.isNotEmpty) slivers.addAll(sliver);
    if (header != null) slivers.insert(0, header!);
    if (footer != null) slivers.add(footer!);
    return slivers;
  }
}
