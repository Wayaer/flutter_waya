import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_waya/constant/way.dart';
import 'package:flutter_waya/flutter_waya.dart';

class SimpleList extends StatelessWidget {
  const SimpleList.custom({
    Key? key,
    this.noScrollBehavior = false,
    this.crossAxisFlex = false,
    this.crossAxisCount = 1,
    this.childAspectRatio = 1,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary = false,
    this.physics,
    this.shrinkWrap = true,
    this.padding,
    this.cacheExtent,
    this.children,
    this.clipBehavior = Clip.hardEdge,
    this.itemExtent,
    this.placeholder,
    this.refreshConfig,
    this.maxCrossAxisExtent,
  })  : assert(!crossAxisFlex ||
            (maxCrossAxisExtent != null && maxCrossAxisExtent > 0)),
        itemBuilder = null,
        separatorBuilder = null,
        itemCount = 0,
        super(key: key);

  const SimpleList.builder({
    Key? key,
    this.noScrollBehavior = false,
    this.crossAxisFlex = false,
    this.crossAxisCount = 1,
    this.childAspectRatio = 1,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    required this.itemBuilder,
    required this.itemCount,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary = false,
    this.physics,
    this.shrinkWrap = true,
    this.padding,
    this.itemExtent,
    this.cacheExtent,
    this.clipBehavior = Clip.hardEdge,
    this.maxCrossAxisExtent,
    this.placeholder,
    this.refreshConfig,
  })  : assert(itemCount >= 0),
        separatorBuilder = null,
        children = null,
        assert(!crossAxisFlex ||
            (maxCrossAxisExtent != null && maxCrossAxisExtent > 0)),
        super(key: key);

  const SimpleList.separated({
    Key? key,
    this.noScrollBehavior = false,
    this.crossAxisFlex = false,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary = false,
    this.physics,
    this.shrinkWrap = true,
    this.padding,
    required this.itemBuilder,
    required this.itemCount,
    required this.separatorBuilder,
    this.cacheExtent,
    this.clipBehavior = Clip.hardEdge,
    this.placeholder,
    this.refreshConfig,
  })  : assert(itemBuilder != null),
        assert(separatorBuilder != null),
        assert(itemCount >= 0),
        children = null,
        itemExtent = null,
        crossAxisCount = 1,
        mainAxisSpacing = 0,
        crossAxisSpacing = 0,
        maxCrossAxisExtent = 1,
        childAspectRatio = 1,
        super(key: key);

  /// [itemCount]==0 || [children].length==0 显示此组件
  final Widget? placeholder;
  final IndexedWidgetBuilder? itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final int itemCount;
  final List<Widget>? children;

  final Clip clipBehavior;
  final Axis scrollDirection;

  ///  刷新组件相关
  final RefreshConfig? refreshConfig;

  /// 是否倒置列表
  final bool reverse;

  /// 是否占满整个空间。false:占满，true：不占满
  final bool shrinkWrap;

  /// 滑动类型设置
  /// AlwaysScrollableScrollPhysics() 总是可以滑动
  /// NeverScrollableScrollPhysics() 禁止滚动
  /// BouncingScrollPhysics()  内容超过一屏 上拉有回弹效果
  /// ClampingScrollPhysics()  包裹内容 不会有回弹
  final ScrollPhysics? physics;

  /// 是否显示头部和底部蓝色阴影
  final bool noScrollBehavior;

  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;

  /// 是否开启列数自适应
  /// [crossAxisFlex]=true 为多列 且宽度自适应
  final bool crossAxisFlex;

  /// 多列最大列数 [crossAxisCount]>1 固定列
  final int crossAxisCount;

  /// ***** GridView ***** ///
  ///  水平子Widget之间间距
  final double mainAxisSpacing;

  ///  垂直子Widget之间间距
  final double crossAxisSpacing;

  ///  单个子Widget的水平最大宽度
  final double? maxCrossAxisExtent;

  ///  子 Widget 宽高比例 [crossAxisCount]>1是 有效
  final double childAspectRatio;

  /// 确定每一个item的高度 会让item加载更加高效
  final double? itemExtent;

  /// 设置预加载的区域
  final double? cacheExtent;

