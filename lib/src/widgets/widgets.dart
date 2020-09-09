import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/styles.dart';
import 'package:flutter_waya/src/constant/widgets.dart';

///发送验证码
class SendSMS extends StatefulWidget {
  final Function onTap;
  final Decoration decoration;
  final BorderRadiusGeometry borderRadius;
  final double borderWidth;
  final double width;
  final double height;
  final String defaultText;
  final String sendingText;
  final String sentText;
  final String notTapText;
  final Color defaultBorderColor;
  final Color notTapBorderColor;
  final Color background;
  final TextStyle defaultTextStyle;
  final TextStyle notTapTextStyle;
  final int seconds;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  SendSMS(
      {Key key,
      this.onTap,
      this.decoration,
      this.borderRadius,
      this.borderWidth,
      this.defaultBorderColor,
      this.notTapBorderColor,
      this.width,
      this.height,
      this.defaultText,
      this.sendingText,
      this.sentText,
      this.notTapText,
      this.defaultTextStyle,
      this.notTapTextStyle,
      this.background,
      this.seconds,
      this.margin,
      this.padding})
      : super(key: key);

  @override
  _SendSMSState createState() => _SendSMSState();
}

class _SendSMSState extends State<SendSMS> {
  int seconds = 0;
  String verifyStr;
  Timer timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      setState(() {
        verifyStr = widget.defaultText ?? '获取验证码';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Universal(
      margin: widget.margin,
      padding: widget.padding,
      onTap: (seconds == 0 && widget.onTap != null) ? onTap : null,
      alignment: Alignment.center,
      width: widget.width ?? ScreenFit.getWidth(86),
      height: widget.height ?? ScreenFit.getHeight(25),
      decoration: widget.decoration ??
          BoxDecoration(
              color: widget.background,
              border: !(widget.defaultBorderColor != null || widget.notTapBorderColor != null)
                  ? null
                  : Border.all(
                      width: widget.borderWidth ?? 0,
                      color: seconds == 0
                          ? (widget.defaultBorderColor ?? getColors(blue))
                          : (widget.notTapBorderColor ?? getColors(black70))),
              borderRadius: widget.borderRadius ?? BorderRadius.circular(20)),
      child: Text(
        '$verifyStr',
        style: seconds == 0
            ? widget.defaultTextStyle ?? WayStyles.textStyleBlue(fontSize: 13)
            : widget.notTapTextStyle ?? WayStyles.textStyleBlack70(fontSize: 13),
      ),
    );
  }

  onTap() {
    setState(() {
      verifyStr = widget.sendingText ?? '发送中';
    });
    widget.onTap(send);
  }

  send(bool sending) {
    if (sending) {
      startTimer();
    } else {
      setState(() {
        verifyStr = widget.sentText ?? '重新发送';
      });
    }
  }

  startTimer() {
    seconds = widget.seconds ?? 60;
    timer = Timer.periodic(Duration(seconds: 1), (time) {
      if (seconds == 0) {
        timer.cancel();
        return;
      }
      seconds--;
      verifyStr = '${seconds}s';
      setState(() {});
      if (seconds == 0) {
        verifyStr = widget.sentText ?? '重新发送';
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) timer.cancel();
  }
}

///点击跳过
class CountDownSkip extends StatefulWidget {
  final String skipText;
  final int seconds;
  final TextStyle textStyle;
  final ValueChanged<int> onChange;
  final GestureTapCallback onTap;
  final Decoration decoration;

  CountDownSkip({
    Key key,
    String skipText,
    int seconds,
    this.textStyle,
    this.onChange,
    this.onTap,
    this.decoration,
  })  : this.skipText = skipText ?? '',
        this.seconds = seconds ?? 5,
        super(key: key);

  @override
  _CountDownSkipState createState() => _CountDownSkipState();
}

class _CountDownSkipState extends State<CountDownSkip> {
  int seconds = 5;
  Timer timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      seconds = widget.seconds;
      startTime();
    });
  }

