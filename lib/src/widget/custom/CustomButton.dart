import 'package:flutter/material.dart';

import 'CustomFlex.dart';

class CustomButton extends StatelessWidget {
  final child;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color background;
  final double height;
  final double width;
  final Decoration decoration;
  final GestureTapCallback onTap;
  final AlignmentGeometry alignment;
  final int maxLines;
  final TextOverflow overflow;
  final String text;
  final bool inkWell;

  CustomButton({
    Key key,
    String text,
    bool inkWell,
    this.textStyle,
    this.onTap,
    this.padding,
    this.margin,
    this.width,
    this.background,
    this.height,
    this.decoration,
    this.alignment,
    this.maxLines,
    this.child,
    TextOverflow overflow,
  })
      : this.text = text ?? 'Button',
        this.inkWell = inkWell ?? false,
        this.overflow = overflow ?? TextOverflow.ellipsis,
        super(key: key);

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
      decoration: decoration ?? BoxDecoration(color: background),
      padding: padding,
      alignment: alignment,
    );
  }
}
