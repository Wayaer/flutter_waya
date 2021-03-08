import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class Progress extends StatefulWidget {
  Progress.circular({
    Key? key,
    this.percent = 0.0,
    this.lineWidth = 5.0,
    this.startAngle = 0.0,
    required this.radius,
    Color? backgroundColor,
    Color? progressColor,
    this.backgroundWidth = -1,
    this.linearGradient,
    this.animation = false,
    this.animationDuration = const Duration(milliseconds: 500),
    this.header,
    this.footer,
    this.center,
    this.addAutomaticKeepAlive = true,
    this.circularStrokeCap = CircularStrokeCap.round,
    this.arcBackgroundColor,
    this.arcType,
    this.animateFromLastPercent = false,
    this.reverse = false,
    this.curve = Curves.linear,
    this.maskFilter,
    this.restartAnimation = false,
    this.onAnimationEnd,
    this.widgetIndicator,
    this.rotateLinearGradient = false,
  })  : assert(startAngle! >= 0.0),
        assert(linearGradient != null || progressColor != null,
            'Cannot provide both linearGradient and progressColor'),
        assert(percent > 0.0 || percent < 1.0,
            'Percent value must be a double between 0.0 and 1.0'),
        assert(arcType == null || arcBackgroundColor != null,
            'arcType is required when you arcBackgroundColor'),
        backgroundColor = backgroundColor ?? ConstColors.black30,
        progressColor = progressColor ?? ConstColors.red,
        state = _CircularState(),
        width = null,
        lineHeight = 0,
        leading = null,
        trailing = null,
        linearStrokeCap = LinearStrokeCap.butt,
        mainAxisAlignment = MainAxisAlignment.start,
        padding = const EdgeInsets.symmetric(horizontal: 10.0),
        isRTL = false,
        clipLinearGradient = false,
        super(key: key);

  Progress.linear({
    Key? key,
    this.percent = 0.0,
    this.lineHeight = 5.0,
    this.width,
    Color? backgroundColor,
    Color? progressColor,
    this.linearGradient,
    this.animation = false,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animateFromLastPercent = true,
    this.isRTL = false,
    this.leading,
    this.trailing,
    this.center,
    this.addAutomaticKeepAlive = true,
    this.linearStrokeCap = LinearStrokeCap.butt,
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0),
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.maskFilter,
    this.clipLinearGradient = false,
    this.curve = Curves.linear,
    this.restartAnimation = false,
    this.onAnimationEnd,
    this.widgetIndicator,
  })  : backgroundColor = backgroundColor ?? ConstColors.black30,
        progressColor = progressColor ?? ConstColors.red,
        assert(linearGradient != null || progressColor != null,
            'Cannot provide both linearGradient and progressColor'),
        assert(percent > 0.0 || percent < 1.0,
            'Percent value must be a double between 0.0 and 1.0'),
        state = _LinearState(),
        radius = 0,
        lineWidth = 5.0,
        backgroundWidth = 1,
        header = null,
        footer = null,
        circularStrokeCap = CircularStrokeCap.round,
        startAngle = null,
        arcType = null,
        arcBackgroundColor = null,
        reverse = false,
        rotateLinearGradient = null,
        super(key: key);

  /// Percent value between 0.0 and 1.0
  final double percent;

  /// First color applied to the complete line
  final Color backgroundColor;

  /// progressColor
  final Color progressColor;

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

  //// circular

  /// Percent value between 0.0 and 1.0
  final double radius;

  /// Width of the progress bar of the circle
  final double lineWidth;

  /// Width of the unfilled background of the progress bar
  final double? backgroundWidth;

  /// widget at the top of the circle
  final Widget? header;

  /// widget at the bottom of the circle
  final Widget? footer;

  /// The kind of finish to place on the end of lines drawn, values
  /// supported: butt, round, square
  final CircularStrokeCap circularStrokeCap;

  /// the angle which the circle will start the progress (in degrees, eg: 0
  /// .0, 45.0, 90.0)
  final double? startAngle;

  /// set the arc type
  final ArcType? arcType;

  /// set a circular background color when use the arcType property
  final Color? arcBackgroundColor;

  /// set true when you want to display the progress in reverse mode
  final bool reverse;

  /// Set to true if you want to rotate linear gradient in accordance to the [startAngle].
  final bool? rotateLinearGradient;

  //// linear

  /// Percent value between 0.0 and 1.0
  final double? width;

  /// Height of the line
  final double lineHeight;

  /// widget at the left of the Line
  final Widget? leading;

  /// widget at the right of the Line
  final Widget? trailing;

  /// The kind of finish to place on the end of lines drawn, values
  /// supported: butt, round, roundAll
  final LinearStrokeCap linearStrokeCap;

  /// mainAxisAlignment of the Row (leading-widget-center-trailing)
  final MainAxisAlignment mainAxisAlignment;

  /// padding to the LinearProgress
  final EdgeInsets padding;

  /// set true if you want to animate the linear from the right to left (RTL)
  final bool isRTL;

  /// Set true if you want to display only part of [linearGradient] based on percent value
  /// (ie. create 'VU effect'). If no [linearGradient] is specified this option is ignored.
  final bool clipLinearGradient;

  final State<StatefulWidget> state;

  @override
  State<StatefulWidget> createState() => state;
}

