import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

export 'button/bubble_button.dart';
export 'button/cloth_button.dart';
export 'button/dropdown_button.dart';
export 'button/elastic_button.dart';
export 'button/liquid_button.dart';
export 'carousel/carousel.dart';
export 'carousel/indicator.dart';
export 'carousel/pagination.dart';
export 'counter.dart';
export 'dialog/picker.dart';
export 'dialog/popup.dart';
export 'dotted_line.dart';
export 'draggable_scrollbar.dart';
export 'gesture_widgets.dart';
export 'image.dart';
export 'json_parse.dart';
export 'progress/liquid_progress.dart';
export 'progress/progress.dart';
export 'progress/wave.dart';
export 'refresh/easy_refresh.dart';
export 'refresh/scroll_physics.dart';
export 'refresh/simple_refresh.dart';
export 'simple_builder.dart';
export 'stretchy_header.dart';

class NoScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
          BuildContext context, Widget child, AxisDirection axisDirection) =>
      child;
}

typedef SendSMSValueCallback = void Function(void Function(bool send));

///  发送验证码
class SendSMS extends StatefulWidget {
  const SendSMS(
      {Key? key,
      this.defaultText = '获取验证码',
      this.sendingText = '发送中',
      this.sentText = '重新发送',
      this.notTapText = '重新发送',
      this.onTap,
      this.decoration,
      this.borderRadius,
      this.borderWidth,
      this.defaultBorderColor,
      this.notTapBorderColor,
      this.width,
      this.height,
      this.defaultTextStyle,
      this.notTapTextStyle,
      this.background,
      this.seconds,
      this.margin,
      this.padding})
      : super(key: key);

  final String defaultText;
  final String sendingText;
  final String sentText;
  final String notTapText;

  final SendSMSValueCallback? onTap;
  final Decoration? decoration;
  final BorderRadiusGeometry? borderRadius;
  final double? borderWidth;
  final double? width;
  final double? height;
  final Color? defaultBorderColor;
  final Color? notTapBorderColor;
  final Color? background;
  final TextStyle? defaultTextStyle;
  final TextStyle? notTapTextStyle;
  final int? seconds;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  _SendSMSState createState() => _SendSMSState();
}

