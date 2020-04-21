import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/src/common/CommonWidget.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/tools/Tools.dart';
import 'package:flutter_waya/src/widget/custom/CustomButton.dart';

class CountDownSkip extends StatefulWidget {
  final String skipText;
  final int seconds;
  final TextStyle textStyle;
  final ValueChanged<int> onChange;
  final GestureTapCallback onTap;
  final Decoration decoration;

  CountDownSkip({
    Key key,
    String skipText,
    int seconds,
    this.textStyle,
    this.onChange,
    this.onTap,
    this.decoration,
  })
      : this.skipText = skipText ?? '',
        this.seconds = seconds ?? 5,
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CountDownSkipState();
  }
}

class CountDownSkipState extends State<CountDownSkip> {
  int seconds = 5;
  Timer timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      seconds = widget.seconds;
      startTime();
    });
  }

  startTime() {
    if (seconds > 0) {
      timer = Tools.timerPeriodic(Duration(seconds: 1), (time) {
        seconds -= 1;
        setState(() {});
        if (widget.onChange is ValueChanged<int>) {
          widget.onChange(seconds);
        }
        if (seconds == 0) timer.cancel();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: widget.onTap,
      decoration: widget.decoration ?? BoxDecoration(color: getColors(white50), borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.symmetric(horizontal: Tools.getHeight(5), vertical: Tools.getWidth(4)),
      child: CommonWidget.textSmall(seconds.toString() + 's' + widget.skipText),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Tools.timerCancel();
  }
}
