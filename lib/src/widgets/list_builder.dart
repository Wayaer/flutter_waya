import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/styles.dart';
import 'package:flutter_waya/src/constant/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GridBuilder extends StatelessWidget {
  final ScrollController controller;
  final EdgeInsetsGeometry padding;

  ///子 Widget 宽高比例
  final double childAspectRatio;

  ///
  final Widget noData;
  final IndexedWidgetBuilder itemBuilder;
  final bool shrinkWrap;
  final int itemCount;
  final ScrollPhysics physics;

  ///一行的 Widget 数量
  final int crossAxisCount;

  ///单个子Widget的水平最大宽度
  final double maxCrossAxisExtent;

  ///水平单个子Widget之间间距
  final double mainAxisSpacing;

  ///垂直单个子Widget之间间距
  final double crossAxisSpacing;

  ///倒置
  final bool reverse;
  final Axis scrollDirection;

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
  })  : this.itemCount = itemCount ?? 0,
        this.scrollDirection = scrollDirection ?? Axis.vertical,
        this.reverse = reverse ?? false,
        this.shrinkWrap = shrinkWrap = true,
        this.crossAxisSpacing = crossAxisSpacing ?? 0.0,
        this.childAspectRatio = childAspectRatio ?? 1.0,
        this.mainAxisSpacing = mainAxisSpacing ?? 0.0,
        this.crossAxisCount = crossAxisCount ?? 1,
        this.padding = padding ?? EdgeInsets.zero,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) {
      return noData ?? Widgets.notDataWidget(margin: EdgeInsets.all(ScreenFit.getWidth(10)));
    }
    return GridView.builder(
      physics: physics,
      itemCount: itemCount,
      scrollDirection: scrollDirection,
      padding: padding,
      reverse: reverse,
      shrinkWrap: shrinkWrap,
      itemBuilder: itemBuilder,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//          maxCrossAxisExtent: maxCrossAxisExtent,
          childAspectRatio: childAspectRatio,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing),
    );
  }
}

class ListBuilder extends StatelessWidget {
  final bool shrinkWrap;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final ScrollPhysics physics;
  final double itemExtent;
  final ScrollController controller;
  final EdgeInsetsGeometry padding;
  final Widget noData;

  ///刷新组件相关
  final bool enablePullDown;
  final bool enablePullUp;
  final RefreshController refreshController;
  final VoidCallback onLoading;
  final VoidCallback onRefresh;
  final Widget header;
  final Widget footer;
  final TextStyle footerTextStyle;
  final Axis scrollDirection;

  ///是否逆转
  final bool reverse;

  ListBuilder({
    Key key,
    @required this.itemBuilder,
    @required this.itemCount,
    this.physics,
    this.controller,
    this.itemExtent,
    Axis scrollDirection,
    EdgeInsetsGeometry padding,
    bool reverse,
    this.noData,
    this.shrinkWrap: true,
    this.enablePullDown: false,
    this.enablePullUp: false,
    this.refreshController,
    this.onLoading,
    this.onRefresh,
    this.header,
    this.footer,
    this.footerTextStyle,
  })  : this.padding = padding ?? EdgeInsets.zero,
        this.scrollDirection = scrollDirection ?? Axis.vertical,
        this.reverse = reverse ?? false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (enablePullDown || enablePullUp) {
      return refresherListView();
    }
    return listViewBuilder();
  }

  Widget listViewBuilder() {
    if (itemCount == 0) {
      return noData ?? Widgets.notDataWidget(margin: EdgeInsets.all(ScreenFit.getWidth(10)));
    }
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
    );
  }

  Widget refresherListView() {
    return Refreshed(
        enablePullDown: enablePullDown,
        enablePullUp: enablePullUp,
        controller: refreshController,
        onLoading: onLoading,
        onRefresh: onRefresh,
        child: listViewBuilder(),
        header: header,
        footer: footer,
        footerTextStyle: footerTextStyle);
  }
}

class ListEntry extends StatelessWidget {
  final GestureTapCallback onTap;
  final GestureTapCallback onDoubleTap;
  final GestureLongPressCallback onLongPress;
  final bool isThreeLine;

  ///是否默认3行高度，subtitle不为空时才能使用
  final bool selected;

  ///设置为true后字体变小
  final bool dense;
  final EdgeInsetsGeometry contentPadding;

  ///左侧widget
  final Widget leading;

  ///副标题
  final Widget subtitle;

  ///右侧widget
  final Widget child;

  final Widget title;
  final String titleText;
  final String heroTag;
  final TextStyle titleStyle;
  final double height;
  final Widget prefix;

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry prefixMargin;
  final bool inkWell;
  final Color underlineColor;

  final EdgeInsetsGeometry arrowMargin;
  final Color color;
  final BoxDecoration decoration;
  final double arrowSize;
  final Color arrowColor;
  final Widget arrowIcon;
  final bool arrow;
  final bool enabled;

  ListEntry(
      {Key key,
      double arrowSize,
      Color arrowColor,
      bool isThreeLine,
      bool arrow,
      bool enabled,
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
      this.titleText,
      this.titleStyle,
      this.underlineColor,
      this.leading,
      this.subtitle,
      this.dense,
      this.contentPadding,
      this.selected,
      this.arrowIcon,
      this.arrowMargin,
      this.prefix,
      this.prefixMargin})
      : this.arrowSize = arrowSize ?? 16,
        this.arrowColor = arrowColor ?? getColors(black),
        this.isThreeLine = isThreeLine ?? false,
        this.arrow = arrow ?? true,
        this.enabled = enabled ?? true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List();
    if (prefix != null) children.add(prefix);
    children.add(listTile());
    if (arrowIcon != null) children.add(arrowIcon);
    if (arrow) children.add(arrowWidget());
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
        decoration: decoration ?? WayStyles.containerUnderlineBackground(underlineColor: underlineColor, color: color),
        children: children);
  }

  Widget listTile() {
    return Expanded(
        child: ListTile(
      contentPadding: contentPadding,
      title: hero(title ?? Text(titleText, style: titleStyle)),
      subtitle: subtitle,
      leading: leading,
      trailing: child,
      isThreeLine: isThreeLine,
      dense: dense,
      enabled: false,
      selected: false,
    ));
  }

  Widget arrowWidget() => IconBox(icon: ConstIcon.arrowRight, size: arrowSize, color: arrowColor, margin: arrowMargin);

  Widget hero(Widget text) {
    if (heroTag != null) return Hero(tag: heroTag, child: text);
    return text;
  }
}
