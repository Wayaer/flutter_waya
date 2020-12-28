import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_waya/constant/way.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SimpleList extends BoxScrollView {
  SimpleList.custom({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = true,
    EdgeInsetsGeometry padding,
    bool addAutomaticKeepALives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    List<Widget> children,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior,
    String restorationId,
    Clip clipBehavior = Clip.hardEdge,
    this.itemExtent,
    this.placeholder,
    this.enablePullDown,
    this.enablePullUp,
    this.refreshController,
    this.onLoading,
    this.onRefresh,
    this.header,
    this.footer,
    bool noScrollBehavior,
    bool crossAxisFlex,
    int crossAxisCount,
    double mainAxisSpacing,
    double crossAxisSpacing,
    this.maxCrossAxisExtent,
    double childAspectRatio,
  })  : childrenDelegate = SliverChildListDelegate(children ?? const <Widget>[],
            addAutomaticKeepAlives: addAutomaticKeepALives ?? true,
            addRepaintBoundaries: addRepaintBoundaries ?? true,
            addSemanticIndexes: addSemanticIndexes ?? true),
        noScrollBehavior = noScrollBehavior ?? true,
        crossAxisCount = crossAxisCount ?? 1,
        crossAxisFlex = crossAxisFlex ?? false,
        assert(!(crossAxisFlex ?? false) ||
            (maxCrossAxisExtent != null && maxCrossAxisExtent > 0)),
        mainAxisSpacing = mainAxisSpacing ?? 0,
        crossAxisSpacing = crossAxisSpacing ?? 0,
        childAspectRatio = childAspectRatio ?? 1,
        showPlaceholder = children == null || children.isEmpty,
        super(
            key: key,
            scrollDirection: scrollDirection ?? Axis.vertical,
            reverse: reverse ?? false,
            controller: controller,
            primary: primary ?? false,
            physics: physics,
            shrinkWrap: shrinkWrap ?? true,
            padding: padding ?? EdgeInsets.zero,
            cacheExtent: cacheExtent,
            semanticChildCount: children?.length ?? 0,
            dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
            keyboardDismissBehavior: keyboardDismissBehavior ??
                ScrollViewKeyboardDismissBehavior.manual,
            restorationId: restorationId,
            clipBehavior: clipBehavior);

  SimpleList.builder({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = true,
    EdgeInsetsGeometry padding,
    this.itemExtent,
    @required IndexedWidgetBuilder itemBuilder,
    @required int itemCount,
    bool addAutomaticKeepALives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String restorationId,
    Clip clipBehavior = Clip.hardEdge,
    int crossAxisCount,
    bool noScrollBehavior,
    bool crossAxisFlex,
    double mainAxisSpacing,
    double crossAxisSpacing,
    double childAspectRatio,
    this.maxCrossAxisExtent,
    this.placeholder,
    this.enablePullDown,
    this.enablePullUp,
    this.refreshController,
    this.onLoading,
    this.onRefresh,
    this.header,
    this.footer,
  })  : assert(itemCount == null || itemCount >= 0),
        assert(semanticChildCount == null || semanticChildCount <= itemCount),
        showPlaceholder = itemCount == null || itemCount < 1,
        noScrollBehavior = noScrollBehavior ?? true,
        crossAxisCount = crossAxisCount ?? 1,
        crossAxisFlex = crossAxisFlex ?? false,
        assert(!(crossAxisFlex ?? false) ||
            (maxCrossAxisExtent != null && maxCrossAxisExtent > 0)),
        mainAxisSpacing = mainAxisSpacing ?? 0,
        crossAxisSpacing = crossAxisSpacing ?? 0,
        childAspectRatio = childAspectRatio ?? 1,
        childrenDelegate = SliverChildBuilderDelegate(itemBuilder,
            childCount: itemCount,
            addAutomaticKeepAlives: addAutomaticKeepALives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes),
        super(
            key: key,
            scrollDirection: scrollDirection ?? Axis.vertical,
            reverse: reverse ?? false,
            controller: controller,
            primary: primary ?? false,
            physics: physics,
            shrinkWrap: shrinkWrap ?? true,
            padding: padding ?? EdgeInsets.zero,
            cacheExtent: cacheExtent,
            semanticChildCount: semanticChildCount ?? itemCount,
            dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
            keyboardDismissBehavior: keyboardDismissBehavior ??
                ScrollViewKeyboardDismissBehavior.manual,
            restorationId: restorationId,
            clipBehavior: clipBehavior);

  SimpleList.separated({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = true,
    EdgeInsetsGeometry padding,
    @required IndexedWidgetBuilder itemBuilder,
    @required int itemCount,
    @required IndexedWidgetBuilder separatorBuilder,
    bool addAutomaticKeepALives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String restorationId,
    Clip clipBehavior = Clip.hardEdge,
    bool noScrollBehavior,
    Widget placeholder,
    this.enablePullDown,
    this.enablePullUp,
    this.refreshController,
    this.onLoading,
    this.onRefresh,
    this.header,
    this.footer,
  })  : assert(itemBuilder != null),
        assert(separatorBuilder != null),
        assert(itemCount != null && itemCount >= 0),
        showPlaceholder = itemCount == null || itemCount < 1,
        noScrollBehavior = noScrollBehavior ?? true,
        placeholder =
            placeholder ?? const PlaceholderChild(margin: EdgeInsets.all(10)),
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
          Widget widget;
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
            scrollDirection: scrollDirection ?? Axis.vertical,
            reverse: reverse ?? false,
            controller: controller,
            primary: primary ?? false,
            physics: physics,
            shrinkWrap: shrinkWrap ?? true,
            padding: padding ?? EdgeInsets.zero,
            cacheExtent: cacheExtent,
            semanticChildCount: itemCount,
            dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
            keyboardDismissBehavior: keyboardDismissBehavior ??
                ScrollViewKeyboardDismissBehavior.manual,
            restorationId: restorationId,
            clipBehavior: clipBehavior);

  /// ***** Public *****///
  /// [itemCount]==0 || [children].length==0 显示此组件
  final Widget placeholder;
  final bool showPlaceholder;

  ///  刷新组件相关
  final bool enablePullDown;
  final bool enablePullUp;
  final RefreshController refreshController;
  final VoidCallback onLoading;
  final VoidCallback onRefresh;
  final Widget header;
  final Widget footer;

  /// 是否倒置列表
  /// final bool reverse;

  /// 是否占满整个空间。false:占满，true：不占满
  /// final bool shrinkWrap;

  /// 滑动类型设置
  /// AlwaysScrollableScrollPhysics() 总是可以滑动
  /// NeverScrollableScrollPhysics() 禁止滚动
  /// BouncingScrollPhysics()  内容超过一屏 上拉有回弹效果
  /// ClampingScrollPhysics()  包裹内容 不会有回弹
  /// final ScrollPhysics physics;

  /// 是否显示头部和底部蓝色阴影
  final bool noScrollBehavior;

  /// final ScrollController controller;
  /// final EdgeInsetsGeometry padding;

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
  final double maxCrossAxisExtent;

  ///  子 Widget 宽高比例 [crossAxisCount]>1是 有效
  final double childAspectRatio;

  /// ***** ListView ***** ///
  /// final bool addAutomaticKeepALives;
  /// final bool addRepaintBoundaries;
  /// final bool addSemanticIndexes;

  /// 确定每一个item的高度 会让item加载更加高效
  final double itemExtent;

  /// 设置预加载的区域
  /// final double cacheExtent;

  /// 如果内容不足，则用户无法滚动 而如果[primary]为true，它们总是可以尝试滚动。
  /// final bool primary;

  /// ***** 自定义Delegate ***** ///
  ///  SliverChildBuilderDelegate
  ///  SliverChildListDelegate
  final SliverChildDelegate childrenDelegate;

  /// SliverGridDelegateWithMaxCrossAxisExtent
  /// SliverGridDelegateWithFixedCrossAxisCount
  /// final SliverGridDelegate gridDelegate;

  Refreshed refresherListView(Widget child) => Refreshed(
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      controller: refreshController,
      onLoading: onLoading,
      onRefresh: onRefresh,
      child: child,
      header: header,
      footer: footer);

  @override
  Widget buildChildLayout(BuildContext context) {
    Widget list = SliverToBoxAdapter(child: Container());
    if (showPlaceholder) {
      list = SliverToBoxAdapter(child: placeholder);
    } else {
      if (crossAxisCount > 1 || crossAxisFlex) {
        list = SliverGrid(
            delegate: childrenDelegate,
            gridDelegate: crossAxisFlex
                ? SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: maxCrossAxisExtent,
                    mainAxisSpacing: mainAxisSpacing,
                    crossAxisSpacing: crossAxisSpacing)
                : SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: childAspectRatio,
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: mainAxisSpacing,
                    crossAxisSpacing: crossAxisSpacing));
      } else {
        list = itemExtent == null
            ? SliverList(delegate: childrenDelegate)
            : SliverFixedExtentList(
                delegate: childrenDelegate, itemExtent: itemExtent);
      }

      if (noScrollBehavior)
        list = ScrollConfiguration(behavior: NoScrollBehavior(), child: list);
    }
    if (enablePullUp == true || enablePullDown == true)
      return refresherListView(list);
    return list;
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

