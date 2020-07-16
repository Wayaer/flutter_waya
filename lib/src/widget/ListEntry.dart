import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/constant.dart';
import 'package:flutter_waya/src/constant/styles.dart';
import 'package:flutter_waya/src/widget/custom/Universal.dart';

class ListEntry extends StatelessWidget {
  final GestureTapCallback onTap;
  final GestureTapCallback onDoubleTap;
  final GestureLongPressCallback onLongPress;
  final bool isThreeLine;

  ///是否默认3行高度，subtitle不为空时才能使用
  final bool selected;

  ///设置为true后字体变小
  final bool dense;
  final EdgeInsetsGeometry contentPadding;

  ///左侧widget
  final Widget leading;

  ///副标题
  final Widget subtitle;

  ///右侧widget
  final Widget child;

  final Widget title;
  final String titleText;
  final String heroTag;
  final TextStyle titleStyle;
  final double height;
  final Widget prefix;

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry prefixMargin;
  final bool inkWell;
  final Color underlineColor;

  final EdgeInsetsGeometry arrowMargin;
  final Color color;
  final BoxDecoration decoration;
  final double arrowSize;
  final Color arrowColor;
  final Widget arrowIcon;
  final bool arrow;
  final bool enabled;

  ListEntry(
      {Key key,
      double arrowSize,
      Color arrowColor,
      bool isThreeLine,
      bool arrow,
      bool enabled,
      this.onTap,
      this.heroTag,
      this.onDoubleTap,
      this.onLongPress,
      this.title,
      this.height,
      this.inkWell,
      this.padding,
      this.margin,
      this.decoration,
      this.child,
      this.color,
      this.titleText,
      this.titleStyle,
      this.underlineColor,
      this.leading,
      this.subtitle,
      this.dense,
      this.contentPadding,
      this.selected,
      this.arrowIcon,
      this.arrowMargin,
      this.prefix,
      this.prefixMargin})
      : this.arrowSize = arrowSize ?? ScreenFit.getWidth(16),
        this.arrowColor = arrowColor ?? getColors(black),
        this.isThreeLine = isThreeLine ?? false,
        this.arrow = arrow ?? true,
        this.enabled = enabled ?? true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List();
    if (prefix != null) children.add(prefix);
    children.add(listTile());
    if (arrowIcon != null) children.add(arrowIcon);
    if (arrow) children.add(arrowWidget());
    return Universal(
        heroTag: heroTag,
        height: height,
        addInkWell: inkWell,
        margin: margin,
        padding: padding,
        onLongPress: enabled ? onLongPress : null,
        onDoubleTap: enabled ? onDoubleTap : null,
        onTap: enabled ? onTap : null,
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        decoration: decoration ??
            WayStyles.containerUnderlineBackground(
                underlineColor: underlineColor, color: color),
        children: children);
  }

  Widget listTile() {
    return Expanded(
        child: ListTile(
      contentPadding: contentPadding,
      title: title ?? Text(titleText, style: titleStyle),
      subtitle: subtitle,
      leading: leading,
      trailing: child,
      isThreeLine: isThreeLine,
      dense: dense,
      enabled: false,
      selected: false,
    ));
  }

  Widget arrowWidget() {
    return IconBox(
        icon: ConstIcon.arrowRight,
        size: arrowSize,
        color: arrowColor,
        margin: arrowMargin);
  }
}
