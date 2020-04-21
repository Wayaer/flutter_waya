import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayStyles.dart';
import 'package:flutter_waya/src/tools/Tools.dart';
import 'package:flutter_waya/waya.dart';

class TabBarWidget extends StatelessWidget {
  final TabController controller;
  final EdgeInsetsGeometry labelPadding;
  final List<Widget> tabBar;
  final Widget among; //tabBar和tabBarView中间层
  final Widget header; //最顶部
  final Widget footer; //最底部
  final List<Widget> tabBarView; //底部tabBarView
  final Color labelColor;
  final Color unselectedLabelColor;
  final TabBarIndicatorSize indicatorSize;
  final TextStyle labelStyle;
  final double indicatorWeight;
  final double underlineHeight;
  final EdgeInsetsGeometry tabBarViewPadding;
  final EdgeInsetsGeometry tabBarMargin;
  final EdgeInsetsGeometry tabBarPadding;
  final EdgeInsetsGeometry tabBarViewMargin;
  final ScrollPhysics physics;
  final Decoration decoration;
  final Decoration indicator; //tabBar 指示器
  final double tabBarViewHeight;
  final Color underlineBackgroundColor;
  final EdgeInsetsGeometry indicatorPadding;

  TabBarWidget({
    Key key,
    double tabBarViewHeight,
    Color underlineBackgroundColor,
    EdgeInsetsGeometry indicatorPadding,
    @required this.tabBar,
    this.controller,
    this.indicator,
    this.decoration,
    this.labelPadding,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorSize,
    this.labelStyle,
    this.indicatorWeight,
    this.underlineHeight,
    this.tabBarView,
    this.among,
    this.tabBarViewMargin,
    this.tabBarViewPadding,
    this.tabBarMargin,
    this.tabBarPadding,
    this.physics,
    this.header,
    this.footer,
  })  : this.underlineBackgroundColor = underlineBackgroundColor ?? getColors(transparent),
        this.tabBarViewHeight = tabBarViewHeight ?? 0,
        this.indicatorPadding = indicatorPadding ?? EdgeInsets.zero,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (header != null) {
      children.add(header);
    }
    children.add(tabBarWidget());
    if (among != null) {
      children.add(among);
    }
    if (tabBarView != null) {
      children.add(tabBarViewWidget());
    }
    if (footer != null) {
      children.add(footer);
    }
    return Column(children: children);
  }

  Widget tabBarViewWidget() {
    return tabBarViewHeight == 0
        ? Expanded(
            child: Container(
                margin: tabBarViewMargin,
                padding: tabBarViewPadding,
                child: TabBarView(controller: controller, children: tabBarView)))
        : Container(
            margin: tabBarViewMargin,
            padding: tabBarViewPadding,
            height: tabBarViewHeight,
            child: TabBarView(controller: controller, children: tabBarView),
          );
  }

  Widget tabBarWidget() {
    return Container(
      margin: tabBarMargin,
      padding: tabBarPadding,
      decoration: decoration ??
          BoxDecoration(
              border: Border(bottom: BorderSide(width: underlineHeight ?? 0, color: underlineBackgroundColor))),
      child: TabBar(
        controller: controller,
        labelPadding: labelPadding,
        tabs: tabBar,
        indicator: indicator,
        labelColor: labelColor ?? getColors(blue),
        unselectedLabelColor: unselectedLabelColor ?? getColors(background),
        indicatorColor: labelColor ?? getColors(blue),
        indicatorWeight: indicatorWeight ?? Tools.getWidth(1),
        indicatorPadding: indicatorPadding,
        labelStyle: labelStyle ?? WayStyles.textStyleBlack70(fontSize: 13),
        indicatorSize: indicatorSize ?? TabBarIndicatorSize.label,
      ),
    );
  }
}
