import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/waya.dart';

class AlertBase extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final GestureTapCallback onTap;
  final Color backgroundColor;
  final AlertPosition position;

  const AlertBase({Key key, this.child, this.padding, this.onTap, this.backgroundColor, this.position})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFlex(
        color: backgroundColor ?? getColors(black70),
        height: BaseUtils.getHeight(),
        width: BaseUtils.getWidth(),
        onTap: onTap,
        padding: padding,
        mainAxisAlignment: mainAxisAlignment(),
        crossAxisAlignment: crossAxisAlignment(),
        children: <Widget>[
          child,
        ]);
  }

  CrossAxisAlignment crossAxisAlignment() {
    if (position == AlertPosition.topLeft ||
        position == AlertPosition.centerLeft ||
        position == AlertPosition.bottomLeft) {
      return CrossAxisAlignment.start;
    } else if (position == AlertPosition.topRight ||
        position == AlertPosition.centerRight ||
        position == AlertPosition.bottomRight) {
      return CrossAxisAlignment.end;
    } else {
      return CrossAxisAlignment.center;
    }
  }

  MainAxisAlignment mainAxisAlignment() {
    if (position == AlertPosition.top || position == AlertPosition.topLeft || position == AlertPosition.topRight) {
      return MainAxisAlignment.start;
    } else if (position == AlertPosition.bottom ||
        position == AlertPosition.bottomLeft ||
        position == AlertPosition.bottomRight) {
      return MainAxisAlignment.end;
    } else {
      return MainAxisAlignment.center;
    }
  }
}
