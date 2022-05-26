import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

enum CircularStrokeCap { butt, round, square }

enum LinearStrokeCap { butt, round, roundAll }

enum ArcType { half, full }

class Progress extends StatefulWidget {
  const Progress.linear({
    Key? key,
    this.percent = 0.0,
    this.lineHeight = 5.0,
    this.width,
    this.backgroundColor,
    this.progressColor,
    this.linearGradient,
    this.animation = false,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animateFromLastPercent = true,
    this.isRTL = false,
    this.center,
    this.addAutomaticKeepAlive = true,
    this.linearStrokeCap = LinearStrokeCap.butt,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.maskFilter,
    this.clipLinearGradient = false,
    this.curve = Curves.linear,
    this.restartAnimation = false,
    this.onAnimationEnd,
    this.widgetIndicator,
  })  : assert(linearGradient != null || progressColor != null,
            'Cannot provide both linearGradient and progressColor'),
        super(key: key);

  /// Percent value between 0.0 and 1.0
  final double percent;

  /// First color applied to the complete line
  final Color? backgroundColor;

  /// progressColor
  final Color? progressColor;

  /// true if you want the Line to have animation
  final bool animation;

  /// duration of the animation in milliseconds, It only applies if animation
  /// attribute is true
  final Duration animationDuration;

  /// widget inside the Line
  final Widget? center;

  /// set true if you want to animate the linear from the last percent value you set
  final bool animateFromLastPercent;

  /// If present, this will make the progress bar colored by this gradient.
  ///
  /// This will override [progressColor]. It is an error to provide both.
  final LinearGradient? linearGradient;

  /// set false if you don't want to preserve the state of the widget
  final bool addAutomaticKeepAlive;

  /// Creates a mask filter that takes the progress shape being drawn and blurs it.
  final MaskFilter? maskFilter;

  /// set a linear curve animation type
  final Curve curve;

  /// set true when you want to restart the animation, it restarts only when reaches 1.0 as a value
  /// defaults to false
  final bool restartAnimation;

  /// Callback called when the animation ends (only if `animation` is true)
  final VoidCallback? onAnimationEnd;

  /// Display a widget indicator at the end of the progress. It only works when `animation` is true
  final Widget? widgetIndicator;

  //// linear

  /// Percent value between 0.0 and 1.0
  final double? width;

  /// Height of the line
  final double lineHeight;

  /// The kind of finish to place on the end of lines drawn, values
  /// supported: butt, round, roundAll
  final LinearStrokeCap linearStrokeCap;

  /// mainAxisAlignment of the Row
  final MainAxisAlignment mainAxisAlignment;

  /// set true if you want to animate the linear from the right to left (RTL)
  final bool isRTL;

  /// Set true if you want to display only part of [linearGradient] based on percent value
  /// (ie. create 'VU effect'). If no [linearGradient] is specified this option is ignored.
  final bool clipLinearGradient;

  @override
  State<StatefulWidget> createState() => _LinearState();
}

abstract class _ProgressSubState extends State<Progress>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController? animationController;
  Animation<double>? animation;
  double percent = 0.0;

  @override
  void initState() {
    if (!widget.animation) percent = widget.percent;
    if (widget.animation && widget.percent > 0) {
      animationController =
          AnimationController(vsync: this, duration: widget.animationDuration);
      animation = Tween<double>(begin: 0.0, end: widget.percent).animate(
        CurvedAnimation(parent: animationController!, curve: widget.curve),
      )..addListener(() {
          percent = animation!.value;
          if (mounted) setState(() {});
          if (widget.restartAnimation && percent == 1.0) {
            animationController!.repeat(min: 0, max: 1.0);
          }
        });
      animationController!.addStatusListener((AnimationStatus status) {
        if (widget.onAnimationEnd != null &&
            status == AnimationStatus.completed) widget.onAnimationEnd!();
      });
      animationController!.forward();
    }
    super.initState();
  }

  @override
  void didUpdateWidget(Progress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percent != widget.percent) {
      if (animationController != null && widget.percent > 0) {
        animationController!.duration = widget.animationDuration;
        animation = Tween<double>(
                begin: widget.animateFromLastPercent ? oldWidget.percent : 0.0,
                end: widget.percent)
            .animate(CurvedAnimation(
                parent: animationController!, curve: widget.curve));
        animationController!.forward(from: 0.0);
      } else {
        percent = widget.percent;
        if (mounted) setState(() {});
      }
    }
    if (oldWidget.animation && !widget.animation) animationController?.stop();
  }

  @override
  bool get wantKeepAlive => widget.addAutomaticKeepAlive;

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }
}

class _LinearState extends _ProgressSubState {
  final GlobalKey<State<StatefulWidget>> _containerKey = GlobalKey();
  final GlobalKey<State<StatefulWidget>> _keyIndicator = GlobalKey();
  double _containerWidth = 0.0;
  double _indicatorWidth = 0.0;

