part of 'progress.dart';

const double _sweep = (pi * 2.0) - .001;

enum LiquidProgressIndicatorType {
  /// linear
  linear,

  /// circular
  circular,

  /// custom
  custom,
}

class LiquidProgressIndicator extends ProgressIndicator {
  const LiquidProgressIndicator.linear({
    super.key,
    super.value = 0.5,
    super.backgroundColor,
    super.color,
    super.valueColor,
    this.borderWidth = 0,
    this.borderColor,
    this.borderRadius = 0,
    this.center,
    this.direction = Axis.horizontal,
  })  : shapePath = null,
        type = LiquidProgressIndicatorType.linear;

  const LiquidProgressIndicator.circular(
      {super.key,
      super.value = 0.5,
      super.backgroundColor,
      super.color,
      super.valueColor,
      this.borderWidth = 0,
      this.borderColor,
      this.center,
      this.direction = Axis.vertical})
      : borderRadius = 0,
        shapePath = null,
        type = LiquidProgressIndicatorType.circular;

  const LiquidProgressIndicator.custom(
      {super.key,
      super.value = 0.5,
      super.backgroundColor,
      super.valueColor,
      super.color,
      this.center,
      required this.direction,
      required this.shapePath})
      : assert(shapePath != null),
        borderWidth = null,
        borderColor = null,
        borderRadius = 0,
        type = LiquidProgressIndicatorType.custom;

  /// The width of the border, if this is set [borderColor] must also be set.
  final double? borderWidth;

  /// The color of the border, if this is set [borderWidth] must also be set.
  final Color? borderColor;

  /// The radius of the border.
  final double borderRadius;

  /// The widget to show in the center of the progress indicator.
  final Widget? center;

  /// The direction the liquid travels.
  final Axis direction;

  /// The path used to draw the shape of the progress indicator. The size of
  /// the progress indicator is controlled by the bounds of this path.
  final Path? shapePath;

  final LiquidProgressIndicatorType type;

  @override
  State<StatefulWidget> createState() => _ProgressState();
}

class _ProgressState extends ExtendedState<LiquidProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case LiquidProgressIndicatorType.linear:
        return buildCustomPaint(
            clipper: _LinearClipper(radius: widget.borderRadius),
            painter: _LinearPainter(
                color: backgroundColor, radius: widget.borderRadius),
            foregroundPainter: _LinearBorderPainter(
                color: widget.borderColor ??
                    Theme.of(context).progressIndicatorTheme.linearTrackColor ??
                    Theme.of(context).primaryColor,
                width: widget.borderWidth!,
                radius: widget.borderRadius));
      case LiquidProgressIndicatorType.circular:
        return buildCustomPaint(
            clipper: _CircleClipper(),
            painter: _CirclePainter(color: backgroundColor),
            foregroundPainter: _CircleBorderPainter(
                color: widget.borderColor ??
                    Theme.of(context)
                        .progressIndicatorTheme
                        .circularTrackColor ??
                    Theme.of(context).primaryColor,
                width: widget.borderWidth!));
      case LiquidProgressIndicatorType.custom:
        final Rect pathBounds = widget.shapePath!.getBounds();
        return SizedBox(
            width: pathBounds.width + pathBounds.left,
            height: pathBounds.height + pathBounds.top,
            child: buildCustomPaint(
                pathBounds: pathBounds,
                clipper: _CustomPathClipper(path: widget.shapePath!),
                painter: _CustomLiquidPathPainter(
                    color: backgroundColor, path: widget.shapePath!)));
    }
  }

  Widget buildCustomPaint(
      {CustomClipper<Path>? clipper,
      CustomPainter? painter,
      CustomPainter? foregroundPainter,
      Rect? pathBounds}) {
    final wave = FlAnimationWave(
        value: widget.value!, color: valueColor, direction: widget.direction);
    return ClipPath(
        clipper: clipper,
        child: CustomPaint(
            painter: painter,
            foregroundPainter: foregroundPainter,
            child: Stack(children: [
              if (pathBounds != null)
                Positioned.fill(
                    left: pathBounds.left, top: pathBounds.top, child: wave)
              else
                wave,
              if (widget.center != null) Center(child: widget.center),
            ])));
  }

  Color get backgroundColor =>
      widget.backgroundColor ?? Theme.of(context).colorScheme.secondary;

  Color get valueColor =>
      widget.color ??
      widget.valueColor?.value ??
      Theme.of(context).colorScheme.primary;
}

class _LinearPainter extends CustomPainter {
  _LinearPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) => canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius)),
      Paint()..color = color);

  @override
  bool shouldRepaint(_LinearPainter oldDelegate) => color != oldDelegate.color;
}

class _LinearBorderPainter extends CustomPainter {
  _LinearBorderPainter({
    required this.color,
    required this.width,
    required this.radius,
  });

  final Color color;
  final double width;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    double alteredRadius = radius - width;
    if (alteredRadius < 0) alteredRadius = 0;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(
                width / 2, width / 2, size.width - width, size.height - width),
            Radius.circular(alteredRadius)),
        paint);
  }

  @override
  bool shouldRepaint(_LinearBorderPainter oldDelegate) =>
      color != oldDelegate.color ||
      width != oldDelegate.width ||
      radius != oldDelegate.radius;
}

class _LinearClipper extends CustomClipper<Path> {
  _LinearClipper({this.radius = 0});

  final double radius;

  @override
  Path getClip(Size size) => Path()
    ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(radius)));

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _CirclePainter extends CustomPainter {
  _CirclePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    canvas.drawArc(Offset.zero & size, 0, _sweep, false, paint);
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) => color != oldDelegate.color;
}

class _CircleBorderPainter extends CustomPainter {
  _CircleBorderPainter({required this.color, required this.width});

  final Color color;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    final Size newSize = Size(size.width - width, size.height - width);
    canvas.drawArc(
        Offset(width / 2, width / 2) & newSize, 0, _sweep, false, borderPaint);
  }

  @override
  bool shouldRepaint(_CircleBorderPainter oldDelegate) =>
      color != oldDelegate.color || width != oldDelegate.width;
}

class _CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()..addArc(Offset.zero & size, 0, _sweep);

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _CustomLiquidPathPainter extends CustomPainter {
  _CustomLiquidPathPainter({required this.color, required this.path});

  final Color color;
  final Path path;

  @override
  void paint(Canvas canvas, Size size) =>
      canvas.drawPath(path, Paint()..color = color);

  @override
  bool shouldRepaint(_CustomLiquidPathPainter oldDelegate) =>
      color != oldDelegate.color || path != oldDelegate.path;
}

class _CustomPathClipper extends CustomClipper<Path> {
  _CustomPathClipper({required this.path});

  final Path path;

  @override
  Path getClip(Size size) => path;

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
