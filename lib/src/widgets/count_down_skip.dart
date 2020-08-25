import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/widgets.dart';
import 'package:flutter_waya/src/tools/tools.dart';

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
  })  : this.skipText = skipText ?? '',
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
    return SimpleButton(
      onTap: widget.onTap,
      decoration: widget.decoration ??
          BoxDecoration(
              color: getColors(white50),
              borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.symmetric(
          horizontal: ScreenFit.getHeight(5), vertical: ScreenFit.getWidth(4)),
      child: Widgets.textSmall(seconds.toString() + 's' + widget.skipText),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Tools.timerCancel();
  }
}
