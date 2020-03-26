import 'package:flutter/material.dart';
import 'package:flutter_waya/src/utils/BaseUtils.dart';

import 'CustomFlex.dart';

class CustomIcon extends StatelessWidget {
  //需要什么属性  自行添加
  final String text;
  final bool inkWell;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color background;
  final Color iconColor;
  final double height;
  final double width;
  final Decoration decoration;
  final GestureTapCallback onTap;
  final IconData icon;
  final double iconSize;
  final TextDirection textDirection;
  final String semanticLabel;
  final Image image;
  Axis direction;
  MainAxisAlignment mainAxisAlignment;
  CrossAxisAlignment crossAxisAlignment;
  int maxLines;
  bool reversal;
  TextOverflow overflow;
  double spacing;
  AlignmentGeometry alignment;

  CustomIcon({
    Key key,
    this.icon,
    this.iconSize,
    this.reversal,
    this.background,
    this.iconColor,
    this.semanticLabel,
    this.textDirection,
    this.text,
    this.inkWell,
    this.textStyle,
    this.onTap,
    this.padding,
    this.margin,
    this.width,
    this.spacing,
    this.height,
    this.decoration,
    this.direction,
    this.alignment,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.maxLines,
    this.overflow,
    this.image,
  }) : super(key: key) {
    if (maxLines == null) maxLines = 1;
    if (overflow == null) overflow = TextOverflow.ellipsis;
    if (reversal == null) reversal = false;
    if (spacing == null) spacing = 4;
    if (overflow == null) overflow = TextOverflow.ellipsis;
    if (crossAxisAlignment == null) crossAxisAlignment = CrossAxisAlignment.center;
    if (mainAxisAlignment == null) mainAxisAlignment = MainAxisAlignment.center;
    if (alignment == null) alignment = Alignment.center;
    if (direction == null) direction = Axis.horizontal;
  }

  @override
  Widget build(BuildContext context) {
    return CustomFlex(
      inkWell: inkWell,
      child: text == null ? iconWidget() : null,
      direction: direction,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: text == null
          ? null
          : <Widget>[
        reversal ? textWidget() : iconWidget(),
        direction == Axis.horizontal
            ? Container(width: spacing ?? BaseUtils.getWidth(spacing))
            : Container(
          height: spacing ?? BaseUtils.getHeight(spacing),
        ),
        reversal ? iconWidget() : textWidget(),
      ],
      width: width,
      height: height,
      onTap: onTap,
      margin: margin,
      color: background,
      decoration: decoration,
      padding: padding,
      alignment: alignment,
    );
  }

  Widget textWidget() {
    return Text(
      text,
      style: textStyle,
      textAlign: TextAlign.start,
      maxLines: maxLines,
      textDirection: textDirection,
      overflow: overflow,
    );
  }

  Widget iconWidget() {
    return image == null
        ? Icon(icon,
        color: iconColor,
        size: iconSize ?? BaseUtils.getWidth(15),
        textDirection: textDirection,
        semanticLabel: semanticLabel)
        : image;
  }
}
