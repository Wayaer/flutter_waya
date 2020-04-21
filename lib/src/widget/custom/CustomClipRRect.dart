import 'package:flutter/cupertino.dart';
import 'package:flutter_waya/src/constant/WayStyles.dart';
import 'package:flutter_waya/src/tools/Tools.dart';

class CustomClipRRect extends StatelessWidget {
  final BorderRadius borderRadius;
  final CustomClipper<RRect> clipper;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double height;
  final double width;
  final Decoration decoration;
  final Clip clipBehavior;

  CustomClipRRect({
    Key key,
    Decoration decoration,
    Clip clipBehavior,
    EdgeInsetsGeometry padding,
    BorderRadius borderRadius,
    this.margin,
    this.clipper,
    this.width,
    this.height,
    this.child,
  })  : this.clipBehavior = clipBehavior ?? Clip.antiAlias,
        this.borderRadius = borderRadius ?? BorderRadius.circular(5),
        this.padding = padding ?? EdgeInsets.all(Tools.getWidth(1)),
        this.decoration = decoration ?? WayStyles.containerRadiusWidth(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: decoration,
      child: ClipRRect(
        clipBehavior: clipBehavior,
        clipper: clipper,
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}
