import 'dart:async';

import 'package:flutter/material.dart';

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
      required this.builder,
      this.onStateChanged});

  /// 状态回调
  final SendStateBuilder builder;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onStateChanged?.call(sendState);
    });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: (seconds < 0) ? onTap : null,
        child: Container(
            margin: widget.margin,
            padding: widget.padding,
            decoration: widget.decoration,
            child: widget.builder(sendState, seconds)),
      );

  @override
  void didUpdateWidget(covariant SendSMS oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.onTap != widget.onTap) {
      setState(() {});
    }
  }

  void onTap() {
    sendState = SendState.sending;
    lastState = sendState;
    widget.onStateChanged?.call(sendState);
    setState(() {});
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
      setState(() {});
    }
  }

  SendState lastState = SendState.none;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer time) {
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
      setState(() {});
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
