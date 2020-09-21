import 'package:flutter/material.dart';

class CanvasPoint extends CustomPainter {
  final double ringWidth;
  final double ringRadius;
  final bool showUnSelectRing;
  final double circleRadius;
  final Color selectColor;
  final Color unSelectColor;
  final List<Point> points;

  CanvasPoint(
      {@required this.ringWidth,
      @required this.ringRadius,
      @required this.showUnSelectRing,
      @required this.circleRadius,
      @required this.selectColor,
      @required this.unSelectColor,
      @required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    /// 绘制9个圆
    final ringPaint = Paint()
      ..isAntiAlias = true
      ..color = this.unSelectColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = this.ringWidth;

    final circlePaint = Paint()
      ..isAntiAlias = true
      ..color = this.unSelectColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < this.points.length; i++) {
      final point = points[i];
      final offSet = Offset(point.x, points[i].y);
      final color = point.isSelect ? this.selectColor : this.unSelectColor;
      circlePaint.color = color;
      ringPaint.color = color;
      canvas.drawCircle(offSet, this.circleRadius, circlePaint);
      if (this.showUnSelectRing || point.isSelect) {
        canvas.drawArc(Rect.fromCircle(center: offSet, radius: this.ringRadius), 0, 360, false, ringPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Point {
  double x;
  double y;
  bool isSelect = false;
  int position;

  Point({@required this.x, @required this.y, @required this.position});
}

class CanvasLine extends CustomPainter {
  final List<Point> pathPoints;
  final Color selectColor;
  final double lineWidth;
  final Point curPoint;

  CanvasLine(
      {@required this.pathPoints, @required this.selectColor, @required this.lineWidth, @required this.curPoint});

  @override
  void paint(Canvas canvas, Size size) {
    int length = pathPoints.length;
    if (length < 1) return;
    final linePaint = Paint()
      ..isAntiAlias = true
      ..color = this.selectColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = this.lineWidth;

    for (int i = 0; i < length - 1; i++) {
      canvas.drawLine(
          Offset(pathPoints[i].x, pathPoints[i].y), Offset(pathPoints[i + 1].x, pathPoints[i + 1].y), linePaint);
    }

    double endX = curPoint.x;
    double endY = curPoint.y;
    if (endX < 0) {
      endX = 0;
    } else if (endX > size.width) {
      endX = size.width;
    }
    if (endY < 0) {
      endY = 0;
    } else if (endY > size.height) {
      endY = size.height;
    }
    canvas.drawLine(Offset(pathPoints[length - 1].x, pathPoints[length - 1].y), Offset(endX, endY), linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
