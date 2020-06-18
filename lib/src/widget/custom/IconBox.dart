import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class IconBox extends StatelessWidget {
  ///icon > image > imageProvider > widget
  final Widget widget;
  final IconData icon;
  final Widget image;
  final ImageProvider imageProvider;

  ///显示图片
  final TextDirection textDirection;

  ///仅支持icon
  final String semanticLabel;
  final String titleText;
  final Widget title;
  final bool addInkWell;
  final TextStyle titleStyle;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color background;
  final Color color;
  final double height;
  final double width;
  final Decoration decoration;
  final GestureTapCallback onTap;

  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final int maxLines;
  final bool reversal;
  final bool visible;
  final TextOverflow overflow;
  final double spacing;
  final double size;
  final AlignmentGeometry alignment;
  final TextAlign textAlign;

  IconBox({
    Key key,
    Axis direction,
    MainAxisAlignment mainAxisAlignment,
    CrossAxisAlignment crossAxisAlignment,
    int maxLines,
    bool reversal,
    TextOverflow overflow,
    double spacing,
    double size,
    TextAlign textAlign,
    this.icon,
    this.background,
    this.color,
    this.semanticLabel,
    this.textDirection,
    this.titleText,
    this.addInkWell,
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
    this.visible,
    this.widget,
  })  : this.maxLines = maxLines ?? 1,
        this.overflow = overflow ?? TextOverflow.ellipsis,
        this.textAlign = textAlign ?? TextAlign.start,
        this.size = size ?? Tools.getWidth(15),
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
        listWidget.addAll(iconWidget());
      } else {
        listWidget.addAll(iconWidget());
        listWidget.add(spacingWidget());
        listWidget.add(titleWidget());
      }
      return universal(children: listWidget);
    }
    if (iconWidget().length > 0) {
      return universal(child: iconWidget()[0]);
    }
    return Container();
  }

  Widget universal({List<Widget> children, Widget child}) {
    return Universal(
      addInkWell: addInkWell,
      child: child,
      visible: visible,
      direction: direction,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: children,
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
    if (title != null) {
      return title;
    }
    return Text(
      titleText ?? '',
      style: titleStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      textDirection: textDirection,
      overflow: overflow,
    );
  }

  bool isChildren() {
    return (titleText != null || title != null) &&
        (icon != null ||
            image != null ||
            widget != null ||
            imageProvider != null);
  }

  List<Widget> iconWidget() {
    List<Widget> listWidget = [];
    if (icon != null) {
      listWidget.add(Icon(icon,
          color: color,
          size: size,
          textDirection: textDirection,
          semanticLabel: semanticLabel));

      ///帮助盲人或者视力有障碍的用户提供语言辅助描述
    }
    if (image != null) {
      listWidget.add(image);
    }
    if (imageProvider != null) {
      listWidget.add(ImageIcon(imageProvider,
          color: color, size: size, semanticLabel: semanticLabel));
    }
    if (widget != null) {
      listWidget.add(widget);
    }
    return listWidget;
  }
}
