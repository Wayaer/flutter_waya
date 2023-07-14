import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

const Duration kFlAnimationDuration = Duration(milliseconds: 300);

typedef FlAnimationCallback = void Function(Function running);

abstract class _FlAnimation extends StatefulWidget {
  const _FlAnimation(
      {super.key,
      required this.child,
      this.onAnimate,
      this.delayDuration,
      this.animationDuration = kFlAnimationDuration,
      this.stayDuration,
      this.reverse = true,
      this.number = 1,
      this.repeat = false});

  /// child
  final Widget child;

  /// Animation duration
  final Duration animationDuration;

  /// The animation is reversed after execution
  final bool reverse;

  /// stay duration
  final Duration? stayDuration;

  /// delay
  final Duration? delayDuration;

  /// number
  final int number;

  /// Loop running animation
  final bool repeat;

  final FlAnimationCallback? onAnimate;
}

enum AnimationStyle {
  fade,
  horizontalHunting,
  verticalHunting,
}

class FlAnimation extends _FlAnimation {
  const FlAnimation(
      {super.key,
      required super.child,
      required this.style,
      super.animationDuration,
      super.delayDuration,
      super.reverse,
      super.stayDuration,
      super.number,
      super.repeat,
      super.onAnimate});

  final AnimationStyle style;

  @override
  State<FlAnimation> createState() => _FlAnimationState();
}

class _FlAnimationState extends State<FlAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    initialize();
    if (widget.delayDuration != null) {
      widget.delayDuration!.delayed(run);
    } else {
      run();
    }

    widget.onAnimate?.call(forwardAndReverse);
  }

  void initialize() {
    _controller =
        AnimationController(duration: widget.animationDuration, vsync: this);
    switch (widget.style) {
      case AnimationStyle.fade:
        _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
        break;
      case AnimationStyle.horizontalHunting:
        _animation = huntingAnimation();
        break;
      case AnimationStyle.verticalHunting:
        _animation = huntingAnimation();
        break;
    }
  }

  Animation<double> huntingAnimation() => TweenSequence([
        TweenSequenceItem<double>(
            tween: Tween(begin: 0.0, end: -10.0)
                .chain(CurveTween(curve: Curves.easeInOut)),
            weight: 0.5),
        TweenSequenceItem<double>(
            tween: Tween(begin: -10.0, end: 10.0)
                .chain(CurveTween(curve: Curves.easeInOut)),
            weight: 1.0),
        TweenSequenceItem<double>(
            tween: Tween(begin: 10.0, end: 0.0)
                .chain(CurveTween(curve: Curves.easeInOut)),
            weight: 0.5),
      ]).animate(_controller);

  Future<void> run() async {
    if (!mounted) return;
    if (widget.repeat) {
      await _controller.repeat(reverse: widget.reverse);
    } else {
      for (int i = 0; i < widget.number; i++) {
        await forwardAndReverse();
      }
    }
  }

  Future<void> forwardAndReverse() async {
    if (!mounted) return;
    await _controller.forward();
    if (widget.reverse) {
      if (!mounted) return;
      await widget.stayDuration?.delayed();
      await _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, Widget? child) => buildChild());
  }

  Widget buildChild() {
    switch (widget.style) {
      case AnimationStyle.fade:
        return Opacity(opacity: _animation.value, child: widget.child);
      case AnimationStyle.horizontalHunting:
        return Transform.translate(
            offset: Offset(_animation.value, 0.0), child: widget.child);
      case AnimationStyle.verticalHunting:
        return Transform.translate(
            offset: Offset(0.0, _animation.value), child: widget.child);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
