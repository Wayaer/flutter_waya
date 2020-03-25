import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/waya.dart';

class AlertBase extends StatelessWidget {
  final Widget child;
  EdgeInsetsGeometry padding;
  final GestureTapCallback onTap;
  final Color backgroundColor;
  AlertPosition position;
  MainAxisAlignment mainAxisAlignment;
  CrossAxisAlignment crossAxisAlignment;

  AlertBase({this.child, this.padding, this.onTap, this.backgroundColor, this.position}) {
    switch (position) {
      case AlertPosition.top:
        mainAxisAlignment = MainAxisAlignment.start;
        crossAxisAlignment = CrossAxisAlignment.center;
        break;
      case AlertPosition.topLeft:
        mainAxisAlignment = MainAxisAlignment.start;
        crossAxisAlignment = CrossAxisAlignment.start;
        break;
      case AlertPosition.topRight:
        mainAxisAlignment = MainAxisAlignment.start;
        crossAxisAlignment = CrossAxisAlignment.end;
        break;
      case AlertPosition.center:
        mainAxisAlignment = MainAxisAlignment.center;
        crossAxisAlignment = CrossAxisAlignment.center;
        break;
      case AlertPosition.centerLeft:
        mainAxisAlignment = MainAxisAlignment.center;
        crossAxisAlignment = CrossAxisAlignment.start;
        break;
      case AlertPosition.centerRight:
        mainAxisAlignment = MainAxisAlignment.center;
        crossAxisAlignment = CrossAxisAlignment.end;
        break;
      case AlertPosition.bottom:
        mainAxisAlignment = MainAxisAlignment.end;
        crossAxisAlignment = CrossAxisAlignment.center;
        break;
      case AlertPosition.bottomLeft:
        mainAxisAlignment = MainAxisAlignment.end;
        crossAxisAlignment = CrossAxisAlignment.start;
        break;
      case AlertPosition.bottomRight:
        mainAxisAlignment = MainAxisAlignment.end;
        crossAxisAlignment = CrossAxisAlignment.end;
        break;
      default:
        mainAxisAlignment = MainAxisAlignment.center;
        crossAxisAlignment = CrossAxisAlignment.center;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomFlex(
        color: backgroundColor ?? getColors(black70),
        height: BaseUtils.getHeight(),
        width: BaseUtils.getWidth(),
        onTap: onTap,
        padding: padding,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: <Widget>[
          child,
        ]);
  }
}
