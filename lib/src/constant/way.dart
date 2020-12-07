import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

const double _radiusLocal = ConstConstant.Radius;

class WayStyles {
  /// 统一所有阴影效果
  static List<BoxShadow> boxShadow() => <BoxShadow>[
        BoxShadow(
            color: getColors(boxShadowColor),
            blurRadius: _radiusLocal,
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
              topLeft: Radius.circular(radius ?? _radiusLocal),
              topRight: Radius.circular(radius ?? _radiusLocal)));

  /// top bottom  margin or padding 20
  static EdgeInsetsGeometry edgeInsetsVertical({double height = 20}) =>
      EdgeInsets.symmetric(vertical: getHeight(height));

  /// 统一白色背景 圆角
  static Decoration containerWhiteRadius(
          {Color color, double radius, bool shadow = false}) =>
      BoxDecoration(
          color: color ?? getColors(white),
          borderRadius: BorderRadius.circular(radius ?? _radiusLocal),
          boxShadow: shadow ? boxShadow() : null);

  /// 统一 白色背景 圆角 边框
  static Decoration containerRadiusWidth(
          {Color color, double width, Color widthColor, double radius}) =>
      BoxDecoration(
          color: color ?? getColors(white),
          borderRadius: BorderRadius.circular(radius ?? _radiusLocal),
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

  /// 以上是多种颜色字体 样式
}

/// start 合并到 end
TextStyle mergeTextStyle(TextStyle startStyle, TextStyle endStyle) {
  if (startStyle != null && endStyle != null) endStyle.merge(startStyle);
  return endStyle;
}

class TitleWidget extends BaseText {
  TitleWidget(String text)
      : super(text,
            color: getColors(white), fontSize: 16, fontWeight: FontWeight.w700);
}

///  垂直线
class LineVertical extends Container {
  LineVertical(
      {double height,
      EdgeInsetsGeometry padding,
      double width,
      Color color,
      EdgeInsetsGeometry margin})
      : super(
            height: height ?? double.infinity,
            width: width ?? 1,
            margin: margin,
            padding: padding,
            color: color ?? getColors(background));
}

///  暂无数据
class NotData extends StatelessWidget {
  const NotData({Key key, this.margin}) : super(key: key);

  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) => Container(
      margin: margin ?? const EdgeInsets.all(100),
      child: Center(child: TextDefault('暂无数据')));
}

class TextDefault extends BaseText {
  TextDefault(String text,
      {Color color,
      int maxLines,
      double height,
      TextStyle style,
      double fontSize,
      TextOverflow overflow,
      TextAlign textAlign})
      : super(text,
            color: color,
            maxLines: maxLines,
            height: height,
            style: style,
            fontSize: fontSize ?? 14,
            overflow: overflow,
            textAlign: textAlign);
}

class TextSmall extends BaseText {
  TextSmall(String text,
      {Color color,
      int maxLines,
      double height,
      double fontSize,
      TextStyle style,
      TextOverflow overflow,
      TextAlign textAlign})
      : super(text,
            color: color,
            maxLines: maxLines,
            height: height,
            style: style,
            fontSize: fontSize ?? 12,
            overflow: overflow,
            textAlign: textAlign);
}

///  BaseText
class BaseText extends Text {
  BaseText(
    String text, {
    Color color,
    int maxLines,
    double fontSize,
    double height,
    TextOverflow overflow,
    TextAlign textAlign,
    TextStyle style,
    String fontFamily,
    FontWeight fontWeight,
  }) : super(text ?? '',
            textAlign: textAlign,
            maxLines: maxLines == null ? 1 : (maxLines == 0 ? null : maxLines),
            overflow: overflow ??
                (maxLines == 0 ? TextOverflow.clip : TextOverflow.ellipsis),
            style: style ??
                BaseTextStyle(
                    fontWeight: fontWeight,
                    fontSize: fontSize,
                    color: color,
                    fontFamily: fontFamily,
                    height: height));
}

class TextStyleBlue extends BaseTextStyle {
  TextStyleBlue({double fontSize, double height, FontWeight fontWeight})
      : super(
            color: getColors(blue),
            fontSize: fontSize,
            height: height,
            fontWeight: fontWeight);
}

class TextStyleBlack30 extends BaseTextStyle {
  TextStyleBlack30({double fontSize, double height, FontWeight fontWeight})
      : super(
            color: getColors(black30),
            fontSize: fontSize,
            height: height,
            fontWeight: fontWeight);
}

class TextStyleBlack70 extends BaseTextStyle {
  TextStyleBlack70({double fontSize, double height, FontWeight fontWeight})
      : super(
            color: getColors(black70),
            fontSize: fontSize,
            height: height,
            fontWeight: fontWeight);
}

class TextStyleWhite extends BaseTextStyle {
  TextStyleWhite({double fontSize, double height, FontWeight fontWeight})
      : super(
            color: getColors(white),
            fontSize: fontSize,
            height: height,
            fontWeight: fontWeight);
}

///  BaseTextStyle
class BaseTextStyle extends TextStyle {
  BaseTextStyle(
      {Color color,
      double fontSize,
      double height,
      String fontFamily,
      FontWeight fontWeight})
      : super(
            color: color ?? getColors(black70),
            fontSize: fontSize ?? 14,
            height: height,
            decoration: TextDecoration.none,
            fontFamily: fontFamily,
            fontWeight: fontWeight);
}
