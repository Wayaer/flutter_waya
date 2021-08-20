import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef CountBuilder = Widget Function(int count, String text);

enum CountAnimationType { part, all }

class CounterAnimation extends StatefulWidget {
  const CounterAnimation({
    Key? key,
    this.animationType = CountAnimationType.part,
    this.duration = const Duration(milliseconds: 500),
    required this.count,
    required this.countBuilder,
    this.onTap,
  }) : super(key: key);

  final int count;

  /// animation duration to change  count
  final Duration duration;

  /// animation type to change count(part,all)
  final CountAnimationType animationType;

  final CountBuilder? countBuilder;

  final ValueCallback<int>? onTap;

  @override
  _CounterAnimationState createState() => _CounterAnimationState();
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
    } else if (widget.animationType == CountAnimationType.part && !allChange) {
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
              Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Stack(fit: StackFit.passthrough, children: <Widget>[
                  Opacity(
                      child: currentSameWidget,
                      opacity: _opacityAnimation.value),
                  Opacity(
                      child: preSameWidget,
                      opacity: 1.0 - _opacityAnimation.value),
                ]),
                Stack(fit: StackFit.passthrough, children: <Widget>[
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
                children: <Widget>[
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
    return Universal(onTap: animation, child: child, clipper: _CountClip());
  }

  Widget _createCount(int count, String text) =>
      widget.countBuilder!.call(count, text);

  void animation() {
    _preCount = _count;
    _count++;
    if (mounted) {
      _controller.reset();
      _controller.forward();
      setState(() {});
    }
    if (widget.onTap != null) widget.onTap!(_count);
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
