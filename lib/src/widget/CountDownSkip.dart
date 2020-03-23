import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/custom/CustomButton.dart';
import 'package:flutter_waya/src/utils/BaseUtils.dart';

class CountDownSkip extends StatefulWidget {
  final String skipText;
  final int seconds;
  final TextStyle textStyle;
  final ValueChanged<int> onChange;
  final GestureTapCallback onTap;
  final Decoration decoration;

  CountDownSkip({
    this.skipText,
    this.seconds: 5,
    this.textStyle,
    this.onChange,
    this.onTap,
    this.decoration,
  });

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
    seconds = widget.seconds;
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      if (seconds > 1) {
        BaseUtils.timePeriodic(Duration(seconds: 1), () {
          seconds -= 1;
          setState(() {});
          if (widget.onChange is ValueChanged<int>) {
            widget.onChange(seconds);
          }
          if (seconds == 0) BaseUtils.cancelTimer();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: widget.onTap,
      decoration: widget.decoration ?? BoxDecoration(color: getColors(white50), borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.symmetric(horizontal: BaseUtils.getHeight(5), vertical: BaseUtils.getWidth(4)),
      text: seconds.toString() +
          's' +
          widget.skipText ?? '',
      textStyle: widget.textStyle ?? TextStyle(fontSize: 13, color: getColors(black70)),
    );
  }

  @override
  void dispose() {
    super.dispose();
    BaseUtils.cancelTimer();
  }
}