@deprecated
class GridBuilder extends StatelessWidget {
  GridBuilder({
    Key key,
    @required this.itemBuilder,
    @required int itemCount,
    bool shrinkWrap,
    double mainAxisSpacing,
    double crossAxisSpacing,
    double childAspectRatio,
    EdgeInsetsGeometry padding,
    Axis scrollDirection,
    int crossAxisCount,
    bool noScrollBehavior,
    bool reverse,
    Widget noData,
    this.controller,
    this.physics,
    this.maxCrossAxisExtent,
  })  : itemCount = itemCount ?? 0,
        scrollDirection = scrollDirection ?? Axis.vertical,
        reverse = reverse ?? false,
        noScrollBehavior = noScrollBehavior ?? true,
        shrinkWrap = shrinkWrap = true,
        crossAxisSpacing = crossAxisSpacing ?? 0.0,
        childAspectRatio = childAspectRatio ?? 1.0,
        mainAxisSpacing = mainAxisSpacing ?? 0.0,
        crossAxisCount = crossAxisCount ?? 1,
        padding = padding ?? EdgeInsets.zero,
        noData =
            noData ?? PlaceholderChild(margin: EdgeInsets.all(getWidth(10))),
        super(key: key);

  ///  移出头部和底部蓝色阴影
  final bool noScrollBehavior;

