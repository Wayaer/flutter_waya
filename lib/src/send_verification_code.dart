import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/src/extended_state.dart';

typedef SendVerificationCodeValueCallback = void Function(
    void Function(bool send));

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
      required this.onTap,
      this.decoration,
      this.duration = const Duration(seconds: 60),
      this.margin,
      this.padding,
      required this.builder,
      this.gestureBuilder,
      this.onStateChanged});

  /// 文字 builder
  final SendStateBuilder builder;

  /// 点击 builder
  final SendStateGestureBuilder? gestureBuilder;

  /// 默认计时秒
  final Duration duration;

  /// 点击按钮
  final SendVerificationCodeValueCallback? onTap;

  /// 状态变化
  final SendStateChanged? onStateChanged;

  /// 装饰器
  final Decoration? decoration;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  State<SendVerificationCode> createState() => _SendVerificationCodeState();
}

class _SendVerificationCodeState extends ExtendedState<SendVerificationCode> {
  int seconds = -1;
  Timer? timer;
  SendState sendState = SendState.none;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onStateChanged?.call(sendState);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gesture = (seconds < 0) ? onTap : null;
    final current = Container(
        margin: widget.margin,
        padding: widget.padding,
        decoration: widget.decoration,
        child: widget.builder(sendState, seconds));
    return widget.gestureBuilder?.call(gesture, current) ??
        GestureDetector(onTap: gesture, child: current);
  }

  @override
  void didUpdateWidget(covariant SendVerificationCode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.onTap != widget.onTap) {
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
    timer = Timer.periodic(const Duration(seconds: 1), (Timer time) {
      if (seconds < 0) {
        timer?.cancel();
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
