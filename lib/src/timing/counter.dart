import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/src/core/extended_state.dart';

/// UI 构建器，参数为当前时长、计时是否运行中以及开始、停止计时方法
typedef FlCounterBuilder = Widget Function(
  Duration duration,
  bool isRunning,
  VoidCallback startTiming,
  VoidCallback stopTiming,
);

/// 回传计时器开始或停止方法的回调
typedef FlCounterOnCallTiming = void Function(VoidCallback callTiming);

/// 计时回调，参数为当前时长
typedef FlCounterVoidCallback = void Function(Duration duration);

/// 计时器，支持正计时与倒计时
class FlCounter extends StatefulWidget {
  /// 倒计时模式
  const FlCounter.down({
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
  }) : isCountDown = true,
       max = null;

  /// 正计时模式
  const FlCounter.up({
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
  }) : isCountDown = false,
       min = null;

  /// UI 构建器，提供当前时长、计时状态与开始、停止方法
  final FlCounterBuilder builder;

  /// [FlCounter.down] 倒计时总时长，默认 60 秒
  /// [FlCounter.up] 初始时间，默认 0 秒
  final Duration value;

  /// [FlCounter.up] 最大时长，达到后自动停止
  final Duration? max;

  /// [FlCounter.down] 最小时长，达到后自动停止
  final Duration? min;

  /// 计时执行间隔，默认 1 秒
  final Duration interval;

  /// 每次计时的步长，默认 1 秒
  final Duration step;

  /// 是否自动开始计时，默认 true
  final bool autoStart;

  /// 调用 startTiming 时是否重置为 [value]，默认 true
  final bool resetOnStart;

  /// 开始计时回调，参数为当前时长
  final FlCounterVoidCallback? onStarts;

  /// 计时结束回调，参数为当前时长
  final FlCounterVoidCallback? onEnds;

  /// 获取开始计时方法的回调
  final FlCounterOnCallTiming? onStartTiming;

  /// 获取停止计时方法的回调
  final FlCounterOnCallTiming? onStopTiming;

  /// 时间变化回调
  final ValueChanged<Duration>? onChanged;

  /// 是否为倒计时模式
  final bool isCountDown;

  @override
  State<FlCounter> createState() => _CounterState();
}

class _CounterState extends FlExtendedState<FlCounter> {
  Duration current = Duration();

  Timer? timer;

