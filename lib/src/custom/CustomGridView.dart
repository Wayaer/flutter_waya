import 'package:flutter/material.dart';
import 'package:flutter_waya/src/utils/BaseUtils.dart';
import 'package:flutter_waya/src/widget/CommonWidget.dart';

class CustomGridView extends StatelessWidget {
  final bool shrinkWrap;
  final int itemCount;
  final ScrollPhysics physics;
  final ScrollController controller;
  final EdgeInsetsGeometry padding;
  final List<Widget> children;
  final Widget noData;
  final double mainAxisSpacing;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double childAspectRatio;

  CustomGridView({
    Key key,
    this.itemCount: 0,
    this.physics,
    this.noData,
    this.controller,
    this.padding,
    this.children,
    this.crossAxisCount: 1,
    this.shrinkWrap: true,
    this.mainAxisSpacing: 0.0,
    this.crossAxisSpacing: 0.0,
    this.childAspectRatio: 1.0,
  })  : assert(children != null),
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
        : noData == null ? CommonWidget.noDataWidget(margin: EdgeInsets.all(BaseUtils.getWidth(10))) : noData;
  }
}
