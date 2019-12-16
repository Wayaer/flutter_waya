import 'package:flutter/material.dart';

import 'CanvasLine.dart';
import 'CanvasPoint.dart';
import 'Point.dart';


// ignore: must_be_immutable
class Gesture extends StatefulWidget {
  final double size;
  final selectColor;
  final unSelectColor;
  final double ringWidth;
  final double ringRadius;
  final double circleRadius;
  final double lineWidth;
  final bool showUnSelectRing;
  final bool immediatelyClear;
  List<Point> points;
  final Function() onPanDown;
  final Function(List<int>) onPanUp;

  Gesture(
      {Key key,
      @required this.size,
      this.selectColor = Colors.greenAccent,
      this.unSelectColor = Colors.grey,
      this.ringWidth: 2,
      this.ringRadius: 35,
      this.showUnSelectRing: false,
      this.circleRadius: 10,
      this.lineWidth: 3,
      this.onPanUp,
      this.onPanDown,
      this.immediatelyClear: true})
      : super(key: key) {
    // 减少刷新频率
    points = [];
    final realRingSize = this.ringRadius + this.ringWidth / 2;
    final gapWidth = size / 6 - realRingSize;
    for (int i = 0; i < 9; i++) {
      double x = gapWidth + realRingSize;
      double y = gapWidth + realRingSize;
      points.add(Point(x: (1 + i % 3 * 2) * x, y: (1 + i ~/ 3 * 2) * y, position: i));
    }
  }

  @override
  State<StatefulWidget> createState() {
    return GestureState();
  }
}

class GestureState extends State<Gesture> {
  double size;
  double ringWidth;
  double ringRadius;
  bool showUnSelectRing;
  double circleRadius;
  Color selectColor; // open only
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
            size: Size(this.size, this.size),
            painter: CanvasPoint(
                ringWidth: this.ringWidth,
                ringRadius: this.ringRadius,
                showUnSelectRing: this.showUnSelectRing,
                circleRadius: this.circleRadius,
                selectColor: this.selectColor,
                unSelectColor: this.unSelectColor,
                points: points),
          ),
        ),
        GestureDetector(
            child: CustomPaint(
              size: Size(this.size, this.size),
              painter: CanvasLine(
                  pathPoints: this.pathPoints,
                  selectColor: this.selectColor,
                  lineWidth: this.lineWidth,
                  curPoint: this.curPoint),
            ),
            onPanDown: this._onPanDown,
            onPanUpdate: (DragUpdateDetails e) => this._onPanUpdate(e, context),
            onPanEnd: (DragEndDetails e) => this._onPanEnd(e, context))
      ],
    );
  }

  _onPanDown(DragDownDetails e) {
    this._clearAllData();
    if (this.onPanDown != null) this.onPanDown();
  }

  _onPanUpdate(DragUpdateDetails e, BuildContext context) {
    RenderBox box = context.findRenderObject();
    Offset offset = box.globalToLocal(e.globalPosition);
    _slideDealt(offset);
    setState(() {
      curPoint = Point(x: offset.dx, y: offset.dy, position: -1);
    });
  }

  _onPanEnd(DragEndDetails e, BuildContext context) {
    if (pathPoints.length > 0) {
      setState(() {
        curPoint = pathPoints[pathPoints.length - 1];
      });
      if (this.onPanUp != null) {
        List<int> items = pathPoints.map((item) => item.position).toList();
        this.onPanUp(items);
      }
      if (this.immediatelyClear) this._clearAllData(); //clear data
    }
  }

  _slideDealt(Offset offSet) {
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
    int position = yPosition * 3 + xPosition;

    if (!points[position].isSelect) {
      points[position].isSelect = true;
      pathPoints.add(points[position]);
    }
  }

  _clearAllData() {
    for (int i = 0; i < 9; i++) {
      points[i].isSelect = false;
    }
    pathPoints.clear();
    setState(() {});
  }
}