  @override
  void initState() {
    super.initState();
    current = widget.value;
    widget.onStartTiming?.call(startTiming);
    widget.onStopTiming?.call(stopTiming);
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((Duration callback) {
        if (mounted) startTiming();
      });
    }
  }

  /// 开始计时，[FlCounter.resetOnStart] 为 true 时先重置为初始值
  void startTiming() {
    assert(widget.interval > Duration.zero, 'interval 必须大于 0');
    assert(widget.step > Duration.zero, 'step 必须大于 0');
    if (widget.interval <= Duration.zero || widget.step <= Duration.zero) return;
    if (widget.resetOnStart) {
      current = widget.value;
    }
    widget.onStarts?.call(current);
    onChanged();
    if (widget.isCountDown) {
      final min = widget.min ?? Duration.zero;
      if (current > min) {
        timer ??= Timer.periodic(widget.interval, (Timer time) {
          current -= widget.step;
          if (current <= min) {
            current = min;
            onChanged();
            _completeTiming();
          } else {
            onChanged();
          }
        });
      } else {
        current = min;
        onChanged();
        onEnds();
      }
    } else {
      if (widget.max != null && (widget.max! <= widget.step || widget.max! <= current)) {
        current = widget.max!;
        onChanged();
        onEnds();
      } else {
        timer ??= Timer.periodic(widget.interval, (Timer time) {
          current += widget.step;
          if (widget.max != null && widget.max! <= current) {
            current = widget.max!;
            onChanged();
            _completeTiming();
          } else {
            onChanged();
          }
        });
      }
    }
  }

  void onEnds() {
    widget.onEnds?.call(current);
  }

  void onChanged() {
    widget.onChanged?.call(current);
    if (mounted) setState(() {});
  }

  /// 手动停止计时并销毁内部定时器，不触发 [FlCounter.onEnds]
  void stopTiming() {
    disposeTime();
    if (mounted) setState(() {});
  }

  void _completeTiming() {
    disposeTime();
    onEnds();
  }

  void disposeTime() {
    timer?.cancel();
    timer = null;
  }

  @override
  void didUpdateWidget(covariant FlCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool autoStartChanged = oldWidget.autoStart != widget.autoStart;
    final bool valueChanged = oldWidget.value != widget.value;
    final bool configChanged =
        oldWidget.interval != widget.interval ||
        oldWidget.resetOnStart != widget.resetOnStart ||
        oldWidget.step != widget.step;
    if (widget.autoStart) {
      if (autoStartChanged || valueChanged || configChanged) {
        if (valueChanged) current = widget.value;
        disposeTime();
        startTiming();
      }
    } else {
      if (autoStartChanged || oldWidget.interval != widget.interval) disposeTime();
      if (valueChanged) {
        current = widget.value;
        if (mounted) setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(current, timer?.isActive ?? false, startTiming, stopTiming);

  @override
  void dispose() {
    disposeTime();
    super.dispose();
  }
}

/// 发送验证码点击回调，返回是否发送成功
typedef FlSendVerificationCodeValueCallback = Future<bool> Function();

/// 根据发送状态与剩余秒数构建内容
typedef FlSendStateBuilder = Widget Function(FlSendState state, int i);

/// 自定义点击手势构建器，传入点击回调与内容组件
typedef FlSendStateGestureBuilder = Widget Function(VoidCallback? onTap, Widget child)?;

/// 发送状态变化回调
typedef FlSendStateChanged = void Function(FlSendState state);

/// 验证码发送状态
enum FlSendState {
  /// 默认状态  获取验证码
  none,

  /// 发送中  调用接口的时候
  sending,

  /// 重新发送
  resend,

  /// 倒计时
  countDown,
}

/// 发送验证码组件，点击后进入发送中与倒计时状态
class FlSendVerificationCode extends StatefulWidget {
  const FlSendVerificationCode({
    super.key,
    required this.onSendTap,
    required this.builder,
    this.decoration,
    this.value = const Duration(seconds: 60),
    this.margin,
    this.padding,
    this.gestureBuilder,
    this.onChanged,
  });

  /// 内容构建器，根据发送状态与剩余秒数构建
  final FlSendStateBuilder builder;

  /// 自定义点击手势构建器，为 null 时使用默认 [GestureDetector]
  final FlSendStateGestureBuilder? gestureBuilder;

  /// 倒计时时长，默认 60 秒
  final Duration value;

  /// 点击发送回调，返回是否发送成功
  final FlSendVerificationCodeValueCallback? onSendTap;

  /// 发送状态变化回调
  final FlSendStateChanged? onChanged;

  /// 内容装饰器
  final Decoration? decoration;

  /// 外边距
  final EdgeInsetsGeometry? margin;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  @override
  State<FlSendVerificationCode> createState() => _SendVerificationCodeState();
}

class _SendVerificationCodeState extends FlExtendedState<FlSendVerificationCode> {
  FlSendState sendState = FlSendState.none;
  FlSendState lastSendState = FlSendState.none;
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
      child: FlCounter.down(
        value: widget.value,
        onStarts: (Duration duration) {
          sendState = FlSendState.countDown;
          onChanged();
        },
        autoStart: false,
        onChanged: (Duration duration) {
          sendState = FlSendState.countDown;
          onChanged();
        },
        onEnds: (Duration duration) {
          sendState = FlSendState.resend;
          onChanged();
        },
        onStartTiming: (VoidCallback startTiming) {
          this.startTiming = startTiming;
        },
        builder: (Duration duration, bool isActive, VoidCallback startTiming, VoidCallback stopTiming) {
          return widget.builder(sendState, duration.inSeconds);
        },
      ),
    );
    return widget.gestureBuilder?.call(onTap, current) ?? GestureDetector(onTap: onTap, child: current);
  }

  Future<void> onTap() async {
    if (sendState == FlSendState.sending || sendState == FlSendState.countDown) {
      return;
    }
    final FlSendVerificationCodeValueCallback? onSendTap = widget.onSendTap;
    if (onSendTap == null) return;
    sendState = FlSendState.sending;
    onChanged();
    if (mounted) setState(() {});
    bool result;
    try {
      result = await onSendTap();
    } on Exception {
      result = false;
    }
    if (!mounted) return;
    if (result) {
      startTiming?.call();
    } else {
      sendState = FlSendState.resend;
      onChanged();
      setState(() {});
    }
  }
}
