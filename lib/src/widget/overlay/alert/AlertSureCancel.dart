import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayStyles.dart';

class AlertSureCancel extends StatelessWidget {
  final List<Widget> children;
  final GestureTapCallback sureTap;
  final GestureTapCallback cancelTap;
  final String cancelText;
  final String sureText;
  final Color backgroundColor;
  final Color backsideColor;
  final TextStyle cancelTextStyle;
  final TextStyle sureTextStyle;
  final EdgeInsetsGeometry padding;
  final Widget sure;
  final Widget cancel;
  final GestureTapCallback backsideTap;
  final double width;
  final double height;
  final Decoration decoration;
  final AlignmentGeometry alignment;
  final bool animatedOpacity;
  final bool gaussian;
  final bool addMaterial;
  final PopupMode popupMode;

  AlertSureCancel({
    Key key,
    String cancelText,
    String sureText,
    Color backgroundColor,
    Color backsideColor,
    TextStyle cancelTextStyle,
    TextStyle sureTextStyle,
    double width,
    double height,
    this.children,
    this.sureTap,
    this.padding,
    this.cancelTap,
    this.sure,
    this.cancel,
    this.backsideTap,
    this.alignment,
    this.decoration,
    this.animatedOpacity,
    this.gaussian,
    this.addMaterial,
    this.popupMode,
  })  : this.cancelText = cancelText ?? 'cancel',
        this.sureText = sureText ?? 'sure',
        this.backgroundColor = backgroundColor ?? getColors(white),
        this.backsideColor = backsideColor ?? getColors(black50),
        this.width = width ?? Tools.getWidth() * 0.85,
        this.height = height,
        this.sureTextStyle = sureTextStyle ?? WayStyles.textStyleBlack30(),
        this.cancelTextStyle = cancelTextStyle ?? WayStyles.textStyleBlack30(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    widgets.addAll(children);
    widgets.add(sureCancel());
    return AlertBase(
        popupMode: popupMode,
        addMaterial: addMaterial,
        gaussian: gaussian,
        onTap: backsideTap,
        color: backsideColor,
        alignment: alignment,
        child: Universal(
          width: width,
          height: height,
          decoration: decoration ?? BoxDecoration(color: backgroundColor),
          padding: padding,
          mainAxisSize: MainAxisSize.min,
          children: widgets,
        ));
  }

  Widget sureCancel() {
    return Universal(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        SimpleButton(
            padding: EdgeInsets.symmetric(
                horizontal: Tools.getWidth(20), vertical: Tools.getHeight(5)),
            onTap: cancelTap,
            child: cancel,
            text: cancelText,
            textStyle: cancelTextStyle),
        SimpleButton(
            onTap: sureTap,
            padding: EdgeInsets.symmetric(
                horizontal: Tools.getWidth(20), vertical: Tools.getHeight(5)),
            text: sureText,
            child: sure,
            textStyle: sureTextStyle),
      ],
    );
  }
}
