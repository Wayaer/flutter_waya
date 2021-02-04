import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class LiquidButton extends StatefulWidget {
  const LiquidButton(
      {Key key,
      @required this.height,
      @required this.width,
      @required this.backgroundColor,
      this.gradientColor,
      this.gap = 1,
      this.duration = const Duration(milliseconds: 500),
      this.retainGradient = false,
      this.tension = 0.04,
      this.expandFactor = 10,
      this.child})
      : assert(expandFactor >= 1.0 && expandFactor <= 50.0),
        assert(gap >= 1 && gap <= height / 2),
        assert(tension >= 0.01 && tension <= 1.0),
        super(key: key);
  final Widget child;
  final double height;
  final double width;
  final Color backgroundColor;
  final Color gradientColor;
  final int gap;
  final Duration duration;
  final bool retainGradient;
  final double tension;
  final double expandFactor;

  @override
  _LiquidButtonState createState() => _LiquidButtonState();
}

class _LiquidButtonState extends State<LiquidButton>
    with TickerProviderStateMixin {
  Offset position = const Offset(0, 0);
  Animation<double> animation;
  AnimationController animationController;
  RenderBox renderBox;

  @override
  void initState() {
    animationController =
        AnimationController(duration: widget.duration, vsync: this);
    animation = Tween<double>(begin: 1.0, end: widget.expandFactor)
        .animate(animationController)
          ..addListener(() => setState(() {}));
    animationController.forward(from: 0.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    renderBox = context.findRenderObject() as RenderBox;
    if (kIsWeb)
      return MouseRegion(
          onHover: onHover,
          onExit: onExit,
          onEnter: onEnter,
          child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: CustomPaint(
                  painter: _LiquidButtonCustomPainter(
                      canvasColor: widget.backgroundColor,
                      gap: widget.gap,
                      retainGradient: widget.retainGradient,
                      tension: widget.tension,
                      gradientColor:
                          widget.gradientColor ?? widget.backgroundColor,
                      position: position,
                      maxExpansion: widget.expandFactor,
                      expandFactor: animation.value),
                  child: Center(child: widget.child))));
    else
      return Universal(
          enabled: true,
          onPanUpdate: onHoverM,
          onPanDown: (DragDownDetails details) => onEnter(null),
          onPanEnd: (DragEndDetails details) => onExit(null),
          width: widget.width,
          height: widget.height,
          child: CustomPaint(
              painter: _LiquidButtonCustomPainter(
                  canvasColor: widget.backgroundColor,
                  gap: widget.gap,
                  retainGradient: widget.retainGradient,
                  tension: widget.tension,
                  gradientColor: widget.gradientColor ?? widget.backgroundColor,
                  position: position,
                  maxExpansion: widget.expandFactor,
                  expandFactor: animation.value),
              child: Center(child: widget.child)));
  }

  void onHover(PointerHoverEvent event) {
    position = renderBox.globalToLocal(event.position);
    setState(() {});
  }

  void onHoverM(DragUpdateDetails event) {
    position = event.localPosition;
    setState(() {});
  }

  void onEnter(PointerEnterEvent event) =>
      animationController.reverse(from: widget.expandFactor);

  void onExit(PointerExitEvent event) => animationController.forward(from: 0.0);
}

class _LiquidButtonCustomPainter extends CustomPainter {
  _LiquidButtonCustomPainter(
      {@required this.expandFactor,
      @required this.position,
      @required this.gap,
      @required this.tension,
      @required this.maxExpansion,
      @required this.canvasColor,
      @required this.gradientColor,
      @required this.retainGradient});

  final double expandFactor;
  final double maxExpansion;
  List<Offset> points = <Offset>[];
  final Offset position;
  final Color canvasColor;
  final Color gradientColor;
  final bool retainGradient;
  final int gap;
  final double tension;

  @override
  void paint(Canvas canvas, Size size) {
    final double midTop = (size.width - doubleTilde(size.height / 2)) / 2;
    for (double x = doubleTilde(size.height / 2); x < midTop * 2; x += gap)
      points.add(Offset(x, 0));

    for (double alpha = doubleTilde(size.height * 1.25);
        alpha >= 0;
        alpha -= gap) {
      final double angle = (math.pi / doubleTilde(size.height * 1.25)) * alpha;
      points.add(Offset(
          math.sin(angle) * size.height / 2 + size.width - size.height / 2,
          math.cos(angle) * size.height / 2 + size.height / 2));
    }
    for (double x = size.width - doubleTilde(size.height / 2) - 1;
        x >= doubleTilde(size.height / 2);
        x -= gap) points.add(Offset(x, -0 + size.height));

    for (int alpha = 0;
        alpha <= doubleTilde(size.height * 1.25);
        alpha += gap) {
      final double angle = (math.pi / doubleTilde(size.height * 1.25)) * alpha;
      points.add(Offset(
          (size.height - math.sin(angle) * size.height / 2) - size.height / 2,
          math.cos(angle) * size.height / 2 + size.height / 2));
    }
    final Path path = Path();

    final Offset temp = attractedOffset(points[0]);
    path.moveTo(temp.dx, temp.dy);
    points.builder((Offset element) {
      final Offset temp = attractedOffset(element);
      path.lineTo(temp.dx, temp.dy);
    });
    final RadialGradient gradient = RadialGradient(
        radius: size.width / size.height,
        colors: <Color>[
          if (retainGradient)
            gradientColor
          else
            expandFactor == maxExpansion ? canvasColor : gradientColor,
          canvasColor
        ],
        center: Alignment.center);
    final Paint paint = Paint();
    paint.shader = gradient.createShader(Rect.fromCenter(
        center: position, height: size.height, width: size.width));
    canvas.drawPath(path, paint);
  }

  double doubleTilde(double x) => x < 0 ? x.ceilToDouble() : x.floorToDouble();

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  Offset attractedOffset(Offset element) {
    final double dx = element.dx - position.dx;
    final double dy = element.dy - position.dy;

    final double dist = math.sqrt(dx * dx + dy * dy);
    final double dist2 = math.max(1, dist);

    final double d = math.min(dist2, math.max(12, (dist2 / 4) - dist2));
    final double D = dist2 * expandFactor;

    return Offset(
        element.dx + (d / D) * (dx * 2), element.dy + (d / D) * (dy * 2));
  }
}
