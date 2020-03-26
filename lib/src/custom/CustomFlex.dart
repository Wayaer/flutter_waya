import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomFlex extends StatelessWidget {
  //自定义横向竖向布局 加入了点击事件
  //公用 点击时间
  bool inkWell;
  final GestureTapCallback onTap;
  final GestureTapCallback onDoubleTap;
  final GestureLongPressCallback onLongPress;

  //横竖 布局 List<Widget>   children
  final List<Widget> children;
  final MainAxisSize mainAxisSize;
  final TextDirection textDirection;
  final TextBaseline textBaseline;
  MainAxisAlignment mainAxisAlignment;
  CrossAxisAlignment crossAxisAlignment;
  Axis direction; //布局横竖
  VerticalDirection verticalDirection;

  //容器 布局
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double height;
  final double width;
  final Color color;
  final AlignmentGeometry alignment;
  final Decoration decoration;
  final BoxConstraints constraints;
  final Matrix4 transform;
  bool isScroll;

  //  HitTestBehavior.opaque 自己处理事件 
  //  HitTestBehavior.deferToChild child处理事件
  //  HitTestBehavior.translucent 自己和child都可以接收事件
  HitTestBehavior behavior;

  CustomFlex({
    Key key,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.isScroll,
    this.children,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.mainAxisSize,
    this.textDirection,
    this.textBaseline,
    this.verticalDirection,
    this.direction,
    this.inkWell,
    this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.alignment,
    this.decoration,
    this.constraints,
    this.transform,
    this.behavior,
  }) : super(key: key) {
    if (isScroll == null) isScroll = false;
    if (mainAxisAlignment == null) mainAxisAlignment = MainAxisAlignment.start;
    if (crossAxisAlignment == null) crossAxisAlignment = CrossAxisAlignment.center;
    if (verticalDirection == null) verticalDirection = VerticalDirection.down;
    if (direction == null) direction = Axis.vertical;
    if (inkWell == null) inkWell = false;
    if (behavior == null) behavior = HitTestBehavior.opaque;
  }

  List<Widget> list;

  @override
  Widget build(BuildContext context) {
    return onTap != null || onLongPress != null
        ? (inkWell
        ? Material(
        color: Colors.transparent,
        child: Ink(
            child: InkWell(
              onTap: onTap,
              onLongPress: onLongPress,
              onDoubleTap: onDoubleTap,
              child: childBody(),
            )))
        : GestureDetector(
      behavior: behavior,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: childBody(),
    ))
        : childBody();
  }

  Widget childBody() {
    if (children != null && children.length > 0) {
      return padding != null ||
          margin != null ||
          height != null ||
          width != null ||
          color != null ||
          decoration != null
          ? containerWidget(singleChildScrollView())
          : singleChildScrollView();
    } else {
      return containerWidget(child);
    }
  }

  Widget containerWidget(Widget childWidget) {
    return Container(
        transform: transform,
        constraints: constraints,
        alignment: alignment,
        color: color,
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        decoration: decoration,
        child: childWidget);
  }

  Widget singleChildScrollView() {
    return isScroll
        ? Expanded(
        child: SingleChildScrollView(
          child: flex(),
        ))
        : flex();
  }

  Widget flex() {
    return Flex(
      children: children,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      direction: direction,
      textBaseline: textBaseline,
      verticalDirection: verticalDirection,
      textDirection: textDirection,
      mainAxisSize: mainAxisSize ?? MainAxisSize.max,
    );
  }
}
