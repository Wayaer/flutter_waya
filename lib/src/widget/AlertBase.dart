import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class AlertBase extends StatelessWidget {
  final Widget child;
  EdgeInsetsGeometry padding;
  final GestureTapCallback onTap;

  AlertBase({this.child, this.padding, this.onTap});

//  {
//    if (padding == null) padding = EdgeInsets.symmetric(horizontal: BaseUtils.getWidth(40),
//        vertical: BaseUtils.getHeight() / 2.5);
//  }

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: CustomFlex(
            color: Colors.transparent,
            height: BaseUtils.getHeight(),
            width: BaseUtils.getWidth(),
            onTap: onTap ?? () {
              BaseNavigatorUtils.getInstance().pop();
            },
            child: Center(child: child,)));
  }
}