  /// 如果内容不足，则用户无法滚动 而如果[primary]为true，它们总是可以尝试滚动。
  final bool primary;

  @override
  Widget build(BuildContext context) {
    Widget widget = Container();
    if (children != null)
      widget = children!.isNotEmpty
          ? custom
          : (placeholder ?? const PlaceholderChild());
    if (itemBuilder != null) {
      if (itemCount < 1) {
        widget = placeholder ?? const PlaceholderChild();
      } else {
        widget = separatorBuilder == null ? builder : separated;
      }
    }
    if (refreshConfig != null) widget = refresherListView(widget);
    return widget;
  }

  ScrollList get custom => ScrollList.custom(
      children: children!,
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
      crossAxisFlex: crossAxisFlex,
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      maxCrossAxisExtent: maxCrossAxisExtent,
      childAspectRatio: childAspectRatio,
      noScrollBehavior: noScrollBehavior);

  ScrollList get separated => ScrollList.separated(
      itemBuilder: itemBuilder!,
      itemCount: itemCount,
      separatorBuilder: separatorBuilder!,
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
      noScrollBehavior: noScrollBehavior);

  ScrollList get builder => ScrollList.builder(
      itemBuilder: itemBuilder!,
      itemCount: itemCount,
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      cacheExtent: cacheExtent,
      itemExtent: itemExtent,
      clipBehavior: clipBehavior,
      crossAxisFlex: crossAxisFlex,
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      maxCrossAxisExtent: maxCrossAxisExtent,
      childAspectRatio: childAspectRatio,
      noScrollBehavior: noScrollBehavior);

  Widget refresherListView(Widget child) => PullRefreshed(
      controller: refreshConfig?.controller,
      child: child,
      onRefresh: refreshConfig?.onRefresh,
      onLoading: refreshConfig?.onLoading,
      header: refreshConfig?.header,
      footer: refreshConfig?.footer);
}

/// 自定义List Grid  List
class ScrollList extends BoxScrollView {
  ScrollList.custom({
    Key? key,
    bool addAutomaticKeepALives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    bool reverse = false,
    bool primary = false,
    bool shrinkWrap = true,
    Axis scrollDirection = Axis.vertical,
    ScrollController? controller,
    ScrollPhysics? physics = const BouncingScrollPhysics(),
    EdgeInsetsGeometry? padding = EdgeInsets.zero,
    double? cacheExtent,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    this.itemExtent,
    this.noScrollBehavior = false,
    this.crossAxisCount = 1,
    this.crossAxisFlex = false,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.childAspectRatio = 1,
    this.maxCrossAxisExtent,
    required List<Widget> children,
  })   : childrenDelegate = SliverChildListDelegate(children,
            addAutomaticKeepAlives: addAutomaticKeepALives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes),
        assert(!crossAxisFlex ||
            (maxCrossAxisExtent != null && maxCrossAxisExtent > 0)),
        super(
            key: key,
            scrollDirection: scrollDirection,
            reverse: reverse,
            controller: controller,
            primary: primary,
            physics: physics,
            shrinkWrap: shrinkWrap,
            padding: padding,
            cacheExtent: cacheExtent,
            semanticChildCount: children.length,
            dragStartBehavior: dragStartBehavior,
            keyboardDismissBehavior: keyboardDismissBehavior,
            restorationId: restorationId,
            clipBehavior: clipBehavior);

