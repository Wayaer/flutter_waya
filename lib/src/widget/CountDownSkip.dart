import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/custom/CustomButton.dart';
import 'package:flutter_waya/src/utils/BaseUtils.dart';

class CountDownSkip extends StatefulWidget {
  String skipText;
  int seconds;
  final TextStyle textStyle;
  final ValueChanged<int> onChange;
  final GestureTapCallback onTap;
  final Decoration decoration;

  CountDownSkip({
    Key key,
    this.skipText,
    this.seconds,
    this.textStyle,
    this.onChange,
    this.onTap,
    this.decoration,
  }) :super(key: key) {
    if (skipText == null) skipText = '';
    if (seconds == null) seconds = 5;
  }

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
      timer = BaseUtils.timerPeriodic(Duration(seconds: 1), (time) {
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
      padding: EdgeInsets.symmetric(horizontal: BaseUtils.getHeight(5), vertical: BaseUtils.getWidth(4)),
      text: seconds.toString() +
          's' + widget.skipText,
      textStyle: widget.textStyle ?? TextStyle(fontSize: 13, color: getColors(black70)),
    );
  }

  @override
  void dispose() {
    super.dispose();
    BaseUtils.timerCancel();
  }
}
