import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

/// 绘制矩形四边虚线边框的 CustomPainter。
class FlDottedLinePainter extends CustomPainter {
  FlDottedLinePainter({
    this.strokeWidth = 1.0,
    this.color = Colors.greenAccent,
    this.gap = 5.0,
    this.length,
    this.radius = 0.0,
    this.strokeCap = StrokeCap.butt,
  });

  /// 线宽，默认 1.0。
  double strokeWidth;

  /// 虚线颜色，默认 Colors.greenAccent。
  Color color;

  /// 虚线段之间的间距，默认 5.0。
  double gap;

  /// 虚线段长度，默认与 [gap] 相同。
  final double? length;

  /// 圆角半径，默认 0 表示直角。
  final double radius;

  /// 线段端点样式，默认 [StrokeCap.butt]。
  final StrokeCap strokeCap;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= strokeWidth || size.height <= strokeWidth) return;
    final Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap
      ..style = PaintingStyle.stroke;
    final double inset = strokeWidth / 2;
    final double left = inset;
    final double top = inset;
    final double right = size.width - inset;
    final double bottom = size.height - inset;
    final double dashLength = length ?? gap;
    if (radius > 0) {
      final Rect rect = Rect.fromLTRB(left, top, right, bottom);
      final double maxRadius = math.min(rect.width, rect.height) / 2;
      final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius.clamp(0.0, maxRadius)));
      canvas.drawPath(_buildDashedPath(Path()..addRRect(rrect), dashLength, gap), dashedPaint);
      return;
    }
    final Path topPath = getDashedPath(
      a: math.Point<double>(left, top),
      b: math.Point<double>(right, top),
      gap: gap,
      length: dashLength,
    );
    final Path rightPath = getDashedPath(
      a: math.Point<double>(right, top),
      b: math.Point<double>(right, bottom),
      gap: gap,
      length: dashLength,
    );
    final Path bottomPath = getDashedPath(
      a: math.Point<double>(left, bottom),
      b: math.Point<double>(right, bottom),
      gap: gap,
      length: dashLength,
    );
    final Path leftPath = getDashedPath(
      a: math.Point<double>(left, top),
      b: math.Point<double>(left, bottom),
      gap: gap,
      length: dashLength,
    );
    canvas.drawPath(topPath, dashedPaint);
    canvas.drawPath(rightPath, dashedPaint);
    canvas.drawPath(bottomPath, dashedPaint);
    canvas.drawPath(leftPath, dashedPaint);
  }

  /// 生成从 a 到 b 的虚线路径，[gap] 为线段间距，[length] 为线段长度。
  Path getDashedPath({
    required math.Point<double> a,
    required math.Point<double> b,
    required double gap,
    double? length,
  }) {
    final Path path = Path();
    final double dashLength = length ?? gap;
    final double width = b.x - a.x;
    final double height = b.y - a.y;
    final double total = math.sqrt(width * width + height * height);
    if (gap < 0 || dashLength <= 0 || total <= 0) return path;
    final double ux = width / total;
    final double uy = height / total;
    for (double start = 0; start < total; start += dashLength + gap) {
      final double end = math.min(start + dashLength, total);
      path
        ..moveTo(a.x + ux * start, a.y + uy * start)
        ..lineTo(a.x + ux * end, a.y + uy * end);
    }
    return path;
  }

  Path _buildDashedPath(Path source, double dashLength, double space) {
    final Path result = Path();
    if (dashLength <= 0 || space < 0) return result;
    for (final PathMetric metric in source.computeMetrics()) {
      for (double start = 0; start < metric.length; start += dashLength + space) {
        final double end = math.min(start + dashLength, metric.length);
        result.addPath(metric.extractPath(start, end), Offset.zero);
      }
    }
    return result;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is! FlDottedLinePainter ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.color != color ||
      oldDelegate.gap != gap ||
      oldDelegate.length != length ||
      oldDelegate.radius != radius ||
      oldDelegate.strokeCap != strokeCap;
}

/// 可设置实线段长度与间隔的虚线 BoxBorder。
class FlDottedLineBorder extends BoxBorder {
  const FlDottedLineBorder({
    this.top = BorderSide.none,
    this.right = BorderSide.none,
    this.bottom = BorderSide.none,
    this.left = BorderSide.none,
    this.length = 5,
    this.space = 3,
  });

  const FlDottedLineBorder.fromBorderSide(BorderSide side, {this.length = 5, this.space = 3})
    : top = side,
      right = side,
      bottom = side,
      left = side;

  const FlDottedLineBorder.symmetric({
    BorderSide vertical = BorderSide.none,
    BorderSide horizontal = BorderSide.none,
    this.length = 5,
    this.space = 3,
  }) : left = vertical,
       top = horizontal,
       right = vertical,
       bottom = horizontal;

  factory FlDottedLineBorder.all({
    Color color = const Color(0xFF000000),
    double width = 1.0,
    double length = 5,
    double space = 3,
  }) {
    final BorderSide side = BorderSide(color: color, width: width, style: BorderStyle.solid);
    return FlDottedLineBorder.fromBorderSide(side, length: length, space: space);
  }

  /// 实线段长度，默认 5。
  final double length;

  /// 相邻实线段的间隔，默认 3。
  final double space;

  /// 上边框样式。
  @override
  final BorderSide top;

  /// 右边框样式。
  final BorderSide right;

  /// 下边框样式。
  @override
  final BorderSide bottom;

  /// 左边框样式。
  final BorderSide left;

