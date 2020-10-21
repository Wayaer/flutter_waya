import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class GestureLock extends StatefulWidget {
  GestureLock(
      {Key key,
      @required this.size,
      Color selectColor,
      Color unSelectColor,
      this.ringWidth = 2,
      this.ringRadius = 35,
      this.showUnSelectRing = false,
      this.circleRadius = 10,
      this.lineWidth = 3,
      this.onPanUp,
      this.onPanDown,
      this.immediatelyClear = true})
      : selectColor = selectColor ?? getColors(greenAccent),
        unSelectColor = unSelectColor ?? getColors(black30),
        super(key: key);

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

  @override
  _GestureLockState createState() => _GestureLockState();
}

class _GestureLockState extends State<GestureLock> {
  List<_Point> points;
  List<_Point> pathPoints = <_Point>[];
  double realRadius = 0;
  _Point curPoint;

  @override
  void initState() {
    super.initState();
    realRadius = widget.ringRadius + widget.ringWidth / 2;
    points = <_Point>[];
    final double realRingSize = widget.ringRadius + widget.ringWidth / 2;
    final double gapWidth = widget.size / 6 - realRingSize;
    for (int i = 0; i < 9; i++) {
      final double x = gapWidth + realRingSize;
      final double y = gapWidth + realRingSize;
      points.add(
          _Point(x: (1 + i % 3 * 2) * x, y: (1 + i ~/ 3 * 2) * y, position: i));
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

  void onPanDownVoid(DragDownDetails e) {
    clearAllData();
    if (widget.onPanDown != null) widget.onPanDown();
  }

  void onPanUpdate(DragUpdateDetails e, BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset offset = box.globalToLocal(e.globalPosition);
    slideDealt(offset);
    curPoint = _Point(x: offset.dx, y: offset.dy, position: -1);
    setState(() {});
  }

  void onPanEnd(DragEndDetails e, BuildContext context) {
    if (pathPoints.isNotEmpty) {
      curPoint = pathPoints[pathPoints.length - 1];
      setState(() {});
      if (widget.onPanUp != null) {
        final List<int> items =
            pathPoints.map((_Point item) => item.position).toList();
        widget.onPanUp(items);
      }
      if (widget.immediatelyClear) clearAllData();
    }
  }

  void slideDealt(Offset offSet) {
    int xPosition = -1;
    int yPosition = -1;
    for (int i = 0; i < 3; i++) {
      if (xPosition == -1 &&
          points[i].x + realRadius >= offSet.dx &&
          offSet.dx >= points[i].x - realRadius) {
        xPosition = i;
      }
      if (yPosition == -1 &&
          points[i * 3].y + realRadius >= offSet.dy &&
          offSet.dy >= points[i * 3].y - realRadius) {
        yPosition = i;
      }
    }
    if (xPosition == -1 || yPosition == -1) return;
    final int position = yPosition * 3 + xPosition;
    if (!points[position].isSelect) {
      points[position].isSelect = true;
      pathPoints.add(points[position]);
    }
  }

  void clearAllData() {
    for (int i = 0; i < 9; i++) points[i].isSelect = false;
    pathPoints.clear();
    setState(() {});
  }
}

class _CanvasPoint extends CustomPainter {
  _CanvasPoint(
      {@required this.ringWidth,
      @required this.ringRadius,
      @required this.showUnSelectRing,
      @required this.circleRadius,
      @required this.selectColor,
      @required this.unSelectColor,
      @required this.points});

  final double ringWidth;
  final double ringRadius;
  final bool showUnSelectRing;
  final double circleRadius;
  final Color selectColor;
  final Color unSelectColor;
  final List<_Point> points;

  @override
  void paint(Canvas canvas, Size size) {
    /// 绘制9个圆
    final Paint ringPaint = Paint()
      ..isAntiAlias = true
      ..color = unSelectColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth;

    final Paint circlePaint = Paint()
      ..isAntiAlias = true
      ..color = unSelectColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      final _Point point = points[i];
      final Offset offSet = Offset(point.x, points[i].y);
      final Color color = point.isSelect ? selectColor : unSelectColor;
      circlePaint.color = color;
      ringPaint.color = color;
      canvas.drawCircle(offSet, circleRadius, circlePaint);
      if (showUnSelectRing || point.isSelect) {
        canvas.drawArc(Rect.fromCircle(center: offSet, radius: ringRadius), 0,
            360, false, ringPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _Point {
  _Point({@required this.x, @required this.y, @required this.position});

  double x;
  double y;
  bool isSelect = false;
  int position;
}

class _CanvasLine extends CustomPainter {
  _CanvasLine(
      {@required this.pathPoints,
      @required this.selectColor,
      @required this.lineWidth,
      @required this.curPoint});

  final List<_Point> pathPoints;
  final Color selectColor;
  final double lineWidth;
  final _Point curPoint;

  @override
  void paint(Canvas canvas, Size size) {
    final int length = pathPoints.length;
    if (length < 1) return;
    final Paint linePaint = Paint()
      ..isAntiAlias = true
      ..color = selectColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = lineWidth;

    for (int i = 0; i < length - 1; i++) {
      canvas.drawLine(Offset(pathPoints[i].x, pathPoints[i].y),
          Offset(pathPoints[i + 1].x, pathPoints[i + 1].y), linePaint);
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
    canvas.drawLine(Offset(pathPoints[length - 1].x, pathPoints[length - 1].y),
        Offset(endX, endY), linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
