import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 可缩放/平移的盒子小部件
class GestureZoom extends StatefulWidget {
  const GestureZoom({
    super.key,
    this.maxScale = 5.0,
    this.doubleTapScale = 2.0,
    required this.child,
    this.onPressed,
    this.duration = const Duration(milliseconds: 300),
  })  : assert(maxScale >= 1.0),
        assert(doubleTapScale >= 1.0 && doubleTapScale <= maxScale);

  /// 通过最大缩放比例 [maxScale]、双击缩放比例 [doubleTapScale]、子部件 [child]、点击事件 [onPressed] 创建小部件
  final double maxScale;

  /// 双击放大比例
  final double doubleTapScale;

  /// 要缩放的组件
  final Widget child;

  final VoidCallback? onPressed;

  /// 动画延迟时间
  final Duration duration;

  @override
  State<GestureZoom> createState() => _GestureZoomState();
}

class _GestureZoomState extends ExtendedState<GestureZoom>
    with TickerProviderStateMixin {
  /// 缩放动画控制器
  AnimationController? _scaleAnimController;

  /// 偏移动画控制器
  AnimationController? _offsetAnimController;

  /// 上次缩放变化数据
  ScaleUpdateDetails? _latestScaleUpdateDetails;

  /// 当前缩放值
  double _scale = 1.0;

  /// 当前偏移值
  Offset _offset = Offset.zero;

  /// 双击缩放的点击位置
  late Offset _doubleTapPosition;

  bool _isScaling = false;
  bool _isDragging = false;

  /// 拖动超出边界的最大值
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

  /// 处理手指抬起事件 [event]
  void _onPointerUp(PointerUpEvent event) =>
      _doubleTapPosition = event.localPosition;

  /// 处理双击
  void _onDoubleTap() {
    final double targetScale = _scale == 1.0 ? widget.doubleTapScale : 1.0;
    _animationScale(targetScale);
    if (targetScale == 1.0) _animationOffset(Offset.zero);
  }

  void _onScaleStart(ScaleStartDetails details) {
    _scaleAnimController?.stop();
    _offsetAnimController?.stop();
  }

  /// 处理缩放变化 [details]
  void _onScaleUpdate(ScaleUpdateDetails details) {
    details.scale != 1.0 ? _scaling(details) : _dragging(details);
    setState(() {});
  }

  /// 执行缩放
  void _scaling(ScaleUpdateDetails details) {
    if (_isDragging) return;
    _isScaling = true;
    if (_latestScaleUpdateDetails == null) {
      _latestScaleUpdateDetails = details;
      return;
    }

    /// 计算缩放比例
    double scaleIncrement = details.scale - _latestScaleUpdateDetails!.scale;
    if (details.scale < 1.0 && _scale > 1.0) scaleIncrement *= _scale;

    if (_scale < 1.0 && scaleIncrement < 0) {
      scaleIncrement *= _scale - 0.5;
    } else if (_scale > widget.maxScale && scaleIncrement > 0) {
      scaleIncrement *= 2.0 - (_scale - widget.maxScale);
    }
    _scale += scaleIncrement;

    /// 计算缩放后偏移前（缩放前后的内容中心对齐）的左上角坐标变化
    final double scaleOffsetX = context.size!.width * (_scale - 1.0) / 2;
    final double scaleOffsetY = context.size!.height * (_scale - 1.0) / 2;

    /// 将缩放前的触摸点映射到缩放后的内容上
    final double scalePointDX =
        (details.localFocalPoint.dx + scaleOffsetX - _offset.dx) / _scale;
    final double scalePointDY =
        (details.localFocalPoint.dy + scaleOffsetY - _offset.dy) / _scale;

    /// 计算偏移，使缩放中心在屏幕上的位置保持不变
    _offset += Offset(
      (context.size!.width / 2 - scalePointDX) * scaleIncrement,
      (context.size!.height / 2 - scalePointDY) * scaleIncrement,
    );

    _latestScaleUpdateDetails = details;
  }

  /// 执行拖动
  void _dragging(ScaleUpdateDetails details) {
    if (_isScaling) return;

    _isDragging = true;
    if (_latestScaleUpdateDetails == null) {
      _latestScaleUpdateDetails = details;
      return;
    }

    /// 计算本次拖动增量
    double offsetXIncrement = (details.localFocalPoint.dx -
            _latestScaleUpdateDetails!.localFocalPoint.dx) *
        _scale;
    double offsetYIncrement = (details.localFocalPoint.dy -
            _latestScaleUpdateDetails!.localFocalPoint.dy) *
        _scale;

    /// 处理 X 轴边界
    final double scaleOffsetX = context.size!.width * (_scale - 1.0) / 2;
    if (scaleOffsetX <= 0) {
      offsetXIncrement = 0;
    } else if (_offset.dx > scaleOffsetX) {
      offsetXIncrement *=
          (_maxDragOver - (_offset.dx - scaleOffsetX)) / _maxDragOver;
    } else if (_offset.dx < -scaleOffsetX) {
      offsetXIncrement *=
          (_maxDragOver - (-scaleOffsetX - _offset.dx)) / _maxDragOver;
    }

    /// 处理 Y 轴边界
    final double scaleOffsetY =
        (context.size!.height * _scale - deviceHeight) / 2;
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

  /// 缩放/拖动结束
  void _onScaleEnd(ScaleEndDetails details) {
    if (_scale < 1.0) {
      /// 缩放值过小，恢复到 1.0
      _animationScale(1.0);
    } else if (_scale > widget.maxScale) {
      /// 缩放值过大，恢复到最大值
      _animationScale(widget.maxScale);
    }
    if (_scale <= 1.0) {
      /// 缩放值过小，修改偏移值，使内容居中
      _animationOffset(Offset.zero);
    } else if (_isDragging) {
      /// 处理拖动超过边界的情况（自动回弹到边界）
      final double realScale =
          _scale > widget.maxScale ? widget.maxScale : _scale;
      double targetOffsetX = _offset.dx, targetOffsetY = _offset.dy;

      /// 处理 X 轴边界
      final double scaleOffsetX = context.size!.width * (realScale - 1.0) / 2;
      if (scaleOffsetX <= 0) {
        targetOffsetX = 0;
      } else if (_offset.dx > scaleOffsetX) {
        targetOffsetX = scaleOffsetX;
      } else if (_offset.dx < -scaleOffsetX) {
        targetOffsetX = -scaleOffsetX;
      }

      /// 处理 Y 轴边界
      final double scaleOffsetY =
          (context.size!.height * realScale - deviceHeight) / 2;
      if (scaleOffsetY < 0) {
        targetOffsetY = 0;
      } else if (_offset.dy > scaleOffsetY) {
        targetOffsetY = scaleOffsetY;
      } else if (_offset.dy < -scaleOffsetY) {
        targetOffsetY = -scaleOffsetY;
      }
      if (_offset.dx != targetOffsetX || _offset.dy != targetOffsetY) {
        /// 启动越界回弹
        _animationOffset(Offset(targetOffsetX, targetOffsetY));
      } else {
        /// 处理 X 轴边界
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

        /// 处理 X 轴边界
        targetOffsetY = targetOffset.dy;
        if (targetOffsetY > scaleOffsetY) {
          targetOffsetY = scaleOffsetY;
        } else if (targetOffsetY < -scaleOffsetY) {
          targetOffsetY = -scaleOffsetY;
        }

        /// 启动惯性滚动
        _animationOffset(Offset(targetOffsetX, targetOffsetY));
      }
    }

    _isScaling = false;
    _isDragging = false;
    _latestScaleUpdateDetails = null;
  }

  /// 执行动画缩放内容到 [targetScale]
  void _animationScale(double targetScale) {
    _scaleAnimController?.dispose();
    _scaleAnimController =
        AnimationController(vsync: this, duration: widget.duration);
    final Animation<dynamic> anim =
        Tween<double>(begin: _scale, end: targetScale)
            .animate(_scaleAnimController!);
    anim.addListener(() {
      _scaling(ScaleUpdateDetails(
        focalPoint: _doubleTapPosition,
        localFocalPoint: _doubleTapPosition,
        scale: anim.value as double,
        horizontalScale: anim.value as double,
        verticalScale: anim.value as double,
      ));
      setState(() {});
    });
    anim.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) _onScaleEnd(ScaleEndDetails());
    });
    _scaleAnimController?.forward();
  }

  /// 执行动画偏移内容到 [targetOffset]
  void _animationOffset(Offset targetOffset) {
    _offsetAnimController?.dispose();
    _offsetAnimController =
        AnimationController(vsync: this, duration: widget.duration);
    final Animation<dynamic> anim = _offsetAnimController!
        .drive<dynamic>(Tween<Offset>(begin: _offset, end: targetOffset));
    anim.addListener(() {
      _offset = anim.value as Offset;
      setState(() {});
    });
    _offsetAnimController?.fling();
  }
}
