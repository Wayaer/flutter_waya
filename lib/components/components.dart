import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

export 'anchor_scroll_list.dart';
export 'builder.dart';
export 'button/bubble_button.dart';
export 'button/dropdown_button.dart';
export 'button/elastic_button.dart';
export 'check_box.dart';
export 'counter.dart';
export 'decorator_box.dart';
export 'dotted_line.dart';
export 'draggable_scrollbar.dart';
export 'gesture.dart';
export 'json_parse.dart';
export 'picker/picker.dart';
export 'pin_box.dart';
export 'progress/liquid_progress.dart';
export 'progress/progress.dart';
export 'progress/wave.dart';
export 'screen_adaptation.dart';
export 'spinKit/spin_kit.dart';
export 'swiper/indicator.dart';
export 'swiper/pagination.dart';
export 'swiper/swiper.dart';
export 'switch.dart';
export 'count_down.dart';
export 'expansion_tiles.dart';
export 'toggle_rotate.dart';
export 'rating_stars.dart';

class NoScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;
}

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

/// 侧滑菜单
class CustomDismissible extends Dismissible {
  const CustomDismissible({
    required super.key,
    required super.child,

    /// 滑动时组件下一层显示的内容
    /// 没有设置secondaryBackground时，从右往左或者从左往右滑动都显示该内容
    /// 设置了secondaryBackground后，从左往右滑动显示该内容，从右往左滑动显示secondaryBackground的内容
    super.background,

    /// 不能单独设置，只能在已经设置了background后才能设置，从右往左滑动时显示
    super.secondaryBackground,

    /// 组件消失前回调，可以弹出是否消失确认窗口。
    super.confirmDismiss,

    /// 组件大小改变时回调
    super.onResize,

    /// 组件消失后回调
    super.onDismissed,

    /// 滑动方向（水平、垂直）
    /// 默认DismissDirection.horizontal 水平
    super.direction = DismissDirection.horizontal,

    /// 组件大小改变的时长，默认300毫秒。Duration(milliseconds: 300)
    super.resizeDuration = const Duration(milliseconds: 300),

    /// 必须拖动项目的偏移阈值才能被视为已解除
    super.dismissThresholds = const <DismissDirection, double>{},

    /// 组件消失的时长，默认200毫秒。Duration(milliseconds: 200)
    super.movementDuration = const Duration(milliseconds: 200),

    /// 滑动时偏移量，默认0.0，
    super.crossAxisEndOffset = 0.0,

    /// 拖动消失后组件大小改变方式
    /// start：下面组件向上滑动
    /// down：上面组件向下滑动
    /// 默认DragStartBehavior.start
    super.dragStartBehavior = DragStartBehavior.start,
  });
}

/// 组件右上角加红点
class Badge extends StatelessWidget {
  const Badge({
    super.key,
    this.hide = false,
    required this.child,
    required this.badge,
    this.badgeColor,
    this.badgeSize,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.alignment,
    this.width,
    this.height,
    this.onTap,
    this.margin,
  });

  /// 是否显示badge
  final bool hide;

  /// 底部组件
  final Widget child;

  /// 自定义badge内容
  final Widget badge;
  final Color? badgeColor;
  final double? badgeSize;

  /// badge 的位置
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final AlignmentGeometry? alignment;

  /// 整个组件的宽高
  final double? width;
  final double? height;

  /// 点击事件
  final GestureTapCallback? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[child];
    if (!hide) {
      Widget current = dot(context);
      if (alignment != null) {
        current = Align(alignment: alignment!, child: current);
      }
      if (right != null || top != null || bottom != null || left != null) {
        current = Positioned(
            right: right, top: top, bottom: bottom, left: left, child: current);
      }
      children.add(current);
    }
    return Universal(
        onTap: onTap,
        margin: margin,
        width: width,
        height: height,
        isStack: !hide,
        children: children);
  }

  Widget dot(BuildContext context) => Container(
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
          color: badgeColor ?? context.theme.primaryColor,
          shape: BoxShape.circle),
      child: badge);
}

class CustomDrawer extends StatefulWidget {
  CustomDrawer({
    super.key,
    double? width,
    required this.child,
    this.callback,
    this.options,
  }) : width = width ?? deviceWidth * 0.7;

  final Widget child;
  final DrawerCallback? callback;
  final double width;
  final ModalWindowsOptions? options;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    widget.callback?.call(true);
    super.initState();
  }

  @override
  void dispose() {
    widget.callback?.call(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.width),
      child: ModalWindows(options: widget.options, child: widget.child));
}

/// 暂无数据
class PlaceholderChild extends StatelessWidget {
  const PlaceholderChild(
      {super.key,
      this.padding = const EdgeInsets.all(100),
      this.child,
      this.text = 'There is no data'});

  final EdgeInsetsGeometry padding;
  final Widget? child;
  final String text;

  @override
  Widget build(BuildContext context) =>
      Padding(padding: padding, child: Center(child: child ?? BText(text)));
}
