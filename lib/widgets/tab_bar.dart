import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_waya/flutter_waya.dart';

class TabBarMerge extends StatelessWidget {
  const TabBarMerge({
    Key? key,
    required this.tabBar,
    this.tabView,
    required this.controller,
    this.reverse = false,
    this.viewHeight = 0,
    this.physics,
    this.width,
    this.among,
    this.header,
    this.footer,
    this.margin,
    this.padding,
    this.decoration,
    this.constraints,
  }) : super(key: key);

  ///  建议传 TabBarBox
  final Widget tabBar;

  ///  头部
  final Widget? header;

  ///  tabBar和tabBarView中间层
  final Widget? among;

  ///  底部
  final Widget? footer;

  ///  控制器
  final TabController controller;

  final List<Widget>? tabView;

  ///  作用于tabView
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  final BoxConstraints? constraints;
  final double? width;
  final ScrollPhysics? physics;
  final double viewHeight;

  ///  [tabBar],[tabView] 反转
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
      expanded: viewHeight == 0,
      margin: margin,
      padding: padding,
      decoration: decoration,
      constraints: constraints,
      width: width,
      height: viewHeight == 0 ? null : viewHeight,
      child: TabBarView(
          controller: controller, physics: physics, children: tabView!));
}

enum TabBarLevelPosition { right, left }

class TabBarBox extends StatelessWidget {
  const TabBarBox({
    Key? key,
    required this.controller,
    required this.tabs,
    this.indicatorPadding = EdgeInsets.zero,
    this.levelPosition = TabBarLevelPosition.right,
    this.labelPadding,
    this.isScrollable,
    this.alignment,
    this.tabBarLevel,
    this.selectedLabelColor,
    this.unselectedLabelColor,
    this.indicatorSize,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.indicatorWeight,
    this.indicator,
    this.margin,
    this.padding,
    this.height,
    this.decoration,
    this.width,
    this.onTap,
  }) : super(key: key);
  final TabController controller;
  final List<Widget> tabs;

  ///  作用于label
  final EdgeInsetsGeometry? labelPadding;

  ///  作用于指示器
  final EdgeInsetsGeometry indicatorPadding;

  ///  指示器高度
  final double? indicatorWeight;
  final TabBarIndicatorSize? indicatorSize;

  ///  tabBar 指示器
  final Decoration? indicator;

  ///  true 最小宽度，false充满最大宽度
  final bool? isScrollable;

  ///  tabBar 位置
  final TabBarLevelPosition levelPosition;

  ///  选中与未选中的指示器和字体样式和颜色，
  final Color? selectedLabelColor;
  final Color? unselectedLabelColor;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;

  ///  tabBar 水平左边或者右边的Widget 添加标签
  final Widget? tabBarLevel;

  ///  作用于整个tabBar
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final Decoration? decoration;
  final ValueChanged<int>? onTap;

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
        controller: controller,
        labelPadding: labelPadding,
        tabs: tabs,
        onTap: onTap,
        isScrollable: isScrollable ?? true,
        indicator: indicator,
        labelColor: selectedLabelColor ?? ConstColors.blue,
        unselectedLabelColor: unselectedLabelColor ?? ConstColors.background,
        indicatorColor: selectedLabelColor ?? ConstColors.blue,
        indicatorWeight: indicatorWeight ?? getWidth(1),
        indicatorPadding: indicatorPadding,
        labelStyle:
            const BasisTextStyle(fontSize: 13, color: ConstColors.black70)
                .merge(selectedLabelStyle),
        unselectedLabelStyle: unselectedLabelStyle,
        indicatorSize: indicatorSize ?? TabBarIndicatorSize.label,
      );
}
