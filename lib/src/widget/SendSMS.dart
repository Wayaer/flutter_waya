import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayStyles.dart';
import 'package:flutter_waya/src/custom/CustomFlex.dart';
import 'package:flutter_waya/src/utils/WayUtils.dart';


class SendSMS extends StatefulWidget {
  final Function onTap;

  const SendSMS({Key key, this.onTap}) : super(key: key);

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
        verifyStr = '获取验证码';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomFlex(
      onTap: (seconds == 0 && widget.onTap != null) ? onTap : null,
      alignment: Alignment.center,
      width: WayUtils.getWidth(86),
      height: WayUtils.getHeight(25),
      decoration: BoxDecoration(
          border: Border.all(
              width: 1.0,
              color: getColors(seconds == 0 ? textBlue : textBlack70)),
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        '$verifyStr',
        style: seconds == 0
            ? WayStyles.textStyleBlue(context, fontSize: 13)
            : WayStyles.textStyleBlack70(context, fontSize: 13),
      ),
    );
  }

  onTap() {
    setState(() {
      verifyStr = '发送中';
    });
    widget.onTap(begin);
  }

  begin(bool isBegin) {
    if (isBegin) {
      setState(() {
        startTimer();
      });
    } else {
      setState(() {
        verifyStr = '已发送';
      });
    }
  }

  startTimer() {
    seconds = 60;

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds == 0) {
        cancelTimer();
        return;
      }
      seconds--;
      verifyStr = '${seconds}s';
      setState(() {});
      if (seconds == 0) {
        verifyStr = '已发送';
      }
    });
  }

  cancelTimer() {
    timer?.cancel();
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }
}
