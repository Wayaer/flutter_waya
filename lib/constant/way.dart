import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

const double _radiusLocal = ConstConstant.Radius;

class WayStyles {
  /// 统一所有阴影效果
  static List<BoxShadow> boxShadow() => <BoxShadow>[
        const BoxShadow(
            color: ConstColors.boxShadowColor,
            blurRadius: _radiusLocal,
            spreadRadius: 1,
            offset: Offset(0, 3))
      ];

  /// left right  margin or padding 20
  static EdgeInsetsGeometry edgeInsetsHorizontal({double width = 20}) =>
      EdgeInsets.symmetric(horizontal: getWidth(width));

  static Decoration borderRadiusTop({Color color, double radius}) =>
      BoxDecoration(
          color: color ?? ConstColors.white,
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
          color: color ?? ConstColors.white,
          borderRadius: BorderRadius.circular(radius ?? _radiusLocal),
          boxShadow: shadow ? boxShadow() : null);

  /// 统一 白色背景 圆角 边框
  static Decoration containerRadiusWidth(
          {Color color, double width, Color widthColor, double radius}) =>
      BoxDecoration(
          color: color ?? ConstColors.white,
          borderRadius: BorderRadius.circular(radius ?? _radiusLocal),
          border: Border.all(
              width: width ?? getWidth(1),
              color: widthColor ?? ConstColors.background));

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
                      color: underlineColor ?? ConstColors.background)));

  /// 统一上划线样式
  static Decoration containerTopLineBackground({Color color}) => BoxDecoration(
      color: color,
      border: const Border(top: BorderSide(color: ConstColors.background)));
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
            color: color ?? ConstColors.background);
}

///  暂无数据
class PlaceholderChild extends StatelessWidget {
  const PlaceholderChild({Key key, this.margin}) : super(key: key);

  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) => Container(
      margin: margin ?? const EdgeInsets.all(100),
      child: Center(child: MergeText('暂无数据')));
}
