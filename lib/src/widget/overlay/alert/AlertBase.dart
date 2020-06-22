import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/colors.dart';

class AlertBase extends StatefulWidget {
  final Widget child;
  final GestureTapCallback onTap;
  final Color color;

  final bool addMaterial;

  ///是否开启动画
  final bool animation;
  final bool animationOpacity;
  final PopupMode popupMode;

  ///是否开始背景模糊
  final bool gaussian;

  ///模糊程度
  final double fuzzyDegree;

  ///Positioned
  final double left;
  final double top;
  final double right;
  final double bottom;

  ///Align
  final AlignmentGeometry alignment;

  const AlertBase(
      {Key key,
      this.child,
      this.onTap,
      int fuzzyDegree,
      bool gaussian,
      bool animationOpacity,
      this.color,
      bool addMaterial,
      bool animation,
      PopupMode popupMode,
      this.left,
      this.top,
      this.right,
      this.bottom,
      this.alignment})
      : this.gaussian = gaussian ?? false,
        this.addMaterial = addMaterial ?? false,
        this.popupMode = popupMode ?? PopupMode.center,
        this.animation = animation ?? true,
        this.animationOpacity = animationOpacity ?? false,
        this.fuzzyDegree = fuzzyDegree ?? 2,
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AlertBaseState();
  }
}

class AlertBaseState extends State<AlertBase> {
  Color backgroundColor = getColors(transparent);
  double opacity = 0;
  double popupDistance = -Tools.getHeight();
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
          popupDistance = -Tools.getWidth();
          break;
        case PopupMode.top:
          popupDistance = -Tools.getHeight();
          //头部弹出
          break;
        case PopupMode.right:
          popupDistance = -Tools.getWidth();
          //右边弹出
          break;
        case PopupMode.bottom:
          popupDistance = -Tools.getHeight();
          //底部弹出
          break;
        default: //PopupMode.center
          popupDistance = 0;
          //中间渐变
          break;
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      if (animation) {
        setState(() {
          opacity = 1;
          popupDistance = 0;
          if (widget.gaussian) fuzzyDegree = widget.fuzzyDegree;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = childWidget();
    if (widget.gaussian) {
      child = backdropFilter(child);
    }
    if (animation) {
      if (popupMode == PopupMode.center) {
        if (widget.animationOpacity) child = animationOpacity(child);
      } else {
        child = animationOpacity(child);
      }
    }
    if (widget.addMaterial) {
      child = Material(
          color: getColors(transparent),
          child: MediaQuery(
              data: MediaQueryData.fromWindow(window), child: child));
    }
    return child;
  }

  Widget animationOpacity(Widget child) {
    return AnimatedPositioned(
      left: popupMode == PopupMode.left ? popupDistance : 0,
      top: popupMode == PopupMode.top ? popupDistance : 0,
      right: popupMode == PopupMode.right ? popupDistance : 0,
      bottom: popupMode == PopupMode.bottom ? popupDistance : 0,
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 200),
      child: child,
    );
  }

  Widget backdropFilter(Widget child) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: fuzzyDegree, sigmaY: fuzzyDegree),
      child: child,
    );
  }

  Widget animatedOpacity(Widget child) {
    return AnimatedOpacity(
      opacity: opacity,
      curve: Curves.slowMiddle,
      duration: Duration(milliseconds: 200),
      child: child,
    );
  }

  Widget childWidget() {
    Widget child = widget.child;
    if (widget.alignment != null)
      child = Align(alignment: widget.alignment, child: child);
    if (widget.top != null ||
        widget.left != null ||
        widget.right != null ||
        widget.bottom != null)
      child = Positioned(
          left: widget.left,
          top: widget.top,
          right: widget.right,
          bottom: widget.bottom,
          child: child);
    if (widget.top == null &&
        widget.left == null &&
        widget.right == null &&
        widget.bottom == null &&
        widget.alignment == null) {
      child = Align(alignment: Alignment.center, child: child);
    }
    return Universal(
      color: widget.color,
      onTap: widget.onTap,
      isStack: true,
      children: <Widget>[child],
    );
  }
}
