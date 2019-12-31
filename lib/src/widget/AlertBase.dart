import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class AlertBase extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  AlertBase({this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return CustomFlex(
        color: Colors.transparent,
        padding: padding ??
            EdgeInsets.symmetric(
                horizontal: WayUtils.getWidth(40),
                vertical: WayUtils.getHeight() / 2.5),
        height: WayUtils.getHeight(),
        onTap: () {
          WayNavigatorUtils.getInstance().pop();
        },
        child: child);
  }
}
