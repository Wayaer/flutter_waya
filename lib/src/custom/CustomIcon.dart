import 'package:flutter/material.dart';
import 'package:flutter_waya/src/utils/WayUtils.dart';

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
  final bool reversal;
  final Decoration decoration;
  final GestureTapCallback onTap;
  final AlignmentGeometry alignment;
  final int maxLines;
  final TextOverflow overflow;
  final IconData icon;
  final double iconSize;
  final double spacing;
  final TextDirection textDirection;
  final String semanticLabel;
  final Axis direction;
  final Image image;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  CustomIcon({
    Key key,
    this.icon,
    this.iconSize,
    this.reversal: false,
    this.background,
    this.iconColor,
    this.semanticLabel,
    this.textDirection,
    this.text,
    this.inkWell: false,
    this.textStyle,
    this.onTap,
    this.padding,
    this.margin,
    this.width,
    this.spacing: 4,
    this.height,
    this.decoration,
    this.direction: Axis.horizontal,
    this.alignment: Alignment.center,
    this.mainAxisAlignment: MainAxisAlignment.center,
    this.crossAxisAlignment: CrossAxisAlignment.center,
    this.maxLines: 1,
    this.overflow: TextOverflow.ellipsis,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFlex(
      inkWell: inkWell,
      child: text == null ? iconWidget(context) : null,
      direction: direction,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: text == null
          ? null
          : <Widget>[
        reversal ? textWidget() : iconWidget(context),
        direction == Axis.horizontal
            ? Container(width: spacing ?? WayUtils.getWidth(spacing))
            : Container(
          height: spacing ?? WayUtils.getHeight(spacing),
        ),
        reversal ? iconWidget(context) : textWidget(),
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

  Widget iconWidget(BuildContext context) {
    return image == null
        ? Icon(icon,
        color: iconColor,
        size: iconSize ?? WayUtils.getWidth(15),
        textDirection: textDirection,
        semanticLabel: semanticLabel)
        : image;
  }
}