  ScrollList.builder({
    Key? key,
    bool addAutomaticKeepALives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    bool reverse = false,
    bool primary = false,
    bool shrinkWrap = true,
    Axis scrollDirection = Axis.vertical,
    ScrollController? controller,
    ScrollPhysics? physics = const BouncingScrollPhysics(),
    EdgeInsetsGeometry? padding = EdgeInsets.zero,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    this.itemExtent,
    this.noScrollBehavior = false,
    this.crossAxisCount = 1,
    this.crossAxisFlex = false,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.childAspectRatio = 1,
    this.maxCrossAxisExtent,
    required IndexedWidgetBuilder itemBuilder,
    required int itemCount,
  })   : assert(itemCount >= 0),
        assert(semanticChildCount == null || semanticChildCount <= itemCount),
        assert(!crossAxisFlex ||
            (maxCrossAxisExtent != null && maxCrossAxisExtent > 0)),
        childrenDelegate = SliverChildBuilderDelegate(itemBuilder,
            childCount: itemCount,
            addAutomaticKeepAlives: addAutomaticKeepALives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes),
        super(
            key: key,
            scrollDirection: scrollDirection,
            reverse: reverse,
            controller: controller,
            primary: primary,
            physics: physics,
            shrinkWrap: shrinkWrap,
            padding: padding,
            cacheExtent: cacheExtent,
            semanticChildCount: semanticChildCount,
            dragStartBehavior: dragStartBehavior,
            keyboardDismissBehavior: keyboardDismissBehavior,
            restorationId: restorationId,
            clipBehavior: clipBehavior);

  ScrollList.separated({
    Key? key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool primary = false,
    ScrollPhysics? physics = const BouncingScrollPhysics(),
    bool shrinkWrap = true,
    EdgeInsetsGeometry? padding = EdgeInsets.zero,
    bool addAutomaticKeepALives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    this.noScrollBehavior = false,
    required IndexedWidgetBuilder itemBuilder,
    required int itemCount,
    required IndexedWidgetBuilder separatorBuilder,
  })   : assert(itemCount >= 0),
        itemExtent = null,
        crossAxisFlex = false,
        crossAxisCount = 1,
        mainAxisSpacing = 0,
        crossAxisSpacing = 0,
        maxCrossAxisExtent = 1,
        childAspectRatio = 1,
        childrenDelegate = SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          final int itemIndex = index ~/ 2;
          Widget? widget;
          if (index.isEven) {
            widget = itemBuilder(context, itemIndex);
          } else {
            widget = separatorBuilder(context, itemIndex);
            assert(() {
              if (widget == null)
                throw FlutterError('separatorBuilder cannot return null.');
              return true;
            }());
          }
          return widget;
        },
            childCount: _computeActualChildCount(itemCount),
            addAutomaticKeepAlives: addAutomaticKeepALives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
            semanticIndexCallback: (Widget _, int index) =>
                index.isEven ? index ~/ 2 : null),
        super(
            key: key,
            scrollDirection: scrollDirection,
            reverse: reverse,
            controller: controller,
            primary: primary,
            physics: physics,
            shrinkWrap: shrinkWrap,
            padding: padding,
            cacheExtent: cacheExtent,
            semanticChildCount: itemCount,
            dragStartBehavior: dragStartBehavior,
            keyboardDismissBehavior: keyboardDismissBehavior,
            restorationId: restorationId,
            clipBehavior: clipBehavior);

  // /// ***** Public *****///
  // /// [itemCount]==0 || [children].length==0 显示此组件
  // final Widget placeholder;
  // final bool showPlaceholder;

  /// 是否显示头部和底部蓝色阴影
  final bool noScrollBehavior;

  /// 是否开启列数自适应
  /// [crossAxisFlex]=true 为多列 且宽度自适应
  final bool crossAxisFlex;

  /// 多列最大列数 [crossAxisCount]>1 固定列
  final int crossAxisCount;

  ///  水平子Widget之间间距
  final double mainAxisSpacing;

  ///  垂直子Widget之间间距
  final double crossAxisSpacing;

  ///  单个子Widget的水平最大宽度
  final double? maxCrossAxisExtent;

  ///  子 Widget 宽高比例 [crossAxisCount]>1是 有效
  final double childAspectRatio;

  /// 确定每一个item的高度 会让item加载更加高效
  final double? itemExtent;

  /// ***** 自定义Delegate ***** ///
  ///  SliverChildBuilderDelegate
  ///  SliverChildListDelegate
  final SliverChildDelegate? childrenDelegate;

  /// SliverGridDelegateWithMaxCrossAxisExtent
  /// SliverGridDelegateWithFixedCrossAxisCount
  /// final SliverGridDelegate gridDelegate;

  @override
  Widget buildChildLayout(BuildContext context) {
    RenderObjectWidget widget = SliverToBoxAdapter(child: Container());

    if (crossAxisCount > 1 || crossAxisFlex) {
      widget = SliverGrid(
          delegate: childrenDelegate!,
          gridDelegate: crossAxisFlex
              ? SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: maxCrossAxisExtent!,
                  mainAxisSpacing: mainAxisSpacing,
                  crossAxisSpacing: crossAxisSpacing)
              : SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: childAspectRatio,
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: mainAxisSpacing,
                  crossAxisSpacing: crossAxisSpacing));
    } else {
      widget = itemExtent == null
          ? SliverList(delegate: childrenDelegate!)
          : SliverFixedExtentList(
              delegate: childrenDelegate!, itemExtent: itemExtent!);
    }
    if (noScrollBehavior)
      return ScrollConfiguration(behavior: NoScrollBehavior(), child: widget);
    return widget;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (itemExtent != null)
      properties
          .add(DoubleProperty('itemExtent', itemExtent, defaultValue: null));
  }

  static int _computeActualChildCount(int itemCount) =>
      math.max(0, itemCount * 2 - 1);
}

