import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 九宫格解锁
class GestureLock extends StatefulWidget {
  const GestureLock(
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
      : selectColor = selectColor ?? ConstColors.greenAccent,
        unSelectColor = unSelectColor ?? ConstColors.black30,
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
  final Function onPanDown;
  final ValueChanged<List<int>> onPanUp;

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
    points = 9.generate((int i) {
      final double x = gapWidth + realRingSize;
      final double y = gapWidth + realRingSize;
      return _Point(
          x: (1 + i % 3 * 2) * x, y: (1 + i ~/ 3 * 2) * y, position: i);
    });
  }

  @override
  Widget build(BuildContext context) => Stack(children: <Widget>[
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
        )),
        Universal(
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
      ]);

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
            pathPoints.builder((_Point item) => item.position);
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
    final Paint ringPaint = Paint()
      ..isAntiAlias = true
      ..color = unSelectColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth;

    final Paint circlePaint = Paint()
      ..isAntiAlias = true
      ..color = unSelectColor
      ..style = PaintingStyle.fill;

    points.builder((_Point point) {
      final Offset offSet = Offset(point.x, point.y);
      final Color color = point.isSelect ? selectColor : unSelectColor;
      circlePaint.color = color;
      ringPaint.color = color;
      canvas.drawCircle(offSet, circleRadius, circlePaint);
      if (showUnSelectRing || point.isSelect) {
        canvas.drawArc(Rect.fromCircle(center: offSet, radius: ringRadius), 0,
            360, false, ringPaint);
      }
    });
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

///  可缩放/平移的盒子小部件
class GestureZoom extends StatefulWidget {
  const GestureZoom({
    Key key,
    this.maxScale = 5.0,
    this.doubleTapScale = 2.0,
    @required this.child,
    this.onPressed,
    this.duration = const Duration(milliseconds: 20),
  })  : assert(maxScale >= 1.0),
        assert(doubleTapScale >= 1.0 && doubleTapScale <= maxScale),
        super(key: key);

  ///  通过最大缩放比例 [maxScale]、双击缩放比例 [doubleTapScale]、子部件 [child]、点击事件 [onPressed] 创建小部件
  final double maxScale;
  final double doubleTapScale;
  final Widget child;
  final VoidCallback onPressed;
  final Duration duration;

  @override
  _GestureZoomState createState() => _GestureZoomState();
}

