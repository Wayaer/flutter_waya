import 'package:flutter/material.dart';

import 'CustomFlex.dart';

class CustomButton extends StatelessWidget {
  final child;
  final String text;
  final bool inkWell;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color color;
  final double height;
  final double width;
  final Decoration decoration;
  final GestureTapCallback onTap;
  final AlignmentGeometry alignment;
  final int maxLines;
  final TextOverflow overflow;

  CustomButton({
    Key key,
    this.text: 'Button',
    this.inkWell: false,
    this.textStyle,
    this.onTap,
    this.padding,
    this.margin,
    this.width,
    this.color,
    this.height,
    this.decoration,
    this.alignment: Alignment.center,
    this.maxLines: 1,
    this.child,
    this.overflow: TextOverflow.ellipsis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFlex(
      inkWell: inkWell,
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
