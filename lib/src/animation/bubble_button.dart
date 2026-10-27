import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_waya/src/core/extended_state.dart';

/// 点击回调，返回下一次是否展示气泡动画
typedef FlBubbleCallback = Future<bool> Function(bool isBubbled);

/// 气泡按钮内容构建器，参数为当前是否处于气泡状态
typedef FlBubbleBuilder = Widget Function(bool isBubbled);

/// 气泡与小圆点的颜色配置
class FlBubbleColor {
  const FlBubbleColor({
    required this.dotFirstColor,
    required this.dotSecondColor,
    this.dotThirdColor,
    this.dotLastColor,
  });

  /// 第一个气泡颜色
  final Color dotFirstColor;

  /// 第二个气泡颜色
  final Color dotSecondColor;

  /// 第三个气泡颜色，为空时取 [dotFirstColor]
  final Color? dotThirdColor;

  /// 最后一个气泡颜色，为空时取 [dotSecondColor]
  final Color? dotLastColor;

  /// 实际使用的第三个气泡颜色
  Color get dotThirdColorReal => dotThirdColor ?? dotFirstColor;

  /// 实际使用的最后一个气泡颜色
  Color get dotLastColorReal => dotLastColor ?? dotSecondColor;
}

/// 圆环渐变色配置
class FlCircleColor {
  const FlCircleColor({required this.start, required this.end});

  /// 渐变起始颜色
  final Color start;

  /// 渐变结束颜色
  final Color end;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other.runtimeType == runtimeType && other is FlCircleColor && start == other.start && end == other.end;

  @override
  int get hashCode => Object.hash(start, end);
}

/// 点击后播放气泡扩散动画的按钮
class FlBubbleButton extends StatefulWidget {
  const FlBubbleButton({
    super.key,
    this.size = 20.0,
    required this.builder,
    double? bubblesSize,
    double? circleSize,
    this.initValue = false,
    this.duration = const Duration(milliseconds: 1000),
    this.bubbleColor = const FlBubbleColor(
      dotFirstColor: Colors.blue,
      dotSecondColor: Colors.lightBlue,
      dotThirdColor: Colors.lightBlueAccent,
      dotLastColor: Colors.lightGreenAccent,
    ),
    this.circleColor = const FlCircleColor(start: Colors.lightBlueAccent, end: Colors.lightGreenAccent),
    this.onTap,
  }) : bubblesSize = bubblesSize ?? size * 2.0,
       circleSize = circleSize ?? size * 0.8;

  /// 按钮尺寸，默认 20
  final double size;

  /// 气泡动画时长，默认 1000 毫秒
  final Duration duration;

  /// 气泡整体尺寸，默认 size * 2
  final double bubblesSize;

  /// 气泡颜色
  final FlBubbleColor bubbleColor;

  /// 圆环尺寸，默认 size * 0.8
  final double circleSize;

  /// 圆环渐变色
  final FlCircleColor circleColor;

  /// 点击按钮回调，返回下一次是否展示气泡动画
  final FlBubbleCallback? onTap;

  /// 初始是否处于气泡状态，默认 false
  final bool initValue;

  /// 按钮内容构建器，参数为当前是否处于气泡状态
  final FlBubbleBuilder builder;

  @override
  State<StatefulWidget> createState() => _BubbleButtonState();
}

class _BubbleButtonState extends FlExtendedState<FlBubbleButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _outerCircleAnimation;
  late Animation<double> _innerCircleAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bubblesAnimation;
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.initValue;
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _initControlAnimation();
  }

  @override
  void didUpdateWidget(FlBubbleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initValue != widget.initValue) _value = widget.initValue;
    if (_controller.duration != widget.duration) _controller.duration = widget.duration;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AnimatedBuilder bubble = AnimatedBuilder(
      animation: _controller,
      child: widget.builder.call(_value),
      builder: (BuildContext context, Widget? child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: (widget.size - widget.bubblesSize) / 2.0,
              left: (widget.size - widget.bubblesSize) / 2.0,
              child: CustomPaint(
                size: Size(widget.bubblesSize, widget.bubblesSize),
                painter: _BubblesPainter(
                  currentProgress: _bubblesAnimation.value,
                  color1: widget.bubbleColor.dotFirstColor,
                  color2: widget.bubbleColor.dotSecondColor,
                  color3: widget.bubbleColor.dotThirdColorReal,
                  color4: widget.bubbleColor.dotLastColorReal,
                ),
              ),
            ),
            Positioned(
              top: (widget.size - widget.circleSize) / 2.0,
              left: (widget.size - widget.circleSize) / 2.0,
              child: CustomPaint(
                size: Size(widget.circleSize, widget.circleSize),
                painter: _CirclePainter(
                  innerCircleRadiusProgress: _innerCircleAnimation.value,
                  outerCircleRadiusProgress: _outerCircleAnimation.value,
                  circleColor: widget.circleColor,
                ),
              ),
            ),
            Container(
              width: widget.size,
              height: widget.size,
              alignment: Alignment.center,
              child: Transform.scale(
                scale: (_value && _controller.isAnimating) ? _scaleAnimation.value : 1.0,
                child: SizedBox(height: widget.size, width: widget.size, child: child),
              ),
            ),
          ],
        );
      },
    );

    return GestureDetector(behavior: HitTestBehavior.translucent, onTap: onTap, child: bubble);
  }

  void onTap() {
    if (_controller.isAnimating) return;
    if (widget.onTap != null) {
      widget.onTap!(_value).then((bool value) {
        if (mounted) handleChanged(value);
      });
    } else {
      handleChanged(!_value);
    }
  }

  void handleChanged(bool value) {
    if (!mounted) return;
    _value = value;
    _controller.reset();
    _controller.forward();
    setState(() {});
  }

  void _initControlAnimation() {
    _outerCircleAnimation = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.ease),
      ),
    );
    _innerCircleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5, curve: Curves.ease),
      ),
    );
    final Animation<double> animate = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.7, curve: _OvershootCurve()),
      ),
    );
    _scaleAnimation = animate;
    _bubblesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 1.0, curve: Curves.decelerate),
      ),
    );
  }
}