class _SendSMSState extends State<SendSMS> {
  int seconds = 0;
  late String verifyStr;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    verifyStr = widget.defaultText;
  }

  @override
  Widget build(BuildContext context) => Universal(
        margin: widget.margin,
        padding: widget.padding,
        onTap: (seconds == 0 && widget.onTap != null) ? onTap : null,
        alignment: Alignment.center,
        width: widget.width,
        height: widget.height,
        decoration: widget.decoration ??
            BoxDecoration(
                color: widget.background,
                border: !(widget.defaultBorderColor != null ||
                        widget.notTapBorderColor != null)
                    ? null
                    : Border.all(
                        width: widget.borderWidth ?? 0,
                        color: seconds == 0
                            ? (widget.defaultBorderColor ?? ConstColors.blue)
                            : (widget.notTapBorderColor ??
                                ConstColors.black70)),
                borderRadius: widget.borderRadius ?? BorderRadius.circular(20)),
        child: BText(verifyStr,
            style: seconds == 0
                ? const BTextStyle(fontSize: 13, color: ConstColors.blue)
                    .merge(widget.defaultTextStyle)
                : const BTextStyle(fontSize: 13, color: ConstColors.black70)
                    .merge(widget.notTapTextStyle)),
      );

  void onTap() {
    verifyStr = widget.sendingText;
    setState(() {});
    if (widget.onTap != null) widget.onTap!(send);
  }

  void send(bool sending) {
    if (sending) {
      startTimer();
    } else {
      verifyStr = widget.sentText;
      setState(() {});
    }
  }

  void startTimer() {
    seconds = widget.seconds ?? 60;
    timer = 1.seconds.timerPeriodic((Timer time) {
      if (seconds == 0) {
        timer!.cancel();
        return;
      }
      seconds--;
      verifyStr = '${seconds}s';
      setState(() {});
      if (seconds == 0) verifyStr = widget.sentText;
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

///  点击跳过
class CountDownSkip extends StatefulWidget {
  const CountDownSkip({
    Key? key,
    this.skipText = '',
    this.seconds = 5,
    this.textStyle,
    this.onChange,
    this.onTap,
    this.decoration,
  }) : super(key: key);

  final String skipText;
  final int seconds;

  final TextStyle? textStyle;
  final ValueChanged<int>? onChange;
  final GestureTapCallback? onTap;
  final Decoration? decoration;

  @override
  _CountDownSkipState createState() => _CountDownSkipState();
}

class _CountDownSkipState extends State<CountDownSkip> {
  late int seconds;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    seconds = widget.seconds;
    addPostFrameCallback((Duration callback) {
      if (seconds > 0) {
        timer = Timer.periodic(const Duration(seconds: 1), (Timer time) {
          seconds -= 1;
          setState(() {});
          if (widget.onChange != null) widget.onChange!(seconds);
          if (seconds == 0) timer?.cancel();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => SimpleButton(
      onTap: widget.onTap,
      decoration: widget.decoration ??
          BoxDecoration(
              color: ConstColors.white50,
              borderRadius: BorderRadius.circular(5)),
      padding:
          EdgeInsets.symmetric(horizontal: getHeight(5), vertical: getWidth(4)),
      child: BText(seconds.toString() + 's' + widget.skipText, fontSize: 12));

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    timer = null;
  }
}

///  侧滑菜单
class CustomDismissible extends Dismissible {
  const CustomDismissible({
    required Key key,
    required Widget child,

    ///  滑动时组件下一层显示的内容
    ///  没有设置secondaryBackground时，从右往左或者从左往右滑动都显示该内容
    ///  设置了secondaryBackground后，从左往右滑动显示该内容，从右往左滑动显示secondaryBackground的内容
    Widget? background,

    ///  不能单独设置，只能在已经设置了background后才能设置，从右往左滑动时显示
    Widget? secondaryBackground,

    ///  组件消失前回调，可以弹出是否消失确认窗口。
    ConfirmDismissCallback? confirmDismiss,

    ///  组件大小改变时回调
    VoidCallback? onResize,

    ///  组件消失后回调
    DismissDirectionCallback? onDismissed,

    ///  滑动方向（水平、垂直）
    ///  默认DismissDirection.horizontal 水平
    DismissDirection? direction,

    ///  组件大小改变的时长，默认300毫秒。Duration(milliseconds: 300)
    Duration? resizeDuration,

    ///  必须拖动项目的偏移阈值才能被视为已解除
    Map<DismissDirection, double>? dismissThresholds,

    ///  组件消失的时长，默认200毫秒。Duration(milliseconds: 200)
    Duration? movementDuration,

    ///  滑动时偏移量，默认0.0，
    double? crossAxisEndOffset,

    ///  拖动消失后组件大小改变方式
    ///  start：下面组件向上滑动
    ///  down：上面组件向下滑动
    ///  默认DragStartBehavior.start
    DragStartBehavior? dragStartBehavior,
  }) : super(
          key: key,
          child: child,
          background: background,
          secondaryBackground: secondaryBackground,
          confirmDismiss: confirmDismiss,
          onResize: onResize,
          onDismissed: onDismissed,
          direction: direction ?? DismissDirection.horizontal,
          resizeDuration: resizeDuration ?? const Duration(milliseconds: 300),
          dismissThresholds:
              dismissThresholds ?? const <DismissDirection, double>{},
          movementDuration:
              movementDuration ?? const Duration(milliseconds: 200),
          crossAxisEndOffset: crossAxisEndOffset ?? 0.0,
          dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
        );
}

///  组件右上角加红点
class Badge extends StatelessWidget {
  const Badge(
      {Key? key,
      required this.child,
      this.hide = false,
      this.pointPadding,
      this.width,
      this.height,
      this.onTap,
      this.margin,
      this.pointColor,
      this.top,
      this.right,
      this.bottom,
      this.left,
      this.pointSize,
      this.pointChild,
      this.alignment})
      : super(key: key);

  final bool hide;
  final Widget child;

  final Widget? pointChild;
  final double? width;
  final double? height;
  final GestureTapCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? pointPadding;
  final Color? pointColor;
  final double? pointSize;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    if (hide) return child;
    final List<Widget> children = <Widget>[child];
    Widget dot = dotWidget;
    if (alignment != null) dot = Align(alignment: alignment!, child: dot);
    if (right != null || top != null || bottom != null || left != null)
      dot = Positioned(
          right: right, top: top, bottom: bottom, left: left, child: dot);
    children.add(dot);
    return Universal(
        onTap: onTap,
        margin: margin,
        width: width,
        height: height,
        isStack: true,
        children: children);
  }

  Widget get dotWidget => Container(
      child: pointChild,
      padding: pointPadding,
      width: pointChild == null ? (pointSize ?? 4) : null,
      height: pointChild == null ? (pointSize ?? 4) : null,
      decoration: BoxDecoration(
          color: pointColor ?? ConstColors.red, shape: BoxShape.circle));
}

typedef ToggleBuilder = Widget Function(Widget child);

/// 旋转组件
class ToggleRotate extends StatefulWidget {
  const ToggleRotate(
      {Key? key,
      required this.child,
      this.onTap,
      this.rad = pi / 2,
      this.clockwise = true,
      this.duration = const Duration(milliseconds: 200),
      this.curve = Curves.fastOutSlowIn,
      this.toggleBuilder,
      this.isRotate = false})
      : super(key: key);

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
  _ToggleRotateState createState() => _ToggleRotateState();
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
      ..addListener(() => setState(() =>
          _rad = (_rotated ? (1 - _rotate.value) : _rotate.value) * widget.rad))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) _rotated = !_rotated;
      });
    _rotate = CurvedAnimation(parent: _controller, curve: widget.curve);
    super.initState();
  }

  @override
  void dispose() {
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
    if (widget.onTap != null) {
      current = current.onTap(() {
        /// _controller.reset();
        /// _controller.forward();
        if (widget.onTap != null) widget.onTap!();
      });
    }
    return current;
  }
}

const Duration _kExpand = Duration(milliseconds: 200);

class ExpansionTiles extends StatefulWidget {
  const ExpansionTiles({
    Key? key,
    this.leading,
    required this.title,
    this.children = const <Widget>[],
    this.initiallyExpanded = false,
    this.subtitle,
    this.backgroundColor,
    this.onExpansionChanged,
    this.trailing,
  }) : super(key: key);

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

  ///  展开时的背景颜色，
  final Color? backgroundColor;

  ///  右侧的箭头
  final Widget? trailing;

  /// 初始状态是否展开，
  final bool initiallyExpanded;

  @override
  _ExpansionTilesState createState() => _ExpansionTilesState();
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
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {});
        });
      }
    });
    if (widget.onExpansionChanged != null)
      widget.onExpansionChanged!(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
        animation: _controller.view,
        builder: (BuildContext context, Widget? child) => Universal(
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
        child: closed ? null : Column(children: widget.children));
  }
}

class CustomDrawer extends StatefulWidget {
  CustomDrawer({
    Key? key,
    double? width,
    this.elevation = 16.0,
    required this.child,
    this.backgroundColor,
    this.callback,
  })  : width = width ?? deviceWidth * 0.7,
        super(key: key);

  final Color? backgroundColor;
  final Widget child;
  final DrawerCallback? callback;
  final double width;
  final double elevation;

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    if (widget.callback != null) widget.callback!(true);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.callback != null) widget.callback!(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.width),
      child: PopupOptions(color: widget.backgroundColor, child: widget.child));
}
