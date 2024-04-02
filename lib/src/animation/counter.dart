import 'package:flutter/material.dart';

typedef CountBuilder = Widget Function(int count, String text);

enum CountAnimationStyle { part, all }

class CounterAnimation extends StatefulWidget {
  const CounterAnimation({
    super.key,
    this.style = CountAnimationStyle.part,
    this.duration = const Duration(milliseconds: 500),
    required this.count,
    required this.builder,
    this.onTap,
  });

  final int count;

  /// animation duration to change count
  final Duration duration;

  /// animation type to change count(part,all)
  final CountAnimationStyle style;

  final CountBuilder builder;

  final ValueChanged<int>? onTap;

  @override
  State<CounterAnimation> createState() => _CounterAnimationState();
}

class _CounterAnimationState extends State<CounterAnimation>
    with SingleTickerProviderStateMixin {
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slidePreValueAnimation;
  late Animation<Offset> _slideCurrentValueAnimation;
  late int _count;
  late int _preCount;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _count = widget.count;
    _preCount = _count;
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _initCountControllerAnimation();
  }

  @override
  void didUpdateWidget(CounterAnimation oldWidget) {
    _count = widget.count;
    _preCount = _count;
    if (_controller.duration != widget.duration) {
      _controller.dispose();
      _controller = AnimationController(duration: widget.duration, vsync: this);
      _initCountControllerAnimation();
      animation();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _initCountControllerAnimation() {
    _slidePreValueAnimation = _controller
        .drive(Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, 1.0)));
    _slideCurrentValueAnimation = _controller
        .drive(Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero));
    _opacityAnimation = _controller.drive(Tween<double>(begin: 0.0, end: 1.0));
  }

  @override
  Widget build(BuildContext context) {
    final String count = _count.toString();
    final String preCount = _preCount.toString();
    int didIndex = 0;
    if (preCount.length == count.length) {
      for (; didIndex < count.length; didIndex++) {
        if (count[didIndex] != preCount[didIndex]) break;
      }
    }
    final bool allChange = preCount.length != count.length || didIndex == 0;

    Widget child;
    if (_count == _preCount) {
      child = _createCount(_count, _count.toString());
    } else if (widget.style == CountAnimationStyle.part && !allChange) {
      final String samePart = count.substring(0, didIndex);
      final String preText = preCount.substring(didIndex, preCount.length);
      final String text = count.substring(didIndex, count.length);
      final Widget preSameWidget = _createCount(_preCount, samePart);
      final Widget currentSameWidget = _createCount(_count, samePart);
      final Widget preWidget = _createCount(_preCount, preText);
      final Widget currentWidget = _createCount(_count, text);
      child = AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext b, Widget? w) =>
              Row(mainAxisSize: MainAxisSize.min, children: [
                Stack(fit: StackFit.passthrough, children: [
                  Opacity(
                      opacity: _opacityAnimation.value,
                      child: currentSameWidget),
                  Opacity(
                      opacity: 1.0 - _opacityAnimation.value,
                      child: preSameWidget),
                ]),
                Stack(fit: StackFit.passthrough, children: [
                  FractionalTranslation(
                      translation: _preCount > _count
                          ? _slideCurrentValueAnimation.value
                          : -_slideCurrentValueAnimation.value,
                      child: currentWidget),
                  FractionalTranslation(
                      translation: _preCount > _count
                          ? _slidePreValueAnimation.value
                          : -_slidePreValueAnimation.value,
                      child: preWidget),
                ])
              ]));
    } else {
      child = AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext b, Widget? w) => Stack(
                fit: StackFit.passthrough,
                children: [
                  FractionalTranslation(
                      translation: _preCount > _count
                          ? _slideCurrentValueAnimation.value
                          : -_slideCurrentValueAnimation.value,
                      child: _createCount(_count, _count.toString())),
                  FractionalTranslation(
                      translation: _preCount > _count
                          ? _slidePreValueAnimation.value
                          : -_slidePreValueAnimation.value,
                      child: _createCount(_preCount, _preCount.toString())),
                ],
              ));
    }
    return GestureDetector(
        onTap: animation, child: ClipRect(clipper: _CountClip(), child: child));
  }

  Widget _createCount(int count, String text) =>
      widget.builder.call(count, text);

  void animation() {
    _preCount = _count;
    _count++;
    _controller.reset();
    _controller.forward();
    if (mounted) setState(() {});
    widget.onTap?.call(_count);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class _CountClip extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) => Offset.zero & size;

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}
