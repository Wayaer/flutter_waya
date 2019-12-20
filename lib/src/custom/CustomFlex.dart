import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomFlex extends StatelessWidget {
  //自定义横向竖向布局 加入了点击事件
  //公用 点击时间
  final bool inkWell;
  final GestureTapCallback onTap;
  final GestureTapCallback onDoubleTap;
  final GestureLongPressCallback onLongPress;

  //横竖 布局 List<Widget>   children
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Axis direction; //布局横竖
  final MainAxisSize mainAxisSize;

  final TextDirection textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline textBaseline;

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
  final bool isScroll;

  //  HitTestBehavior.opaque 自己处理事件 
  //  HitTestBehavior.deferToChild child处理事件
  //  HitTestBehavior.translucent 自己和child都可以接收事件
  final HitTestBehavior behavior;

  CustomFlex({
    Key key,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.isScroll: false,
    this.children,
    this.mainAxisAlignment: MainAxisAlignment.start,
    this.crossAxisAlignment: CrossAxisAlignment.center,
    this.mainAxisSize,
    this.textDirection,
    this.textBaseline,
    this.verticalDirection: VerticalDirection.down,
    this.direction: Axis.vertical,
    this.inkWell: false,
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
    this.behavior: HitTestBehavior.opaque,
  }) : super(key: key);
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
