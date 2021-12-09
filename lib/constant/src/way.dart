import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

List<BoxShadow> getBaseBoxShadow(Color color) => <BoxShadow>[
      BoxShadow(
          color: color,
          blurRadius: 0.05,
          spreadRadius: 0.05,
          offset: const Offset(0, 0))
    ];

///  暂无数据
class PlaceholderChild extends StatelessWidget {
  const PlaceholderChild({Key? key, this.margin = const EdgeInsets.all(100)})
      : super(key: key);

  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) =>
      Container(margin: margin, child: const Center(child: BText('暂无数据')));
}
