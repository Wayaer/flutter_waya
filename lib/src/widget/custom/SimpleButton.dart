import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class SimpleButton extends StatelessWidget {
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
  final bool addInkWell;
  final bool visible;

  SimpleButton({
    Key key,
    String text,
    bool inkWell,
    this.textStyle,
    this.visible,
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
    this.addInkWell,
  })  : this.text = text ?? 'Button',
        this.overflow = overflow ?? TextOverflow.ellipsis,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget = Text(
      text,
      textAlign: TextAlign.start,
      style: textStyle,
      maxLines: maxLines,
      overflow: overflow,
    );
    if (child != null) widget = child;
    return Universal(
      visible: visible,
      addInkWell: addInkWell,
      mainAxisSize: MainAxisSize.min,
      child: widget,
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