  ///  一行的 Widget 数量
  final int crossAxisCount;
  final ScrollController controller;
  final EdgeInsetsGeometry padding;

  ///  没有数据时占位置 暂无数据
  final Widget noData;
  final IndexedWidgetBuilder itemBuilder;
  final bool shrinkWrap;
  final int itemCount;
  final ScrollPhysics physics;

  ///  倒置
  final bool reverse;
  final Axis scrollDirection;

  /// *****
  ///  子Widget的水平最大宽度
  final double maxCrossAxisExtent;

  ///  水平单个子Widget之间间距
  final double mainAxisSpacing;

  ///  垂直单个子Widget之间间距
  final double crossAxisSpacing;

  ///  子 Widget 宽高比例
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0)
      return noData ?? const PlaceholderChild(margin: EdgeInsets.all(10));
    return noScrollBehavior
        ? ScrollConfiguration(
            behavior: NoScrollBehavior(), child: gridViewBuilder)
        : gridViewBuilder;
  }

  Widget get gridViewBuilder => GridView.builder(
        physics: physics,
        itemCount: itemCount,
        scrollDirection: scrollDirection,
        padding: padding,
        reverse: reverse,
        shrinkWrap: shrinkWrap,
        itemBuilder: itemBuilder,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

            /// axCrossAxisExtent: maxCrossAisExtent,
            childAspectRatio: childAspectRatio,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing),
      );
}

@deprecated
class ListBuilder extends StatelessWidget {
  ListBuilder({
    Key key,
    this.itemBuilder,
    @required this.itemCount,
    Axis scrollDirection,
    EdgeInsetsGeometry padding,
    bool reverse,
    bool noScrollBehavior,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.physics,
    this.controller,
    this.itemExtent,
    this.addAutomaticKeepALives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.noData,
    this.shrinkWrap = true,
    this.enablePullDown = false,
    this.enablePullUp = false,
    this.refreshController,
    this.onLoading,
    this.onRefresh,
    this.header,
    this.footer,
    this.footerTextStyle,
    this.listType,
    this.primary = false,
    this.cacheExtent,
    this.semanticChildCount,
    this.childrenDelegate,
  })  : padding = padding ?? EdgeInsets.zero,
        scrollDirection = scrollDirection ?? Axis.vertical,
        reverse = reverse ?? false,
        noScrollBehavior = noScrollBehavior ?? true,
        super(key: key) {
    if (listType == null || listType == ListType.builder)
      assert(itemBuilder != null);
    if (listType == ListType.custom) assert(childrenDelegate != null);
  }

  ///  移出头部和底部蓝色阴影
  final bool noScrollBehavior;
  final ListType listType;

  final bool shrinkWrap;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final ScrollPhysics physics;
  final double itemExtent;
  final ScrollController controller;
  final EdgeInsetsGeometry padding;
  final Widget noData;

