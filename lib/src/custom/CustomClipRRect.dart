import 'package:flutter/cupertino.dart';
import 'package:flutter_waya/src/constant/WayStyles.dart';
import 'package:flutter_waya/src/utils/BaseUtils.dart';

class CustomClipRRect extends StatelessWidget {
  final BorderRadius borderRadius;
  final CustomClipper<RRect> clipper;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double height;
  final double width;
  final Decoration decoration;
  Clip clipBehavior;

  CustomClipRRect({
    Key key,
    this.borderRadius,
    this.padding,
    this.margin,
    this.clipper,
    this.width,
    this.height,
    this.decoration,
    this.clipBehavior,
    this.child,
  }) :super(key: key) {
    if (clipBehavior == null) clipBehavior = Clip.antiAlias;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? EdgeInsets.all(BaseUtils.getWidth(1)),
      margin: margin,
      decoration: decoration ?? WayStyles.containerRadiusWidth(),
      child: ClipRRect(
        clipBehavior: clipBehavior,
        clipper: clipper,
        borderRadius: borderRadius ?? BorderRadius.circular(5),
        child: child,
      ),
    );
  }
}