abstract class _ProgressSubState extends State<Progress>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController? animationController;
  Animation<double>? animation;
  double percent = 0.0;

  @override
  void initState() {
    if (!widget.animation) percent = widget.percent;
    if (widget.animation) {
      animationController =
          AnimationController(vsync: this, duration: widget.animationDuration);
      animation = Tween<double>(begin: 0.0, end: widget.percent).animate(
        CurvedAnimation(parent: animationController!, curve: widget.curve),
      )..addListener(() {
          percent = animation!.value;
          setState(() {});
          if (widget.restartAnimation && percent == 1.0)
            animationController!.repeat(min: 0, max: 1.0);
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
      if (animationController != null) {
        animationController!.duration = widget.animationDuration;
        animation = Tween<double>(
                begin: widget.animateFromLastPercent ? oldWidget.percent : 0.0,
                end: widget.percent)
            .animate(
          CurvedAnimation(parent: animationController!, curve: widget.curve),
        );
        animationController!.forward(from: 0.0);
      } else {
        percent = widget.percent;
        setState(() {});
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

class _CircularState extends _ProgressSubState {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final List<Widget> items = <Widget>[];
    if (widget.header != null) items.add(widget.header!);
    items.add(Universal(
        isStack: true,
        height: widget.radius + widget.lineWidth,
        width: widget.radius,
        children: <Widget>[
          CustomPaint(
            painter: _CirclePainter(
                progress: percent * 360,
                progressColor: widget.progressColor,
                backgroundColor: widget.backgroundColor,
                startAngle: widget.startAngle!,
                circularStrokeCap: widget.circularStrokeCap,
                radius: (widget.radius / 2) - widget.lineWidth / 2,
                lineWidth: widget.lineWidth,
                backgroundWidth: //negative values ignored, replaced with lineWidth
                    widget.backgroundWidth! >= 0.0
                        ? widget.backgroundWidth!
                        : widget.lineWidth,
                arcBackgroundColor: widget.arcBackgroundColor,
                arcType: widget.arcType,
                reverse: widget.reverse,
                linearGradient: widget.linearGradient,
                maskFilter: widget.maskFilter,
                rotateLinearGradient: widget.rotateLinearGradient!),
            child: (widget.center != null)
                ? Center(child: widget.center)
                : Container(),
          ),
          if (widget.widgetIndicator != null && widget.animation)
            Positioned.fill(
                child: Transform.rotate(
              angle: radians(
                  (widget.circularStrokeCap != CircularStrokeCap.butt &&
                          widget.reverse)
                      ? -15
                      : 0),
              child: Transform.rotate(
                  angle: radians((widget.reverse ? -360 : 360) * percent),
                  child: Transform.translate(
                      offset: Offset(
                          (widget.circularStrokeCap != CircularStrokeCap.butt)
                              ? widget.lineWidth / 2
                              : 0,
                          -widget.radius / 2 + widget.lineWidth / 2),
                      child: widget.widgetIndicator)),
            ))
        ]));

    if (widget.footer != null) items.add(widget.footer!);
    return Universal(mainAxisSize: MainAxisSize.min, children: items);
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
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final List<Widget> items = <Widget>[];
    if (widget.leading != null) items.add(widget.leading!);
    final double percentPositionedHorizontal =
        _containerWidth * percent - _indicatorWidth / 3;
    final Stack bar = Stack(children: <Widget>[
      CustomPaint(
          key: _containerKey,
          painter: _LinearPainter(
              isRTL: widget.isRTL,
              progress: percent,
              progressColor: widget.progressColor,
              linearGradient: widget.linearGradient,
              backgroundColor: widget.backgroundColor,
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
    items.add(bar);
    if (widget.trailing != null)
      items.add(Align(alignment: Alignment.center, child: widget.trailing));
    return Universal(
        height: widget.lineHeight,
        isStack: true,
        padding: widget.padding,
        width: widget.width ?? double.infinity,
        children: items);
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
      if (linearGradient != null)
        _paintLine.shader = _createGradientShaderRightToLeft(size, xProgress);
      canvas.drawLine(end, Offset(xProgress, size.height / 2), _paintLine);
    } else {
      final double xProgress = size.width * progress;
      if (linearGradient != null)
        _paintLine.shader = _createGradientShaderLeftToRight(size, xProgress);
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

class _CirclePainter extends CustomPainter {
  _CirclePainter(
      {required this.lineWidth,
      required this.backgroundWidth,
      required this.progress,
      required this.radius,
      required this.progressColor,
      required this.backgroundColor,
      this.startAngle = 0.0,
      this.circularStrokeCap = CircularStrokeCap.round,
      this.linearGradient,
      this.reverse = false,
      this.arcBackgroundColor,
      this.arcType,
      this.maskFilter,
      required this.rotateLinearGradient}) {
    _paintBackground.color = backgroundColor;
    _paintBackground.style = PaintingStyle.stroke;
    _paintBackground.strokeWidth = backgroundWidth;
    if (circularStrokeCap == CircularStrokeCap.round) {
      _paintBackground.strokeCap = StrokeCap.round;
    } else if (circularStrokeCap == CircularStrokeCap.butt) {
      _paintBackground.strokeCap = StrokeCap.butt;
    } else {
      _paintBackground.strokeCap = StrokeCap.square;
    }
    if (arcBackgroundColor != null) {
      _paintBackgroundStartAngle.color = arcBackgroundColor!;
      _paintBackgroundStartAngle.style = PaintingStyle.stroke;
      _paintBackgroundStartAngle.strokeWidth = lineWidth;
      if (circularStrokeCap == CircularStrokeCap.round) {
        _paintBackgroundStartAngle.strokeCap = StrokeCap.round;
      } else if (circularStrokeCap == CircularStrokeCap.butt) {
        _paintBackgroundStartAngle.strokeCap = StrokeCap.butt;
      } else {
        _paintBackgroundStartAngle.strokeCap = StrokeCap.square;
      }
    }

    _paintLine.color = progressColor;
    _paintLine.style = PaintingStyle.stroke;
    _paintLine.strokeWidth = lineWidth;
    if (circularStrokeCap == CircularStrokeCap.round) {
      _paintLine.strokeCap = StrokeCap.round;
    } else if (circularStrokeCap == CircularStrokeCap.butt) {
      _paintLine.strokeCap = StrokeCap.butt;
    } else {
      _paintLine.strokeCap = StrokeCap.square;
    }
  }

  final Paint _paintBackground = Paint();
  final Paint _paintLine = Paint();
  final Paint _paintBackgroundStartAngle = Paint();
  final double lineWidth;
  final double backgroundWidth;
  final double progress;
  final double radius;
  final Color progressColor;
  final Color backgroundColor;
  final CircularStrokeCap circularStrokeCap;
  final double startAngle;
  final LinearGradient? linearGradient;
  final Color? arcBackgroundColor;
  final ArcType? arcType;
  final bool reverse;
  final MaskFilter? maskFilter;
  final bool rotateLinearGradient;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    double fixedStartAngle = startAngle;
    final Rect rectForArc = Rect.fromCircle(center: center, radius: radius);
    double startAngleFixedMargin = 1.0;
    if (arcType != null) {
      if (arcType == ArcType.full) {
        fixedStartAngle = 220;
        startAngleFixedMargin = 172 / fixedStartAngle;
      } else {
        fixedStartAngle = 270;
        startAngleFixedMargin = 135 / fixedStartAngle;
      }
    }
    arcType == ArcType.half
        ? canvas.drawArc(rectForArc, radians(-90.0 + fixedStartAngle),
            radians(360 * startAngleFixedMargin), false, _paintBackground)
        : canvas.drawCircle(center, radius, _paintBackground);

    if (maskFilter != null) _paintLine.maskFilter = maskFilter;

    if (linearGradient != null) {
      if (rotateLinearGradient && progress > 0) {
        double correction = 0;
        if (_paintLine.strokeCap == StrokeCap.round ||
            _paintLine.strokeCap == StrokeCap.square)
          correction = math.atan(_paintLine.strokeWidth / 2 / radius);

        _paintLine.shader = SweepGradient(
                transform: reverse
                    ? GradientRotation(
                        radians(-90 - progress + startAngle) - correction)
                    : GradientRotation(
                        radians(-90.0 + startAngle) - correction),
                startAngle: radians(0),
                endAngle: radians(progress),
                tileMode: TileMode.clamp,
                colors: reverse
                    ? linearGradient!.colors.reversed.toList()
                    : linearGradient!.colors)
            .createShader(Rect.fromCircle(center: center, radius: radius));
      } else if (!rotateLinearGradient) {
        _paintLine.shader = linearGradient!
            .createShader(Rect.fromCircle(center: center, radius: radius));
      }
    }

    fixedStartAngle = startAngle;

    startAngleFixedMargin = 1.0;
    if (arcType != null) {
      if (arcType == ArcType.full) {
        fixedStartAngle = 220;
        startAngleFixedMargin = 172 / fixedStartAngle;
      } else {
        fixedStartAngle = 270;
        startAngleFixedMargin = 135 / fixedStartAngle;
      }
    }

    if (arcBackgroundColor != null)
      canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          radians(-90.0 + fixedStartAngle),
          radians(360 * startAngleFixedMargin),
          false,
          _paintBackgroundStartAngle);

    if (reverse) {
      final double start =
          radians(360 * startAngleFixedMargin - 90.0 + fixedStartAngle);
      final double end = radians(-progress * startAngleFixedMargin);
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start,
          end, false, _paintLine);
    } else {
      final double start = radians(-90.0 + fixedStartAngle);
      final double end = radians(progress * startAngleFixedMargin);
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start,
          end, false, _paintLine);
    }
  }

  double radians(num deg) => (deg * (math.pi / 180.0)).toDouble();

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
