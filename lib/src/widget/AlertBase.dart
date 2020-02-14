import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class AlertBase extends StatelessWidget {
  final Widget child;
  EdgeInsetsGeometry padding;
  final GestureTapCallback onTap;

  AlertBase({this.child, this.padding, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomFlex(
        color: Colors.transparent,
        height: BaseUtils.getHeight(),
        width: BaseUtils.getWidth(),
        onTap: onTap,
        child: Center(
          child: child,
        ));
  }
}
