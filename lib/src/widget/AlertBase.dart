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
                horizontal: BaseUtils.getWidth(40),
                vertical: BaseUtils.getHeight() / 2.5),
        height: BaseUtils.getHeight(),
        onTap: () {
          BaseNavigatorUtils.getInstance().pop();
        },
        child: child);
  }
}
