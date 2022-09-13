import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

export 'anchor_scroll_list.dart';
export 'builder.dart';
export 'button/bubble_button.dart';
export 'button/dropdown_button.dart';
export 'button/elastic_button.dart';
export 'check_box.dart';
export 'check_box.dart';
export 'counter.dart';
export 'dotted_line.dart';
export 'draggable_scrollbar.dart';
export 'gesture_widgets.dart';
export 'json_parse.dart';
export 'popup/picker.dart';
export 'popup/popup.dart';
export 'progress/liquid_progress.dart';
export 'progress/progress.dart';
export 'progress/wave.dart';
export 'refresh/simple_refresh.dart';
export 'screen_adaptation.dart';
export 'swiper/indicator.dart';
export 'swiper/pagination.dart';
export 'swiper/swiper.dart';
export 'switch.dart';

class NoScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
          BuildContext context, Widget child, AxisDirection axisDirection) =>
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

/// 发送验证码
class SendSMS extends StatefulWidget {
  const SendSMS(
      {super.key,
      required this.onTap,
      this.decoration,
      this.duration = const Duration(seconds: 60),
      this.margin,
      this.padding,
      required this.stateBuilder});

  /// 状态回调
  final SendStateBuilder stateBuilder;

  /// 默认计时秒
  final Duration duration;

  /// 点击按钮
  final SendSMSValueCallback? onTap;

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
    if (mounted) setState(() {});
    widget.onTap?.call(send);
  }

  void send(bool sending) {
    if (sending) {
      seconds = widget.duration.inSeconds;
      startTimer();
    } else {
      sendState = SendState.resend;
      if (mounted) setState(() {});
    }
  }

  void startTimer() {
    timer = 1.seconds.timerPeriodic((Timer time) {
      if (seconds < 0) {
        timer!.cancel();
        return;
      }
      seconds--;
      sendState = seconds < 0 ? SendState.resend : SendState.countDown;
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

typedef ToggleBuilder = Widget Function(Widget child);

/// 旋转组件
class ToggleRotate extends StatefulWidget {
  const ToggleRotate(
      {super.key,
      required this.child,
      this.onTap,
      this.rad = pi / 2,
      this.clockwise = true,
      this.duration = const Duration(milliseconds: 200),
      this.curve = Curves.fastOutSlowIn,
      this.toggleBuilder,
      this.isRotate = false});

  final Widget child;

  /// 是否旋转
  final bool isRotate;

  /// 点击事件
  final GestureTapCallback? onTap;

  /// 旋转角度 pi / 2
  /// 1=180℃  2=90℃
  final double rad;

  /// 动画时长
  final Duration duration;

  /// 是否顺时针旋转
  final bool clockwise;

  /// 动画曲线
  final Curve curve;

  /// 自定义非旋转区域
  final ToggleBuilder? toggleBuilder;

  @override
  State<ToggleRotate> createState() => _ToggleRotateState();
}

class _ToggleRotateState extends State<ToggleRotate>
    with SingleTickerProviderStateMixin {
  double _rad = 0;
  bool _rotated = false;
  late AnimationController _controller;
  late Animation<double> _rotate;

  @override
  void initState() {
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..addListener(listener)
      ..addStatusListener(statusListener);
    _rotate = CurvedAnimation(parent: _controller, curve: widget.curve);
    super.initState();
  }

  void statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) _rotated = !_rotated;
  }

  void listener() {
    if (mounted) {
      setState(() =>
          _rad = (_rotated ? (1 - _rotate.value) : _rotate.value) * widget.rad);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(listener);
    _controller.removeStatusListener(statusListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ToggleRotate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isRotate != widget.isRotate) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget current = Transform(
        transform: Matrix4.rotationZ(widget.clockwise ? _rad : -_rad),
        alignment: Alignment.center,
        child: widget.child);
    if (widget.toggleBuilder != null) current = widget.toggleBuilder!(current);
    if (widget.onTap != null) current = current.onTap(widget.onTap!);
    return current;
  }
}

const Duration _kExpand = Duration(milliseconds: 200);

class ExpansionTiles extends StatefulWidget {
  const ExpansionTiles({
    super.key,
    this.leading,
    required this.title,
    this.children = const <Widget>[],
    this.child,
    this.initiallyExpanded = false,
    this.subtitle,
    this.backgroundColor,
    this.onExpansionChanged,
    this.trailing,
  });

  /// 标题左侧图标，
  final Widget? leading;

  /// title:闭合时显示的标题，
  final Widget title;

  /// 副标题
  final Widget? subtitle;

  /// 展开或关闭监听
  final ValueChanged<bool>? onExpansionChanged;

  /// 子元素，
  final List<Widget> children;

  /// 自定义子元素
  final Widget? child;

  /// 展开时的背景颜色，
  final Color? backgroundColor;

  /// 右侧的箭头
  final Widget? trailing;

  /// 初始状态是否展开，
  final bool initiallyExpanded;

  @override
  State<ExpansionTiles> createState() => _ExpansionTilesState();
}

class _ExpansionTilesState extends State<ExpansionTiles>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<Color?> _headerColor;
  late Animation<Color?> _iconColor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));
    _isExpanded = widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (mounted) {
      setState(() {
        _isExpanded = !_isExpanded;
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse().then<void>((void value) {
            if (mounted) setState(() {});
          });
        }
      });
      widget.onExpansionChanged?.call(_isExpanded);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
        animation: _controller.view,
        builder: (_, Widget? child) => Universal(
                color: _backgroundColor.value ?? Colors.transparent,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTileTheme.merge(
                      iconColor: _iconColor.value,
                      textColor: _headerColor.value,
                      child: ListEntry(
                          onTap: _handleTap,
                          leading: widget.leading,
                          title: widget.title,
                          subtitle: widget.subtitle,
                          child: widget.trailing ??
                              RotationTransition(
                                turns: _iconTurns,
                                child: const Icon(Icons.expand_more),
                              ))),
                  ClipRect(
                      child: Align(
                          heightFactor: _heightFactor.value, child: child))
                ]),
        child:
            closed ? null : widget.child ?? Column(children: widget.children));
  }
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
      child: PopupModalWindows(options: widget.options, child: widget.child));
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
