import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// [TabBar]和[TabBarView]
/// 外层添加 常用属性
class TabBarMerge extends StatelessWidget {
  const TabBarMerge({
    Key? key,
    required this.tabBar,
    required this.controller,
    this.tabView,
    this.reverse = false,
    this.height,
    this.physics,
    this.width,
    this.among,
    this.header,
    this.footer,
    this.margin,
    this.padding,
    this.decoration,
    this.constraints,
    this.dragStartBehavior = DragStartBehavior.start,
  }) : super(key: key);

  /// 使用 [TabBarBox] [TabBar]
  final Widget tabBar;

  final DragStartBehavior dragStartBehavior;

  /// 头部
  final Widget? header;

  /// [tabBar]和[tabBarView]中间层
  final Widget? among;

  /// 底部
  final Widget? footer;

  /// 控制器
  final TabController controller;

  final List<Widget>? tabView;

  /// 作用于[tabView]
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final ScrollPhysics? physics;

  /// [tabBar],[tabView] 反转
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    if (header != null) children.add(header!);
    children
        .add(tabView == null ? tabBar : (reverse ? tabBarUniversal : tabBar));
    if (among != null) children.add(among!);
    if (tabView != null) children.add(reverse ? tabBar : tabBarUniversal);
    if (footer != null) children.add(footer!);
    return Column(children: children);
  }

  Widget get tabBarUniversal => Universal(
      expanded: true,
      margin: margin,
      padding: padding,
      decoration: decoration,
      constraints: constraints,
      width: width,
      height: height,
      child: TabBarView(
          controller: controller,
          physics: physics,
          dragStartBehavior: dragStartBehavior,
          children: tabView!));
}

/// TabBarLevel 位置
enum TabBarLevelPosition { right, left }

class TabBarBox extends StatelessWidget {
  const TabBarBox({
    Key? key,
    required this.controller,
    required this.tabs,
    this.indicatorPadding = EdgeInsets.zero,
    this.levelPosition = TabBarLevelPosition.right,
    this.labelPadding,
    this.isScrollable = true,
    this.alignment,
    this.tabBarLevel,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorSize = TabBarIndicatorSize.label,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.indicatorWeight = 1,
    this.indicator,
    this.margin,
    this.padding,
    this.height,
    this.decoration,
    this.width,
    this.onTap,
    this.indicatorColor,
    this.automaticIndicatorColorAdjustment = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.overlayColor,
    this.mouseCursor,
    this.enableFeedback,
    this.physics,
  }) : super(key: key);

  /// [TabBar] 位置
  final TabBarLevelPosition levelPosition;

  /// [TabBar] 水平左边或者右边的Widget 添加标签
  final Widget? tabBarLevel;

  /// 作用于整个[TabBar]
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final Decoration? decoration;
  final ValueChanged<int>? onTap;

  /// [TabBar]
  final bool automaticIndicatorColorAdjustment;
  final DragStartBehavior dragStartBehavior;
  final MaterialStateProperty<Color?>? overlayColor;
  final MouseCursor? mouseCursor;
  final bool? enableFeedback;
  final ScrollPhysics? physics;
  final TabController controller;
  final List<Widget> tabs;

  /// 作用于 label
  final EdgeInsetsGeometry? labelPadding;

  /// 作用于指示器
  final EdgeInsetsGeometry indicatorPadding;

  /// 指示器高度
  final double indicatorWeight;
  final TabBarIndicatorSize? indicatorSize;

  /// tabBar 指示器
  final Decoration? indicator;

  /// true 最小宽度，false充满最大宽度
  final bool isScrollable;

  /// 选中与未选中的指示器和字体样式和颜色，
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    if (tabBarLevel != null) {
      switch (levelPosition) {
        case TabBarLevelPosition.right:
          children.add(Expanded(child: tabBarWidget));
          children.add(tabBarLevel!);
          break;
        case TabBarLevelPosition.left:
          children.add(tabBarLevel!);
          children.add(Expanded(child: tabBarWidget));
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
        child: tabBarLevel == null ? tabBarWidget : null);
  }

  Widget get tabBarWidget => TabBar(
      automaticIndicatorColorAdjustment: automaticIndicatorColorAdjustment,
      dragStartBehavior: dragStartBehavior,
      overlayColor: overlayColor,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      physics: physics,
      controller: controller,
      labelPadding: labelPadding,
      tabs: tabs,
      onTap: onTap,
      isScrollable: isScrollable,
      indicator: indicator,
      labelColor: labelColor,
      unselectedLabelColor: unselectedLabelColor,
      indicatorColor: indicatorColor ?? labelColor,
      indicatorWeight: indicatorWeight,
      indicatorPadding: indicatorPadding,
      labelStyle: labelStyle,
      unselectedLabelStyle: unselectedLabelStyle,
      indicatorSize: indicatorSize);
}
