part of 'progress.dart';

class _CirclePainter extends CustomPainter {
  _CirclePainter(
      {this.lineWidth,
      this.backgroundWidth,
      this.progress,
      @required this.radius,
      this.progressColor,
      this.backgroundColor,
      this.startAngle = 0.0,
      this.circularStrokeCap = CircularStrokeCap.round,
      this.linearGradient,
      this.reverse,
      this.arcBackgroundColor,
      this.arcType,
      this.maskFilter,
      this.rotateLinearGradient}) {
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
      _paintBackgroundStartAngle.color = arcBackgroundColor;
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
  final LinearGradient linearGradient;
  final Color arcBackgroundColor;
  final ArcType arcType;
  final bool reverse;
  final MaskFilter maskFilter;
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
                    ? linearGradient.colors.reversed.toList()
                    : linearGradient.colors)
            .createShader(Rect.fromCircle(center: center, radius: radius));
      } else if (!rotateLinearGradient) {
        _paintLine.shader = linearGradient
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
