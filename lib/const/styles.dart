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
