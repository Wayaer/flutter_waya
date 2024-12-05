import 'package:flutter/material.dart';
import 'package:flutter_waya/src/extended_state.dart';

typedef AnimationCounterBuilder = Widget Function(String value);

enum CounterStyle { part, all }

/// animation counter
class AnimationCounter extends StatefulWidget {
  const AnimationCounter.down({
    super.key,
    this.style = CounterStyle.part,
    this.duration = const Duration(milliseconds: 300),
    required this.value,
    required this.builder,
  }) : isDown = true;

  const AnimationCounter.up({
    super.key,
    this.style = CounterStyle.part,
    this.duration = const Duration(milliseconds: 300),
    required this.value,
    required this.builder,
  }) : isDown = false;

  /// value
  final String value;

  /// animation duration to change
  final Duration duration;

  /// animation type to change
  final CounterStyle style;

  /// value builder
  final AnimationCounterBuilder builder;

  /// animation direction
  final bool isDown;

  @override
  State<AnimationCounter> createState() => _AnimationCounterState();
}

class _AnimationCounterState extends ExtendedState<AnimationCounter>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> preSlideAnimation;
  late Animation<Offset> slideAnimation;
  late String value;
  late String preValue;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: widget.duration, value: 1, vsync: this);
    value = widget.value;
    preValue = value;
    slideAnimation = controller
        .drive(Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero));
    preSlideAnimation = controller
        .drive(Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, 1.0)));
  }

  @override
  void didUpdateWidget(AnimationCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (controller.duration != widget.duration) {
      controller.duration = widget.duration;
    }
    if (widget.value != value) {
      if (mounted) animation(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    int didIndex = 0;
    if (preValue.length == value.length) {
      for (; didIndex < value.length; didIndex++) {
        if (value[didIndex] != preValue[didIndex]) break;
      }
    }
    final bool allChange = preValue.length != value.length || didIndex == 0;
    return ClipRect(
        child: AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              if (value == preValue) {
                return builder(value);
              } else if (widget.style == CounterStyle.part && !allChange) {
                return Row(mainAxisSize: MainAxisSize.min, children: [
                  builder(value.substring(0, didIndex)),
                  buildStack(value.substring(didIndex, value.length),
                      preValue.substring(didIndex, preValue.length))
                ]);
              }
              return buildStack(value, preValue);
            }));
  }

  Widget buildStack(String value, String preValue) =>
      Stack(fit: StackFit.passthrough, alignment: Alignment.center, children: [
        FractionalTranslation(
            translation:
                widget.isDown ? slideAnimation.value : -slideAnimation.value,
            child: builder(value)),
        if (controller.value < 1)
          FractionalTranslation(
              translation: widget.isDown
                  ? preSlideAnimation.value
                  : -preSlideAnimation.value,
              child: builder(preValue))
      ]);

  Widget builder(String value) => widget.builder(value);

  void animation(String newValue) {
    preValue = value;
    value = newValue;
    if (mounted) {
      controller.reset();
      controller.forward();
    }
  }

  @override
  void dispose() {
    controller.stop();
    controller.dispose();
    super.dispose();
  }
}
