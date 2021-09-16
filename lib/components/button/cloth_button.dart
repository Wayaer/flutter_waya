import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ClothButton extends StatefulWidget {
  const ClothButton.round(
      {Key? key,
      required this.size,
      required this.backgroundColor,
      this.child,
      this.retainGradient = false,
      this.gap = 1,
      this.duration = const Duration(milliseconds: 500),
      this.gradientColor,
      this.expandFactor = 10.0})
      : assert(expandFactor > 1.0 || expandFactor < 50.0),
        super(key: key);

  const ClothButton.rectangle(
      {Key? key,
      required this.size,
      required this.backgroundColor,
      this.duration = const Duration(milliseconds: 500),
      this.child,
      this.expandFactor = 10.0,
      this.gradientColor,
      this.retainGradient = false})
      : gap = null,
        assert(expandFactor > 1.0 || expandFactor < 50.0),
        super(key: key);

  final Size size;
  final Widget? child;
  final Color backgroundColor;
  final Color? gradientColor;
  final Duration duration;
  final double expandFactor;
  final bool retainGradient;
  final int? gap;

  @override
  _ClothButtonState createState() => _ClothButtonState();
}

class _ClothButtonState extends State<ClothButton>
    with TickerProviderStateMixin {
  late Offset position;
  late Animation<double> animation;
  late AnimationController animationController;
  late RenderBox renderBox;

  @override
  void initState() {
    position = Offset(widget.size.width / 2, widget.size.height / 2);
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
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject == null) return Container();
    renderBox = renderObject as RenderBox;
    final CustomPainter painter = widget.gap == null
        ? _ClothCustomPainter(
            relativePosition: position,
            expandFactor: animation.value,
            backgroundColor: widget.backgroundColor,
            maxExpand: widget.expandFactor,
            retainGradient: widget.retainGradient,
            gradientColor: widget.gradientColor ?? widget.backgroundColor)
        : _RoundClothCustomPainter(
            gap: widget.gap!,
            relativePosition: position,
            expandFactor: animation.value,
            backgroundColor: widget.backgroundColor,
            maxExpand: widget.expandFactor,
            retainGradient: widget.retainGradient,
            gradientColor: widget.gradientColor ?? widget.backgroundColor);
    final SizedBox size = SizedBox.fromSize(
        size: widget.size,
        child:
            CustomPaint(painter: painter, child: Center(child: widget.child)));
    return kIsWeb
        ? MouseRegion(
            onHover: onHover, onExit: onExit, onEnter: onEnter, child: size)
        : GestureDetector(
            onPanUpdate: onHoverM,
            onPanDown: (DragDownDetails details) => onEnter(null),
            onPanEnd: (DragEndDetails details) => onExit(null),
            child: size);
  }

  void onHover(PointerHoverEvent event) {
    position = renderBox.globalToLocal(event.position);
    setState(() {});
  }

  void onHoverM(DragUpdateDetails event) {
    position = event.localPosition;
    setState(() {});
  }

  void onEnter(PointerEnterEvent? event) =>
      animationController.reverse(from: widget.expandFactor);

  void onExit(PointerExitEvent? event) =>
      animationController.forward(from: 0.0);
}

class _ClothCustomPainter extends CustomPainter {
  _ClothCustomPainter(
      {required this.maxExpand,
      required this.expandFactor,
      required this.relativePosition,
      required this.backgroundColor,
      required this.gradientColor,
      required this.retainGradient});

  final double expandFactor;
  final double maxExpand;
  List<Offset> points = <Offset>[];
  final Offset relativePosition;
  final Color backgroundColor;
  final Color gradientColor;
  final bool retainGradient;