  ///  刷新组件相关
  final bool enablePullDown;
  final bool enablePullUp;
  final RefreshController refreshController;
  final VoidCallback onLoading;
  final VoidCallback onRefresh;
  final Widget header;
  final Widget footer;
  final TextStyle footerTextStyle;
  final Axis scrollDirection;

  ///  是否逆转
  final bool reverse;
  final bool primary;

  final bool addAutomaticKeepALives;

  final bool addRepaintBoundaries;

  final bool addSemanticIndexes;
  final double cacheExtent;
  final int semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final SliverChildDelegate childrenDelegate;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  @override
  Widget build(BuildContext context) => (enablePullDown || enablePullUp)
      ? refresherListView
      : noScrollBehavior
          ? scrollConfiguration
          : list;

  Widget get scrollConfiguration =>
      ScrollConfiguration(behavior: NoScrollBehavior(), child: list);

  Widget get list {
    if (listType == ListType.custom) return listViewCustom;
    return listViewBuilder;
  }

  Widget get listViewBuilder {
    if (itemCount == 0)
      return noData ?? PlaceholderChild(margin: EdgeInsets.all(getWidth(10)));
    return ListView.builder(
      scrollDirection: scrollDirection,
      physics: physics,
      reverse: reverse,
      shrinkWrap: shrinkWrap,
      controller: controller,
      itemBuilder: itemBuilder,
      itemCount: itemCount,
      itemExtent: itemExtent,
      padding: padding,
      primary: primary,
      addAutomaticKeepAlives: addAutomaticKeepALives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      cacheExtent: cacheExtent,
      semanticChildCount: semanticChildCount,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
    );
  }

  Widget get listViewCustom {
    if (itemCount == 0)
      return noData ?? PlaceholderChild(margin: EdgeInsets.all(getWidth(10)));
    return ListView.custom(
        scrollDirection: scrollDirection,
        physics: physics,
        reverse: reverse,
        shrinkWrap: shrinkWrap,
        controller: controller,
        itemExtent: itemExtent,
        padding: padding,
        primary: primary,
        childrenDelegate: childrenDelegate,
        cacheExtent: cacheExtent,
        semanticChildCount: semanticChildCount,
        dragStartBehavior: dragStartBehavior,
        keyboardDismissBehavior: keyboardDismissBehavior);
  }

  Widget get refresherListView => Refreshed(
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      controller: refreshController,
      onLoading: onLoading,
      onRefresh: onRefresh,
      child: list,
      header: header,
      footer: footer);
}

