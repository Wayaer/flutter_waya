import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 虚线
class DottedLine extends StatelessWidget {
  const DottedLine({
    Key? key,
    double? strokeWidth,
    Color? color,
    double? gap,
    double? width,
    double? height,
    this.margin,
  })  : strokeWidth = strokeWidth ?? 1,
        color = color ?? Colors.greenAccent,
        gap = gap ?? 5.0,
        height = height ?? 1.0,
        width = width ?? double.infinity,
        super(key: key);
  final double strokeWidth;
  final Color color;
  final double gap;
  final double width;
  final double height;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) => Container(
      width: width,
      height: height,
      margin: margin,
      child: CustomPaint(
          painter: _DottedPainter(
              color: color, strokeWidth: strokeWidth, gap: gap)));
}

class _DottedPainter extends CustomPainter {
  _DottedPainter(
      {this.strokeWidth = 5.0,
      this.color = Colors.greenAccent,
      this.gap = 5.0});

  double strokeWidth;
  Color color;
  double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final double x = size.width;
    final double y = size.height;
    final Path _topPath = getDashedPath(
        a: const math.Point<double>(0, 0),
        b: math.Point<double>(x, 0),
        gap: gap);
    final Path _rightPath = getDashedPath(
        a: math.Point<double>(x, 0), b: math.Point<double>(x, y), gap: gap);
    final Path _bottomPath = getDashedPath(
        a: math.Point<double>(0, y), b: math.Point<double>(x, y), gap: gap);
    final Path _leftPath = getDashedPath(
        a: const math.Point<double>(0, 0),
        b: math.Point<double>(0.001, y),
        gap: gap);
    canvas.drawPath(_topPath, dashedPaint);
    canvas.drawPath(_rightPath, dashedPaint);
    canvas.drawPath(_bottomPath, dashedPaint);
    canvas.drawPath(_leftPath, dashedPaint);
  }

  Path getDashedPath({
    required math.Point<double> a,
    required math.Point<double> b,
    required double gap,
  }) {
    final Size size = Size(b.x - a.x, b.y - a.y);
    final Path path = Path();
    path.moveTo(a.x, a.y);
    bool shouldDraw = true;
    math.Point<double> currentPoint = math.Point<double>(a.x, a.y);
    final num radians = math.atan(size.height / size.width);
    final num dx = math.cos(radians) * gap < 0
        ? math.cos(radians) * gap * -1
        : math.cos(radians) * gap;
    final num dy = math.sin(radians) * gap < 0
        ? math.sin(radians) * gap * -1
        : math.sin(radians) * gap;
    while (currentPoint.x <= b.x && currentPoint.y <= b.y) {
      shouldDraw
          ? path.lineTo(currentPoint.x.toDouble(), currentPoint.y.toDouble())
          : path.moveTo(currentPoint.x.toDouble(), currentPoint.y.toDouble());
      shouldDraw = !shouldDraw;
      currentPoint = math.Point<double>(
          currentPoint.x + dx.toDouble(), currentPoint.y + dy.toDouble());
    }
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
