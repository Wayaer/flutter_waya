import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayStyles.dart';
import 'package:flutter_waya/src/utils/WayUtils.dart';

class TabBarWidget extends StatelessWidget {
  TabController controller;
  final EdgeInsetsGeometry labelPadding;
  final List<Widget> tabs;
  final Color labelColor;
  final Color unselectedLabelColor;
  final TabBarIndicatorSize indicatorSize;

  TabBarWidget({
    this.controller,
    this.labelPadding,
    this.tabs,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorSize,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      labelPadding: labelPadding ??
          EdgeInsets.only(
              top: WayUtils.getHeight(11),
              left: 0,
              right: 0,
              bottom: WayUtils.getHeight(10)),
      tabs: tabs,
      labelColor: labelColor ?? getColors(tabBarLabelColor),
      unselectedLabelColor:
          unselectedLabelColor ?? getColors(tabBarUnselectedLabelColor),
      indicatorColor: labelColor ?? getColors(tabBarLabelColor),
      indicatorWeight: WayUtils.getWidth(1),
      labelStyle: WayStyles.textStyleBlack70(context, fontSize: 13),
      indicatorSize: indicatorSize ?? TabBarIndicatorSize.label,
    );
  }
}
