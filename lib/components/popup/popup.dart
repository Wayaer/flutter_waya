import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ModalWindowsOptions {
  const ModalWindowsOptions(
      {this.top = 0,
      this.left = 0,
      this.right = 0,
      this.bottom = 0,
      this.alignment = Alignment.center,
      this.gaussian = false,
      this.addMaterial = false,
      this.ignoring = false,
      this.fuzzyDegree = 4,
      this.mainAxisSize = MainAxisSize.min,
      this.color,
      this.behavior = HitTestBehavior.opaque,
      this.onTap,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.direction = Axis.horizontal,
      this.isScroll = false,
      this.isStack = false,
      this.filter});

  /// 背景事件
  final GestureTapCallback? onTap;
  final HitTestBehavior behavior;

  /// 背景色
  final Color? color;

  /// false 底层不响应事件  true 底层响应事件
  final bool ignoring;

  /// 是否添加Material Widget 部分组件需要基于Material
  final bool addMaterial;

  /// [filter]!=null 时 [fuzzyDegree] 无效
  /// [gaussian] 必须为 true
  final ImageFilter? filter;

  /// 是否开始背景模糊
  final bool gaussian;

  /// 模糊程度 0-100
  /// [gaussian] 必须为 true
  final double fuzzyDegree;

  /// 位置
  final double left;
  final double top;
  final double right;
  final double bottom;
  final AlignmentGeometry alignment;

  //// [children] 不为null 时以下参数有效
  /// ****** Flex ******  ///
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Axis direction;
  final MainAxisSize mainAxisSize;

  /// ****** SingleChildScrollView ******  ///
  final bool isScroll;

  /// ****** Stack ******  ///
  final bool isStack;

  ModalWindowsOptions copyWith({
    GestureTapCallback? onTap,
    HitTestBehavior? behavior,
    Color? color,
    bool? ignoring,
    bool? addMaterial,
    ImageFilter? filter,
    bool? gaussian,
    double? fuzzyDegree,
    double? left,
    double? top,
    double? right,
    double? bottom,
    AlignmentGeometry? alignment,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    Axis? direction,
    MainAxisSize? mainAxisSize,
    bool? isScroll,
    bool? isStack,
  }) =>
      ModalWindowsOptions(
          onTap: onTap ?? this.onTap,
          behavior: behavior ?? this.behavior,
          color: color ?? this.color,
          ignoring: ignoring ?? this.ignoring,
          addMaterial: addMaterial ?? this.addMaterial,
          filter: filter ?? this.filter,
          gaussian: gaussian ?? this.gaussian,
          fuzzyDegree: fuzzyDegree ?? this.fuzzyDegree,
          left: left ?? this.left,
          top: top ?? this.top,
          right: right ?? this.right,
          bottom: bottom ?? this.bottom,
          alignment: alignment ?? this.alignment,
          mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
          direction: direction ?? this.direction,
          mainAxisSize: mainAxisSize ?? this.mainAxisSize,
          isScroll: isScroll ?? this.isScroll,
          isStack: isStack ?? this.isStack);
}

class PopupModalWindows extends StatelessWidget {
  PopupModalWindows(
      {Key? key,
      this.onWillPop,
      this.children,
      this.child,
      ModalWindowsOptions? options})
      : options = options ?? GlobalOptions().modalWindowsOptions,
        super(key: key);

  /// 顶层组件
  final Widget? child;
  final List<Widget>? children;

  /// Android 监听物理返回按键
  final WillPopCallback? onWillPop;

  /// 弹框最低层配置
  final ModalWindowsOptions options;

  @override
  Widget build(BuildContext context) {
    Widget child = childWidget;
    if (options.gaussian) child = backdropFilter(child);
    if (options.addMaterial) {
      child = Material(
          color: Colors.transparent,
          child: MediaQuery(
              data: MediaQueryData.fromWindow(window), child: child));
    }
    if (options.ignoring) child = IgnorePointer(child: child);
    if (onWillPop != null) WillPopScope(child: child, onWillPop: onWillPop);
    return child;
  }

  Widget backdropFilter(Widget child) => BackdropFilter(
      filter: options.filter ??
          ImageFilter.blur(
              sigmaX: options.fuzzyDegree, sigmaY: options.fuzzyDegree),
      child: child);