class _GestureZoomState extends State<GestureZoom>
    with TickerProviderStateMixin {
  ///  缩放动画控制器
  AnimationController _scaleAnimController;

  ///  偏移动画控制器
  AnimationController _offsetAnimController;

  ///  上次缩放变化数据
  ScaleUpdateDetails _latestScaleUpdateDetails;

  ///  当前缩放值
  double _scale = 1.0;

  ///  当前偏移值
  Offset _offset = Offset.zero;

  ///  双击缩放的点击位置
  Offset _doubleTapPosition;

  bool _isScaling = false;
  bool _isDragging = false;

  ///  拖动超出边界的最大值
  final double _maxDragOver = 100;

  @override
  Widget build(BuildContext context) => Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..translate(_offset.dx, _offset.dy)
        ..scale(_scale, _scale),
      child: Listener(
          onPointerUp: _onPointerUp,
          child: GestureDetector(
              onTap: widget.onPressed,
              onDoubleTap: _onDoubleTap,
              onScaleStart: _onScaleStart,
              onScaleUpdate: _onScaleUpdate,
              onScaleEnd: _onScaleEnd,
              child: widget.child)));

  @override
  void dispose() {
    _scaleAnimController?.dispose();
    _offsetAnimController?.dispose();
    super.dispose();
  }

  ///  处理手指抬起事件 [event]
  void _onPointerUp(PointerUpEvent event) =>
      _doubleTapPosition = event.localPosition;

  ///  处理双击
  void _onDoubleTap() {
    final double targetScale = _scale == 1.0 ? widget.doubleTapScale : 1.0;
    _animationScale(targetScale);
    if (targetScale == 1.0) _animationOffset(Offset.zero);
  }

  void _onScaleStart(ScaleStartDetails details) {
    _scaleAnimController?.stop();
    _offsetAnimController?.stop();
  }

  ///  处理缩放变化 [details]
  void _onScaleUpdate(ScaleUpdateDetails details) => setState(() {
        details.scale != 1.0 ? _scaling(details) : _dragging(details);
      });

  ///  执行缩放
  void _scaling(ScaleUpdateDetails details) {
    if (_isDragging) return;
    _isScaling = true;
    if (_latestScaleUpdateDetails == null) {
      _latestScaleUpdateDetails = details;
      return;
    }

    ///  计算缩放比例
    double scaleIncrement = details.scale - _latestScaleUpdateDetails.scale;
    if (details.scale < 1.0 && _scale > 1.0) scaleIncrement *= _scale;

    if (_scale < 1.0 && scaleIncrement < 0) {
      scaleIncrement *= _scale - 0.5;
    } else if (_scale > widget.maxScale && scaleIncrement > 0) {
      scaleIncrement *= 2.0 - (_scale - widget.maxScale);
    }
    _scale += scaleIncrement;

    ///  计算缩放后偏移前（缩放前后的内容中心对齐）的左上角坐标变化
    final double scaleOffsetX = context.size.width * (_scale - 1.0) / 2;
    final double scaleOffsetY = context.size.height * (_scale - 1.0) / 2;

    ///  将缩放前的触摸点映射到缩放后的内容上
    final double scalePointDX =
        (details.localFocalPoint.dx + scaleOffsetX - _offset.dx) / _scale;
    final double scalePointDY =
        (details.localFocalPoint.dy + scaleOffsetY - _offset.dy) / _scale;

    ///  计算偏移，使缩放中心在屏幕上的位置保持不变
    _offset += Offset(
      (context.size.width / 2 - scalePointDX) * scaleIncrement,
      (context.size.height / 2 - scalePointDY) * scaleIncrement,
    );

    _latestScaleUpdateDetails = details;
  }

  ///  执行拖动
  void _dragging(ScaleUpdateDetails details) {
    if (_isScaling) return;

    _isDragging = true;
    if (_latestScaleUpdateDetails == null) {
      _latestScaleUpdateDetails = details;
      return;
    }

    ///  计算本次拖动增量
    double offsetXIncrement = (details.localFocalPoint.dx -
            _latestScaleUpdateDetails.localFocalPoint.dx) *
        _scale;
    double offsetYIncrement = (details.localFocalPoint.dy -
            _latestScaleUpdateDetails.localFocalPoint.dy) *
        _scale;

    ///  处理 X 轴边界
    final double scaleOffsetX = context.size.width * (_scale - 1.0) / 2;
    if (scaleOffsetX <= 0) {
      offsetXIncrement = 0;
    } else if (_offset.dx > scaleOffsetX) {
      offsetXIncrement *=
          (_maxDragOver - (_offset.dx - scaleOffsetX)) / _maxDragOver;
    } else if (_offset.dx < -scaleOffsetX) {
      offsetXIncrement *=
          (_maxDragOver - (-scaleOffsetX - _offset.dx)) / _maxDragOver;
    }

    ///  处理 Y 轴边界
    final double scaleOffsetY =
        (context.size.height * _scale - deviceHeight) / 2;
    if (scaleOffsetY <= 0) {
      offsetYIncrement = 0;
    } else if (_offset.dy > scaleOffsetY) {
      offsetYIncrement *=
          (_maxDragOver - (_offset.dy - scaleOffsetY)) / _maxDragOver;
    } else if (_offset.dy < -scaleOffsetY) {
      offsetYIncrement *=
          (_maxDragOver - (-scaleOffsetY - _offset.dy)) / _maxDragOver;
    }

    _offset += Offset(offsetXIncrement, offsetYIncrement);

    _latestScaleUpdateDetails = details;
  }

  ///  缩放/拖动结束
  void _onScaleEnd(ScaleEndDetails details) {
    if (_scale < 1.0) {
      ///  缩放值过小，恢复到 1.0
      _animationScale(1.0);
    } else if (_scale > widget.maxScale) {
      ///  缩放值过大，恢复到最大值
      _animationScale(widget.maxScale);
    }
    if (_scale <= 1.0) {
      ///  缩放值过小，修改偏移值，使内容居中
      _animationOffset(Offset.zero);
    } else if (_isDragging) {
      ///  处理拖动超过边界的情况（自动回弹到边界）
      final double realScale =
          _scale > widget.maxScale ? widget.maxScale : _scale;
      double targetOffsetX = _offset.dx, targetOffsetY = _offset.dy;

      ///  处理 X 轴边界
      final double scaleOffsetX = context.size.width * (realScale - 1.0) / 2;
      if (scaleOffsetX <= 0) {
        targetOffsetX = 0;
      } else if (_offset.dx > scaleOffsetX) {
        targetOffsetX = scaleOffsetX;
      } else if (_offset.dx < -scaleOffsetX) {
        targetOffsetX = -scaleOffsetX;
      }

      ///  处理 Y 轴边界
      final double scaleOffsetY =
          (context.size.height * realScale - deviceHeight) / 2;
      if (scaleOffsetY < 0) {
        targetOffsetY = 0;
      } else if (_offset.dy > scaleOffsetY) {
        targetOffsetY = scaleOffsetY;
      } else if (_offset.dy < -scaleOffsetY) {
        targetOffsetY = -scaleOffsetY;
      }
      if (_offset.dx != targetOffsetX || _offset.dy != targetOffsetY) {
        ///  启动越界回弹
        _animationOffset(Offset(targetOffsetX, targetOffsetY));
      } else {
        ///  处理 X 轴边界
        final double duration =
            widget.duration.inSeconds + widget.duration.inMilliseconds / 1000;
        final Offset targetOffset =
            _offset + details.velocity.pixelsPerSecond * duration;
        targetOffsetX = targetOffset.dx;
        if (targetOffsetX > scaleOffsetX) {
          targetOffsetX = scaleOffsetX;
        } else if (targetOffsetX < -scaleOffsetX) {
          targetOffsetX = -scaleOffsetX;
        }

        ///  处理 X 轴边界
        targetOffsetY = targetOffset.dy;
        if (targetOffsetY > scaleOffsetY) {
          targetOffsetY = scaleOffsetY;
        } else if (targetOffsetY < -scaleOffsetY) {
          targetOffsetY = -scaleOffsetY;
        }

        ///  启动惯性滚动
        _animationOffset(Offset(targetOffsetX, targetOffsetY));
      }
    }

    _isScaling = false;
    _isDragging = false;
    _latestScaleUpdateDetails = null;
  }

  ///  执行动画缩放内容到 [targetScale]
  void _animationScale(double targetScale) {
    _scaleAnimController?.dispose();
    _scaleAnimController =
        AnimationController(vsync: this, duration: widget.duration);
    final Animation<dynamic> anim =
        Tween<double>(begin: _scale, end: targetScale)
            .animate(_scaleAnimController);
    anim.addListener(() => setState(() {
          _scaling(ScaleUpdateDetails(
            focalPoint: _doubleTapPosition,
            localFocalPoint: _doubleTapPosition,
            scale: anim.value as double,
            horizontalScale: anim.value as double,
            verticalScale: anim.value as double,
          ));
        }));
    anim.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) _onScaleEnd(ScaleEndDetails());
    });
    _scaleAnimController.forward();
  }

  ///  执行动画偏移内容到 [targetOffset]
  void _animationOffset(Offset targetOffset) {
    _offsetAnimController?.dispose();
    _offsetAnimController =
        AnimationController(vsync: this, duration: widget.duration);
    final Animation<dynamic> anim = _offsetAnimController
        .drive<dynamic>(Tween<Offset>(begin: _offset, end: targetOffset));
    anim.addListener(() => setState(() {
          _offset = anim.value as Offset;
        }));
    _offsetAnimController.fling();
  }
}
