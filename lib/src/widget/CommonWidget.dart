import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/ColorInfo.dart';
import 'package:flutter_waya/src/utils/Utils.dart';

class CommonWidget {
  static Widget titleWidget(title) {
    return Text(title,
        style: TextStyle(
            color: getColors(appBarTextColor),
            fontSize: 16,
            fontWeight: FontWeight.w700));
  }

  //垂直线
  static Widget lineVertical(double height,
      {EdgeInsetsGeometry padding,
      double width,
      Color color,
      EdgeInsetsGeometry margin}) {
    return Container(
      height: height,
      width: width ?? Utils.getWidth(1),
      margin: margin,
      padding: padding,
      color: color ?? getColors(lineBackground),
    );
  }

  //横线
  static Widget lineHorizontal(double width,
      {EdgeInsetsGeometry padding,
      double height,
      Color color,
      EdgeInsetsGeometry margin}) {
    return Container(
      height: height ?? Utils.getWidth(1),
      padding: padding,
      width: width ?? Utils.getWidth(),
      margin: margin,
      color: color ?? getColors(lineBackground),
    );
  }

  static Widget noDataWidget(
      {double size, String showText, TextStyle textStyle, double, margin}) {
    return Container(
      margin: margin ?? EdgeInsets.all(100),
      child: Center(
          child: Text(
        showText ?? "暂无数据",
        style: textStyle ?? TextStyle(),
      )),
    );
  }
}
