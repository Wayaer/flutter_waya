import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';

import 'gusturelock/CanvasLine.dart';
import 'gusturelock/CanvasPoint.dart';
import 'gusturelock/Point.dart';

/// ignore: must_be_immutable
class GestureLock extends StatefulWidget {
  final double size;
  Color selectColor;
  Color unSelectColor;
  final double ringWidth;
  final double ringRadius;
  final double circleRadius;
  final double lineWidth;
  final bool showUnSelectRing;
  final bool immediatelyClear;
  List<Point> points;
  final Function() onPanDown;
  final Function(List<int>) onPanUp;

  GestureLock({Key key,
    @required this.size,
    this.selectColor,
    this.unSelectColor,
    this.ringWidth: 2,
    this.ringRadius: 35,
    this.showUnSelectRing: false,
    this.circleRadius: 10,
    this.lineWidth: 3,
    this.onPanUp,
    this.onPanDown,
    this.immediatelyClear: true})
      : super(key: key) {
    /// 减少刷新频率
    points = [];
    if (selectColor == null) selectColor = getColors(greenAccent);
    if (unSelectColor == null) unSelectColor = getColors(black30);
    final realRingSize = this.ringRadius + this.ringWidth / 2;
    final gapWidth = size / 6 - realRingSize;
    for (int i = 0; i < 9; i++) {
      double x = gapWidth + realRingSize;
      double y = gapWidth + realRingSize;
      points.add(
          Point(x: (1 + i % 3 * 2) * x, y: (1 + i ~/ 3 * 2) * y, position: i));
    }
  }

  @override
  State<StatefulWidget> createState() {
    return GestureLockState();
  }
}

class GestureLockState extends State<GestureLock> {
  double size;
  double ringWidth;
  double ringRadius;
  bool showUnSelectRing;
  double circleRadius;
  Color selectColor;

  /// open only
  Color unSelectColor;
  double lineWidth;
  List<Point> points;
  Function() onPanDown;
  Function(List<int>) onPanUp;
  List<Point> pathPoints = [];
  double realRadius = 0;
  Point curPoint;
  bool immediatelyClear;

  @override
  void initState() {
    super.initState();
    size = widget.size;
    ringWidth = widget.ringWidth;
    ringRadius = widget.ringRadius;
    showUnSelectRing = widget.showUnSelectRing;
    circleRadius = widget.circleRadius;
    selectColor = widget.selectColor;
    unSelectColor = widget.unSelectColor;
    lineWidth = widget.lineWidth;
    points = widget.points;
    onPanDown = widget.onPanDown;
    onPanUp = widget.onPanUp;
    immediatelyClear = widget.immediatelyClear;
    realRadius = this.ringRadius + this.ringWidth / 2;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: CustomPaint(
            size: Size(size, size),
            painter: CanvasPoint(
                ringWidth: ringWidth,
                ringRadius: ringRadius,
                showUnSelectRing: showUnSelectRing,
                circleRadius: circleRadius,
                selectColor: selectColor,
                unSelectColor: unSelectColor,
                points: points),
          ),
        ),
        GestureDetector(
            child: CustomPaint(
              size: Size(size, size),
              painter: CanvasLine(
                  pathPoints: pathPoints,
                  selectColor: selectColor,
                  lineWidth: lineWidth,
                  curPoint: curPoint),
            ),
            onPanDown: onPanDownVoid,
            onPanUpdate: (DragUpdateDetails e) => onPanUpdate(e, context),
            onPanEnd: (DragEndDetails e) => onPanEnd(e, context))
      ],
    );
  }

  onPanDownVoid(DragDownDetails e) {
    clearAllData();
    if (onPanDown != null) onPanDown();
  }

  onPanUpdate(DragUpdateDetails e, BuildContext context) {
    RenderBox box = context.findRenderObject();
    Offset offset = box.globalToLocal(e.globalPosition);
    slideDealt(offset);
    setState(() {
      curPoint = Point(x: offset.dx, y: offset.dy, position: -1);
    });
  }

  onPanEnd(DragEndDetails e, BuildContext context) {
    if (pathPoints.length > 0) {
      setState(() {
        curPoint = pathPoints[pathPoints.length - 1];
      });
      if (onPanUp != null) {
        List<int> items = pathPoints.map((item) => item.position).toList();
        onPanUp(items);
      }
      if (immediatelyClear) clearAllData();

      ///clear data
    }
  }

  slideDealt(Offset offSet) {
    int xPosition = -1;
    int yPosition = -1;
    for (int i = 0; i < 3; i++) {
      if (xPosition == -1 && points[i].x + realRadius >= offSet.dx &&
          offSet.dx >= points[i].x - realRadius) {
        xPosition = i;
      }
      if (yPosition == -1 && points[i * 3].y + realRadius >= offSet.dy &&
          offSet.dy >= points[i * 3].y - realRadius) {
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
    for (int i = 0; i < 9; i++) {
      points[i].isSelect = false;
    }
    pathPoints.clear();
    setState(() {});
  }
}
