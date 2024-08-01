import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/src/extended_state.dart';

typedef CountDownBuilder = Widget Function(
    Duration duration, bool isRunning, VoidCallback startTiming);

typedef CountDownOnStartTiming = void Function(VoidCallback startTiming);

/// 倒计时
class CountDown extends StatefulWidget {
  const CountDown({
    super.key,
    this.duration = const Duration(seconds: 5),
    this.periodic = const Duration(seconds: 1),
    this.onChanged,
    required this.builder,
    this.autoStart = true,
    this.onStarts,
    this.onEnds,
    this.onStartTiming,
  });

  /// UI 回调
  final CountDownBuilder builder;

  /// 倒计时时间
  final Duration duration;

  /// 周期
  final Duration periodic;

  /// 自动开始
  final bool autoStart;

  /// 开始回调
  final VoidCallback? onStarts;

  /// 执行计时器方法回调
  final CountDownOnStartTiming? onStartTiming;

  /// 结束回调
  final VoidCallback? onEnds;

  /// 时间变化回调
  final ValueChanged<Duration>? onChanged;

  @override
  State<CountDown> createState() => _CountDownState();
}

class _CountDownState extends ExtendedState<CountDown> {
  late Duration current;
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
    current = widget.duration;
    disposeTime();
    widget.onStarts?.call();
    if (current.inMilliseconds > 0) {
      timer = Timer.periodic(widget.periodic, (Timer time) {
        if (current < widget.periodic) {
          current = Duration.zero;
        } else {
          current -= widget.periodic;
        }
        widget.onChanged?.call(current);
        setState(() {});
        if (current.inMicroseconds <= 0) {
          disposeTime();
          widget.onEnds?.call();
        }
      });
    } else {
      current = Duration.zero;
      setState(() {});
      widget.onEnds?.call();
    }
  }

  void disposeTime() {
    timer?.cancel();
    timer = null;
  }

  @override
  void didUpdateWidget(covariant CountDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration ||
        oldWidget.autoStart != widget.autoStart ||
        oldWidget.periodic != widget.periodic) {
      if (widget.autoStart) startTiming();
    }
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(current, timer?.isActive ?? false, startTiming);

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
        child: CountDown(
            duration: widget.duration,
            onStarts: () {
              sendState = SendState.countDown;
              onChanged();
            },
            autoStart: false,
            onChanged: (Duration duration) {
              sendState = SendState.countDown;
              onChanged();
            },
            onEnds: () {
              sendState = SendState.resend;
              onChanged();
            },
            onStartTiming: (VoidCallback startTiming) {
              this.startTiming = startTiming;
            },
            builder:
                (Duration duration, bool isActive, VoidCallback startTiming) {
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
