import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/ColorInfo.dart';
import 'package:flutter_waya/src/constant/Styles.dart';
import 'package:flutter_waya/src/utils/Utils.dart';

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
              top: Utils.getHeight(11),
              left: 0,
              right: 0,
              bottom: Utils.getHeight(10)),
      tabs: tabs,
      labelColor: labelColor ?? getColors(tabBarLabelColor),
      unselectedLabelColor:
          unselectedLabelColor ?? getColors(tabBarUnselectedLabelColor),
      indicatorColor: labelColor ?? getColors(tabBarLabelColor),
      indicatorWeight: Utils.getWidth(1),
      labelStyle: Styles.textStyleBlack70(context, fontSize: 13),
      indicatorSize: indicatorSize ?? TabBarIndicatorSize.label,
    );
  }
}
