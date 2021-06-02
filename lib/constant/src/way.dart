import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

const List<BoxShadow> baseBoxShadow = <BoxShadow>[
  BoxShadow(
      color: ConstColors.boxShadowColor,
      blurRadius: ConstConstant.radius,
      spreadRadius: 1,
      offset: Offset(0, 3))
];

///  暂无数据
class PlaceholderChild extends StatelessWidget {
  const PlaceholderChild({Key? key, this.margin = const EdgeInsets.all(100)})
      : super(key: key);

  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) =>
      Container(margin: margin, child: Center(child: BText('暂无数据')));
}
