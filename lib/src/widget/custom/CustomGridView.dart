import 'package:flutter/material.dart';
import 'package:flutter_waya/src/common/CommonWidget.dart';
import 'package:flutter_waya/src/tools/Tools.dart';

class CustomGridView extends StatelessWidget {
  final ScrollController controller;
  final EdgeInsetsGeometry padding;
  final List<Widget> children;
  final Widget noData;
  final bool shrinkWrap;
  final int itemCount;
  final ScrollPhysics physics;
  final double mainAxisSpacing;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double childAspectRatio;

  CustomGridView({
    Key key,
    bool shrinkWrap,
    int itemCount,
    double mainAxisSpacing,
    int crossAxisCount,
    double crossAxisSpacing,
    double childAspectRatio,
    this.noData,
    this.controller,
    this.padding,
    this.children, this.physics,
  })
      : assert(children != null),
        this.itemCount = itemCount ?? 0,
        this.crossAxisCount = crossAxisCount ?? 0,
        this.shrinkWrap = shrinkWrap = true,
        this.crossAxisSpacing = crossAxisSpacing ?? 0.0,
        this.childAspectRatio = childAspectRatio ?? 1.0,
        this.mainAxisSpacing = mainAxisSpacing ?? 1,
        super(key: key);

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
        : noData == null ? CommonWidget.notDataWidget(
        margin: EdgeInsets.all(Tools.getWidth(10))) : noData;
  }
}
