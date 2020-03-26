import 'package:flutter/material.dart';
import 'package:flutter_waya/src/utils/BaseUtils.dart';
import 'package:flutter_waya/src/widget/CommonWidget.dart';

class CustomGridView extends StatelessWidget {
  final ScrollController controller;
  final EdgeInsetsGeometry padding;
  final List<Widget> children;
  final Widget noData;
  bool shrinkWrap;
  int itemCount;
  ScrollPhysics physics;
  double mainAxisSpacing;
  int crossAxisCount;
  double crossAxisSpacing;
  double childAspectRatio;

  CustomGridView({
    Key key,
    this.itemCount,
    this.physics,
    this.noData,
    this.controller,
    this.padding,
    this.children,
    this.crossAxisCount,
    this.shrinkWrap,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.childAspectRatio,
  })
      : assert(children != null),
        super(key: key) {
    if (itemCount == null) itemCount = 0;
    if (crossAxisCount == null) crossAxisCount = 0;
    if (shrinkWrap == null) shrinkWrap = true;
    if (crossAxisSpacing == null) crossAxisSpacing = 0.0;
    if (childAspectRatio == null) childAspectRatio = 1.0;
    if (mainAxisSpacing == null) mainAxisSpacing = 1;
  }

  @override
  Widget build(BuildContext context) {
    return itemCount > 0
        ? GridView.count(
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      controller: controller,
      physics: physics,
      padding: padding,
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      childAspectRatio: childAspectRatio,
      children: children,
    )
        : noData == null ? CommonWidget.noDataWidget(margin: EdgeInsets.all(BaseUtils.getWidth(10))) : noData;
  }
}
