import 'package:flutter/material.dart';

import 'CustomFlex.dart';

class CustomButton extends StatelessWidget {
  final child;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color color;
  final double height;
  final double width;
  final Decoration decoration;
  final GestureTapCallback onTap;
  final AlignmentGeometry alignment;
  int maxLines;
  TextOverflow overflow;
  String text;
  bool inkWell;

  CustomButton({
    Key key,
    this.text,
    this.inkWell,
    this.textStyle,
    this.onTap,
    this.padding,
    this.margin,
    this.width,
    this.color,
    this.height,
    this.decoration,
    this.alignment,
    this.maxLines,
    this.child,
    this.overflow: TextOverflow.ellipsis,
  }) : super(key: key) {
    if (text == null) text = 'Button';
    if (inkWell == null) inkWell = false;
    if (maxLines == null) maxLines = 1;
    if (overflow == null) overflow = TextOverflow.ellipsis;
  }

  @override
  Widget build(BuildContext context) {
    return CustomFlex(
      inkWell: inkWell,
      mainAxisSize: MainAxisSize.min,
      child: child != null
          ? child
          : Text(
        text,
        textAlign: TextAlign.start,
        style: textStyle,
        maxLines: maxLines,
        overflow: overflow,
      ),
      width: width,
      height: height,
      onTap: onTap,
      margin: margin,
      color: color,
      decoration: decoration,
      padding: padding,
      alignment: alignment,
    );
  }
}
