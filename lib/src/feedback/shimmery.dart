import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/src/core/extended_state.dart';

/// 微光扫过动画，常用于骨架屏、占位图等加载场景。
///
/// 默认每 3 秒扫过一次、无间隔，方向为左上到右下，颜色为半透明白色渐变。
class FlShimmery extends StatefulWidget {
  const FlShimmery({
    super.key,
    required this.child,
    this.enabled = true,
    this.colors = const [
      Colors.transparent,
      Color.from(alpha: 0.05, red: 1, green: 1, blue: 1),
      Color.from(alpha: 0.3, red: 1, green: 1, blue: 1),
      Color.from(alpha: 0.05, red: 1, green: 1, blue: 1),
      Colors.transparent,
    ],
    this.duration = const Duration(seconds: 3),
    this.interval = const Duration(seconds: 0),
    this.direction = const FlShimmerDirection.fromLTRB(),
  }) : assert(colors.length >= 2, 'colors 至少需要 2 个颜色');

  /// 需要叠加微光动画的子组件。
  final Widget child;

  /// 是否启用动画，默认 true；为 false 时直接展示 child。
  final bool enabled;

  /// 渐变颜色列表，默认 透明→5%白→30%白→5%白→透明。
  final List<Color> colors;

  /// 单次扫过动画的时长，默认 3 秒。
  final Duration duration;

  /// 两次动画之间的间隔，默认 Duration.zero（立即重播）。
  final Duration interval;

  /// 动画移动方向，默认 FlShimmerDirection.fromLTRB()（左上到右下）。
  final FlShimmerDirection direction;

  @override
  State<FlShimmery> createState() => _ShimmeryState();
}

class _ShimmeryState extends FlExtendedState<FlShimmery> with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  AnimationController? controller;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    initController();
  }

  void initController() {
    animation?.removeListener(listener);
    animation = null;
    timer?.cancel();
    timer = null;
    if (!widget.enabled) {
      controller?.stop();
      return;
    }
    final AnimationController current = controller ??= AnimationController(vsync: this, duration: widget.duration);
    current.duration = widget.duration;
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: current,
        curve: const Interval(0, 0.6, curve: Curves.decelerate),
      ),
    )..addListener(listener);
    current.forward(from: 0);
  }

  void listener() {
    if (controller!.isCompleted && timer == null) {
      if (widget.interval <= Duration.zero) {
        controller!.forward(from: 0);
      } else {
        timer = Timer(widget.interval, () {
          timer = null;
          if (mounted) controller!.forward(from: 0);
        });
      }
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    animation?.removeListener(listener);
    controller?.dispose();
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FlShimmery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled ||
        widget.duration != oldWidget.duration ||
        widget.interval != oldWidget.interval) {
      initController();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return CustomPaint(
      foregroundPainter: _ShimmeryAnimation(
        context: context,
        position: animation!.value,
        colors: widget.colors,
        begin: widget.direction.begin,
        end: widget.direction.end,
      ),
      child: widget.child,
    );
  }
}

/// 微光动画的移动方向，由起止对齐点描述。
class FlShimmerDirection {
  /// 动画起点与终点。
  final Alignment begin, end;

  const FlShimmerDirection._fromLTRB({this.begin = Alignment.topLeft, this.end = Alignment.centerRight});

  const FlShimmerDirection._fromRTLB({this.begin = Alignment.centerRight, this.end = Alignment.topLeft});

  const FlShimmerDirection._fromLBRT({this.begin = Alignment.bottomLeft, this.end = Alignment.centerRight});

  const FlShimmerDirection._fromRBLT({this.begin = Alignment.bottomRight, this.end = Alignment.centerLeft});

  const FlShimmerDirection._fromLeftToRight({this.begin = Alignment.centerLeft, this.end = Alignment.centerRight});

  const FlShimmerDirection._fromRightToLeft({this.begin = Alignment.centerRight, this.end = Alignment.centerLeft});

  /// 默认方向：左上到右下。
  factory FlShimmerDirection() => const FlShimmerDirection._fromLTRB();

  /// 左上 → 右下（默认方向）。
  const factory FlShimmerDirection.fromLTRB() = FlShimmerDirection._fromLTRB;

  /// 右上 → 左下。
  const factory FlShimmerDirection.fromRTLB() = FlShimmerDirection._fromRTLB;

  /// 左下 → 右上。
  const factory FlShimmerDirection.fromLBRT() = FlShimmerDirection._fromLBRT;

  /// 右下 → 左上。
  const factory FlShimmerDirection.fromRBLT() = FlShimmerDirection._fromRBLT;

  /// 左中 → 右中。
  const factory FlShimmerDirection.fromLeftToRight() = FlShimmerDirection._fromLeftToRight;

  /// 右中 → 左中。
  const factory FlShimmerDirection.fromRightToLeft() = FlShimmerDirection._fromRightToLeft;
}

class _ShimmeryAnimation extends CustomPainter {
  final BuildContext context;
  double position;
  double width = 0.2;
  final List<Color> colors;
  final Alignment begin, end;

  _ShimmeryAnimation({
    required this.context,
    required this.position,
    required this.colors,
    required this.begin,
    required this.end,
  });

  //Custom Painter to paint one frame of the animation. This is called in a loop to animate
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    final List<double> stops = List<double>.generate(colors.length, (int index) {
      if (index == 0) return 0.0;
      if (index == colors.length - 1) return 1.0;
      return (position + (index - 1) * width).clamp(0.0, 1.0);
    });
    paint.style = PaintingStyle.fill;
    paint.shader = LinearGradient(tileMode: TileMode.decal, begin: begin, end: end, stops: stops, colors: colors)
        .createShader(
          Rect.fromLTRB(
            size.width * -0.5,
            (size.height > size.width) ? 0 : size.height * -0.5,
            size.width * 1.5,
            size.height * 1.5,
          ),
        );
    final Path path = Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
