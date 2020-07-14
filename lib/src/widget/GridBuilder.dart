import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/widgets.dart';

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
      return noData ??
          Widgets.notDataWidget(
              margin: EdgeInsets.all(ScreenFit.getWidth(10)));
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
