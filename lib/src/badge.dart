import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 组件右上角加红点
class Badge extends StatelessWidget {
  const Badge({
    super.key,
    this.hide = false,
    required this.child,
    required this.badge,
    this.badgeColor,
    this.badgeSize,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.alignment,
    this.width,
    this.height,
    this.onTap,
    this.margin,
  });

  /// 是否显示badge
  final bool hide;

  /// 底部组件
  final Widget child;

  /// 自定义badge内容
  final Widget badge;
  final Color? badgeColor;
  final double? badgeSize;

  /// badge 的位置
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final AlignmentGeometry? alignment;

  /// 整个组件的宽高
  final double? width;
  final double? height;

  /// 点击事件
  final GestureTapCallback? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [child];
    if (!hide) {
      Widget current = dot(context);
      if (alignment != null) {
        current = Align(alignment: alignment!, child: current);
      }
      if (right != null || top != null || bottom != null || left != null) {
        current = Positioned(
            right: right, top: top, bottom: bottom, left: left, child: current);
      }
      children.add(current);
    }
    return Universal(
        onTap: onTap,
        margin: margin,
        width: width,
        height: height,
        isStack: !hide,
        children: children);
  }

  Widget dot(BuildContext context) => Container(
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
          color: badgeColor ?? context.theme.primaryColor,
          shape: BoxShape.circle),
      child: badge);
}
