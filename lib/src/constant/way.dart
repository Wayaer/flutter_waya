import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

const double radiusLocal = ConstConstant.Radius;
const double fontSize = ConstConstant.fontSize;

class WayStyles {
  //统一所有阴影效果
  static List<BoxShadow> boxShadow() =>
      [BoxShadow(color: getColors(boxShadowColor), blurRadius: radiusLocal, spreadRadius: 1, offset: Offset(0, 3))];

  //left right  margin or padding 20
  static EdgeInsetsGeometry edgeInsetsHorizontal({double width: 20}) =>
      EdgeInsets.symmetric(horizontal: ScreenFit.getWidth(width));

  static Decoration borderRadiusTop({Color color, double radius}) => BoxDecoration(
      color: color ?? getColors(white),
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius ?? radiusLocal), topRight: Radius.circular(radius ?? radiusLocal)));

  //top bottom  margin or padding 20
  static EdgeInsetsGeometry edgeInsetsVertical({double height: 20}) =>
      EdgeInsets.symmetric(vertical: ScreenFit.getHeight(height));

  //统一白色背景 圆角
  static Decoration containerWhiteRadius({Color color, double radius, bool shadow: false}) => BoxDecoration(
      color: color ?? getColors(white),
      borderRadius: BorderRadius.circular(radius ?? radiusLocal),
      boxShadow: shadow ? boxShadow() : null);

  //统一 白色背景 圆角 边框
  static Decoration containerRadiusWidth({Color color, double width, Color widthColor, double radius}) => BoxDecoration(
      color: color ?? getColors(white),
      borderRadius: BorderRadius.circular(radius ?? radiusLocal),
      border: Border.all(width: width ?? ScreenFit.getWidth(1), color: widthColor ?? getColors(background)));

  //统一下划线样式
  static Decoration containerUnderlineBackground({Color color, double width, Color underlineColor}) => BoxDecoration(
      color: color,
      border: underlineColor == null
          ? null
          : Border(
              bottom:
                  BorderSide(width: width ?? ScreenFit.getHeight(1), color: underlineColor ?? getColors(background))));

  //统一上划线样式
  static Decoration containerTopLineBackground({Color color}) =>
      BoxDecoration(color: color, border: Border(top: BorderSide(color: getColors(background))));

  static TextStyle textStyleWhite({double fontSize, TextStyle textStyle}) =>
      mergeTextStyle(textStyle, WayStyles.textStyle(color: getColors(white), fontSize: fontSize));

  static TextStyle textStyleBlack70({double fontSize, TextStyle textStyle}) =>
      mergeTextStyle(textStyle, WayStyles.textStyle(color: getColors(black70), fontSize: fontSize));

  static TextStyle textStyleBlue({double fontSize, TextStyle textStyle}) =>
      mergeTextStyle(textStyle, WayStyles.textStyle(color: getColors(blue), fontSize: fontSize));

  static TextStyle textStyleBlack30({double fontSize, TextStyle textStyle}) => mergeTextStyle(
      textStyle,
      WayStyles.textStyle(
        color: getColors(black30),
        fontSize: fontSize,
      ));

  static TextStyle textStyle(
          {Color color, double fontSize, double height, FontWeight fontWeight, TextDecoration decoration}) =>
      TextStyle(
          decoration: TextDecoration.none,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontSize: fontSize ?? 14,
          height: height,
          color: color ?? getColors(black70));

  //以上是多种颜色字体 样式

  //start 合并到 end
  static TextStyle mergeTextStyle(TextStyle startStyle, TextStyle endStyle) {
    if (startStyle != null && endStyle != null) endStyle.merge(startStyle);
    return endStyle;
  }
}

class WayWidgets {
  static Widget titleWidget(String title) =>
      Text(title, style: TextStyle(color: getColors(white), fontSize: 16, fontWeight: FontWeight.w700));

  ///垂直线
  static Widget lineVertical(double height,
          {EdgeInsetsGeometry padding, double width, Color color, EdgeInsetsGeometry margin}) =>
      Container(
          height: height,
          width: width ?? ScreenFit.getWidth(1),
          margin: margin,
          padding: padding,
          color: color ?? getColors(background));

  ///横线
  static Widget lineHorizontal(double width,
          {EdgeInsetsGeometry padding, double height, Color color, EdgeInsetsGeometry margin}) =>
      Container(
          height: height ?? ScreenFit.getWidth(1),
          padding: padding,
          width: width ?? ScreenFit.getWidth(0),
          margin: margin,
          color: color ?? getColors(background));

  static Widget notDataWidget({double size, String showText, TextStyle textStyle, double, margin}) => Container(
      margin: margin ?? EdgeInsets.all(100),
      child: Center(
          child: Text(
        showText ?? "暂无数据",
        style: textStyle ?? TextStyle(),
      )));

  static textDefault(String text,
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

  static textSmall(String text,
          {Color color, int maxLines, TextStyle style, double height, FontWeight fontWeight, TextOverflow overflow}) =>
      textWidget(text,
          maxLines: maxLines,
          color: color,
          fontSize: 13,
          style: style,
          fontWeight: fontWeight,
          overflow: overflow,
          height: height);

  static textWidget(String text,
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
          overflow: overflow ?? (maxLines == 0 ? TextOverflow.clip : TextOverflow.ellipsis),
          style: style ??
              WayStyles.textStyle(
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w500,
                  fontSize: fontSize ?? 14,
                  height: height,
                  color: color ?? getColors(black70)));
}