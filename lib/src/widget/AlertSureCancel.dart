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
  final GestureTapCallback backsideTap;

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
    this.backsideTap,
  }) {
    if (backgroundColor == null) getColors(white);
    if (padding == null) EdgeInsets.all(BaseUtils.getWidth(20));
    if (sureTextStyle == null)
      TextStyle(
          decoration: TextDecoration.none,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: getColors(blue));
    if (cancelTextStyle == null)
      TextStyle(
          decoration: TextDecoration.none,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: getColors(black30));
  }

  @override
  Widget build(BuildContext context) {
    return AlertBase(
        onTap: backsideTap,
        child: CustomFlex(
          onTap: () {},
          mainAxisAlignment: MainAxisAlignment.end,
          color: backgroundColor,
          padding: padding,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(child: showWidget),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CustomButton(
                    padding: EdgeInsets.symmetric(
                        horizontal: BaseUtils.getWidth(20),
                        vertical: BaseUtils.getHeight(5)),
                    onTap: cancelOnTap ??
                        () {
                          BaseNavigatorUtils.getInstance().pop();
                        },
                    child: cancel,
                    text: cancelText,
                    textStyle: cancelTextStyle),
                CustomButton(
                    onTap: sureOnTap ??
                        () {
                          BaseNavigatorUtils.getInstance().pop();
                        },
                    padding: EdgeInsets.symmetric(
                        horizontal: BaseUtils.getWidth(20),
                        vertical: BaseUtils.getHeight(5)),
                    text: sureText,
                    child: sure,
                    textStyle: sureTextStyle),
              ],
            )
          ],
        ));
  }
}
