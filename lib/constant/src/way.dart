import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

List<BoxShadow> getBoxShadow(
        {int num = 1,
        Color color = Colors.black12,
        double? radius,
        BlurStyle blurStyle = BlurStyle.normal,
        double blurRadius = 0.05,
        double spreadRadius = 0.05,
        Offset? offset}) =>
    num.generate((index) => BoxShadow(
        color: color,
        blurStyle: blurStyle,
        blurRadius: radius ?? blurRadius,
        spreadRadius: radius ?? spreadRadius,
        offset: offset ?? const Offset(0, 0)));

/// 暂无数据
class PlaceholderChild extends StatelessWidget {
  const PlaceholderChild(
      {Key? key,
      this.padding = const EdgeInsets.all(100),
      this.child,
      this.text = 'There is no data'})
      : super(key: key);

  final EdgeInsetsGeometry padding;
  final Widget? child;
  final String text;

  @override
  Widget build(BuildContext context) =>
      Padding(padding: padding, child: Center(child: child ?? BText(text)));
}