  @override
  void paint(Canvas canvas, Size size) {
    final int buttonWidth = (size.width - expandFactor * 2).toInt();
    final int buttonHeight = (size.height - expandFactor * 2).toInt();

    final List<double> leftTop = <double>[expandFactor, expandFactor];
    final List<double> rightTop = <double>[
      size.width - expandFactor,
      expandFactor
    ];
    final List<double> rightBottom = <double>[
      size.width - expandFactor,
      size.height - expandFactor
    ];
    final List<double> leftBottom = <double>[
      expandFactor,
      size.height - expandFactor
    ];
    buttonWidth.generate((int index) {
      points.add(Offset(leftTop[0] + index, leftTop[1]));
      return index;
    });

    buttonHeight.generate((int index) {
      points.add(Offset(rightTop[0], rightTop[1] + index));
      return index;
    });

    buttonWidth.generate((int index) {
      points.add(Offset(rightBottom[0] - index, rightBottom[1]));
      return index;
    });

    buttonHeight.generate((int index) {
      points.add(Offset(leftBottom[0], leftBottom[1] - index));
      return index;
    });

    final Path path = Path();

    final Offset tempP = attractedPoint(points[0]);
    path.moveTo(tempP.dx, tempP.dy);
    points.builder((Offset element) {
      final Offset anotherPoint = attractedPoint(element);
      path.lineTo(anotherPoint.dx, anotherPoint.dy);
    });

    final RadialGradient gradient = RadialGradient(
        radius: size.width / size.height,
        colors: <Color>[
          if (retainGradient)
            gradientColor
          else
            expandFactor == maxExpand ? backgroundColor : gradientColor,
          backgroundColor
        ],
        center: Alignment.center);
    final Paint paint = Paint();
    paint.shader = gradient.createShader(Rect.fromCenter(
        center: relativePosition, height: size.height, width: size.width));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  Offset attractedPoint(Offset element) {
    final double dx = element.dx - relativePosition.dx;
    final double dy = element.dy - relativePosition.dy;
    final double dist = (dx * dx + dy * dy).sqrt;
    final double dist2 = math.max(1, dist);

    final double d = math.min(dist2, math.max(9, (dist2 / 4) - dist2));
    final double D = dist2 * expandFactor;
    return Offset(element.dx + (d / D) * (relativePosition.dx - element.dx),
        element.dy + (d / D) * (relativePosition.dy - element.dy));
  }
}

class _RoundClothCustomPainter extends CustomPainter {
  _RoundClothCustomPainter(
      {required this.maxExpand,
      required this.expandFactor,
      required this.relativePosition,
      required this.backgroundColor,
      required this.gap,
      required this.gradientColor,
      required this.retainGradient});

  final double expandFactor;
  final double maxExpand;
  List<Offset> points = <Offset>[];
  final Offset relativePosition;
  final Color backgroundColor;
  final double margin = 5;
  final int gap;
  final Color gradientColor;
  final bool retainGradient;

  @override
  void paint(Canvas canvas, Size size) {
    for (double x = doubleTilde(size.height / 2);
        x < size.width - doubleTilde(size.height / 2);
        x += gap) {
      points.add(Offset(expandFactor / 4 + x + margin, margin));
    }

    for (double alpha = doubleTilde(size.height * 1.25);
        alpha >= 0;
        alpha -= gap) {
      final double angle = (math.pi / doubleTilde(size.height * 1.25)) * alpha;
      points.add(Offset(
          math.sin(angle) * size.height / 2 +
              margin +
              size.width -
              size.height / 2,
          math.cos(angle) * size.height / 2 + margin + size.height / 2));
    }
    for (double x = size.width - doubleTilde(size.height / 2) - 1;
        x >= doubleTilde(size.height / 2);
        x -= gap) {
      points.add(Offset(x + margin + expandFactor / 4, margin + size.height));
    }

    for (int alpha = 0;
        alpha <= doubleTilde(size.height * 1.25);
        alpha += gap) {
      final double angle = (math.pi / doubleTilde(size.height * 1.25)) * alpha;
      points.add(Offset(
          (size.height - math.sin(angle) * size.height / 2) +
              margin -
              size.height / 2,
          math.cos(angle) * size.height / 2 + margin + size.height / 2));
    }

    final Path path = Path();

    final Offset tempP = attractedPoint(points[0]);
    path.moveTo(tempP.dx, tempP.dy);
    points.builder((Offset element) {
      final Offset anotherPoint = attractedPoint(element);
      path.lineTo(anotherPoint.dx, anotherPoint.dy);
    });

    final RadialGradient gradient = RadialGradient(
        radius: size.width / size.height,
        colors: <Color>[
          if (retainGradient)
            gradientColor
          else
            expandFactor == maxExpand ? backgroundColor : gradientColor,
          backgroundColor
        ],
        center: Alignment.center);
    final Paint paint = Paint();
    paint.shader = gradient.createShader(Rect.fromCenter(
        center: relativePosition, height: size.height, width: size.width));
    canvas.drawPath(path, paint);
  }

  double doubleTilde(double x) => x < 0 ? x.ceilToDouble() : x.floorToDouble();

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  Offset attractedPoint(Offset element) {
    final double dx = element.dx - relativePosition.dx;
    final double dy = element.dy - relativePosition.dy;

    final double dist = math.sqrt(dx * dx + dy * dy);
    final double dist2 = math.max(1, dist);

    final double d = math.min(dist2, math.max(9, (dist2 / 4) - dist2));
    final double D = dist2 * expandFactor;

    return Offset(element.dx + (d / D) * (relativePosition.dx - element.dx),
        element.dy + (d / D) * (relativePosition.dy - element.dy));
  }
}
