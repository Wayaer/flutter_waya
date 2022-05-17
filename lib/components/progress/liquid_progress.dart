import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

const double _sweep = (math.pi * 2.0) - .001;

enum LiquidProgressType {
  linear,
  circular,
  custom,
}

class LiquidProgress extends ProgressIndicator {
  const LiquidProgress.linear({
    Key? key,
    double value = 0.5,
    Color? backgroundColor,
    Animation<Color>? valueColor,
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
    this.borderRadius = 0,
    this.center,
    this.direction = Axis.horizontal,
  })  : shapePath = null,
        type = LiquidProgressType.linear,
        super(
            key: key,
            value: value,
            backgroundColor: backgroundColor,
            valueColor: valueColor);

  const LiquidProgress.circular(
      {Key? key,
      double value = 0.5,
      Color? backgroundColor,
      Animation<Color>? valueColor,
      this.borderWidth = 0,
      this.borderColor,
      this.center,
      this.direction = Axis.vertical})
      : borderRadius = 0,
        shapePath = null,
        type = LiquidProgressType.circular,
        super(
            key: key,
            value: value,
            backgroundColor: backgroundColor,
            valueColor: valueColor);

  const LiquidProgress.custom(
      {Key? key,
      double value = 0.5,
      Color? backgroundColor,
      Animation<Color>? valueColor,
      this.center,
      required this.direction,
      required this.shapePath})
      : borderWidth = null,
        borderColor = null,
        borderRadius = 0,
        type = LiquidProgressType.custom,
        super(
            key: key,
            value: value,
            backgroundColor: backgroundColor,
            valueColor: valueColor);

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

  final LiquidProgressType type;

  Color _getBackgroundColor(BuildContext context) =>
      backgroundColor ?? Theme.of(context).backgroundColor;

  Color _getValueColor(BuildContext context) =>
      valueColor?.value ?? Theme.of(context).colorScheme.secondary;

  @override
  State<StatefulWidget> createState() => _ProgressState();
}

class _ProgressState extends State<LiquidProgress> {
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case LiquidProgressType.linear:
        return linear;
      case LiquidProgressType.circular:
        return circular;
      case LiquidProgressType.custom:
        return custom;
    }
  }

  Widget get custom {
    final Rect pathBounds = widget.shapePath!.getBounds();
    return SizedBox(
        width: pathBounds.width + pathBounds.left,
        height: pathBounds.height + pathBounds.top,
        child: ClipPath(
            clipper: _CustomPathClipper(path: widget.shapePath!),
            child: CustomPaint(
              painter: _CustomPathPainter(
                  color: widget._getBackgroundColor(context),
                  path: widget.shapePath!),
              child: Stack(children: <Widget>[
                Positioned.fill(
                    left: pathBounds.left,
                    top: pathBounds.top,
                    child: Wave(
                        value: widget.value!,
                        color: widget._getValueColor(context),
                        direction: widget.direction)),
                if (widget.center != null) Center(child: widget.center),
              ]),
            )));
  }

  Widget get circular => ClipPath(
        clipper: _CircleClipper(),
        child: CustomPaint(
            painter: _CirclePainter(color: widget._getBackgroundColor(context)),
            foregroundPainter: _CircleBorderPainter(
                color: widget.borderColor ??
                    context.theme.progressIndicatorTheme.circularTrackColor ??
                    context.theme.primaryColor,
                width: widget.borderWidth!),
            child: Stack(children: <Widget>[
              Wave(
                  value: widget.value!,
                  color: widget._getValueColor(context),
                  direction: widget.direction),
              if (widget.center != null) Center(child: widget.center),
            ])),
      );

  Widget get linear => ClipPath(
      clipper: _LinearClipper(radius: widget.borderRadius),
      child: CustomPaint(
          painter: _LinearPainter(
              color: widget._getBackgroundColor(context),
              radius: widget.borderRadius),
          foregroundPainter: _LinearBorderPainter(
              color: widget.borderColor!,
              width: widget.borderWidth!,
              radius: widget.borderRadius),
          child: Stack(children: <Widget>[
            Wave(
                value: widget.value!,
                color: widget._getValueColor(context),
                direction: widget.direction),
            if (widget.center != null) Center(child: widget.center),
          ])));
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
    final double alteredRadius = radius;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(
                width / 2, width / 2, size.width - width, size.height - width),
            Radius.circular(alteredRadius - width)),
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

class _CustomPathPainter extends CustomPainter {
  _CustomPathPainter({required this.color, required this.path});

  final Color color;
  final Path path;

  @override
  void paint(Canvas canvas, Size size) =>
      canvas.drawPath(path, Paint()..color = color);

  @override
  bool shouldRepaint(_CustomPathPainter oldDelegate) =>
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