class ListEntry extends StatelessWidget {
  const ListEntry(
      {Key? key,
      this.isThreeLine = false,
      this.enabled = true,
      this.dense = true,
      this.arrow = false,
      this.inkWell = false,
      this.titleText = '',
      this.arrowSize = 15,
      this.onTap,
      this.heroTag,
      this.onDoubleTap,
      this.onLongPress,
      this.title,
      this.height,
      this.padding,
      this.margin,
      this.decoration,
      this.child,
      this.color,
      this.titleStyle,
      this.underlineColor,
      this.leading,
      this.subtitle,
      this.contentPadding,
      this.selected,
      this.prefix,
      this.arrowColor,
      this.arrowIcon})
      : super(key: key);

  ///  单击事件
  final GestureTapCallback? onTap;

  ///  双击事件
  final GestureTapCallback? onDoubleTap;

  ///  长按事件
  final GestureLongPressCallback? onLongPress;

  ///  显示三行
  final bool isThreeLine;

  ///  是否默认3行高度，subtitle不为空时才能使用
  final bool? selected;

  ///  设置为true后 高度变小 默认为true
  final bool dense;

  ///  内边距
  final EdgeInsetsGeometry? contentPadding;

  ///  左侧widget
  final Widget? leading;

  ///  副标题
  final Widget? subtitle;

  ///  右侧widget
  final Widget? child;

  ///  右边是否有箭头
  final bool arrow;
  final Widget? arrowIcon;
  final double arrowSize;
  final Color? arrowColor;

  ///  中间内容
  final Widget? title;
  final String titleText;
  final TextStyle? titleStyle;
  final String? heroTag;

  ///  高
  final double? height;

  ///  前缀
  final Widget? prefix;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool inkWell;
  final Color? underlineColor;
  final Color? color;

  ///  是否可点击
  final bool enabled;

  ///  整个ListEntry装饰器
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    if (prefix != null) children.add(prefix!);
    children.add(listTile);
    if (arrow || arrowIcon != null) children.add(arrowIcon ?? arrowWidget);
    return Universal(
        height: height,
        addInkWell: inkWell,
        margin: margin,
        padding: padding,
        onLongPress: enabled ? onLongPress : null,
        onDoubleTap: enabled ? onDoubleTap : null,
        onTap: enabled ? onTap : null,
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        decoration: decoration ?? defaultDecoration,
        children: children);
  }

  Decoration? get defaultDecoration => underlineColor != null || color != null
      ? WayStyles.containerUnderlineBackground(
          underlineColor: underlineColor!, color: color!)
      : null;

  Widget get arrowWidget =>
      Icon(ConstIcon.arrowRight, size: arrowSize, color: arrowColor);

  Widget get listTile => Expanded(
      child: ListTile(
          contentPadding: contentPadding,
          title: hero(title ?? BasisText(titleText, style: titleStyle)),
          subtitle: subtitle,
          leading: leading,
          trailing: child,
          isThreeLine: isThreeLine,
          dense: dense,
          enabled: false,
          selected: selected ?? false));

  Widget hero(Widget text) {
    if (heroTag != null) return Hero(tag: heroTag!, child: text);
    return text;
  }
}
