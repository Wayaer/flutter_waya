import 'dart:math' as math;

import 'package:flutter/material.dart';

class Wave extends StatefulWidget {
  const Wave({
    Key? key,
    required this.value,
    required this.color,
    required this.direction,
  }) : super(key: key);

  final double value;
  final Color color;
  final Axis direction;

  @override
  _WaveState createState() => _WaveState();
}

class _WaveState extends State<Wave> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: CurvedAnimation(
          parent: _animationController, curve: Curves.easeInOut),
      builder: (BuildContext context, Widget? child) => ClipPath(
          child: Container(color: widget.color),
          clipper: _WaveClipper(
              animationValue: _animationController.value,
              value: widget.value,
              direction: widget.direction)));
}

class _WaveClipper extends CustomClipper<Path> {
  _WaveClipper(
      {required this.animationValue,
      required this.value,
      required this.direction});

  final double animationValue;
  final double value;
  final Axis direction;

  @override
  Path getClip(Size size) {
    if (direction == Axis.horizontal) {
      return Path()
        ..addPolygon(_generateHorizontalWavePath(size), false)
        ..lineTo(0.0, size.height)
        ..lineTo(0.0, 0.0)
        ..close();
    }
    return Path()
      ..addPolygon(_generateVerticalWavePath(size), false)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..close();
  }

  List<Offset> _generateHorizontalWavePath(Size size) {
    final List<Offset> waveList = <Offset>[];
    for (int i = -2; i <= size.height.toInt() + 2; i++) {
      final double waveHeight = size.width / 20;
      final double dx =
          math.sin((animationValue * 360 - i) % 360 * (math.pi / 180)) *
                  waveHeight +
              (size.width * value);
      waveList.add(Offset(dx, i.toDouble()));
    }
    return waveList;
  }

  List<Offset> _generateVerticalWavePath(Size size) {
    final List<Offset> waveList = <Offset>[];
    for (int i = -2; i <= size.width.toInt() + 2; i++) {
      final double waveHeight = size.height / 20;
      final double dy =
          math.sin((animationValue * 360 - i) % 360 * (math.pi / 180)) *
                  waveHeight +
              (size.height - (size.height * value));
      waveList.add(Offset(i.toDouble(), dy));
    }
    return waveList;
  }

  @override
  bool shouldReclip(_WaveClipper oldClipper) =>
      animationValue != oldClipper.animationValue;
}
