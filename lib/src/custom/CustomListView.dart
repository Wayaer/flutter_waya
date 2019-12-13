import 'package:flutter/material.dart';
import 'package:flutter_waya/src/widget/CommonWidget.dart';

class CustomListView extends StatelessWidget {
  final bool shrinkWrap;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final ScrollPhysics physics;
  final double itemExtent;
  final ScrollController controller;
  final EdgeInsetsGeometry padding;
  final Widget noData;

  CustomListView({
    Key key,
    this.itemBuilder,
    this.itemCount,
    this.physics,
    this.controller,
    this.itemExtent,
    this.padding,
    this.noData,
    this.shrinkWrap: true,
  })  : assert(itemCount != null),
        assert(itemBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return itemCount > 0
        ? ListView.builder(
            physics: physics,
            shrinkWrap: shrinkWrap,
            controller: controller,
            itemBuilder: itemBuilder,
            itemCount: itemCount,
            itemExtent: itemExtent,
            padding: padding,
          )
        : noData == null ? CommonWidget.noDataWidget() : noData;
  }
}
