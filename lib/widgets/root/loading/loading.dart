import 'dart:math';
import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_waya/flutter_waya.dart';

part 'bounce.dart';

part 'circle.dart';

part 'cube.dart';

part 'fading.dart';

part 'ring.dart';

class _DelayTween extends Tween<double> {
  _DelayTween({double? begin, double? end, required this.delay})
      : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) => super.lerp((sin((t - delay) * 2 * pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
