import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/colors.dart';
import 'package:flutter_waya/src/constant/styles.dart';
import 'package:flutter_waya/src/tools/Tools.dart';
import 'package:flutter_waya/src/widget/custom/Universal.dart';

class SendSMS extends StatefulWidget {
  final Function onTap;
  final Decoration decoration;
  final BorderRadiusGeometry borderRadius;
  final double borderWidth;
  final double width;
  final double height;
  final String defaultText;
  final String sendingText;
  final String sentText;
  final String notTapText;
  final Color defaultBorderColor;
  final Color notTapBorderColor;
  final Color background;
  final TextStyle defaultTextStyle;
  final TextStyle notTapTextStyle;
  final int seconds;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  SendSMS(
      {Key key,
      this.onTap,
      this.decoration,
      this.borderRadius,
      this.borderWidth,
      this.defaultBorderColor,
      this.notTapBorderColor,
      this.width,
      this.height,
      this.defaultText,
      this.sendingText,
      this.sentText,
      this.notTapText,
      this.defaultTextStyle,
      this.notTapTextStyle,
      this.background,
      this.seconds,
      this.margin,
      this.padding})
      : super(key: key);

  @override
  SendSMSState createState() => SendSMSState();
}

class SendSMSState extends State<SendSMS> {
  int seconds = 0;
  String verifyStr;
  Timer timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      setState(() {
        verifyStr = widget.defaultText ?? '获取验证码';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Universal(
      margin: widget.margin,
      padding: widget.padding,
      onTap: (seconds == 0 && widget.onTap != null) ? onTap : null,
      alignment: Alignment.center,
      width: widget.width ?? Tools.getWidth(86),
      height: widget.height ?? Tools.getHeight(25),
      decoration: widget.decoration ??
          BoxDecoration(
              color: widget.background,
              border: !(widget.defaultBorderColor != null ||
                      widget.notTapBorderColor != null)
                  ? null
                  : Border.all(
                      width: widget.borderWidth ?? 0,
                      color: seconds == 0
                          ? (widget.defaultBorderColor ?? getColors(blue))
                          : (widget.notTapBorderColor ?? getColors(black70))),
              borderRadius: widget.borderRadius ?? BorderRadius.circular(20)),
      child: Text(
        '$verifyStr',
        style: seconds == 0
            ? widget.defaultTextStyle ?? WayStyles.textStyleBlue(fontSize: 13)
            : widget.notTapTextStyle ??
                WayStyles.textStyleBlack70(fontSize: 13),
      ),
    );
  }

  onTap() {
    setState(() {
      verifyStr = widget.sendingText ?? '发送中';
    });
    widget.onTap(send);
  }

  send(bool sending) {
    if (sending) {
      startTimer();
    } else {
      setState(() {
        verifyStr = widget.sentText ?? '重新发送';
      });
    }
  }

  startTimer() {
    seconds = widget.seconds ?? 60;
    timer = Timer.periodic(Duration(seconds: 1), (time) {
      if (seconds == 0) {
        timer.cancel();
        return;
      }
      seconds--;
      verifyStr = '${seconds}s';
      setState(() {});
      if (seconds == 0) {
        verifyStr = widget.sentText ?? '重新发送';
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) timer.cancel();
  }
}
