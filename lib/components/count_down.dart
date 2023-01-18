import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef CountDownBuilder = Widget Function(int i);

enum CountDownType {
  microseconds,
  milliseconds,
  seconds,
  minutes,
  hours,
  days,
}

/// 倒计时
class CountDown extends StatefulWidget {
  const CountDown({
    super.key,
    this.duration = const Duration(seconds: 5),
    this.onChanged,
    required this.builder,
    this.periodic = 1000,
    this.type = CountDownType.seconds,
  });

  /// UI 回调
  final CountDownBuilder builder;

  /// 倒计时时间
  final Duration duration;

  /// 定时 依据[countDownType]
  final int periodic;

  /// 倒计时 类型
  final CountDownType type;

  final ValueChanged<int>? onChanged;

  @override
  State<CountDown> createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  late int i;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    disposeTime();
    Duration periodic;
    switch (widget.type) {
      case CountDownType.microseconds:
        i = widget.duration.inMicroseconds;
        periodic = widget.periodic.microseconds;
        break;
      case CountDownType.milliseconds:
        i = widget.duration.inMilliseconds;
        periodic = widget.periodic.milliseconds;
        break;
      case CountDownType.seconds:
        i = widget.duration.inSeconds;
        periodic = widget.periodic.seconds;
        break;
      case CountDownType.minutes:
        i = widget.duration.inMinutes;
        periodic = widget.periodic.minutes;
        break;
      case CountDownType.hours:
        i = widget.duration.inHours;
        periodic = widget.periodic.hours;
        break;
      case CountDownType.days:
        i = widget.duration.inDays;
        periodic = widget.periodic.days;
        break;
    }

    addPostFrameCallback((Duration callback) {
      if (i > 0) {
        timer = periodic.timerPeriodic((Timer time) {
          i -= widget.periodic;
          if (mounted) setState(() {});
          widget.onChanged?.call(i);
          if (i == 0) disposeTime();
        });
      }
    });
  }

  void disposeTime() {
    timer?.cancel();
    timer = null;
  }

  @override
  void didUpdateWidget(covariant CountDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration ||
        oldWidget.onChanged != widget.onChanged ||
        oldWidget.periodic != widget.periodic ||
        oldWidget.builder != widget.builder) init();
  }

  @override
  Widget build(BuildContext context) => widget.builder(i);

  @override
  void dispose() {
    super.dispose();
    disposeTime();
  }
}
