import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

List<BoxShadow> getBaseBoxShadow(Color color, {double radius = 0.05}) =>
    <BoxShadow>[
      BoxShadow(
          color: color,
          blurRadius: radius,
          spreadRadius: radius,
          offset: const Offset(0, 0))
    ];

/// 暂无数据
class PlaceholderChild extends StatelessWidget {
  const PlaceholderChild(
      {Key? key, this.padding = const EdgeInsets.all(100), this.child})
      : super(key: key);

  final EdgeInsetsGeometry padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) => Padding(
      padding: padding, child: Center(child: child ?? const BText('暂无数据')));
}
