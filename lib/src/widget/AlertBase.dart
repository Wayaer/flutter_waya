import 'package:flutter/material.dart';
import 'package:flutter_waya/waya.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';

class AlertBase extends StatelessWidget {
  final Widget child;
  EdgeInsetsGeometry padding;
  final GestureTapCallback onTap;
  final Color backgroundColor;
  final bool center;

  AlertBase({this.child, this.padding, this.onTap, this.backgroundColor, this.center: true});

  @override
  Widget build(BuildContext context) {
    return CustomFlex(
        color: backgroundColor ?? getColors(black70),
        height: BaseUtils.getHeight(),
        width: BaseUtils.getWidth(),
        onTap: onTap,
        child: center
            ? Center(
                child: child,
              )
            : child);
  }
}
