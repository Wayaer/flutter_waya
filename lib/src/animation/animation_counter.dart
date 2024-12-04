import 'package:flutter/material.dart';
import 'package:flutter_waya/src/extended_state.dart';

typedef AnimationCounterCallback = void Function(String text);

typedef AnimationCounterBuilder = Widget Function(
    String text, AnimationCounterCallback animate);

enum CounterStyle { part, all }

enum CounterTranslationStyle { up, down }

class AnimationCounter extends StatefulWidget {
  const AnimationCounter({
    super.key,
    this.style = CounterStyle.part,
    this.translationStyle = CounterTranslationStyle.up,
    this.duration = const Duration(milliseconds: 300),
    required this.text,
    required this.builder,
  });

  final String text;

  /// animation duration to change count
  final Duration duration;

  /// animation type to change
  final CounterStyle style;

  /// animation translation type to change
  final CounterTranslationStyle translationStyle;

  ///
  final AnimationCounterBuilder builder;

  @override
  State<AnimationCounter> createState() => _AnimationCounterState();
}

class _AnimationCounterState extends ExtendedState<AnimationCounter>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> preSlideAnimation;
  late Animation<Offset> slideAnimation;
  late String _text;
  late String _preText;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    _text = widget.text;
    _preText = _text;
    initAnimationController();
  }

  @override
  void didUpdateWidget(AnimationCounter oldWidget) {
    if (controller.duration != widget.duration) {
      controller.dispose();
      initAnimationController();
    }
    if (widget.text != _text) {
      animation(widget.text);
    }
    super.didUpdateWidget(oldWidget);
  }

  void initAnimationController() {
    controller = AnimationController(duration: widget.duration, vsync: this);
    preSlideAnimation = controller
        .drive(Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, 1.0)));
    slideAnimation = controller
        .drive(Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero));
  }

  @override
  Widget build(BuildContext context) {
    final String text = _text.toString();
    final String preText = _preText.toString();
    int didIndex = 0;
    if (preText.length == text.length) {
      for (; didIndex < text.length; didIndex++) {
        if (text[didIndex] != preText[didIndex]) break;
      }
    }
    final bool allChange = preText.length != text.length || didIndex == 0;

    Widget child;
    if (_text == _preText) {
      child = builder(_text.toString());
    } else if (widget.style == CounterStyle.part && !allChange) {
      final Widget same = builder(text.substring(0, didIndex));
      final Widget pre = builder(preText.substring(didIndex, preText.length));
      final Widget current = builder(text.substring(didIndex, text.length));
      child = AnimatedBuilder(
          animation: controller,
          child: same,
          builder: (BuildContext context, Widget? child) =>
              Row(mainAxisSize: MainAxisSize.min, children: [
                child ?? same,
                Stack(fit: StackFit.passthrough, children: [
                  buildFractionalTranslation(slideAnimation, current),
                  buildFractionalTranslation(preSlideAnimation, pre),
                ])
              ]));
    } else {
      child = AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, _) =>
              Stack(fit: StackFit.passthrough, children: [
                buildFractionalTranslation(
                    slideAnimation, builder(_text.toString())),
                buildFractionalTranslation(
                    preSlideAnimation, builder(_preText.toString())),
              ]));
    }
    return ClipRect(clipper: _CountClip(), child: child);
  }

  Widget buildFractionalTranslation(
          Animation<Offset> animation, Widget child) =>
      FractionalTranslation(
          translation: widget.translationStyle == CounterTranslationStyle.down
              ? animation.value
              : -animation.value,
          child: child);

  Widget builder(String text) => widget.builder.call(text, animation);

  void animation(String newText) {
    _preText = _text;
    _text = newText;
    controller.reset();
    controller.forward();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

class _CountClip extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) => Offset.zero & size;

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}
