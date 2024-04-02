import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/src/extended_state.dart';

/// Creates simple yet beautiful shimmer animations
///
/// Shimmer is very widely used as the default animation for skeleton loaders or placeholder widgets throughout the development community.
/// Therefore, having an easy to use, yet customizable widget ready to use for Android, iOS and Web, gives developers an advantage to focus on their actual functionality, let shimmer make the loading experience smoother.
///
/// By default, the widget will select the preset config but it can be easily customized as shown below:
///
/// - @required [child] : accepts a child [Widget] over which the animation is to be displayed
/// - [color] : accepts a [Color] and sets the color of the animation overlay. Default value is [Colors.white]
/// - [colorOpacity] : accepts a [double] and sets the Opacity of the color of the animation overlay. Default value is [0.3]
/// - [enabled] : accepts a [bool] which toggles the animation on/off. Default value is [true]
/// - [duration] : accepts a [Duration] that would be the time period of animation. Default value is [Duration(seconds: 3)]
/// - [interval] : accepts a [Duration] that would be the interval between the repeating animation. Default value is [Duration(seconds: 0)]
/// - [direction] : accepts a [ShimmerDirection] and aligns the animation accordingly. Default value is [ShimmerDirection.fromLBRT()]
class Shimmery extends StatefulWidget {
  const Shimmery({
    super.key,
    required this.child,
    this.enabled = true,
    this.color = Colors.white,
    this.colorOpacity = 0.3,
    this.duration = const Duration(seconds: 3),
    this.interval = const Duration(seconds: 0),
    this.direction = const ShimmerDirection.fromLTRB(),
  });

  /// Accepts a child [Widget] over which the animation is to be displayed
  final Widget child;

  /// Accepts a [bool] which toggles the animation on/off. Default value is [true]
  final bool enabled;

  /// Accepts a parameter of type [Color] and sets the color of the animation overlay. Default value is [Colors.white]
  final Color color;

  /// Accepts a parameter of type [double] and sets the Opacity of the color of the animation overlay. Default value is [0.3]
  final double colorOpacity;

  /// Accepts a [Duration] that would be the time period of animation. Default value is [Duration(seconds: 3)]
  final Duration duration;

  /// Accepts a [Duration] that would be the interval between the repeating animation. Default value is [Duration(seconds: 0)] i.e. no interval
  final Duration interval;

  /// Accepts a [ShimmerDirection] and aligns the animation accordingly. Default value is [ShimmerDirection.fromLBRT()]
  final ShimmerDirection direction;

  @override
  State<Shimmery> createState() => _ShimmeryState();
}

class _ShimmeryState extends ExtendedState<Shimmery>
    with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  AnimationController? controller;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    initController();
  }

  void initController() {
    controller?.dispose();
    controller = null;
    animation?.removeListener(listener);
    animation = null;
    if (widget.enabled) {
      controller = AnimationController(vsync: this, duration: widget.duration);
      animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: controller!,
        curve: const Interval(0, 0.6, curve: Curves.decelerate),
      ))
        ..addListener(listener);
      controller!.forward();
    }
  }

  void listener() async {
    if (controller!.isCompleted) {
      timer = Timer(
          widget.interval, () => mounted ? controller!.forward(from: 0) : null);
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Shimmery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
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
            color: widget.color,
            opacity: widget.colorOpacity,
            begin: widget.direction.begin,
            end: widget.direction.end),
        child: widget.child);
  }
}

/// A direction along which the shimmer animation will travel
///
///
/// Shimmer animation can travel in 6 possible directions:
///
/// Diagonal Directions:
/// - [ShimmerDirection.fromLTRB] : animation starts from Left Top and moves towards the Right Bottom. This is also the default behaviour if no direction is specified.
/// - [ShimmerDirection.fromRTLB] : animation starts from Right Top and moves towards the Left Bottom
/// - [ShimmerDirection.fromLBRT] : animation starts from Left Bottom and moves towards the Right Top
/// - [ShimmerDirection.fromRBLT] : animation starts from Right Bottom and moves towards the Left Top
///
/// Directions along the axes:
/// - [ShimmerDirection.fromLeftToRight] : animation starts from Left Center and moves towards the Right Center
/// - [ShimmerDirection.fromRightToLeft] : animation starts from Right Center and moves towards the Left Center
class ShimmerDirection {
  final Alignment begin, end;

  const ShimmerDirection._fromLTRB({
    this.begin = Alignment.topLeft,
    this.end = Alignment.centerRight,
  });

  const ShimmerDirection._fromRTLB({
    this.begin = Alignment.centerRight,
    this.end = Alignment.topLeft,
  });

  const ShimmerDirection._fromLBRT({
    this.begin = Alignment.bottomLeft,
    this.end = Alignment.centerRight,
  });

  const ShimmerDirection._fromRBLT({
    this.begin = Alignment.topRight,
    this.end = Alignment.centerLeft,
  });

  const ShimmerDirection._fromLeftToRight({
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
  });

  const ShimmerDirection._fromRightToLeft({
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
  });

  factory ShimmerDirection() => const ShimmerDirection._fromLTRB();

  /// Animation starts from Left Top and moves towards the Right Bottom
  const factory ShimmerDirection.fromLTRB() = ShimmerDirection._fromLTRB;

  /// Animation starts from Right Top and moves towards the Left Bottom
  const factory ShimmerDirection.fromRTLB() = ShimmerDirection._fromRTLB;

  /// Animation starts from Left Bottom and moves towards the Right Top
  const factory ShimmerDirection.fromLBRT() = ShimmerDirection._fromLBRT;

  /// Animation starts from Right Bottom and moves towards the Left Top
  const factory ShimmerDirection.fromRBLT() = ShimmerDirection._fromRBLT;

  /// Animation starts from Left Center and moves towards the Right Center
  const factory ShimmerDirection.fromLeftToRight() =
      ShimmerDirection._fromLeftToRight;

  /// Animation starts from Right Center and moves towards the Left Center
  const factory ShimmerDirection.fromRightToLeft() =
      ShimmerDirection._fromRightToLeft;
}

class _ShimmeryAnimation extends CustomPainter {
  final BuildContext context;
  double position, opacity;
  double width = 0.2;
  final Color color;
  final Alignment begin, end;

  _ShimmeryAnimation({
    required this.context,
    required this.position,
    required this.color,
    required this.opacity,
    required this.begin,
    required this.end,
  });

  //Custom Painter to paint one frame of the animation. This is called in a loop to animate
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    var stops = [
      0.0,
      position,
      (position + width) > 1 ? 1.0 : position + width,
      (position + (width * 2)) > 1 ? 1.0 : position + (width * 2),
      1.0
    ];
    paint.style = PaintingStyle.fill;
    paint.shader = LinearGradient(
        tileMode: TileMode.decal,
        begin: begin,
        end: end,
        stops: stops,
        colors: [
          Colors.transparent,
          (color).withOpacity(0.05),
          (color).withOpacity(opacity),
          (color).withOpacity(0.05),
          Colors.transparent
        ]).createShader(Rect.fromLTRB(
        size.width * -0.5,
        (size.height > size.width) ? 0 : size.height * -0.5,
        size.width * 1.5,
        size.height * 1.5));
    var path = Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
