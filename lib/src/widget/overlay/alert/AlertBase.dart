import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';

class AlertBase extends StatefulWidget {
  final Widget child;
  final GestureTapCallback onTap;
  final Color color;
  final AlignmentGeometry alignment;
  final bool addMaterial;

  ///是否开启动画
  final bool animated;

  ///是否开始背景模糊
  final bool gaussian;
  final bool animatedOpacity;

  ///模糊程度
  final double fuzzyDegree;

  const AlertBase(
      {Key key,
      this.child,
      this.onTap,
      AlignmentGeometry alignment,
      int fuzzyDegree,
      bool gaussian,
      bool animatedOpacity,
      this.color,
      bool addMaterial,
      bool animated})
      : this.gaussian = gaussian ?? false,
        this.addMaterial = addMaterial ?? false,
        this.alignment = alignment ?? Alignment.center,
        this.animated = animated ?? true,
        this.animatedOpacity = animatedOpacity ?? false,
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

  int index;
  bool animated;

  @override
  void initState() {
    super.initState();
    animated = widget.animated ?? true;
    if (animated) {
      AlignmentGeometry alignment = widget.alignment;
      if (alignment == Alignment.centerLeft ||
          alignment == Alignment.topLeft ||
          alignment == Alignment.bottomLeft) {
        popupDistance = -Tools.getWidth();
        //左边推出
        index = 0;
      } else if (alignment == Alignment.centerRight ||
          alignment == Alignment.topRight ||
          alignment == Alignment.bottomRight) {
        popupDistance = -Tools.getWidth();
        //右边弹出
        index = 2;
      } else if (alignment == Alignment.topCenter) {
        popupDistance = -Tools.getHeight();
        //头部弹出
        index = 1;
      } else if (alignment == Alignment.bottomCenter) {
        popupDistance = -Tools.getHeight();
        //底部弹出
        index = 3;
      } else {
        //其他或中间渐变
        index = 5;
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      if (animated) {
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
    if (animated) {
      if (index == 5) {
        if (widget.animatedOpacity) child = animatedOpacity(child);
      } else {
        child = animatedPositioned(child);
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

  Widget animatedPositioned(Widget child) {
    return AnimatedPositioned(
      left: index == 0 ? popupDistance : 0,
      top: index == 1 ? popupDistance : 0,
      right: index == 2 ? popupDistance : 0,
      bottom: index == 3 ? popupDistance : 0,
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
    Widget align = Align(alignment: widget.alignment, child: widget.child);
    if (widget.color == null && widget.onTap == null) {
      return Universal(
        isStack: true,
        children: <Widget>[align],
      );
    }
    return Universal(
      color: widget.color,
      isStack: true,
      onTap: widget.onTap,
      child: align,
    );
  }
}
