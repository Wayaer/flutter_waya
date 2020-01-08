import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayStyles.dart';
import 'package:flutter_waya/src/utils/WayUtils.dart';

class TabBarWidget extends StatelessWidget {
  TabController controller;
  final EdgeInsetsGeometry labelPadding;
  final List<Widget> tabBar;
  final Widget amongWidget;
  final Widget headWidget;
  final Widget footWidget;
  final List<Widget> tabBarView;
  final Color labelColor;
  final Color unselectedLabelColor;
  final TabBarIndicatorSize indicatorSize;
  final TextStyle labelStyle;
  final double indicatorWeight;
  final double tabBarViewHeight;
  final Color underlineBackgroundColor;
  final double underlineHeight;
  final EdgeInsetsGeometry tabBarViewPadding;
  final EdgeInsetsGeometry tabBarMargin;
  final EdgeInsetsGeometry tabBarPadding;
  final EdgeInsetsGeometry tabBarViewMargin;
  final EdgeInsetsGeometry indicatorPadding;
  final ScrollPhysics physics;
  final Widget tabBarViewWidget;
  final Decoration decoration;
  final Decoration indicator;

  TabBarWidget({
    this.controller,
    this.indicator,
    this.decoration,
    this.labelPadding,
    this.tabBar,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorSize,
    this.labelStyle,
    this.indicatorWeight,
    this.underlineBackgroundColor: Colors.transparent,
    this.underlineHeight,
    this.indicatorPadding: EdgeInsets.zero,
    this.tabBarView,
    this.amongWidget,
    this.tabBarViewMargin,
    this.tabBarViewPadding,
    this.tabBarMargin,
    this.tabBarPadding,
    this.tabBarViewHeight: 0,
    this.physics,
    this.tabBarViewWidget,
    this.headWidget,
    this.footWidget,
  });

  //if（tabBarViewHeight==0）{
  // tabBarViewWidget 必须传
  // }else{
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Offstage(
        offstage: headWidget == null,
        child: headWidget,
      ),
      Container(
        margin: tabBarMargin,
        padding: tabBarPadding,
        decoration: decoration ?? BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: underlineHeight ?? 0,
                    color: underlineBackgroundColor))),
        child: TabBar(
          controller: controller,
          labelPadding: labelPadding,
          tabs: tabBar,
          indicator: indicator,
          labelColor: labelColor ?? getColors(blue),
          unselectedLabelColor: unselectedLabelColor ?? getColors(background),
          indicatorColor: labelColor ?? getColors(blue),
          indicatorWeight: indicatorWeight ?? WayUtils.getWidth(1),
          indicatorPadding: indicatorPadding,
          labelStyle: labelStyle ?? WayStyles.textStyleBlack70(fontSize: 13),
          indicatorSize: indicatorSize ?? TabBarIndicatorSize.label,
        ),
      ),
      Offstage(
        offstage: amongWidget == null,
        child: amongWidget,
      ),
      tabBarViewHeight == 0
          ? Expanded(
          child: Container(
              margin: tabBarViewMargin,
              padding: tabBarViewPadding,
              child:
              TabBarView(controller: controller, children: tabBarView)))
          : Container(
          margin: tabBarViewMargin,
          padding: tabBarViewPadding,
          height: tabBarViewHeight,
          child: TabBarView(controller: controller, children: tabBarView)),
      Offstage(
        offstage: footWidget == null,
        child: footWidget,
      ),
    ]);
  }
}