double _mapValueFromRangeToRange(double value, double fromLow, double fromHigh, double toLow, double toHigh) =>
    toLow + ((value - fromLow) / (fromHigh - fromLow) * (toHigh - toLow));

double _clamp(double value, double low, double high) => math.min(math.max(value, low), high);

class _OvershootCurve extends Curve {
  const _OvershootCurve();

  final double period = 2.5;

  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    t -= 1.0;
    return t * t * ((period + 1) * t + period) + 1.0;
  }

  @override
  String toString() => '$runtimeType($period)';
}

class _CirclePainter extends CustomPainter {
  _CirclePainter({
    required this.outerCircleRadiusProgress,
    required this.innerCircleRadiusProgress,
    this.circleColor = const FlCircleColor(start: Color(0xFFFF5722), end: Color(0xFFFFC107)),
  }) {
    _circlePaint.style = PaintingStyle.stroke;
  }

  final Paint _circlePaint = Paint();

  final double outerCircleRadiusProgress;
  final double innerCircleRadiusProgress;
  final FlCircleColor circleColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double center = size.width * 0.5;
    _updateCircleColor();

    final double strokeWidth = outerCircleRadiusProgress * center - (innerCircleRadiusProgress * center);
    if (strokeWidth > 0.0) {
      _circlePaint.strokeWidth = strokeWidth;
      canvas.drawCircle(Offset(center, center), outerCircleRadiusProgress * center, _circlePaint);
    }
  }

  void _updateCircleColor() {
    double colorProgress = _clamp(outerCircleRadiusProgress, 0.5, 1.0);
    colorProgress = _mapValueFromRangeToRange(colorProgress, 0.5, 1.0, 0.0, 1.0);
    _circlePaint.color = Color.lerp(circleColor.start, circleColor.end, colorProgress)!;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate.runtimeType != runtimeType) return true;
    return oldDelegate is _CirclePainter &&
        (oldDelegate.outerCircleRadiusProgress != outerCircleRadiusProgress ||
            oldDelegate.innerCircleRadiusProgress != innerCircleRadiusProgress ||
            oldDelegate.circleColor != circleColor);
  }
}

class _BubblesPainter extends CustomPainter {
  _BubblesPainter({
    required this.currentProgress,
    this.color1 = const Color(0xFFFFC107),
    this.color2 = const Color(0xFFFF9800),
    this.color3 = const Color(0xFFFF5722),
    this.color4 = const Color(0xFFF44336),
  }) {
    _outerBubblesPositionAngle = 360.0 / bubblesCount;
    for (int i = 0; i < 4; i++) {
      _circlePaints.add(Paint()..style = PaintingStyle.fill);
    }
  }

  final double currentProgress;
  final int bubblesCount = 7;
  final Color color1;
  final Color color2;
  final Color color3;
  final Color color4;

  double _outerBubblesPositionAngle = 51.42;
  double _centerX = 0.0;
  double _centerY = 0.0;
  final List<Paint> _circlePaints = <Paint>[];

  double _maxOuterDotsRadius = 0.0;
  double _maxInnerDotsRadius = 0.0;
  late double _maxDotSize;

  double _currentRadius1 = 0.0;
  double _currentDotSize1 = 0.0;
  double _currentDotSize2 = 0.0;
  double _currentRadius2 = 0.0;

  @override
  void paint(Canvas canvas, Size size) {
    _centerX = size.width * 0.5;
    _centerY = size.height * 0.5;
    _maxDotSize = size.width * 0.05;
    _maxOuterDotsRadius = size.width * 0.5 - _maxDotSize * 2;
    _maxInnerDotsRadius = 0.8 * _maxOuterDotsRadius;

    _updateOuterBubblesPosition();
    _updateInnerBubblesPosition();
    _updateBubblesPaints();
    _drawOuterBubblesFrame(canvas);
    _drawInnerBubblesFrame(canvas);
  }

