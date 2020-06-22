import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/colors.dart';
import 'package:flutter_waya/src/tools/Tools.dart';

class Widgets {
  static Widget titleWidget(String title) {
    return Text(title, style: TextStyle(
        color: getColors(white), fontSize: 16, fontWeight: FontWeight.w700));
  }

  ///垂直线
  static Widget lineVertical(double height,
      {EdgeInsetsGeometry padding, double width, Color color, EdgeInsetsGeometry margin}) {
    return Container(
      height: height,
      width: width ?? Tools.getWidth(1),
      margin: margin,
      padding: padding,
      color: color ?? getColors(background),
    );
  }

  ///横线
  static Widget lineHorizontal(double width,
      {EdgeInsetsGeometry padding, double height, Color color, EdgeInsetsGeometry margin}) {
    return Container(
      height: height ?? Tools.getWidth(1),
      padding: padding,
      width: width ?? Tools.getWidth(),
      margin: margin,
      color: color ?? getColors(background),
    );
  }

  static Widget notDataWidget({double size, String showText, TextStyle textStyle, double, margin}) {
    return Container(
      margin: margin ?? EdgeInsets.all(100),
      child: Center(
          child: Text(
            showText ?? "暂无数据",
            style: textStyle ?? TextStyle(),
          )),
    );
  }

  static textDefault(String text,
      {Color color, int maxLines, double height, FontWeight fontWeight, TextAlign textAlign, TextOverflow overflow}) {
    return textWidget(text,
        textAlign: textAlign,
        maxLines: maxLines,
        color: color,
        fontWeight: fontWeight,
        overflow: overflow,
        height: height);
  }

  static textSmall(String text,
      {Color color, int maxLines, double height, FontWeight fontWeight, TextOverflow overflow}) {
    return textWidget(text,
        maxLines: maxLines,
        color: color,
        fontSize: 13,
        fontWeight: fontWeight,
        overflow: overflow,
        height: height);
  }

  static textWidget(String text,
      {Color color,
        int maxLines,
        TextAlign textAlign,
        double fontSize,
        double height,
        FontWeight fontWeight,
        TextOverflow overflow}) {
    return Text(text,
        textAlign: textAlign ?? TextAlign.center,
        maxLines: maxLines == null ? 1 : (maxLines == 0 ? null : maxLines),
        overflow: overflow ??
            (maxLines == 0 ? TextOverflow.clip : TextOverflow.ellipsis),
        style: TextStyle(
            decoration: TextDecoration.none,
            fontWeight: FontWeight.w500,
            fontSize: fontSize ?? 14,
            height: height,
            color: color ?? getColors(black70)));
  }
}
