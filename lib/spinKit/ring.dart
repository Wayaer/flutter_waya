part of 'spin_kit.dart';

class SpinKitRing extends StatefulWidget {
  const SpinKitRing({
    super.key,
    required this.color,
    this.lineWidth = 7.0,
    this.size = 50.0,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  });

  final Color color;
  final double size;
  final double lineWidth;
  final Duration duration;
  final AnimationController? controller;

  @override
  State<SpinKitRing> createState() => _SpinKitRingState();
}

class _SpinKitRingState extends State<SpinKitRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1, _animation2, _animation3;

  @override
  void initState() {
    super.initState();
    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() => setState(() {}))
      ..repeat();
    _animation1 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear)));
    _animation2 = Tween<double>(begin: -2 / 3, end: 1 / 2).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.5, 1.0, curve: Curves.linear)));
    _animation3 = Tween<double>(begin: 0.25, end: 5 / 6).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 1.0, curve: _SpinKitRingCurve())));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Transform(
      transform: Matrix4.identity()..rotateZ((_animation1.value) * 5 * pi / 6),
      alignment: FractionalOffset.center,
      child: SizedBox.fromSize(
          size: Size.square(widget.size),
          child: CustomPaint(
            foregroundPainter: _RingPainter(
                paintWidth: widget.lineWidth,
                trackColor: widget.color,
                progressPercent: _animation3.value,
                startAngle: pi * _animation2.value),
          )),
    ));
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.paintWidth,
    required this.progressPercent,
    required this.startAngle,
    required this.trackColor,
  }) : trackPaint = Paint()
          ..color = trackColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = paintWidth
          ..strokeCap = StrokeCap.square;

  final double paintWidth;
  final Paint trackPaint;
  final Color trackColor;
  final double progressPercent;
  final double startAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (min(size.width, size.height) - paintWidth) / 2;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        2 * pi * progressPercent, false, trackPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _SpinKitRingCurve extends Curve {
  const _SpinKitRingCurve();

  @override
  double transform(double t) => (t <= 0.5) ? 2 * t : 2 * (1 - t);
}

class SpinKitDualRing extends StatefulWidget {
  const SpinKitDualRing({
    super.key,
    this.color,
    this.lineWidth = 7.0,
    this.size = 50.0,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  });

  final Color? color;
  final double lineWidth;
  final double size;
  final Duration duration;
  final AnimationController? controller;

  @override
  State<SpinKitDualRing> createState() => _SpinKitDualRingState();
}

class _SpinKitDualRingState extends State<SpinKitDualRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() => setState(() {}))
      ..repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Transform(
            transform: Matrix4.identity()..rotateZ((_animation.value) * pi * 2),
            alignment: FractionalOffset.center,
            child: CustomPaint(
              painter: _DualRingPainter(
                  paintWidth: widget.lineWidth,
                  color: widget.color ??
                      context.theme.progressIndicatorTheme.color ??
                      context.theme.primaryColor),
              child: SizedBox.fromSize(size: Size.square(widget.size)),
            )));
  }
}

class _DualRingPainter extends CustomPainter {
  _DualRingPainter({required double paintWidth, required Color color})
      : ringPaint = Paint()
          ..color = color
          ..strokeWidth = paintWidth
          ..style = PaintingStyle.stroke;

  final Paint ringPaint;
  final double angle = 90;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect =
        Rect.fromPoints(Offset.zero, Offset(size.width, size.height));
    canvas.drawArc(rect, 0.0, getRadian(angle), false, ringPaint);
    canvas.drawArc(rect, getRadian(180.0), getRadian(angle), false, ringPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  double getRadian(double angle) => pi / 180 * angle;
}
