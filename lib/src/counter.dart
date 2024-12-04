import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/src/extended_state.dart';

typedef CounterBuilder = Widget Function(Duration duration, bool isRunning,
    VoidCallback startTiming, VoidCallback stopTiming);

typedef CounterOnCallTiming = void Function(VoidCallback callTiming);

typedef CounterVoidCallback = void Function(Duration duration);

/// 计时器
class Counter extends StatefulWidget {
  const Counter.down({
    super.key,
    this.value = const Duration(seconds: 60),
    this.min,
    this.interval = const Duration(seconds: 1),
    this.step = const Duration(seconds: 1),
    required this.builder,
    this.autoStart = true,
    this.resetOnStart = true,
    this.onStarts,
    this.onChanged,
    this.onEnds,
    this.onStartTiming,
    this.onStopTiming,
  })  : isCountDown = true,
        max = null;

  const Counter.up({
    super.key,
    this.value = const Duration(seconds: 0),
    this.max,
    this.interval = const Duration(seconds: 1),
    this.step = const Duration(seconds: 1),
    required this.builder,
    this.autoStart = true,
    this.resetOnStart = true,
    this.onStarts,
    this.onChanged,
    this.onEnds,
    this.onStartTiming,
    this.onStopTiming,
  })  : isCountDown = false,
        min = null;

  /// UI 回调
  final CounterBuilder builder;

  /// [Counter.down] 倒计时时长
  /// [Counter.up] 初始时间
  final Duration value;

  /// [Counter.up] 最大时长
  final Duration? max;

  /// [Counter.down] 最小时长
  final Duration? min;

  /// 执行间隔时间
  final Duration interval;

  /// 步长
  final Duration step;

  /// 自动开始
  final bool autoStart;

  /// 调用 [startTiming] 时是否重置
  final bool resetOnStart;

  /// 开始回调
  final CounterVoidCallback? onStarts;

  /// 结束回调
  final CounterVoidCallback? onEnds;

  /// 执行计时器方法回调
  final CounterOnCallTiming? onStartTiming;

  /// 停止计时器方法回调
  final CounterOnCallTiming? onStopTiming;

  /// 时间变化回调
  final ValueChanged<Duration>? onChanged;

  /// 是否倒计时
  final bool isCountDown;

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends ExtendedState<Counter> {
  Duration current = Duration();

  Timer? timer;

  @override
  void initState() {
    super.initState();
    current = widget.value;
    widget.onStartTiming?.call(startTiming);
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((Duration callback) {
        startTiming();
      });
    }
  }

  void startTiming() {
    if (widget.resetOnStart) {
      current = widget.value;
      setState(() {});
    }
    widget.onStarts?.call(current);
    if (widget.isCountDown) {
      final min = (widget.min?.inMicroseconds ?? 0);
      if (current.inMicroseconds > min) {
        timer ??= Timer.periodic(widget.interval, (Timer time) {
          if (current < widget.step) {
            current = widget.min ?? Duration.zero;
          } else {
            current -= widget.step;
          }
          if (current.inMicroseconds <= min) {
            stopTiming();
          }
          widget.onChanged?.call(current);
          setState(() {});
        });
      } else {
        current = widget.min ?? Duration.zero;
        setState(() {});
        widget.onEnds?.call(current);
      }
    } else {
      if (widget.max != null &&
          widget.max!.inMicroseconds <= widget.step.inMicroseconds) {
        current = widget.max!;
        setState(() {});
        widget.onEnds?.call(current);
      } else {
        timer ??= Timer.periodic(widget.interval, (Timer time) {
          current += widget.step;
          if (widget.max != null &&
              current.inMicroseconds >= widget.max!.inMicroseconds) {
            stopTiming();
            current = widget.max!;
          }
          widget.onChanged?.call(current);
          setState(() {});
        });
      }
    }
  }

  void stopTiming() {
    disposeTime();
    widget.onEnds?.call(current);
  }

  void disposeTime() {
    timer?.cancel();
    timer = null;
  }

  @override
  void didUpdateWidget(covariant Counter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value ||
        oldWidget.autoStart != widget.autoStart ||
        oldWidget.resetOnStart != widget.resetOnStart ||
        oldWidget.step != widget.step) {
      if (oldWidget.interval != widget.interval) disposeTime();
      if (widget.autoStart) startTiming();
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(
      current, timer?.isActive ?? false, startTiming, stopTiming);

  @override
  void dispose() {
    disposeTime();
    super.dispose();
  }
}

typedef SendVerificationCodeValueCallback = Future<bool> Function();

typedef SendStateBuilder = Widget Function(SendState state, int i);

typedef SendStateGestureBuilder = Widget Function(
    VoidCallback? onTap, Widget child)?;

typedef SendStateChanged = void Function(SendState state);

enum SendState {
  /// 默认状态  获取验证码
  none,

  /// 发送中  调用接口的时候
  sending,

  /// 重新发送
  resend,

  /// 倒计时
  countDown
}

/// 发送验证码
class SendVerificationCode extends StatefulWidget {
  const SendVerificationCode(
      {super.key,
      required this.onSendTap,
      required this.builder,
      this.decoration,
      this.value = const Duration(seconds: 60),
      this.margin,
      this.padding,
      this.gestureBuilder,
      this.onChanged});

  /// 文字 builder
  final SendStateBuilder builder;

  /// 点击 builder
  final SendStateGestureBuilder? gestureBuilder;

  /// 默认计时秒
  final Duration value;

  /// 点击按钮
  final SendVerificationCodeValueCallback? onSendTap;

  /// 状态变化
  final SendStateChanged? onChanged;

  /// 装饰器
  final Decoration? decoration;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  State<SendVerificationCode> createState() => _SendVerificationCodeState();
}

class _SendVerificationCodeState extends ExtendedState<SendVerificationCode> {
  SendState sendState = SendState.none;
  SendState lastSendState = SendState.none;
  VoidCallback? startTiming;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChanged();
    });
  }

  void onChanged() {
    if (lastSendState == sendState) return;
    widget.onChanged?.call(sendState);
    lastSendState = sendState;
  }

  @override
  Widget build(BuildContext context) {
    final current = Container(
        margin: widget.margin,
        padding: widget.padding,
        decoration: widget.decoration,
        child: Counter.down(
            value: widget.value,
            onStarts: (Duration duration) {
              sendState = SendState.countDown;
              onChanged();
            },
            autoStart: false,
            onChanged: (Duration duration) {
              sendState = SendState.countDown;
              onChanged();
            },
            onEnds: (Duration duration) {
              sendState = SendState.resend;
              onChanged();
            },
            onStartTiming: (VoidCallback startTiming) {
              this.startTiming = startTiming;
            },
            builder: (Duration duration, bool isActive,
                VoidCallback startTiming, VoidCallback stopTiming) {
              return widget.builder(sendState, duration.inSeconds);
            }));
    return widget.gestureBuilder?.call(onTap, current) ??
        GestureDetector(onTap: onTap, child: current);
  }

  void onTap() {
    if (sendState == SendState.sending || sendState == SendState.countDown) {
      return;
    }
    sendState = SendState.sending;
    onChanged();
    setState(() {});
    widget.onSendTap?.call().then((result) {
      if (!mounted) return;
      if (result) {
        startTiming?.call();
      } else {
        sendState = SendState.resend;
        onChanged();
        setState(() {});
      }
    });
  }
}
