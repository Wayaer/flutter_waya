import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TabBarMerge extends StatelessWidget {

  ///最好传入 CustomTabBar
  final Widget tabBar;

  ///tabBar和tabBarView中间层
  final Widget among;

  ///最顶部
  final Widget header;

  ///最底部
  final Widget footer;
  final ScrollPhysics physics;
  final List<Widget> tabBarView;
  final double viewHeight;
  final TabController controller;

  ///以下属性主要针对 tabBarView
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Decoration decoration;
  final BoxConstraints constraints;
  final double width;

  TabBarMerge({
    Key key,
    this.among,
    this.physics,
    this.header,
    this.footer,
    double viewHeight,
    @required this.tabBar,
    this.tabBarView,
    @required this.controller,
    this.margin,
    this.padding,
    this.decoration,
    this.constraints,
    this.width,
  })
      :
        this.viewHeight=viewHeight ?? 0,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (header != null) {
      children.add(header);
    }
    children.add(tabBar);
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
    return viewHeight == 0
        ? Expanded(
        child: Container(
            margin: margin,
            padding: padding,
            decoration: decoration,
            constraints: constraints,
            width: width,
            child: TabBarView(controller: controller, children: tabBarView)))
        : Container(
        margin: margin,
        padding: padding,
        decoration: decoration,
        constraints: constraints,
        width: width,
        height: viewHeight,
        child: TabBarView(controller: controller, children: tabBarView));
  }

}
