import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayStyles.dart';

class AlertSureCancel extends StatelessWidget {
  final Widget content;
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
  final EdgeInsetsGeometry margin;
  final Decoration decoration;
  final AlignmentGeometry alignment;
  final bool animatedOpacity;
  final bool gaussian;

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
    this.content,
    this.sureTap,
    this.cancelTap,
    this.sure,
    this.cancel,
    this.backsideTap, this.alignment, this.decoration,
    this.animatedOpacity, this.gaussian,
  })
      : this.cancelText = cancelText ?? 'cancle',
        this.sureText = sureText ?? 'sure',
        this.margin = margin ??
            EdgeInsets.symmetric(horizontal: Tools.getWidth(40)),
        this.backgroundColor = backgroundColor ?? getColors(white),
        this.width = width ?? Tools.getWidth() - Tools.getWidth(40),
        this.height = height ?? Tools.getHeight(200),
        this.padding = padding ??
            EdgeInsets.symmetric(vertical: Tools.getHeight(10)),
        this.sureTextStyle = sureTextStyle ?? WayStyles.textStyleBlack30(),
        this.cancelTextStyle = cancelTextStyle ?? WayStyles.textStyleBlack30(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertBase(
        gaussian: gaussian,
        onTap: backsideTap,
        alignment: alignment,
        child: CustomFlex(
          width: width,
          height: height,
          mainAxisAlignment: MainAxisAlignment.end,
          decoration: decoration ?? BoxDecoration(color: backgroundColor),
          margin: margin,
          padding: padding,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(child: content),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CustomButton(
                    padding: EdgeInsets.symmetric(
                        horizontal: Tools.getWidth(20),
                        vertical: Tools.getHeight(5)),
                    onTap: cancelTap,
                    child: cancel,
                    text: cancelText,
                    textStyle: cancelTextStyle),
                CustomButton(
                    onTap: sureTap,
                    padding: EdgeInsets.symmetric(
                        horizontal: Tools.getWidth(20),
                        vertical: Tools.getHeight(5)),
                    text: sureText,
                    child: sure,
                    textStyle: sureTextStyle),
              ],
            )
          ],
        ));
  }
}
