import 'package:flutter/cupertino.dart';
import 'package:flutter_waya/src/constant/WayStyles.dart';
import 'package:flutter_waya/src/utils/WayUtils.dart';

class CustomClipRRect extends StatelessWidget {
  final BorderRadius borderRadius;
  final CustomClipper<RRect> clipper;
  final Clip clipBehavior;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double height;
  final double width;
  final Decoration decoration;

  const CustomClipRRect({
    Key key,
    this.borderRadius,
    this.padding,
    this.margin,
    this.clipper,
    this.width,
    this.height,
    this.decoration,
    this.clipBehavior = Clip.antiAlias,
    this.child,
  })  : assert(clipBehavior != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? EdgeInsets.all(WayUtils.getWidth(1)),
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
