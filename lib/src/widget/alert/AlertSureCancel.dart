import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/widget/alert/AlertBase.dart';
import 'package:flutter_waya/waya.dart';

class AlertSureCancel extends StatelessWidget {
  final Widget showWidget;
  final GestureTapCallback sureTap;
  final GestureTapCallback cancelTap;
  final String cancelText;
  final String sureText;
  final Color backgroundColor;
  final TextStyle cancelTextStyle;
  final TextStyle sureTextStyle;
  final EdgeInsetsGeometry padding;
  final Widget sure;
  final Widget cancel;
  final GestureTapCallback backsideTap;
  final double width;
  final double height;
  final AlertPosition position;
  final EdgeInsetsGeometry margin;
  final Decoration decoration;

  AlertSureCancel({
    Key key,
    String cancelText,
    String sureText,
    Color backgroundColor,
    TextStyle cancelTextStyle,
    TextStyle sureTextStyle,
    EdgeInsetsGeometry padding,
    double width,
    double height,
    EdgeInsetsGeometry margin,
    this.showWidget,
    this.sureTap,
    this.cancelTap,
    this.sure,
    this.cancel,
    this.backsideTap, this.position, this.decoration,
  })
      : this.cancelText = cancelText ?? 'cancle',
        this.sureText = sureText ?? 'sure',
        this.margin = margin ?? EdgeInsets.symmetric(horizontal: Tools.getWidth(40)),
        this.backgroundColor = backgroundColor ?? getColors(white),
        this.width = width ?? Tools.getWidth() - Tools.getWidth(40),
        this.height = height ?? Tools.getHeight(200),
        this.padding = padding ?? EdgeInsets.symmetric(vertical: Tools.getHeight(10)),
        this.sureTextStyle = sureTextStyle ??
            TextStyle(
                decoration: TextDecoration.none, fontSize: 13, fontWeight: FontWeight.w500, color: getColors(blue)),
        this.cancelTextStyle = cancelTextStyle ??
            TextStyle(
                decoration: TextDecoration.none, fontSize: 13, fontWeight: FontWeight.w500, color: getColors(black30)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertBase(
        onTap: backsideTap,
        position: position,
        child: CustomFlex(
          width: width,
          height: height,
          mainAxisAlignment: MainAxisAlignment.end,
          decoration: decoration ?? BoxDecoration(color: backgroundColor),
          margin: margin,
          padding: padding,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(child: showWidget),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CustomButton(
                    padding: EdgeInsets.symmetric(horizontal: Tools.getWidth(20), vertical: Tools.getHeight(5)),
                    onTap: cancelTap ??
                            () {
                          NavigatorTools.getInstance().pop();
                        },
                    child: cancel,
                    text: cancelText,
                    textStyle: cancelTextStyle),
                CustomButton(
                    onTap: sureTap ??
                            () {
                          NavigatorTools.getInstance().pop();
                        },
                    padding: EdgeInsets.symmetric(horizontal: Tools.getWidth(20), vertical: Tools.getHeight(5)),
                    text: sureText,
                    child: sure,
                    textStyle: sureTextStyle),
              ],
            )
          ],
        ));
  }
}
