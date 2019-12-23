import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/custom/CustomButton.dart';
import 'package:flutter_waya/src/utils/WayUtils.dart';

class CountDownSkip extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String SkipText;
  final int seconds;
  final TextStyle textStyle;
  final ValueChanged<int> onChange;
  final GestureTapCallback onTap;
  final bool showSkip;
  final Decoration decoration;

  CountDownSkip({
    // ignore: non_constant_identifier_names
    this.SkipText: '跳过',
    this.seconds: 5,
    this.textStyle,
    this.showSkip: true,
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
        log(seconds);
        WayUtils.timePeriodic(Duration(seconds: 1), () {
          seconds -= 1;
          setState(() {});
          if (widget.onChange is ValueChanged<int>) {
            widget.onChange(seconds);
          }
          if (seconds == 0) WayUtils.cancelTimer();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: widget.onTap,
      decoration: widget.decoration ??
          BoxDecoration(
              color: getColors(white50),
              borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.symmetric(
          horizontal: WayUtils.getHeight(5), vertical: WayUtils.getWidth(4)),
      text: seconds.toString() +
          's' +
          (widget.showSkip
              ? (seconds == 0 ? ' ' + widget.SkipText : '')
              : ' ' + widget.SkipText),
      textStyle: widget.textStyle ??
          TextStyle(fontSize: 13, color: getColors(black70)),
    );
  }

  @override
  void dispose() {
    super.dispose();
    WayUtils.cancelTimer();
  }
}