  startTime() {
    if (seconds > 0) {
      timer = Tools.timerPeriodic(Duration(seconds: 1), (time) {
        seconds -= 1;
        setState(() {});
        if (widget.onChange is ValueChanged<int>) {
          widget.onChange(seconds);
        }
        if (seconds == 0) timer.cancel();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleButton(
      onTap: widget.onTap,
      decoration: widget.decoration ?? BoxDecoration(color: getColors(white50), borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.symmetric(horizontal: ScreenFit.getHeight(5), vertical: ScreenFit.getWidth(4)),
      child: Widgets.textSmall(seconds.toString() + 's' + widget.skipText),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Tools.timerCancel();
  }
}

///侧滑菜单
class CustomDismissible extends StatelessWidget {
  ///子组件
  final Widget child;

  ///滑动时组件下一层显示的内容
  ///没有设置secondaryBackground时，从右往左或者从左往右滑动都显示该内容
  ///设置了secondaryBackground后，从左往右滑动显示该内容，从右往左滑动显示secondaryBackground的内容
  final Widget background;

  ///不能单独设置，只能在已经设置了background后才能设置，从右往左滑动时显示
  final Widget secondaryBackground;

  ///组件消失前回调，可以弹出是否消失确认窗口。
  final ConfirmDismissCallback confirmDismiss;

  ///组件大小改变时回调
  final VoidCallback onResize;

  ///组件消失后回调
  final DismissDirectionCallback onDismissed;

  /// 滑动方向（水平、垂直）
  ///默认DismissDirection.horizontal 水平
  final DismissDirection direction;

  ///组件大小改变的时长，默认300毫秒。Duration(milliseconds: 300)
  final Duration resizeDuration;

  ///必须拖动项目的偏移阈值才能被视为已解除
  final Map<DismissDirection, double> dismissThresholds;

  ///组件消失的时长，默认200毫秒。Duration(milliseconds: 200)
  final Duration movementDuration;

  ///滑动时偏移量，默认0.0，
  final double crossAxisEndOffset;

  ///拖动消失后组件大小改变方式
  ///start：下面组件向上滑动
  ///down：上面组件向下滑动
  ///默认DragStartBehavior.start
  final DragStartBehavior dragStartBehavior;

  const CustomDismissible(
      {Key key,
      this.background,
      this.secondaryBackground,
      this.confirmDismiss,
      this.onResize,
      this.onDismissed,
      DismissDirection direction,
      Duration resizeDuration,
      Map<DismissDirection, double> dismissThresholds,
      Duration movementDuration,
      double crossAxisEndOffset,
      DragStartBehavior dragStartBehavior,
      this.child})
      : this.direction = direction ?? DismissDirection.horizontal,
        this.resizeDuration = resizeDuration ?? const Duration(milliseconds: 300),
        this.dismissThresholds = dismissThresholds ?? const <DismissDirection, double>{},
        this.movementDuration = movementDuration ?? const Duration(milliseconds: 200),
        this.crossAxisEndOffset = crossAxisEndOffset ?? 0.0,
        this.dragStartBehavior = dragStartBehavior ?? DragStartBehavior.start,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      child: child,
      key: key,
      background: background,
      secondaryBackground: secondaryBackground,
      confirmDismiss: confirmDismiss,
      onResize: onResize,
      onDismissed: onDismissed,
      direction: direction,
      resizeDuration: resizeDuration,
      dismissThresholds: dismissThresholds,
      movementDuration: movementDuration,
      crossAxisEndOffset: crossAxisEndOffset,
      dragStartBehavior: dragStartBehavior,
    );
  }
}

///组件右上角加红点
class HintDot extends StatelessWidget {
  final Widget child;
  final Widget pointChild;
  final double width;
  final double height;
  final GestureTapCallback onTap;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry pointPadding;
  final Color pointColor;
  final double pointSize;
  final bool hide;
  final double top;
  final double right;
  final double bottom;
  final double left;
  final AlignmentGeometry alignment;

  const HintDot(
      {Key key,
      @required this.child,
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
      bool hide,
      this.pointChild,
      this.alignment})
      : this.hide = hide ?? false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hide) return child;
    List<Widget> children = [];
    if (child != null) children.add(child);
    Widget dot = dotWidget();
    if (alignment != null) dot = Align(alignment: alignment, child: dot);
    if (right != null || top != null || bottom != null || left != null)
      dot = Positioned(right: right, top: top, bottom: bottom, left: left, child: dot);
    if (dot != null) children.add(dot);
    return Universal(
      onTap: onTap,
      margin: margin,
      width: width,
      height: height,
      isStack: true,
      children: children,
    );
  }

  Widget dotWidget() => Container(
        child: pointChild,
        padding: pointPadding,
        width: pointChild == null ? (pointSize ?? ScreenFit.getWidth(4)) : null,
        height: pointChild == null ? (pointSize ?? ScreenFit.getWidth(4)) : null,
        decoration: BoxDecoration(color: pointColor ?? getColors(red), shape: BoxShape.circle),
      );
}