  Widget get childWidget => Universal(
      color: options.color,
      onTap: options.onTap,
      behavior: options.behavior,
      alignment: options.alignment,
      padding: EdgeInsets.fromLTRB(
          options.left, options.top, options.right, options.bottom),
      child: child,
      direction: options.direction,
      isScroll: options.isScroll,
      isStack: options.isStack,
      mainAxisSize: options.mainAxisSize,
      mainAxisAlignment: options.mainAxisAlignment,
      crossAxisAlignment: options.crossAxisAlignment,
      children: children);
}

class PopupDoubleChooseWindows extends StatelessWidget {
  const PopupDoubleChooseWindows({
    Key? key,
    this.backgroundColor,
    this.width = 300,
    this.height,
    required this.content,
    this.padding,
    this.left,
    this.right,
    this.decoration,
    this.options,
  }) : super(key: key);

  /// 弹框内容
  final Widget content;

  /// 弹框背景色
  final Color? backgroundColor;

  /// 弹框 padding
  final EdgeInsetsGeometry? padding;

  /// 左边按钮
  final Widget? left;

  /// 右边按钮
  final Widget? right;

  final double width;
  final double? height;

  /// 弹框样式
  final Decoration? decoration;

  /// 低层模态框配置
  final ModalWindowsOptions? options;

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = <Widget>[];
    widgets.add(content);
    if (left != null && right != null) widgets.add(doubleChoose);
    return PopupModalWindows(
        options: options,
        child: Universal(
            onTap: () {},
            width: width,
            height: height,
            decoration: decoration ??
                BoxDecoration(
                    color:
                        backgroundColor ?? context.theme.dialogBackgroundColor),
            padding: padding,
            mainAxisSize: MainAxisSize.min,
            children: widgets));
  }

  Widget get doubleChoose =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
        Expanded(child: left!),
        Expanded(child: right!),
      ]);
}

enum LoadingStyle {
  /// 圆圈
  circular,

  /// 横条
  linear,

  /// 不常用 下拉刷新圆圈
  refresh,
}

class PopupLoadingWindows extends StatelessWidget {
  const PopupLoadingWindows({
    Key? key,
    this.strokeWidth = 4.0,
    this.style = LoadingStyle.circular,
    this.custom,
    this.value,
    this.valueColor,
    this.semanticsLabel,
    this.semanticsValue,
    this.backgroundColor,
    this.options,
    this.extra,
  }) : super(key: key);

  /// 以下为官方三个 ProgressIndicator 配置
  final LoadingStyle style;
  final double? value;
  final Animation<Color>? valueColor;
  final String? semanticsLabel;
  final String? semanticsValue;
  final Color? backgroundColor;
  final double strokeWidth;

  /// 官方 ProgressIndicator 底部加个组件
  final Widget? extra;

  /// 通常使用自定义的
  final Widget? custom;

  /// 低层模态框配置
  final ModalWindowsOptions? options;

  @override
  Widget build(BuildContext context) {
    Widget? windows = custom;
    if (windows == null) {
      final List<Widget> children = <Widget>[];
      switch (style) {
        case LoadingStyle.circular:
          children.add(CircularProgressIndicator(
              value: value,
              backgroundColor: backgroundColor,
              valueColor: valueColor,
              strokeWidth: strokeWidth,
              semanticsLabel: semanticsLabel,
              semanticsValue: semanticsValue));
          break;
        case LoadingStyle.linear:
          children.add(LinearProgressIndicator(
              value: value,
              backgroundColor: backgroundColor,
              valueColor: valueColor,
              semanticsLabel: semanticsLabel,
              semanticsValue: semanticsValue));
          break;
        case LoadingStyle.refresh:
          children.add(RefreshProgressIndicator(
              value: value,
              backgroundColor: backgroundColor,
              valueColor: valueColor,
              strokeWidth: strokeWidth,
              semanticsLabel: semanticsLabel,
              semanticsValue: semanticsValue));
          break;
      }
      if (extra != null) children.add(extra!);
      windows = Universal(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          decoration: BoxDecoration(
              color: backgroundColor, borderRadius: BorderRadius.circular(8.0)),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: children);
    }
    return PopupModalWindows(options: options, child: windows);
  }
}
