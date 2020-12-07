import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/way.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GridBuilder extends StatelessWidget {
  GridBuilder({
    Key key,
    bool shrinkWrap,
    @required int itemCount,
    double mainAxisSpacing,
    double crossAxisSpacing,
    double childAspectRatio,
    bool reverse,
    this.noData,
    this.controller,
    EdgeInsetsGeometry padding,
    this.physics,
    @required this.itemBuilder,
    this.maxCrossAxisExtent,
    Axis scrollDirection,
    int crossAxisCount,
  })  : itemCount = itemCount ?? 0,
        scrollDirection = scrollDirection ?? Axis.vertical,
        reverse = reverse ?? false,
        shrinkWrap = shrinkWrap = true,
        crossAxisSpacing = crossAxisSpacing ?? 0.0,
        childAspectRatio = childAspectRatio ?? 1.0,
        mainAxisSpacing = mainAxisSpacing ?? 0.0,
        crossAxisCount = crossAxisCount ?? 1,
        padding = padding ?? EdgeInsets.zero,
        super(key: key);

  final ScrollController controller;
  final EdgeInsetsGeometry padding;

  ///  子 Widget 宽高比例
  final double childAspectRatio;

  ///  暂无数据
  final Widget noData;
  final IndexedWidgetBuilder itemBuilder;
  final bool shrinkWrap;
  final int itemCount;
  final ScrollPhysics physics;

  ///  一行的 Widget 数量
  final int crossAxisCount;

  ///  单个子Widget的水平最大宽度
  final double maxCrossAxisExtent;

  ///  水平单个子Widget之间间距
  final double mainAxisSpacing;

  ///  垂直单个子Widget之间间距
  final double crossAxisSpacing;

  ///  倒置
  final bool reverse;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0)
      return noData ?? NotData(margin: EdgeInsets.all(getWidth(10)));
    return GridView.builder(
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
}

class ListBuilder extends StatelessWidget {
  ListBuilder({
    Key key,
    this.itemBuilder,
    @required this.itemCount,
    Axis scrollDirection,
    EdgeInsetsGeometry padding,
    bool reverse,
    this.separatorBuilder,
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
        super(key: key) {
    if (listType == null || listType == ListType.builder)
      assert(itemBuilder != null);
    if (listType == ListType.custom) assert(childrenDelegate != null);
    if (listType == ListType.separated)
      assert(
          itemBuilder != null && separatorBuilder != null && itemCount != null);
  }

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
  final IndexedWidgetBuilder separatorBuilder;

  @override
  Widget build(BuildContext context) =>
      (enablePullDown || enablePullUp) ? refresherListView() : list();

  Widget list() {
    if (listType == ListType.separated) return listViewSeparated();
    if (listType == ListType.custom) return listViewCustom();
    return listViewBuilder();
  }

  Widget listViewBuilder() {
    if (itemCount == 0)
      return noData ?? NotData(margin: EdgeInsets.all(getWidth(10)));
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

  Widget listViewCustom() {
    if (itemCount == 0)
      return noData ?? NotData(margin: EdgeInsets.all(getWidth(10)));
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

  Widget listViewSeparated() {
    if (itemCount == 0)
      return noData ?? NotData(margin: EdgeInsets.all(getWidth(10)));
    return ListView.separated(
        scrollDirection: scrollDirection,
        physics: physics,
        reverse: reverse,
        shrinkWrap: shrinkWrap,
        controller: controller,
        padding: padding,
        primary: primary,
        cacheExtent: cacheExtent,
        dragStartBehavior: dragStartBehavior,
        keyboardDismissBehavior: keyboardDismissBehavior,
        itemBuilder: itemBuilder,
        separatorBuilder: separatorBuilder,
        itemCount: itemCount,
        addAutomaticKeepAlives: addAutomaticKeepALives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes);
  }

  Widget refresherListView() => Refreshed(
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      controller: refreshController,
      onLoading: onLoading,
      onRefresh: onRefresh,
      child: list(),
      header: header,
      footer: footer,
      footerTextStyle: footerTextStyle);
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
    children.add(listTile());
    if (arrow || arrowIcon != null) children.add(arrowIcon ?? arrowWidget());
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
        decoration: decoration ?? defaultDecoration(),
        children: children);
  }

  Decoration defaultDecoration() => underlineColor != null || color != null
      ? WayStyles.containerUnderlineBackground(
          underlineColor: underlineColor, color: color)
      : null;

  Widget arrowWidget() =>
      Icon(ConstIcon.arrowRight, size: arrowSize, color: arrowColor);

  Widget listTile() => Expanded(
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