class ListEntry extends StatelessWidget {
  const ListEntry(
      {Key key,
      bool isThreeLine,
      bool enabled,
      bool dense,
      bool arrow,
      String titleText,
      double arrowSize,
      this.onTap,
      this.heroTag,
      this.onDoubleTap,
      this.onLongPress,
      this.title,
      this.height,
      this.inkWell,
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
      : isThreeLine = isThreeLine ?? false,
        arrow = arrow ?? false,
        enabled = enabled ?? true,
        dense = dense ?? true,
        arrowSize = arrowSize ?? 15,
        titleText = titleText ?? '',
        super(key: key);

  ///  单击事件
  final GestureTapCallback onTap;

  ///  双击事件
  final GestureTapCallback onDoubleTap;

  ///  长按事件
  final GestureLongPressCallback onLongPress;

  ///  显示三行
  final bool isThreeLine;

  ///  是否默认3行高度，subtitle不为空时才能使用
  final bool selected;

  ///  设置为true后 高度变小 默认为true
  final bool dense;

  ///  内边距
  final EdgeInsetsGeometry contentPadding;

  ///  左侧widget
  final Widget leading;

  ///  副标题
  final Widget subtitle;

  ///  右侧widget
  final Widget child;

  ///  右边是否有箭头
  final bool arrow;
  final Widget arrowIcon;
  final double arrowSize;
  final Color arrowColor;

  ///  中间内容
  final Widget title;
  final String titleText;
  final TextStyle titleStyle;
  final String heroTag;

  ///  高
  final double height;

  ///  前缀
  final Widget prefix;

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool inkWell;
  final Color underlineColor;
  final Color color;

  ///  是否可点击
  final bool enabled;

  ///  整个ListEntry装饰器
  final BoxDecoration decoration;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    if (prefix != null) children.add(prefix);
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

  Decoration get defaultDecoration => underlineColor != null || color != null
      ? WayStyles.containerUnderlineBackground(
          underlineColor: underlineColor, color: color)
      : null;

  Widget get arrowWidget =>
      Icon(ConstIcon.arrowRight, size: arrowSize, color: arrowColor);

  Widget get listTile => Expanded(
          child: ListTile(
        contentPadding: contentPadding,
        title: hero(title ?? Text(titleText, style: titleStyle)),
        subtitle: subtitle,
        leading: leading,
        trailing: child,
        isThreeLine: isThreeLine,
        dense: dense,
        enabled: false,
        selected: selected ?? false,
      ));

  Widget hero(Widget text) {
    if (heroTag != null) return Hero(tag: heroTag, child: text);
    return text;
  }
}

class CustomList extends BoxScrollView {
  CustomList({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    this.itemExtent,
    this.gridDelegate,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    List<Widget> children = const <Widget>[],
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String restorationId,
    Clip clipBehavior = Clip.hardEdge,
  })  : childrenDelegate = SliverChildListDelegate(children,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
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
            semanticChildCount: semanticChildCount ?? children.length,
            dragStartBehavior: dragStartBehavior,
            keyboardDismissBehavior: keyboardDismissBehavior,
            restorationId: restorationId,
            clipBehavior: clipBehavior);

  CustomList.builder({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    this.itemExtent,
    this.gridDelegate,
    @required IndexedWidgetBuilder itemBuilder,
    int itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String restorationId,
    Clip clipBehavior = Clip.hardEdge,
  })  : assert(itemCount == null || itemCount >= 0),
        assert(semanticChildCount == null || semanticChildCount <= itemCount),
        childrenDelegate = SliverChildBuilderDelegate(itemBuilder,
            childCount: itemCount,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
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
            semanticChildCount: semanticChildCount ?? itemCount,
            dragStartBehavior: dragStartBehavior,
            keyboardDismissBehavior: keyboardDismissBehavior,
            restorationId: restorationId,
            clipBehavior: clipBehavior);

  CustomList.separated({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    @required IndexedWidgetBuilder itemBuilder,
    @required IndexedWidgetBuilder separatorBuilder,
    @required int itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String restorationId,
    Clip clipBehavior = Clip.hardEdge,
  })  : assert(itemBuilder != null),
        assert(separatorBuilder != null),
        assert(itemCount != null && itemCount >= 0),
        itemExtent = null,
        gridDelegate = null,
        childrenDelegate = SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          final int itemIndex = index ~/ 2;
          Widget widget;
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
            addAutomaticKeepAlives: addAutomaticKeepAlives,
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

  const CustomList.custom({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    this.itemExtent,
    this.gridDelegate,
    @required this.childrenDelegate,
    double cacheExtent,
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String restorationId,
    Clip clipBehavior = Clip.hardEdge,
  })  : assert(childrenDelegate != null),
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

  CustomList.count({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    @required int crossAxisCount,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    double childAspectRatio = 1.0,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    List<Widget> children = const <Widget>[],
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String restorationId,
    Clip clipBehavior = Clip.hardEdge,
  })  : gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio),
        childrenDelegate = SliverChildListDelegate(children,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes),
        itemExtent = null,
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
            semanticChildCount: semanticChildCount ?? children.length,
            dragStartBehavior: dragStartBehavior,
            keyboardDismissBehavior: keyboardDismissBehavior,
            restorationId: restorationId,
            clipBehavior: clipBehavior);

  CustomList.extent({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    @required double maxCrossAxisExtent,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    double childAspectRatio = 1.0,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    List<Widget> children = const <Widget>[],
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String restorationId,
    Clip clipBehavior = Clip.hardEdge,
  })  : gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: maxCrossAxisExtent,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio),
        childrenDelegate = SliverChildListDelegate(children,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes),
        itemExtent = null,
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
            semanticChildCount: semanticChildCount ?? children.length,
            dragStartBehavior: dragStartBehavior,
            keyboardDismissBehavior: keyboardDismissBehavior,
            restorationId: restorationId,
            clipBehavior: clipBehavior);

  final double itemExtent;

  ///  SliverChildBuilderDelegate
  ///  SliverChildListDelegate
  final SliverChildDelegate childrenDelegate;

  /// SliverGridDelegateWithMaxCrossAxisExtent
  /// SliverGridDelegateWithFixedCrossAxisCount
  final SliverGridDelegate gridDelegate;

  @override
  Widget buildChildLayout(BuildContext context) {
    if (gridDelegate != null)
      return SliverGrid(delegate: childrenDelegate, gridDelegate: gridDelegate);
    if (itemExtent != null)
      return SliverFixedExtentList(
          delegate: childrenDelegate, itemExtent: itemExtent);
    return SliverList(delegate: childrenDelegate);
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
