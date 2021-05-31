import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
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

enum SpinKitStyle {
  circle,
  fadingCircle,
  squareCircle,
  doubleBounce,
  threeBounce,
  pulse,
  ripple,
  cubeGrid,
  foldingCube,
  fadingFour,
  wanderingCubes,
  ring,
  dualRing,
  wave,
}

class SpinKit extends StatelessWidget {
  const SpinKit(
    this.style, {
    Key? key,
    this.color,
    this.size = 50,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  }) : super(key: key);

  final SpinKitStyle style;
  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  Widget build(BuildContext context) {
    final Color _color = color ?? Colors.white;
    switch (style) {
      case SpinKitStyle.circle:
        return SpinKitCircle(
          color: _color,
          size: size,
          duration: duration,
          itemBuilder: itemBuilder,
          controller: controller,
        );
      case SpinKitStyle.fadingCircle:
        return SpinKitFadingCircle(
          color: _color,
          size: size,
          duration: duration,
          itemBuilder: itemBuilder,
          controller: controller,
        );
      case SpinKitStyle.squareCircle:
        return SpinKitFadingCircle(
          color: _color,
          size: size,
          duration: duration,
          itemBuilder: itemBuilder,
          controller: controller,
        );
      case SpinKitStyle.doubleBounce:
        return SpinKitDoubleBounce(
          color: _color,
          size: size,
          duration: duration,
          itemBuilder: itemBuilder,
          controller: controller,
        );
      case SpinKitStyle.threeBounce:
        return SpinKitThreeBounce(
          color: _color,
          size: size,
          duration: duration,
          itemBuilder: itemBuilder,
          controller: controller,
        );
      case SpinKitStyle.pulse:
        return SpinKitPulse(
          color: _color,
          size: size,
          duration: duration,
          itemBuilder: itemBuilder,
          controller: controller,
        );
      case SpinKitStyle.ripple:
        return SpinKitRipple(
          color: _color,
          size: size,
          duration: duration,
          itemBuilder: itemBuilder,
          controller: controller,
        );
      case SpinKitStyle.cubeGrid:
        return SpinKitCubeGrid(
          color: _color,
          size: size,
          duration: duration,
          itemBuilder: itemBuilder,
          controller: controller,
        );
      case SpinKitStyle.foldingCube:
        return SpinKitFoldingCube(
          color: _color,
          size: size,
          duration: duration,
          itemBuilder: itemBuilder,
          controller: controller,
        );
      case SpinKitStyle.fadingFour:
        return SpinKitFadingFour(
          color: _color,
          size: size,
          duration: duration,
          itemBuilder: itemBuilder,
          controller: controller,
        );
      case SpinKitStyle.wanderingCubes:
        return SpinKitWanderingCubes(
          color: _color,
          size: size,
          duration: duration,
          itemBuilder: itemBuilder,
        );
      case SpinKitStyle.ring:
        return SpinKitRing(
          color: _color,
          size: size,
          duration: duration,
          controller: controller,
        );
      case SpinKitStyle.dualRing:
        return SpinKitDualRing(
          color: _color,
          size: size,
          duration: duration,
          controller: controller,
        );
      case SpinKitStyle.wave:
        return SpinKitWave(
          color: _color,
          size: size,
          duration: duration,
          itemBuilder: itemBuilder,
          controller: controller,
        );
    }
  }
}

enum SpinKitWaveType { start, end, center }

class SpinKitWave extends StatefulWidget {
  const SpinKitWave({
    Key? key,
    this.color = Colors.blue,
    this.type = SpinKitWaveType.center,
    this.size = 50.0,
    this.itemBuilder,
    this.itemCount = 5,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  })  : assert(itemCount >= 2, 'itemCount Cant be less then 2 '),
        super(key: key);

  final Color? color;
  final int itemCount;
  final double size;
  final SpinKitWaveType type;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  _SpinKitWaveState createState() => _SpinKitWaveState();
}

class _SpinKitWaveState extends State<SpinKitWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<double> _bars = getAnimationDelay(widget.itemCount);
    return Center(
        child: Universal(
            size: Size(widget.size * 1.25, widget.size),
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _bars.length.generate((int i) => _ScaleYWidget(
                  scaleY: _DelayTween(begin: .4, end: 1.0, delay: _bars[i])
                      .animate(_controller),
                  child: SizedBox.fromSize(
                      size: Size(widget.size / widget.itemCount, widget.size),
                      child: _itemBuilder(i)),
                ))));
  }

  List<double> getAnimationDelay(int itemCount) {
    switch (widget.type) {
      case SpinKitWaveType.start:
        return _startAnimationDelay(itemCount);
      case SpinKitWaveType.end:
        return _endAnimationDelay(itemCount);
      case SpinKitWaveType.center:
      default:
        return _centerAnimationDelay(itemCount);
    }
  }

  List<double> _startAnimationDelay(int count) {
    return <double>[
      ...List<double>.generate(
          count ~/ 2, (int index) => -1.0 - (index * 0.1) - 0.1).reversed,
      if (count.isOdd) -1.0,
      ...List<double>.generate(
        count ~/ 2,
        (int index) => -1.0 + (index * 0.1) + (count.isOdd ? 0.1 : 0.0),
      ),
    ];
  }

  List<double> _endAnimationDelay(int count) {
    return <double>[
      ...List<double>.generate(
          count ~/ 2, (int index) => -1.0 + (index * 0.1) + 0.1).reversed,
      if (count.isOdd) -1.0,
      ...List<double>.generate(
        count ~/ 2,
        (int index) => -1.0 - (index * 0.1) - (count.isOdd ? 0.1 : 0.0),
      )
    ];
  }

  List<double> _centerAnimationDelay(int count) {
    return <double>[
      ...List<double>.generate(
          count ~/ 2, (int index) => -1.0 + (index * 0.2) + 0.2).reversed,
      if (count.isOdd) -1.0,
      ...List<double>.generate(
          count ~/ 2, (int index) => -1.0 + (index * 0.2) + 0.2),
    ];
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(
          decoration: BoxDecoration(
              color: widget.color, borderRadius: BorderRadius.circular(4)));
}

class _ScaleYWidget extends AnimatedWidget {
  const _ScaleYWidget({
    Key? key,
    required Animation<double> scaleY,
    required this.child,
    this.alignment = Alignment.center,
  }) : super(key: key, listenable: scaleY);

  final Widget child;
  final Alignment alignment;

  Animation<double> get scale => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) => Transform(
      transform: Matrix4.identity()..scale(1.0, scale.value, 1.0),
      alignment: alignment,
      child: child);
}
