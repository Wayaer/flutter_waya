import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/src/extended_state.dart';

typedef CounterBuilder = Widget Function(Duration duration, bool isRunning,
    VoidCallback startTiming, VoidCallback stopTiming);

typedef CounterOnCallTiming = void Function(VoidCallback callTiming);

///
typedef CounterVoidCallback = void Function(Duration duration);

/// 倒计时
class Counter extends StatefulWidget {
  const Counter.down({
    super.key,
    this.duration = const Duration(seconds: 60),
    this.periodic = const Duration(seconds: 1),
    required this.builder,
    this.autoStart = true,
    this.resetOnStart = true,
    this.onStarts,
    this.onChanged,
    this.onEnds,
    this.onStartTiming,
    this.onStopTiming,
  })  : isCountDown = true,
        maxDuration = null;

  const Counter.up({
    super.key,
    this.duration = const Duration(seconds: 0),
    this.maxDuration,
    this.periodic = const Duration(seconds: 1),
    required this.builder,
    this.autoStart = true,
    this.resetOnStart = true,
    this.onStarts,
    this.onChanged,
    this.onEnds,
    this.onStartTiming,
    this.onStopTiming,
  }) : isCountDown = false;

  /// UI 回调
  final CounterBuilder builder;

  /// [Counter.down] 倒计时时长
  /// [Counter.up] 初始时间
  final Duration duration;

  /// [Counter.up] 最大时长
  final Duration? maxDuration;

  /// 周期
  final Duration periodic;

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
    current = widget.duration;
    widget.onStartTiming?.call(startTiming);
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((Duration callback) {
        startTiming();
      });
    }
  }

  void startTiming() {
    if (widget.resetOnStart) {
      current = widget.duration;
      setState(() {});
    }
    disposeTime();
    widget.onStarts?.call(current);
    if (widget.isCountDown) {
      if (current.inMilliseconds > 0) {
        timer = Timer.periodic(widget.periodic, (Timer time) {
          if (current < widget.periodic) {
            current = Duration.zero;
          } else {
            current -= widget.periodic;
          }
          if (current.inMicroseconds <= 0) {
            stopTiming();
          }
          widget.onChanged?.call(current);
          setState(() {});
        });
      } else {
        current = Duration.zero;
        setState(() {});
        widget.onEnds?.call(current);
      }
    } else {
      if (widget.maxDuration != null &&
          widget.maxDuration!.inMicroseconds <=
              widget.periodic.inMicroseconds) {
        current = widget.maxDuration!;
        setState(() {});
        widget.onEnds?.call(current);
      } else {
        timer = Timer.periodic(widget.periodic, (Timer time) {
          current += widget.periodic;
          if (widget.maxDuration != null &&
              current.inMicroseconds >= widget.maxDuration!.inMicroseconds) {
            stopTiming();
            current = widget.maxDuration!;
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
    if (oldWidget.duration != widget.duration ||
        oldWidget.autoStart != widget.autoStart ||
        oldWidget.resetOnStart != widget.resetOnStart ||
        oldWidget.periodic != widget.periodic) {
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
      this.duration = const Duration(seconds: 60),
      this.margin,
      this.padding,
      this.gestureBuilder,
      this.onChanged});

  /// 文字 builder
  final SendStateBuilder builder;

  /// 点击 builder
  final SendStateGestureBuilder? gestureBuilder;

  /// 默认计时秒
  final Duration duration;

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
            duration: widget.duration,
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
