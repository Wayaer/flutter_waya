import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class PopupBase extends StatefulWidget {
  const PopupBase(
      {Key key,
      this.child,
      this.onTap,
      double fuzzyDegree,
      bool gaussian,
      bool ignoring,
      bool animationOpacity,
      this.color,
      bool addMaterial,
      bool handleTouch,
      bool animation,
      PopupMode popupMode,
      double left,
      double top,
      double right,
      double bottom,
      AlignmentGeometry alignment,
      this.behavior})
      : top = top ?? 0,
        left = left ?? 0,
        right = right ?? 0,
        bottom = bottom ?? 0,
        alignment = alignment ?? Alignment.center,
        gaussian = gaussian ?? false,
        addMaterial = addMaterial ?? false,
        handleTouch = handleTouch ?? true,
        popupMode = popupMode ?? PopupMode.center,
        animation = animation ?? true,
        ignoring = ignoring ?? false,
        animationOpacity = animationOpacity ?? false,
        fuzzyDegree = fuzzyDegree ?? 2,
        super(key: key);

  final Widget child;
  final GestureTapCallback onTap;
  final HitTestBehavior behavior;
  final Color color;
  final bool handleTouch;

  final bool addMaterial;

  ///是否开启动画
  final bool animation;
  final bool animationOpacity;
  final PopupMode popupMode;

  ///是否开始背景模糊
  final bool gaussian;

  ///模糊程度
  final double fuzzyDegree;

  final double left;
  final double top;
  final double right;
  final double bottom;
  final AlignmentGeometry alignment;

  ///是否可以操作背景
  final bool ignoring;

  @override
  _PopupBaseState createState() => _PopupBaseState();
}

class _PopupBaseState extends State<PopupBase> {
  Color backgroundColor = getColors(transparent);
  double opacity = 0;
  double popupDistance = -getHeight(0);
  double fuzzyDegree = 0;
  PopupMode popupMode;
  bool animation;

  @override
  void initState() {
    super.initState();
    animation = widget.animation;
    if (animation) {
      popupMode = widget.popupMode;
      switch (popupMode) {
        case PopupMode.left:
          popupDistance = -getWidth(0);
          break;
        case PopupMode.top:
          popupDistance = -getHeight(0);
          //头部弹出
          break;
        case PopupMode.right:
          popupDistance = -getWidth(0);
          //右边弹出
          break;
        case PopupMode.bottom:
          popupDistance = -getHeight(0);
          //底部弹出
          break;
        default: //PopupMode.center
          popupDistance = 0;
          //中间渐变
          break;
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((Duration callback) {
      if (animation) {
        opacity = 1;
        popupDistance = 0;
        if (widget.gaussian) fuzzyDegree = widget.fuzzyDegree;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = childWidget();
    if (widget.gaussian) child = backdropFilter(child);
    if (animation) {
      if (popupMode == PopupMode.center) {
        if (widget.animationOpacity) child = animationOpacity(child);
      } else {
        child = animationOpacity(child);
      }
    }
    if (widget.addMaterial)
      child = Material(
          color: getColors(transparent), child: MediaQuery(data: MediaQueryData.fromWindow(window), child: child));

    if (!widget.handleTouch) child = IgnorePointer(ignoring: widget.handleTouch, child: child);
    if (widget.ignoring) child = IgnorePointer(child: child);
    return child;
  }

  Widget animationOpacity(Widget child) => AnimatedPositioned(
      left: popupMode == PopupMode.left ? popupDistance : 0,
      top: popupMode == PopupMode.top ? popupDistance : 0,
      right: popupMode == PopupMode.right ? popupDistance : 0,
      bottom: popupMode == PopupMode.bottom ? popupDistance : 0,
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 200),
      child: child);

  Widget backdropFilter(Widget child) =>
      BackdropFilter(filter: ImageFilter.blur(sigmaX: fuzzyDegree, sigmaY: fuzzyDegree), child: child);

  Widget animatedOpacity(Widget child) => AnimatedOpacity(
      opacity: opacity, curve: Curves.slowMiddle, duration: const Duration(milliseconds: 200), child: child);

  Widget childWidget() => Universal(
      color: widget.color,
      onTap: widget.onTap,
      behavior: widget.behavior,
      alignment: widget.alignment,
      padding: EdgeInsets.fromLTRB(widget.left, widget.top, widget.right, widget.bottom),
      child: widget.child);
}
