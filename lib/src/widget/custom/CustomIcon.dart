import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class CustomIcon extends StatelessWidget {
  ///需要什么属性  自行添加
  final IconData icon;

  ///icon
  final ImageProvider imageProvider;

  ///图片转icon
  final Widget image;

  ///显示图片
  final TextDirection textDirection;

  ///仅支持icon
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

  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final int maxLines;
  final bool reversal;
  final TextOverflow overflow;
  final double spacing;
  final double iconSize;
  final AlignmentGeometry alignment;

  CustomIcon({
    Key key,
    Axis direction,
    MainAxisAlignment mainAxisAlignment,
    CrossAxisAlignment crossAxisAlignment,
    int maxLines,
    bool reversal,
    TextOverflow overflow,
    double spacing,
    double iconSize,
    this.icon,
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
    this.height,
    this.decoration,
    this.alignment,
    this.imageProvider,
    this.image,
    this.title,
  })  : this.maxLines = maxLines ?? 1,
        this.overflow = overflow ?? TextOverflow.ellipsis,
        this.iconSize = iconSize ?? Tools.getWidth(15),
        this.reversal = reversal ?? false,
        this.direction = direction ?? Axis.horizontal,
        this.spacing = spacing ?? Tools.getWidth(4),
        this.crossAxisAlignment =
            crossAxisAlignment ?? CrossAxisAlignment.center,
        this.mainAxisAlignment = mainAxisAlignment ?? MainAxisAlignment.center,
        super(key: key);

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
        width: direction == Axis.horizontal ? spacing : 0,
        height: direction == Axis.vertical ? spacing : 0);
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
    return (titleText != null || title != null) &&
        (icon != null || image != null || imageProvider != null);
  }

  Widget iconWidget() {
    List<Widget> listWidget = [];
    if (icon != null) {
      listWidget.add(Icon(icon,
          color: iconColor,
          size: iconSize,
          textDirection: textDirection,
          semanticLabel: semanticLabel));

      ///帮助盲人或者视力有障碍的用户提供语言辅助描述
    }
    if (imageProvider != null) {
      listWidget.add(ImageIcon(imageProvider,
          color: iconColor, size: iconSize, semanticLabel: semanticLabel));
    }
    if (image != null) {
      listWidget.add(image);
    }
    if (listWidget.length == 1) {
      return listWidget[0];
    } else {
      return Row(mainAxisSize: MainAxisSize.min, children: listWidget);
    }
  }
}
