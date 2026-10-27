import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/extended_state.dart';

part 'liquid_progress.dart';

typedef FlLinearProgressChildBuilder = Widget Function(
    BuildContext context, double percent);

class FlLinearProgress extends StatefulWidget {
  const FlLinearProgress({
    super.key,
    required this.progressColor,
    this.percent = 0.0,
    this.height = 5.0,
    this.width = double.infinity,
    this.backgroundColor,
    this.animation = false,
    this.repeat = false,
    this.duration = const Duration(seconds: 2),
    this.curve = Curves.fastLinearToSlowEaseIn,
    this.isRTL = false,
    this.builder,
    this.strokeCap = StrokeCap.butt,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.maskFilter,
    this.onChanged,
  })  : assert(percent >= 0 && percent <= 1),
        assert(progressColor != null),
        isClip = false,
        linearGradient = null;

  const FlLinearProgress.gradient({
    super.key,
    required this.linearGradient,
    this.percent = 0.0,
    this.height = 5.0,
    this.width = double.infinity,
    this.backgroundColor,
    this.animation = false,
    this.repeat = false,
    this.duration = const Duration(seconds: 2),
    this.curve = Curves.fastLinearToSlowEaseIn,
    this.isRTL = false,
    this.builder,
    this.strokeCap = StrokeCap.square,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.maskFilter,
    this.isClip = true,
    this.onChanged,
  })  : assert(percent >= 0 && percent <= 1),
        assert(linearGradient != null),
        progressColor = null;

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
  final Duration duration;

  /// widget inside the Line
  final FlLinearProgressChildBuilder? builder;

  /// If present, this will make the progress bar colored by this gradient.
  ///
  /// This will override [progressColor]. It is an error to provide both.
  final LinearGradient? linearGradient;

  /// Creates a mask filter that takes the progress shape being drawn and blurs it.
  final MaskFilter? maskFilter;

  /// set a linear curve animation type
  final Curve curve;

  /// set true when you want to restart the animation, it restarts only when reaches 1.0 as a value
  /// defaults to false
  final bool repeat;

  /// Percent value between 0.0 and 1.0
  final double width;

  /// Height of the line
  final double height;

  /// The kind of finish to place on the end of lines drawn, values
  /// supported: butt, round, roundAll
  final StrokeCap strokeCap;

  /// mainAxisAlignment of the Row
  final MainAxisAlignment mainAxisAlignment;

  /// set true if you want to animate the linear from the right to left (RTL)
  final bool isRTL;

  /// Called when the user is selecting a new value for the progress bar
  final ValueChanged<double>? onChanged;

  /// Set true if you want to display only part of [linearGradient] based on percent value
  /// (ie. create 'VU effect'). If no [linearGradient] is specified this option is ignored.
  final bool isClip;

  @override
  State<StatefulWidget> createState() => _FlLinearProgressState();
}

class _FlLinearProgressState extends ExtendedState<FlLinearProgress>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;

  @override
  void initState() {
    super.initState();
    initAnimationController();
    startAnimation();
  }

  void initAnimationController() {
    if (widget.animation) {
      if (widget.percent > 0) {
        controller ??=
            AnimationController(vsync: this, duration: widget.duration);
        controller!
            .drive(CurveTween(curve: widget.curve))
            .addListener(listener);
      } else {
        widget.onChanged?.call(percent);
      }
    } else {
      disposeController();
    }
  }

  void disposeController() {
    controller?.removeListener(listener);
    controller?.dispose();
  }

  void listener() {
    lastPercent = percent;
    widget.onChanged?.call(percent);
    if (mounted) setState(() {});
  }

  void startAnimation({double? from}) {
    if (controller != null) {
      if (widget.repeat) {
        controller!.repeat(max: widget.percent);
      } else {
        controller!.animateTo(widget.percent);
      }
    }
  }

  double lastPercent = 0;

  double get percent => (controller?.value ?? widget.percent);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.height,
        width: widget.width,
        child: CustomPaint(
            painter: _LinearProgressPainter(
                isRTL: widget.isRTL,
                progress: percent,
                progressColor: widget.progressColor ??
                    Theme.of(context).progressIndicatorTheme.color ??
                    Theme.of(context).primaryColor,
                linearGradient: widget.linearGradient,
                backgroundColor: widget.backgroundColor ??
                    Theme.of(context).colorScheme.primary,
                strokeCap: widget.strokeCap,
                width: widget.height,
                maskFilter: widget.maskFilter,
                isClip: widget.isClip),
            child: widget.builder?.call(context, percent)));
  }

  @override
  void didUpdateWidget(covariant FlLinearProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animation != widget.animation) initAnimationController();
    if (oldWidget.duration != widget.duration) {
      controller?.duration = widget.duration;
    }
    startAnimation(from: oldWidget.percent);
  }

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }
}

class _LinearProgressPainter extends CustomPainter {
  final Paint background = Paint();
  final Paint line = Paint();
  final double width;
  final double progress;
  final bool isRTL;
  final Color backgroundColor;
  final StrokeCap strokeCap;
  final MaskFilter? maskFilter;
  final bool isClip;
  final LinearGradient? linearGradient;
  final Color progressColor;

  _LinearProgressPainter({
    required this.width,
    required this.progress,
    required this.isRTL,
    required this.progressColor,
    required this.backgroundColor,
    this.strokeCap = StrokeCap.butt,
    this.linearGradient,
    this.maskFilter,
    required this.isClip,
  }) {
    line.color = progress == 0 ? Colors.transparent : progressColor;
    background.color = backgroundColor;

    line.style = PaintingStyle.stroke;
    background.style = PaintingStyle.stroke;

    line.strokeWidth = width;
    background.strokeWidth = width;

    line.strokeCap = strokeCap;
    background.strokeCap = strokeCap;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Offset start = Offset(0.0, size.height / 2);
    final Offset end = Offset(size.width, size.height / 2);
    canvas.drawLine(start, end, background);
    if (maskFilter != null) line.maskFilter = maskFilter;

    if (isRTL) {
      final double xProgress = size.width - size.width * progress;
      if (linearGradient != null) {
        line.shader = _createGradientShaderRightToLeft(size, xProgress);
      }
      canvas.drawLine(end, Offset(xProgress, size.height / 2), line);
    } else {
      final double xProgress = size.width * progress;
      if (linearGradient != null) {
        line.shader = _createGradientShaderLeftToRight(size, xProgress);
      }
      canvas.drawLine(start, Offset(xProgress, size.height / 2), line);
    }
  }

  Shader _createGradientShaderRightToLeft(Size size, double xProgress) {
    final Offset shaderEndPoint =
        isClip ? Offset.zero : Offset(xProgress, size.height);
    return linearGradient!.createShader(
        Rect.fromPoints(Offset(size.width, size.height), shaderEndPoint));
  }

  Shader _createGradientShaderLeftToRight(Size size, double x) {
    final Offset shaderEndPoint =
        isClip ? Offset(size.width, size.height) : Offset(x, size.height);
    return linearGradient!
        .createShader(Rect.fromPoints(Offset.zero, shaderEndPoint));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
