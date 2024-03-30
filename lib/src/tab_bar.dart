import 'package:flutter/material.dart';
import 'package:fl_extended/fl_extended.dart';

/// [TabBar]和[TabBarView]
/// 外层添加 常用属性
class TabBarMerge extends StatelessWidget {
  const TabBarMerge({
    super.key,
    required this.tabBar,
    required this.tabBarView,
    this.reverse = false,
    this.height,
    this.width,
    this.among,
    this.header,
    this.footer,
    this.margin,
    this.padding,
    this.decoration,
    this.constraints,
  });

  /// 使用 [TabBarBox] [TabBar]
  final Widget tabBar;
  final Widget tabBarView;

  /// 头部
  final Widget? header;

  /// [tabBar]和[tabBarView]中间层
  final Widget? among;

  /// 底部
  final Widget? footer;

  /// 作用于[tabView]
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;

  /// [tabBar],[tabView] 反转
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    if (header != null) children.add(header!);
    children.add(reverse ? buildTabBarView : tabBar);
    if (among != null) children.add(among!);
    children.add(reverse ? tabBar : buildTabBarView);
    if (footer != null) children.add(footer!);
    return Column(children: children);
  }

  Widget get buildTabBarView => Universal(
      expanded: true,
      margin: margin,
      padding: padding,
      decoration: decoration,
      constraints: constraints,
      width: width,
      height: height,
      child: tabBarView);
}

/// TabBarLevel 位置
enum TabBarLevelPosition { right, left }

class TabBarBox extends StatelessWidget {
  const TabBarBox({
    super.key,
    required this.tabBar,
    this.levelPosition = TabBarLevelPosition.right,
    this.alignment,
    this.margin,
    this.padding,
    this.height,
    this.decoration,
    this.width,
    this.level,
  });

  /// [TabBar]
  final TabBar tabBar;

  /// [TabBar] 位置
  final TabBarLevelPosition levelPosition;

  /// [TabBar] 水平左边或者右边的Widget 添加标签
  final Widget? level;

  /// 作用于整个[TabBar]
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    if (level != null) {
      switch (levelPosition) {
        case TabBarLevelPosition.right:
          children.add(Expanded(child: tabBar));
          children.add(level!);
          break;
        case TabBarLevelPosition.left:
          children.add(level!);
          children.add(Expanded(child: tabBar));
          break;
      }
    }
    return Universal(
        height: height,
        margin: margin,
        padding: padding,
        width: width,
        alignment: alignment,
        direction: Axis.horizontal,
        decoration: decoration,
        children: children,
        child: level == null ? tabBar : null);
  }
}
