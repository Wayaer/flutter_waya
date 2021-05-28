import 'dart:math' as math;
import 'dart:ui';

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

class DottedLineBorder extends BoxBorder {
  const DottedLineBorder(
      {this.top = BorderSide.none,
      this.right = BorderSide.none,
      this.bottom = BorderSide.none,
      this.left = BorderSide.none,
      this.dottedLength = 5,
      this.dottedSpace = 3});

  const DottedLineBorder.fromBorderSide(
    BorderSide side, {
    this.dottedLength = 5,
    this.dottedSpace = 3,
  })  : top = side,
        right = side,
        bottom = side,
        left = side;

  const DottedLineBorder.symmetric(
      {BorderSide vertical = BorderSide.none,
      BorderSide horizontal = BorderSide.none,
      this.dottedLength = 5,
      this.dottedSpace = 3})
      : left = vertical,
        top = horizontal,
        right = vertical,
        bottom = horizontal;

  factory DottedLineBorder.all(
      {Color color = const Color(0xFF000000),
      double width = 1.0,
      double dottedLength = 5,
      double dottedSpace = 3}) {
    final BorderSide side =
        BorderSide(color: color, width: width, style: BorderStyle.solid);
    return DottedLineBorder.fromBorderSide(side,
        dottedLength: dottedLength, dottedSpace: dottedSpace);
  }

  final double dottedLength;
  final double dottedSpace;

  static DottedLineBorder merge(DottedLineBorder a, DottedLineBorder b) {
    assert(BorderSide.canMerge(a.top, b.top));
    assert(BorderSide.canMerge(a.right, b.right));
    assert(BorderSide.canMerge(a.bottom, b.bottom));
    assert(BorderSide.canMerge(a.left, b.left));
    return DottedLineBorder(
        top: BorderSide.merge(a.top, b.top),
        right: BorderSide.merge(a.right, b.right),
        bottom: BorderSide.merge(a.bottom, b.bottom),
        left: BorderSide.merge(a.left, b.left),
        dottedSpace: a.dottedSpace + b.dottedSpace,
        dottedLength: a.dottedLength + b.dottedLength);
  }

  @override
  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.fromLTRB(left.width, top.width, right.width, bottom.width);

  bool get _colorIsUniform {
    final Color topColor = top.color;
    return right.color == topColor &&
        bottom.color == topColor &&
        left.color == topColor;
  }

  bool get _widthIsUniform {
    final double topWidth = top.width;
    return right.width == topWidth &&
        bottom.width == topWidth &&
        left.width == topWidth;
  }

  bool get _styleIsUniform {
    final BorderStyle topStyle = top.style;
    return right.style == topStyle &&
        bottom.style == topStyle &&
        left.style == topStyle;
  }

  @override
  bool get isUniform => _colorIsUniform && _widthIsUniform && _styleIsUniform;

