import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayStyles.dart';
import 'package:flutter_waya/src/custom/CustomFlex.dart';
import 'package:flutter_waya/src/utils/BaseUtils.dart';

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
      this.seconds})
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
    return CustomFlex(
      onTap: (seconds == 0 && widget.onTap != null) ? onTap : null,
      alignment: Alignment.center,
      width: widget.width ?? BaseUtils.getWidth(86),
      height: widget.height ?? BaseUtils.getHeight(25),
      decoration: widget.decoration ??
          BoxDecoration(
              color: widget.background,
              border: Border.all(
                  width: widget.borderWidth ?? BaseUtils.getWidth(0),
                  color: seconds == 0
                      ? (widget.defaultBorderColor ?? getColors(blue))
                      : (widget.notTapBorderColor ?? getColors(black70))),
              borderRadius: widget.borderRadius ?? BorderRadius.circular(20)),
      child: Text(
        '$verifyStr',
        style: seconds == 0
            ? widget.defaultTextStyle ?? WayStyles.textStyleBlue(fontSize: 13)
            : widget.notTapTextStyle ?? WayStyles.textStyleBlack70(fontSize: 13),
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
