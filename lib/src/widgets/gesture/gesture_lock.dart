import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class GestureLock extends StatefulWidget {
  final double size;
  final Color selectColor;
  final Color unSelectColor;
  final double ringWidth;
  final double ringRadius;
  final double circleRadius;
  final double lineWidth;
  final bool showUnSelectRing;
  final bool immediatelyClear;
  final Function() onPanDown;
  final Function(List<int>) onPanUp;

  GestureLock(
      {Key key,
      @required this.size,
      Color selectColor,
      Color unSelectColor,
      this.ringWidth: 2,
      this.ringRadius: 35,
      this.showUnSelectRing: false,
      this.circleRadius: 10,
      this.lineWidth: 3,
      this.onPanUp,
      this.onPanDown,
      this.immediatelyClear: true})
      : this.selectColor = selectColor ?? getColors(greenAccent),
        this.unSelectColor = unSelectColor ?? getColors(black30),
        super(key: key);

  @override
  _GestureLockState createState() => _GestureLockState();
}

class _GestureLockState extends State<GestureLock> {
  List<Point> points;
  List<Point> pathPoints = [];
  double realRadius = 0;
  Point curPoint;

  @override
  void initState() {
    super.initState();
    realRadius = widget.ringRadius + widget.ringWidth / 2;
    points = [];
    final realRingSize = widget.ringRadius + widget.ringWidth / 2;
    final gapWidth = widget.size / 6 - realRingSize;
    for (int i = 0; i < 9; i++) {
      double x = gapWidth + realRingSize;
      double y = gapWidth + realRingSize;
      points.add(Point(x: (1 + i % 3 * 2) * x, y: (1 + i ~/ 3 * 2) * y, position: i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _CanvasPoint(
                ringWidth: widget.ringWidth,
                ringRadius: widget.ringRadius,
                showUnSelectRing: widget.showUnSelectRing,
                circleRadius: widget.circleRadius,
                selectColor: widget.selectColor,
                unSelectColor: widget.unSelectColor,
                points: points),
          ),
        ),
        GestureDetector(
            child: CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _CanvasLine(
                    pathPoints: pathPoints,
                    selectColor: widget.selectColor,
                    lineWidth: widget.lineWidth,
                    curPoint: curPoint)),
            onPanDown: onPanDownVoid,
            onPanUpdate: (DragUpdateDetails e) => onPanUpdate(e, context),
            onPanEnd: (DragEndDetails e) => onPanEnd(e, context))
      ],
    );
  }

  onPanDownVoid(DragDownDetails e) {
    clearAllData();
    if (widget.onPanDown != null) widget.onPanDown();
  }

  onPanUpdate(DragUpdateDetails e, BuildContext context) {
    RenderBox box = context.findRenderObject();
    Offset offset = box.globalToLocal(e.globalPosition);
    slideDealt(offset);
    curPoint = Point(x: offset.dx, y: offset.dy, position: -1);
    setState(() {});
  }

  onPanEnd(DragEndDetails e, BuildContext context) {
    if (pathPoints.length > 0) {
      curPoint = pathPoints[pathPoints.length - 1];
      setState(() {});
      if (widget.onPanUp != null) {
        List<int> items = pathPoints.map((item) => item.position).toList();
        widget.onPanUp(items);
      }
      if (widget.immediatelyClear) clearAllData();
    }
  }

  slideDealt(Offset offSet) {
    int xPosition = -1;
    int yPosition = -1;
    for (int i = 0; i < 3; i++) {
      if (xPosition == -1 && points[i].x + realRadius >= offSet.dx && offSet.dx >= points[i].x - realRadius) {
        xPosition = i;
      }
      if (yPosition == -1 && points[i * 3].y + realRadius >= offSet.dy && offSet.dy >= points[i * 3].y - realRadius) {
        yPosition = i;
      }
    }
    if (xPosition == -1 || yPosition == -1) return;
    int position = yPosition * 3 + xPosition;
    if (!points[position].isSelect) {
      points[position].isSelect = true;
      pathPoints.add(points[position]);
    }
  }

  clearAllData() {
    for (int i = 0; i < 9; i++) points[i].isSelect = false;
    pathPoints.clear();
    setState(() {});
  }
}

class _CanvasPoint extends CustomPainter {
  final double ringWidth;
  final double ringRadius;
  final bool showUnSelectRing;
  final double circleRadius;
  final Color selectColor;
  final Color unSelectColor;
  final List<Point> points;

  _CanvasPoint(
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

class _CanvasLine extends CustomPainter {
  final List<Point> pathPoints;
  final Color selectColor;
  final double lineWidth;
  final Point curPoint;

  _CanvasLine(
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
