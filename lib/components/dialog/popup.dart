import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class PopupOptions extends StatelessWidget {
  const PopupOptions(
      {Key? key,
      this.top = 0,
      this.left = 0,
      this.right = 0,
      this.bottom = 0,
      this.alignment = Alignment.topLeft,
      this.gaussian = false,
      this.addMaterial = false,
      this.ignoring = false,
      this.fuzzyDegree = 4,
      this.mainAxisSize = MainAxisSize.min,
      this.color,
      this.behavior = HitTestBehavior.opaque,
      this.child,
      this.onTap,
      this.children,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.direction = Axis.horizontal,
      this.isScroll = false,
      this.isStack = false,
      this.onWillPop,
      this.filter})
      : super(key: key);

  /// 顶层组件
  final Widget? child;
  final List<Widget>? children;

  /// 背景事件
  final GestureTapCallback? onTap;
  final HitTestBehavior behavior;

  /// 背景色
  final Color? color;

  /// false 底层不响应事件  true 底层响应事件
  final bool ignoring;

  /// 是否添加Material Widget 部分组件需要基于Material
  final bool addMaterial;

  /// 是否开始背景模糊
  final bool gaussian;

  /// 模糊程度 0-100
  /// [gaussian] 必须为 true
  final double fuzzyDegree;

  /// [filter]!=null 时 [fuzzyDegree] 无效
  /// [gaussian] 必须为 true
  final ImageFilter? filter;

  /// 具体位置
  final double left;
  final double top;
  final double right;
  final double bottom;

  /// 位置
  final AlignmentGeometry alignment;

  //// [children] 不为null 时以下参数有效
  ///  ****** Flex ******  ///
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Axis direction;
  final MainAxisSize mainAxisSize;

  ///  ****** SingleChildScrollView ******  ///
  final bool isScroll;

  ///  ****** Stack ******  ///
  final bool isStack;

  /// Android 监听物理返回按键
  final WillPopCallback? onWillPop;

  @override
  Widget build(BuildContext context) {
    Widget child = childWidget;
    if (gaussian) child = backdropFilter(child);
    if (addMaterial) {
      child = Material(
          color: Colors.transparent,
          child: MediaQuery(
              data: MediaQueryData.fromWindow(window), child: child));
    }
    if (ignoring) child = IgnorePointer(child: child);
    if (onWillPop != null) WillPopScope(child: child, onWillPop: onWillPop);
    return child;
  }

  Widget backdropFilter(Widget child) => BackdropFilter(
      filter:
          filter ?? ImageFilter.blur(sigmaX: fuzzyDegree, sigmaY: fuzzyDegree),
      child: child);

  Widget get childWidget => Universal(
      color: color,
      onTap: onTap,
      behavior: behavior,
      alignment: alignment,
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: child,
      direction: direction,
      isScroll: isScroll,
      isStack: isStack,
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children);
}

class PopupSureCancel extends StatelessWidget {
  const PopupSureCancel({
    Key? key,
    this.backgroundColor,
    this.barrierColor,
    this.width = 300,
    this.height,
    required this.content,
    this.padding,
    this.sure,
    this.cancel,
    this.backsideTap,
    this.alignment = Alignment.center,
    this.decoration,
    this.gaussian = false,
    this.addMaterial = false,
  }) : super(key: key);

  final Widget content;

  /// 弹框背景色
  final Color? backgroundColor;

  /// 弹框底部 背景色
  final Color? barrierColor;

  /// 弹框
  final EdgeInsetsGeometry? padding;

  /// 确定按钮
  final Widget? sure;

  /// 取消按钮
  final Widget? cancel;

  /// 背景点击事件
  final GestureTapCallback? backsideTap;
  final double width;
  final double? height;
  final Decoration? decoration;

  /// 弹窗位置
  final AlignmentGeometry alignment;

  /// 背景是否模糊
  final bool gaussian;

  /// 是否添加Material Widget 部分组件需要基于Material
  final bool addMaterial;

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = <Widget>[];
    widgets.add(content);
    if (cancel != null && sure != null) widgets.add(sureCancel());
    return PopupOptions(
        addMaterial: addMaterial,
        gaussian: gaussian,
        onTap: backsideTap,
        color: barrierColor,
        alignment: alignment,
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

  Widget sureCancel() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
        Expanded(child: cancel!),
        Expanded(child: sure!),
      ]);
}

enum LoadingType {
  ///  圆圈
  circular,

  ///  横条
  linear,

  ///  不常用 下拉刷新圆圈
  refresh,
}

class Loading extends StatelessWidget {
  const Loading({
    Key? key,
    this.text = '加载中...',
    this.strokeWidth = 4.0,
    this.loadingType = LoadingType.circular,
    this.textStyle,
    this.custom,
    this.ignoring = false,
    this.gaussian = false,
    this.value,
    this.valueColor,
    this.semanticsLabel,
    this.semanticsValue,
    this.onTap,
    this.behavior,
    this.fuzzyDegree = 4,
    this.backgroundColor,
  }) : super(key: key);

  final double? value;
  final Animation<Color>? valueColor;
  final String? semanticsLabel;
  final String? semanticsValue;
  final TextStyle? textStyle;
  final Widget? custom;
  final LoadingType loadingType;
  final Color? backgroundColor;
  final double strokeWidth;
  final String text;

  /// 模糊程度 0-100
  final double fuzzyDegree;

  /// 是否开始背景模糊
  final bool gaussian;

  /// 是否可以操作背景 默认false 不可操作
  final bool ignoring;

  /// 背景事件
  final GestureTapCallback? onTap;
  final HitTestBehavior? behavior;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    switch (loadingType) {
      case LoadingType.circular:
        children.add(CircularProgressIndicator(
            value: value,
            backgroundColor: backgroundColor,
            valueColor: valueColor,
            strokeWidth: strokeWidth,
            semanticsLabel: semanticsLabel,
            semanticsValue: semanticsValue));
        break;
      case LoadingType.linear:
        children.add(LinearProgressIndicator(
            value: value,
            backgroundColor: backgroundColor,
            valueColor: valueColor,
            semanticsLabel: semanticsLabel,
            semanticsValue: semanticsValue));
        break;
      case LoadingType.refresh:
        children.add(RefreshProgressIndicator(
            value: value,
            backgroundColor: backgroundColor,
            valueColor: valueColor,
            strokeWidth: strokeWidth,
            semanticsLabel: semanticsLabel,
            semanticsValue: semanticsValue));
        break;
    }
    children.add(Container(
        margin: const EdgeInsets.only(top: 16),
        child: BText(text, style: textStyle)));
    return PopupOptions(
        ignoring: ignoring,
        gaussian: gaussian,
        fuzzyDegree: fuzzyDegree,
        alignment: Alignment.center,
        onTap: onTap,
        child: custom ??
            Universal(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8.0)),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: children));
  }
}
