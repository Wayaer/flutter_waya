part of 'progress.dart';

/// 波浪动画
class FlWave extends StatefulWidget {
  const FlWave({
    super.key,
    required this.value,
    required this.color,
    required this.direction,
  });

  final double value;
  final Color color;
  final Axis direction;

  @override
  State<FlWave> createState() => _FlWaveState();
}

class _FlWaveState extends ExtendedState<FlWave>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    controller.repeat();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      builder: (BuildContext context, Widget? child) => ClipPath(
          clipper: _FlWaveClipper(
              animationValue: controller.value,
              value: widget.value,
              direction: widget.direction),
          child: Container(color: widget.color)));

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _FlWaveClipper extends CustomClipper<Path> {
  _FlWaveClipper(
      {required this.animationValue,
      required this.value,
      required this.direction});

  final double animationValue;
  final double value;
  final Axis direction;

  @override
  Path getClip(Size size) {
    switch (direction) {
      case Axis.horizontal:
        return Path()
          ..addPolygon(_generateHorizontalFlWavePath(size), false)
          ..lineTo(0.0, size.height)
          ..lineTo(0.0, 0.0)
          ..close();
      case Axis.vertical:
        return Path()
          ..addPolygon(_generateVerticalFlWavePath(size), false)
          ..lineTo(size.width, size.height)
          ..lineTo(0.0, size.height)
          ..close();
    }
  }

  List<Offset> _generateHorizontalFlWavePath(Size size) {
    final List<Offset> waveList = <Offset>[];
    for (int i = -2; i <= size.height.toInt() + 2; i++) {
      final double waveHeight = size.width / 20;
      final double dx =
          sin((animationValue * 360 - i) % 360 * (pi / 180)) * waveHeight +
              (size.width * value);
      waveList.add(Offset(dx, i.toDouble()));
    }
    return waveList;
  }

  List<Offset> _generateVerticalFlWavePath(Size size) {
    final List<Offset> waveList = <Offset>[];
    for (int i = -2; i <= size.width.toInt() + 2; i++) {
      final double waveHeight = size.height / 20;
      final double dy =
          sin((animationValue * 360 - i) % 360 * (pi / 180)) * waveHeight +
              (size.height - (size.height * value));
      waveList.add(Offset(i.toDouble(), dy));
    }
    return waveList;
  }

  @override
  bool shouldReclip(_FlWaveClipper oldClipper) =>
      animationValue != oldClipper.animationValue;
}
