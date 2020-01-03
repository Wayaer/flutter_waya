import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/widget/AlertBase.dart';

class AlertSureCancel extends StatelessWidget {
  final Widget showWidget;
  final GestureTapCallback sureOnTap;
  final GestureTapCallback cancelOnTap;
  final String cancelText;
  final String sureText;
  final Widget sure;
  final Widget cancel;
  final Color backgroundColor;

  final TextStyle cancelTextStyle;
  final TextStyle sureTextStyle;
  final EdgeInsetsGeometry padding;

  AlertSureCancel({
    this.showWidget,
    this.sureOnTap,
    this.cancelOnTap,
    this.cancelText: 'cancle',
    this.sureText: 'sure',
    this.cancelTextStyle,
    this.sureTextStyle,
    this.sure,
    this.cancel,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AlertBase(
        child: CustomFlex(
          onTap: () {},
          mainAxisAlignment: MainAxisAlignment.end,
          color: backgroundColor ?? getColors(white),
          padding: padding ?? EdgeInsets.all(WayUtils.getWidth(20)),
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(child: showWidget),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CustomButton(
                  padding: EdgeInsets.symmetric(
                      horizontal: WayUtils.getWidth(20),
                      vertical: WayUtils.getHeight(5)),
                  onTap: cancelOnTap ??
                          () {
                        WayNavigatorUtils.getInstance().pop();
                      },
                  child: cancel,
                  text: cancelText,
                  textStyle: cancelTextStyle ??
                      TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: getColors(black30)),
                ),
                CustomButton(
                  onTap: sureOnTap ??
                          () {
                        WayNavigatorUtils.getInstance().pop();
                      },
                  padding: EdgeInsets.symmetric(
                      horizontal: WayUtils.getWidth(20),
                      vertical: WayUtils.getHeight(5)),
                  text: sureText,
                  child: sure,
                  textStyle: sureTextStyle ??
                      TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: getColors(blue)),
                ),
              ],
            )
          ],
        ));
  }
}
