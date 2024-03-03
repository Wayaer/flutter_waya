import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ListEntry extends StatelessWidget {
  const ListEntry(
      {super.key,
      this.isThreeLine = false,
      this.enabled = true,
      this.dense = true,
      this.arrow = false,
      this.titleText = '',
      this.arrowSize = 15,
      this.onTap,
      this.heroTag,
      this.onDoubleTap,
      this.onLongPress,
      this.title,
      this.height,
      this.padding,
      this.margin,
      this.decoration,
      this.child,
      this.color,
      this.titleStyle,
      this.underlineColor,
      this.leading,
      this.subtitle,
      this.contentPadding,
      this.selected,
      this.prefix,
      this.arrowColor,
      this.arrowIcon});

  /// 单击事件
  final GestureTapCallback? onTap;

  /// 双击事件
  final GestureTapCallback? onDoubleTap;

  /// 长按事件
  final GestureLongPressCallback? onLongPress;

  /// 显示三行
  final bool isThreeLine;

  /// 是否默认3行高度，subtitle不为空时才能使用
  final bool? selected;

  /// 设置为true后 高度变小 默认为true
  final bool dense;

  /// 内边距
  final EdgeInsetsGeometry? contentPadding;

  /// 左侧widget
  final Widget? leading;

  /// 副标题
  final Widget? subtitle;

  /// 右侧widget
  final Widget? child;

  /// 右边是否有箭头
  final bool arrow;
  final Widget? arrowIcon;
  final double arrowSize;
  final Color? arrowColor;

  /// 中间内容
  final Widget? title;
  final String titleText;
  final TextStyle? titleStyle;
  final String? heroTag;

  /// 高
  final double? height;

  /// 前缀
  final Widget? prefix;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? underlineColor;
  final Color? color;

  /// 是否可点击
  final bool enabled;

  /// 整个ListEntry装饰器
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    if (prefix != null) children.add(prefix!);
    children.add(listTile);
    if (arrow || arrowIcon != null) children.add(arrowIcon ?? arrowWidget);
    return Universal(
        height: height,
        margin: margin,
        padding: padding,
        onLongPress: enabled ? onLongPress : null,
        onDoubleTap: enabled ? onDoubleTap : null,
        onTap: enabled ? onTap : null,
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        decoration: decoration ?? defaultDecoration,
        children: children);
  }

  Decoration? get defaultDecoration => color != null || underlineColor != null
      ? BoxDecoration(
          color: color,
          border: underlineColor != null
              ? Border(bottom: BorderSide(color: underlineColor!, width: 0.8))
              : null)
      : null;

  Widget get arrowWidget =>
      Icon(Icons.arrow_forward_ios_rounded, size: arrowSize, color: arrowColor);

  Widget get listTile => Expanded(
      child: ListTile(
          contentPadding: contentPadding,
          title: hero(title ?? BText(titleText, style: titleStyle)),
          subtitle: subtitle,
          leading: leading,
          trailing: child,
          isThreeLine: isThreeLine,
          dense: dense,
          enabled: false,
          selected: selected ?? false));

  Widget hero(Widget text) {
    if (heroTag != null) return Hero(tag: heroTag!, child: text);
    return text;
  }
}