  @override
  void paint(Canvas canvas, Rect rect,
      {TextDirection? textDirection,
      BoxShape shape = BoxShape.rectangle,
      BorderRadius? borderRadius}) {
    if (isUniform) {
      switch (top.style) {
        case BorderStyle.none:
          return;
        case BorderStyle.solid:
          switch (shape) {
            case BoxShape.circle:
              assert(borderRadius == null,
                  'A borderRadius can only be given for rectangular boxes.');
              final double width = top.width;
              final Paint paint = top.toPaint();
              final Rect inner = rect.deflate(width);
              canvas.drawPath(
                  _buildDashPath(
                      Path()..addOval(inner), dottedLength, dottedSpace),
                  paint);
              break;
            case BoxShape.rectangle:
              if (borderRadius != null) {
                final Paint paint = Paint()..color = top.color;
                final RRect outer = borderRadius.toRRect(rect);
                final double width = top.width;
                if (width == 0.0) {
                  paint
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 0.0;
                  canvas.drawPath(
                      _buildDashPath(
                          Path()..addRRect(outer), dottedLength, dottedSpace),
                      paint);
                } else {
                  final RRect inner = outer.deflate(width);
                  canvas.drawPath(
                      _buildDashPath(
                          Path()..addRRect(inner), dottedLength, dottedSpace),
                      paint
                        ..isAntiAlias = true
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = width);
                }
                return;
              }
              final double width = top.width;
              final Paint paint = top.toPaint();
              canvas.drawPath(
                  _buildDashPath(Path()..addRect(rect.deflate(width / 2.0)),
                      dottedLength, dottedSpace),
                  paint);
              break;
          }
          return;
      }
    }

    assert(() {
      if (borderRadius != null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'A borderRadius can only be given for a uniform Border.'),
          ErrorDescription('The following is not uniform:'),
          if (!_colorIsUniform) ErrorDescription('BorderSide.color'),
          if (!_widthIsUniform) ErrorDescription('BorderSide.width'),
          if (!_styleIsUniform) ErrorDescription('BorderSide.style'),
        ]);
      }
      return true;
    }());
    assert(() {
      if (shape != BoxShape.rectangle) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'A Border can only be drawn as a circle if it is uniform'),
          ErrorDescription('The following is not uniform:'),
          if (!_colorIsUniform) ErrorDescription('BorderSide.color'),
          if (!_widthIsUniform) ErrorDescription('BorderSide.width'),
          if (!_styleIsUniform) ErrorDescription('BorderSide.style'),
        ]);
      }
      return true;
    }());
    paintDottedBorder(canvas, rect,
        top: top, right: right, bottom: bottom, left: left);
  }

  void paintDottedBorder(Canvas canvas, Rect rect,
      {BorderSide top = BorderSide.none,
      BorderSide right = BorderSide.none,
      BorderSide bottom = BorderSide.none,
      BorderSide left = BorderSide.none}) {
    final Paint paint = Paint()..strokeWidth = 0.0;

    final Path path = Path();

    switch (top.style) {
      case BorderStyle.solid:
        paint.color = top.color;
        path.reset();
        path.moveTo(rect.left, rect.top + top.width / 2);
        path.lineTo(rect.right, rect.top + top.width / 2);
        paint.style = PaintingStyle.stroke;

        canvas.drawPath(_buildDashPath(path, dottedLength, dottedSpace),
            paint..strokeWidth = top.width);
        break;
      case BorderStyle.none:
        break;
    }
    switch (right.style) {
      case BorderStyle.solid:
        paint.color = right.color;
        path.reset();
        path.moveTo(rect.right, rect.top);
        path.lineTo(rect.right, rect.bottom);
        paint.style = PaintingStyle.stroke;
        canvas.drawPath(_buildDashPath(path, dottedLength, dottedSpace),
            paint..strokeWidth = right.width);
        break;
      case BorderStyle.none:
        break;
    }

    switch (bottom.style) {
      case BorderStyle.solid:
        paint.color = bottom.color;
        path.reset();
        path.moveTo(rect.right, rect.bottom);
        path.lineTo(rect.left, rect.bottom);
        paint.style = PaintingStyle.stroke;
        canvas.drawPath(_buildDashPath(path, dottedLength, dottedSpace),
            paint..strokeWidth = bottom.width);
        break;
      case BorderStyle.none:
        break;
    }

    switch (left.style) {
      case BorderStyle.solid:
        paint.color = left.color;
        path.reset();
        path.moveTo(rect.left + left.width / 2, rect.bottom);
        path.lineTo(rect.left + left.width / 2, rect.top);
        paint.style = PaintingStyle.stroke;
        canvas.drawPath(_buildDashPath(path, dottedLength, dottedSpace),
            paint..strokeWidth = left.width);
        break;
      case BorderStyle.none:
        break;
    }
  }

  Path _buildDashPath(Path path, double dottedLength, double dottedSpace) {
    final Path r = Path();
    for (final PathMetric metric in path.computeMetrics()) {
      double start = 0.0;
      while (start < metric.length) {
        final double end = start + dottedLength;
        r.addPath(metric.extractPath(start, end), Offset.zero);
        start = end + dottedSpace;
      }
    }
    return r;
  }

  @override
  ShapeBorder scale(double t) => DottedLineBorder(
      top: top.scale(t),
      right: right.scale(t),
      bottom: bottom.scale(t),
      left: left.scale(t));

  @override
  BoxBorder? add(ShapeBorder other, {bool reversed = false}) {
    if (other is DottedLineBorder &&
        BorderSide.canMerge(top, other.top) &&
        BorderSide.canMerge(right, other.right) &&
        BorderSide.canMerge(bottom, other.bottom) &&
        BorderSide.canMerge(left, other.left))
      return DottedLineBorder.merge(this, other);
    return null;
  }

  @override
  final BorderSide top;

  final BorderSide right;

  @override
  final BorderSide bottom;

  final BorderSide left;
}