  num _degToRad(num deg) => deg * (math.pi / 180.0);

  void _drawOuterBubblesFrame(Canvas canvas) {
    final double start = _outerBubblesPositionAngle / 4.0 * 3.0;
    for (int i = 0; i < bubblesCount; i++) {
      final double cX = _centerX + _currentRadius1 * math.cos(_degToRad(start + _outerBubblesPositionAngle * i));
      final double cY = _centerY + _currentRadius1 * math.sin(_degToRad(start + _outerBubblesPositionAngle * i));
      canvas.drawCircle(Offset(cX, cY), _currentDotSize1, _circlePaints[i % _circlePaints.length]);
    }
  }

  void _drawInnerBubblesFrame(Canvas canvas) {
    final double start = _outerBubblesPositionAngle / 4.0 * 3.0 - _outerBubblesPositionAngle / 2.0;
    for (int i = 0; i < bubblesCount; i++) {
      final double cX = _centerX + _currentRadius2 * math.cos(_degToRad(start + _outerBubblesPositionAngle * i));
      final double cY = _centerY + _currentRadius2 * math.sin(_degToRad(start + _outerBubblesPositionAngle * i));
      canvas.drawCircle(Offset(cX, cY), _currentDotSize2, _circlePaints[(i + 1) % _circlePaints.length]);
    }
  }

  void _updateOuterBubblesPosition() {
    if (currentProgress < 0.3) {
      _currentRadius1 = _mapValueFromRangeToRange(currentProgress, 0.0, 0.3, 0.0, _maxOuterDotsRadius * 0.8);
    } else {
      _currentRadius1 = _mapValueFromRangeToRange(
        currentProgress,
        0.3,
        1.0,
        0.8 * _maxOuterDotsRadius,
        _maxOuterDotsRadius,
      );
    }
    if (currentProgress == 0) {
      _currentDotSize1 = 0;
    } else if (currentProgress < 0.7) {
      _currentDotSize1 = _maxDotSize;
    } else {
      _currentDotSize1 = _mapValueFromRangeToRange(currentProgress, 0.7, 1.0, _maxDotSize, 0.0);
    }
  }

  void _updateInnerBubblesPosition() {
    if (currentProgress < 0.3) {
      _currentRadius2 = _mapValueFromRangeToRange(currentProgress, 0.0, 0.3, 0.0, _maxInnerDotsRadius);
    } else {
      _currentRadius2 = _maxInnerDotsRadius;
    }
    if (currentProgress == 0) {
      _currentDotSize2 = 0;
    } else if (currentProgress < 0.2) {
      _currentDotSize2 = _maxDotSize;
    } else if (currentProgress < 0.5) {
      _currentDotSize2 = _mapValueFromRangeToRange(currentProgress, 0.2, 0.5, _maxDotSize, 0.3 * _maxDotSize);
    } else {
      _currentDotSize2 = _mapValueFromRangeToRange(currentProgress, 0.5, 1.0, _maxDotSize * 0.3, 0.0);
    }
  }

  void _updateBubblesPaints() {
    final double progress = _clamp(currentProgress, 0.6, 1.0);
    final int alpha = _mapValueFromRangeToRange(progress, 0.6, 1.0, 255.0, 0.0).toInt();
    if (currentProgress < 0.5) {
      final double progress = _mapValueFromRangeToRange(currentProgress, 0.0, 0.5, 0.0, 1.0);
      _circlePaints[0].color = Color.lerp(color1, color2, progress)!.withAlpha(alpha);
      _circlePaints[1].color = Color.lerp(color2, color3, progress)!.withAlpha(alpha);
      _circlePaints[2].color = Color.lerp(color3, color4, progress)!.withAlpha(alpha);
      _circlePaints[3].color = Color.lerp(color4, color1, progress)!.withAlpha(alpha);
    } else {
      final double progress = _mapValueFromRangeToRange(currentProgress, 0.5, 1.0, 0.0, 1.0);
      _circlePaints[0].color = Color.lerp(color2, color3, progress)!.withAlpha(alpha);
      _circlePaints[1].color = Color.lerp(color3, color4, progress)!.withAlpha(alpha);
      _circlePaints[2].color = Color.lerp(color4, color1, progress)!.withAlpha(alpha);
      _circlePaints[3].color = Color.lerp(color1, color2, progress)!.withAlpha(alpha);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate.runtimeType != runtimeType) return true;
    return oldDelegate is _BubblesPainter &&
        (oldDelegate.bubblesCount != bubblesCount ||
            oldDelegate.currentProgress != currentProgress ||
            oldDelegate.color1 != color1 ||
            oldDelegate.color2 != color2 ||
            oldDelegate.color3 != color3 ||
            oldDelegate.color4 != color4);
  }
}