  @override
  void initState() {
    addPostFrameCallback((_) {
      if (mounted) {
        _containerWidth = _containerKey.currentContext!.size!.width;
        if (_keyIndicator.currentContext != null) {
          _indicatorWidth = _keyIndicator.currentContext!.size!.width;
        }
        if (mounted) setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double percentPositionedHorizontal =
        _containerWidth * percent - _indicatorWidth / 3;
    final Stack bar = Stack(children: <Widget>[
      CustomPaint(
          key: _containerKey,
          painter: _LinearPainter(
              isRTL: widget.isRTL,
              progress: percent,
              progressColor: widget.progressColor ??
                  context.theme.progressIndicatorTheme.color ??
                  context.theme.primaryColor,
              linearGradient: widget.linearGradient,
              backgroundColor:
                  widget.backgroundColor ?? context.theme.backgroundColor,
              linearStrokeCap: widget.linearStrokeCap,
              lineWidth: widget.lineHeight,
              maskFilter: widget.maskFilter,
              clipLinearGradient: widget.clipLinearGradient),
          child: (widget.center != null)
              ? Center(child: widget.center)
              : Container()),
      if (widget.widgetIndicator != null && _indicatorWidth == 0)
        Opacity(
            opacity: 0.0, key: _keyIndicator, child: widget.widgetIndicator),
      if (widget.widgetIndicator != null &&
          _containerWidth > 0 &&
          _indicatorWidth > 0)
        Positioned(
            right: widget.isRTL ? percentPositionedHorizontal : null,
            left: !widget.isRTL ? percentPositionedHorizontal : null,
            top: 0,
            child: widget.widgetIndicator!),
    ]);
    return Universal(
        height: widget.lineHeight,
        width: widget.width ?? double.infinity,
        child: bar);
  }
}

class _LinearPainter extends CustomPainter {
  _LinearPainter({
    required this.lineWidth,
    required this.progress,
    required this.isRTL,
    required this.progressColor,
    required this.backgroundColor,
    this.linearStrokeCap = LinearStrokeCap.butt,
    this.linearGradient,
    this.maskFilter,
    required this.clipLinearGradient,
  }) {
    _paintBackground.color = backgroundColor;
    _paintBackground.style = PaintingStyle.stroke;
    _paintBackground.strokeWidth = lineWidth;

    _paintLine.color = progress.toString() == '0.0'
        ? progressColor.withOpacity(0.0)
        : progressColor;
    _paintLine.style = PaintingStyle.stroke;
    _paintLine.strokeWidth = lineWidth;

    if (linearStrokeCap == LinearStrokeCap.round) {
      _paintLine.strokeCap = StrokeCap.round;
    } else if (linearStrokeCap == LinearStrokeCap.butt) {
      _paintLine.strokeCap = StrokeCap.butt;
    } else {
      _paintLine.strokeCap = StrokeCap.round;
      _paintBackground.strokeCap = StrokeCap.round;
    }
  }

  final Paint _paintBackground = Paint();
  final Paint _paintLine = Paint();
  final double lineWidth;
  final double progress;
  final bool isRTL;
  final Color progressColor;
  final Color backgroundColor;
  final LinearStrokeCap linearStrokeCap;
  final LinearGradient? linearGradient;
  final MaskFilter? maskFilter;
  final bool clipLinearGradient;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset start = Offset(0.0, size.height / 2);
    final Offset end = Offset(size.width, size.height / 2);
    canvas.drawLine(start, end, _paintBackground);
    if (maskFilter != null) _paintLine.maskFilter = maskFilter;

    if (isRTL) {
      final double xProgress = size.width - size.width * progress;
      if (linearGradient != null) {
        _paintLine.shader = _createGradientShaderRightToLeft(size, xProgress);
      }
      canvas.drawLine(end, Offset(xProgress, size.height / 2), _paintLine);
    } else {
      final double xProgress = size.width * progress;
      if (linearGradient != null) {
        _paintLine.shader = _createGradientShaderLeftToRight(size, xProgress);
      }
      canvas.drawLine(start, Offset(xProgress, size.height / 2), _paintLine);
    }
  }

  Shader _createGradientShaderRightToLeft(Size size, double xProgress) {
    final Offset shaderEndPoint =
        clipLinearGradient ? Offset.zero : Offset(xProgress, size.height);
    return linearGradient!.createShader(
        Rect.fromPoints(Offset(size.width, size.height), shaderEndPoint));
  }

  Shader _createGradientShaderLeftToRight(Size size, double xProgress) {
    final Offset shaderEndPoint = clipLinearGradient
        ? Offset(size.width, size.height)
        : Offset(xProgress, size.height);
    return linearGradient!
        .createShader(Rect.fromPoints(Offset.zero, shaderEndPoint));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

double _radians(num deg) => (deg * (math.pi / 180.0)).toDouble();
