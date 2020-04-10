import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayIcon.dart';
import 'package:flutter_waya/src/constant/WayStyles.dart';
import 'package:flutter_waya/src/custom/CustomFlex.dart';
import 'package:flutter_waya/src/utils/BaseUtils.dart';

class ListItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final GestureTapCallback onDoubleTap;
  final GestureLongPressCallback onLongPress;
  final bool isThreeLine; //是否默认3行高度，subtitle不为空时才能使用
  final bool selected;
  final bool dense; //设置为true后字体变小
  final EdgeInsetsGeometry contentPadding;
  final Widget leading; //左侧widget
  final Widget subtitle; //副标题
  final Widget child; //右侧widget
  final Widget title;
  final String titleText;
  final TextStyle titleStyle;
  final double height;

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool inkWell;
  final Color underlineColor;

  final EdgeInsetsGeometry arrowMargin;
  final Color backgroundColor;
  final BoxDecoration decoration;
  final double arrowSize;
  final Color arrowColor;
  final Widget arrowIcon;
  final bool arrow;
  final bool enabled;

  ListItem({Key key,
    this.title,
    this.height,
    this.inkWell,
    this.onTap,
    this.arrow: true,
    this.padding,
    this.margin,
    this.decoration,
    this.child,
    this.backgroundColor,
    this.titleText,
    this.titleStyle,
    this.arrowSize,
    this.arrowColor,
    this.underlineColor,
    this.leading, this.subtitle,
    this.dense, this.onLongPress,
    this.contentPadding, this.enabled: true,
    this.isThreeLine, this.selected,
    this.onDoubleTap, this.arrowIcon, this.arrowMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFlex(
      height: height,
      inkWell: inkWell,
      margin: margin,
      padding: padding,
      onLongPress: enabled ? onLongPress : null,
      onDoubleTap: enabled ? onDoubleTap : null,
      onTap: enabled ? onTap : null,
      direction: Axis.horizontal,
      decoration: decoration ??
          WayStyles.containerUnderlineBackground(underlineColor: underlineColor, color: backgroundColor),
      children: <Widget>[
        Expanded(child: ListTile(
          contentPadding: contentPadding,
          title: title ?? Text(titleText, style: titleStyle),
          subtitle: subtitle,
          leading: leading,
          trailing: child,
          isThreeLine: isThreeLine ?? false,
          dense: dense,
          enabled: false,
          selected: false, //展示是否默认显示选中
        )),
        Offstage(
          offstage: !arrow,
          child: Container(
              margin: arrowMargin,
              child: arrowIcon ?? Icon(
                WayIcon.iconsRight,
                size: arrowSize ?? BaseUtils.getWidth(16),
                color: arrowColor ?? getColors(black),
              )),
        ),
      ],

    );
  }
}
