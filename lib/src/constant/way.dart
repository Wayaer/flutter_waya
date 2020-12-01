import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

const double radiusLocal = ConstConstant.Radius;
const double fontSize = ConstConstant.fontSize;

class WayStyles {
  /// 统一所有阴影效果
  static List<BoxShadow> boxShadow() => <BoxShadow>[
        BoxShadow(
            color: getColors(boxShadowColor),
            blurRadius: radiusLocal,
            spreadRadius: 1,
            offset: const Offset(0, 3))
      ];

  /// left right  margin or padding 20
  static EdgeInsetsGeometry edgeInsetsHorizontal({double width = 20}) =>
      EdgeInsets.symmetric(horizontal: getWidth(width));

  static Decoration borderRadiusTop({Color color, double radius}) =>
      BoxDecoration(
          color: color ?? getColors(white),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius ?? radiusLocal),
              topRight: Radius.circular(radius ?? radiusLocal)));

  /// top bottom  margin or padding 20
  static EdgeInsetsGeometry edgeInsetsVertical({double height = 20}) =>
      EdgeInsets.symmetric(vertical: getHeight(height));

  /// 统一白色背景 圆角
  static Decoration containerWhiteRadius(
          {Color color, double radius, bool shadow = false}) =>
      BoxDecoration(
          color: color ?? getColors(white),
          borderRadius: BorderRadius.circular(radius ?? radiusLocal),
          boxShadow: shadow ? boxShadow() : null);

  /// 统一 白色背景 圆角 边框
  static Decoration containerRadiusWidth(
          {Color color, double width, Color widthColor, double radius}) =>
      BoxDecoration(
          color: color ?? getColors(white),
          borderRadius: BorderRadius.circular(radius ?? radiusLocal),
          border: Border.all(
              width: width ?? getWidth(1),
              color: widthColor ?? getColors(background)));

  /// 统一下划线样式
  static Decoration containerUnderlineBackground(
          {Color color, double width, Color underlineColor}) =>
      BoxDecoration(
          color: color,
          border: underlineColor == null
              ? null
              : Border(
                  bottom: BorderSide(
                      width: width ?? getHeight(1),
                      color: underlineColor ?? getColors(background))));

  /// 统一上划线样式
  static Decoration containerTopLineBackground({Color color}) => BoxDecoration(
      color: color,
      border: Border(top: BorderSide(color: getColors(background))));

  static TextStyle textStyleWhite({double fontSize, TextStyle textStyle}) =>
      mergeTextStyle(textStyle,
          WayStyles.textStyle(color: getColors(white), fontSize: fontSize));

  static TextStyle textStyleBlack70({double fontSize, TextStyle textStyle}) =>
      mergeTextStyle(textStyle,
          WayStyles.textStyle(color: getColors(black70), fontSize: fontSize));

  static TextStyle textStyleBlue({double fontSize, TextStyle textStyle}) =>
      mergeTextStyle(textStyle,
          WayStyles.textStyle(color: getColors(blue), fontSize: fontSize));

  static TextStyle textStyleBlack30({double fontSize, TextStyle textStyle}) =>
      mergeTextStyle(
          textStyle,
          WayStyles.textStyle(
            color: getColors(black30),
            fontSize: fontSize,
          ));

  static TextStyle textStyle(
          {Color color,
          double fontSize,
          double height,
          FontWeight fontWeight,
          TextDecoration decoration}) =>
      TextStyle(
          decoration: TextDecoration.none,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontSize: fontSize ?? 14,
          height: height,
          color: color ?? getColors(black70));

  /// 以上是多种颜色字体 样式

  /// start 合并到 end
  static TextStyle mergeTextStyle(TextStyle startStyle, TextStyle endStyle) {
    if (startStyle != null && endStyle != null) endStyle.merge(startStyle);
    return endStyle;
  }
}

///  横线
Widget divider({
  double height,
  Color color,
  double thickness,
  double indent,
  double endIndent,
}) =>
    Divider(
        height: height,
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
        color: color);

class WayWidgets {
  static Text titleWidget(String title) => Text(title,
      style: TextStyle(
          color: getColors(white), fontSize: 16, fontWeight: FontWeight.w700));

  ///  垂直线
  static Widget lineVertical(double height,
          {EdgeInsetsGeometry padding,
          double width,
          Color color,
          EdgeInsetsGeometry margin}) =>
      Container(
          height: height,
          width: width ?? getWidth(1),
          margin: margin,
          padding: padding,
          color: color ?? getColors(background));

  static Widget notDataWidget(
          {double size,
          String showText,
          TextStyle textStyle,
          EdgeInsetsGeometry margin}) =>
      Container(
          margin: margin ?? const EdgeInsets.all(100),
          child: Center(
              child: Text(
            showText ?? '暂无数据',
            style: textStyle ?? const TextStyle(),
          )));

  static Text textDefault(String text,
          {Color color,
          int maxLines,
          double height,
          FontWeight fontWeight,
          TextAlign textAlign,
          TextOverflow overflow}) =>
      textWidget(text,
          textAlign: textAlign,
          maxLines: maxLines,
          color: color,
          fontWeight: fontWeight,
          overflow: overflow,
          height: height);

  static Text textSmall(String text,
          {Color color,
          int maxLines,
          TextStyle style,
          double height,
          FontWeight fontWeight,
          TextOverflow overflow}) =>
      textWidget(text,
          maxLines: maxLines,
          color: color,
          fontSize: 13,
          style: style,
          fontWeight: fontWeight,
          overflow: overflow,
          height: height);

  static Text textWidget(String text,
          {Color color,
          TextStyle style,
          int maxLines,
          TextAlign textAlign,
          double fontSize,
          double height,
          FontWeight fontWeight,
          TextOverflow overflow}) =>
      Text(text,
          textAlign: textAlign ?? TextAlign.center,
          maxLines: maxLines == null ? 1 : (maxLines == 0 ? null : maxLines),
          overflow: overflow ??
              (maxLines == 0 ? TextOverflow.clip : TextOverflow.ellipsis),
          style: style ??
              WayStyles.textStyle(
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w500,
                  fontSize: fontSize ?? 14,
                  height: height,
                  color: color ?? getColors(black70)));
}