  /// 合并两个虚线边框，实线段长度与间隔逐项相加。
  static FlDottedLineBorder merge(FlDottedLineBorder a, FlDottedLineBorder b) {
    assert(BorderSide.canMerge(a.top, b.top));
    assert(BorderSide.canMerge(a.right, b.right));
    assert(BorderSide.canMerge(a.bottom, b.bottom));
    assert(BorderSide.canMerge(a.left, b.left));
    return FlDottedLineBorder(
      top: BorderSide.merge(a.top, b.top),
      right: BorderSide.merge(a.right, b.right),
      bottom: BorderSide.merge(a.bottom, b.bottom),
      left: BorderSide.merge(a.left, b.left),
      space: a.space + b.space,
      length: a.length + b.length,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.fromLTRB(left.width, top.width, right.width, bottom.width);

  bool get _colorIsUniform {
    final Color topColor = top.color;
    return right.color == topColor && bottom.color == topColor && left.color == topColor;
  }

  bool get _widthIsUniform {
    final double topWidth = top.width;
    return right.width == topWidth && bottom.width == topWidth && left.width == topWidth;
  }

  bool get _styleIsUniform {
    final BorderStyle topStyle = top.style;
    return right.style == topStyle && bottom.style == topStyle && left.style == topStyle;
  }

  /// 非统一边框的诊断说明，供两处 assert 共用。
  List<DiagnosticsNode> get _nonUniformDescriptions => <DiagnosticsNode>[
    ErrorDescription('The following is not uniform:'),
    if (!_colorIsUniform) ErrorDescription('BorderSide.color'),
    if (!_widthIsUniform) ErrorDescription('BorderSide.width'),
    if (!_styleIsUniform) ErrorDescription('BorderSide.style'),
  ];

  @override
  bool get isUniform => _colorIsUniform && _widthIsUniform && _styleIsUniform;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    if (isUniform) {
      switch (top.style) {
        case BorderStyle.none:
          return;
        case BorderStyle.solid:
          switch (shape) {
            case BoxShape.circle:
              assert(borderRadius == null, 'A borderRadius can only be given for rectangular boxes.');
              final double width = top.width;
              final Paint paint = top.toPaint();
              final Rect inner = rect.deflate(width / 2);
              canvas.drawPath(_buildDashPath(Path()..addOval(inner), length, space), paint);
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
                  canvas.drawPath(_buildDashPath(Path()..addRRect(outer), length, space), paint);
                } else {
                  final RRect inner = outer.deflate(width / 2);
                  canvas.drawPath(
                    _buildDashPath(Path()..addRRect(inner), length, space),
                    paint
                      ..isAntiAlias = true
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = width,
                  );
                }
                return;
              }
              final double width = top.width;
              final Paint paint = top.toPaint();
              canvas.drawPath(_buildDashPath(Path()..addRect(rect.deflate(width / 2.0)), length, space), paint);
              break;
          }
          return;
      }
    }

    assert(() {
      if (borderRadius != null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('A borderRadius can only be given for a uniform Border.'),
          ..._nonUniformDescriptions,
        ]);
      }
      return true;
    }());
    assert(() {
      if (shape != BoxShape.rectangle) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('A Border can only be drawn as a circle if it is uniform'),
          ..._nonUniformDescriptions,
        ]);
      }
      return true;
    }());
    paintDottedBorder(canvas, rect, top: top, right: right, bottom: bottom, left: left);
  }

  /// 按边分别绘制虚线。
  void paintDottedBorder(
    Canvas canvas,
    Rect rect, {
    BorderSide top = BorderSide.none,
    BorderSide right = BorderSide.none,
    BorderSide bottom = BorderSide.none,
    BorderSide left = BorderSide.none,
  }) {
    _paintDashedSide(
      canvas,
      top,
      Offset(rect.left, rect.top + top.width / 2),
      Offset(rect.right, rect.top + top.width / 2),
    );
    _paintDashedSide(
      canvas,
      right,
      Offset(rect.right - right.width / 2, rect.top),
      Offset(rect.right - right.width / 2, rect.bottom),
    );
    _paintDashedSide(
      canvas,
      bottom,
      Offset(rect.right, rect.bottom - bottom.width / 2),
      Offset(rect.left, rect.bottom - bottom.width / 2),
    );
    _paintDashedSide(
      canvas,
      left,
      Offset(rect.left + left.width / 2, rect.bottom),
      Offset(rect.left + left.width / 2, rect.top),
    );
  }

  /// 绘制单条边框虚线，[side] 为 none 时跳过。
  void _paintDashedSide(Canvas canvas, BorderSide side, Offset start, Offset end) {
    if (side.style == BorderStyle.none) return;
    final Path path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(end.dx, end.dy);
    final Paint paint = Paint()
      ..color = side.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = side.width;
    canvas.drawPath(_buildDashPath(path, length, space), paint);
  }

  Path _buildDashPath(Path path, double length, double space) {
    final Path r = Path();
    if (length <= 0 || space < 0) return r;
    for (final PathMetric metric in path.computeMetrics()) {
      double start = 0.0;
      while (start < metric.length) {
        final double end = start + length;
        r.addPath(metric.extractPath(start, end), Offset.zero);
        start = end + space;
      }
    }
    return r;
  }

  @override
  ShapeBorder scale(double t) => FlDottedLineBorder(
    top: top.scale(t),
    right: right.scale(t),
    bottom: bottom.scale(t),
    left: left.scale(t),
    length: length * t,
    space: space * t,
  );

  @override
  BoxBorder? add(ShapeBorder other, {bool reversed = false}) {
    if (other is FlDottedLineBorder &&
        BorderSide.canMerge(top, other.top) &&
        BorderSide.canMerge(right, other.right) &&
        BorderSide.canMerge(bottom, other.bottom) &&
        BorderSide.canMerge(left, other.left)) {
      return FlDottedLineBorder.merge(this, other);
    }
    return null;
  }
}
