import 'package:flutter/material.dart';
import 'package:flutter_waya/src/utils/BaseUtils.dart';

import 'CustomFlex.dart';

class CustomIcon extends StatelessWidget {
  //需要什么属性  自行添加
  final IconData icon; //icon
  final ImageProvider imageProvider; //图片转icon
  final Image image; //显示图片
  final TextDirection textDirection; //仅支持icon
  final String semanticLabel;
  final String titleText;
  final Widget title;
  final bool inkWell;
  final TextStyle titleStyle;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color background;
  final Color iconColor;
  final double height;
  final double width;
  final Decoration decoration;
  final GestureTapCallback onTap;

  Axis direction;
  MainAxisAlignment mainAxisAlignment;
  CrossAxisAlignment crossAxisAlignment;
  int maxLines;
  bool reversal;
  TextOverflow overflow;
  double spacing;
  double iconSize;
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
    this.titleText,
    this.inkWell,
    this.titleStyle,
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
    this.imageProvider,
    this.image,
    this.title,
  }) : super(key: key) {
    if (maxLines == null) maxLines = 1;
    if (overflow == null) overflow = TextOverflow.ellipsis;
    if (iconSize == null) iconSize = BaseUtils.getWidth(15);
    if (reversal == null) reversal = false;
    if (direction == null) direction = Axis.horizontal;
    if (spacing == null) spacing = BaseUtils.getWidth(4);
    if (crossAxisAlignment == null) crossAxisAlignment = CrossAxisAlignment.center;
    if (mainAxisAlignment == null) mainAxisAlignment = MainAxisAlignment.center;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listWidget = [];
    if (isChildren()) {
      if (reversal) {
        listWidget.add(titleWidget());
        listWidget.add(spacingWidget());
        listWidget.add(iconWidget());
      } else {
        listWidget.add(iconWidget());
        listWidget.add(spacingWidget());
        listWidget.add(titleWidget());
      }
    }
    return CustomFlex(
      inkWell: inkWell,
      child: (isChildren()) ? null : iconWidget(),
      direction: direction,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: (isChildren()) ? listWidget : null,
      width: width,
      height: height,
      onTap: onTap,
      margin: margin,
      decoration: decoration ?? BoxDecoration(color: background),
      padding: padding,
      alignment: alignment,
    );
  }

  Widget spacingWidget() {
    return Container(
        width: direction == Axis.horizontal ? spacing : 0, height: direction == Axis.vertical ? spacing : 0);
  }

  Widget titleWidget() {
    return title != null
        ? title
        : Text(
            titleText ?? '',
            style: titleStyle,
            textAlign: TextAlign.start,
            maxLines: maxLines,
            textDirection: textDirection,
            overflow: overflow,
          );
  }

  bool isChildren() {
    return (titleText != null || title != null) && (icon != null || image != null || imageProvider != null);
  }

  Widget iconWidget() {
    List<Widget> listWidget = [];
    if (icon != null) {
      listWidget.add(Icon(icon,
          color: iconColor,
          size: iconSize,
          textDirection: textDirection,
          semanticLabel: semanticLabel)); //帮助盲人或者视力有障碍的用户提供语言辅助描述
    }
    if (imageProvider != null) {
      listWidget.add(ImageIcon(imageProvider, color: iconColor, size: iconSize, semanticLabel: semanticLabel));
    }
    if (image != null) {
      listWidget.add(image);
    }
    return Row(mainAxisSize: MainAxisSize.min, children: listWidget);
  }
}
