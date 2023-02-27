import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef SendSMSValueCallback = void Function(void Function(bool send));

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

typedef SendStateBuilder = Widget Function(SendState state, int i);
typedef SendStateChanged = void Function(SendState state);

/// 发送验证码
class SendSMS extends StatefulWidget {
  const SendSMS(
      {super.key,
      required this.onTap,
      this.decoration,
      this.duration = const Duration(seconds: 60),
      this.margin,
      this.padding,
      required this.stateBuilder,
      this.onStateChanged});

  /// 状态回调
  final SendStateBuilder stateBuilder;

  /// 默认计时秒
  final Duration duration;

  /// 点击按钮
  final SendSMSValueCallback? onTap;

  /// 状态变化
  final SendStateChanged? onStateChanged;

  /// 装饰器
  final Decoration? decoration;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  State<SendSMS> createState() => _SendSMSState();
}

class _SendSMSState extends State<SendSMS> {
  int seconds = -1;
  Timer? timer;
  SendState sendState = SendState.none;

  @override
  void initState() {
    super.initState();
    addPostFrameCallback((_) {
      widget.onStateChanged?.call(sendState);
    });
  }

  @override
  Widget build(BuildContext context) => Universal(
      margin: widget.margin,
      padding: widget.padding,
      onTap: (seconds < 0) ? onTap : null,
      decoration: widget.decoration,
      child: widget.stateBuilder(sendState, seconds));

  @override
  void didUpdateWidget(covariant SendSMS oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration ||
        oldWidget.onTap != widget.onTap ||
        oldWidget.decoration != widget.decoration ||
        oldWidget.stateBuilder != widget.stateBuilder) {
      if (mounted) setState(() {});
    }
  }

  void onTap() {
    sendState = SendState.sending;
    lastState = sendState;
    widget.onStateChanged?.call(sendState);
    if (mounted) setState(() {});
    widget.onTap?.call(send);
  }

  void send(bool sending) {
    if (sending) {
      seconds = widget.duration.inSeconds;
      startTimer();
    } else {
      sendState = SendState.resend;
      lastState = sendState;
      widget.onStateChanged?.call(sendState);
      if (mounted) setState(() {});
    }
  }

  SendState lastState = SendState.none;

  void startTimer() {
    timer = 1.seconds.timerPeriodic((Timer time) {
      if (seconds < 0) {
        timer!.cancel();
        return;
      }
      seconds--;
      sendState = seconds < 0 ? SendState.resend : SendState.countDown;
      if (sendState != lastState) {
        widget.onStateChanged?.call(sendState);
        lastState = sendState;
      }
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
  }
}
