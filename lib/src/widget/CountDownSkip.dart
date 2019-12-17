import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class CountDownSkip extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String SkipText;
  final int seconds;
  final TextStyle textStyle;
  final Function onChange;
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
        Utils.timePeriodic(Duration(seconds: 1), () {
          seconds -= 1;
          setState(() {});
          widget.onChange(seconds);
          if (seconds == 0) Utils.cancelTimer();
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
          horizontal: Utils.getHeight(5), vertical: Utils.getWidth(4)),
      text: seconds.toString() +
          's' +
          (widget.showSkip
              ? (seconds == 0 ? ' ' + widget.SkipText : '')
              : ' ' + widget.SkipText),
      textStyle: widget.textStyle ??
          TextStyle(fontSize: 13, color: getColors(textBlack70)),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Utils.cancelTimer();
  }
}
