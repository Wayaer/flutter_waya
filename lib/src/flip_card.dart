import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

enum FlipCardState {
  /// 正面
  front,

  /// 反面
  back;

  FlipCardState get toggle {
    if (this == FlipCardState.front) {
      return FlipCardState.back;
    } else {
      return FlipCardState.front;
    }
  }

  bool get isFront => this == FlipCardState.front;

  bool get isBack => this == FlipCardState.back;
}

typedef FlipCardOnFlipCallback = void Function(FlipCardState state);

class FlipCardController {
  FlipCardController(
      {required this.vsync,
      FlipCardState state = FlipCardState.front,
      this.duration = const Duration(milliseconds: 250)}) {
    _initController();
    _state = state;
  }

  final TickerProvider vsync;

  /// 翻转动画时间
  final Duration duration;

  late AnimationController _animationController;

  /// animation controller
  AnimationController get animationController => _animationController;

  /// 正面旋转动画
  Animation<double>? _frontRotation;

  Animation<double> get frontRotation => _frontRotation ??= TweenSequence([
        TweenSequenceItem<double>(
            tween: Tween(begin: 0.0, end: pi / 2)
                .chain(CurveTween(curve: Curves.easeIn)),
            weight: 50.0),
        TweenSequenceItem<double>(
            tween: ConstantTween<double>(pi / 2), weight: 50.0)
      ]).animate(_animationController);

  /// 反面旋转动画
  Animation<double>? _backRotation;

  Animation<double> get backRotation => _backRotation ??= TweenSequence([
        TweenSequenceItem<double>(
            tween: ConstantTween<double>(pi / 2), weight: 50.0),
        TweenSequenceItem<double>(
            tween: Tween(begin: -pi / 2, end: 0.0)
                .chain(CurveTween(curve: Curves.easeOut)),
            weight: 50.0)
      ]).animate(_animationController);

  /// 卡片状态
  FlipCardState _state = FlipCardState.front;

  /// 获取卡片状态
  FlipCardState get state => _state;

  /// 设置卡片状态
  set state(FlipCardState state) {
    _state = state;
    _animationController.value = state.index.toDouble();
  }

  void _initController() {
    _animationController = AnimationController(
        value: state.index.toDouble(), duration: duration, vsync: vsync);
  }

  void toggle() {
    _animationController.value = (_state = state.toggle).index.toDouble();
  }

  Future<bool> animateToggle() async {
    if (_animationController.isAnimating) return false;
    final animation = state.isFront
        ? _animationController.forward(from: 0)
        : _animationController.reverse(from: 1);
    final completer = Completer();
    await animation.whenComplete(() {
      _state = state.toggle;
      completer.complete(true);
    });
    return await completer.future;
  }

  Future<bool> skew(double amount,
      {Duration? duration, Curve curve = Curves.linear}) async {
    if (_animationController.isAnimating) return false;
    if (amount < 0) amount = 0;
    if (amount > 1) amount = 1;
    final target = state.isFront ? amount : 1 - amount;
    await _animationController.animateTo(target,
        duration: duration, curve: curve);
    return true;
  }

  Future<bool> hint(
      {Duration duration = const Duration(milliseconds: 150),
      Duration? total}) async {
    if (_animationController.isAnimating) return false;
    final durationTotal = total ?? _animationController.duration;
    final completer = Completer();
    Duration? original = _animationController.duration;
    _animationController.duration = durationTotal;
    state.isFront
        ? _animationController.forward()
        : _animationController.reverse();
    await Future.delayed(duration);
    (state.isFront
            ? _animationController.reverse()
            : _animationController.forward())
        .whenComplete(() {
      completer.complete(true);
      _animationController.duration = original;
    });
    return await completer.future;
  }

  void dispose() {
    _animationController.dispose();
  }
}

/// 翻转组件
class FlipCard extends StatelessWidget {
  const FlipCard({
    super.key,
    required this.front,
    required this.back,
    this.fit = StackFit.loose,
    this.direction = Axis.horizontal,
    this.alignment = AlignmentDirectional.topCenter,
    required this.controller,
  });

  /// 正面
  final Widget front;

  /// 反面
  final Widget back;

  /// 翻转水平或垂直
  final Axis direction;

  /// alignment
  final AlignmentGeometry alignment;

  /// 子组件布局
  final StackFit fit;

  /// controller
  final FlipCardController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: alignment, fit: fit, children: [
      buildAnimatedBuilder(
        child: front,
        animation: controller.frontRotation,
        isFront: true,
      ),
      buildAnimatedBuilder(
          child: back, animation: controller.backRotation, isFront: false),
    ]);
  }

  Widget buildAnimatedBuilder(
          {required Widget child,
          required Animation<double> animation,
          required bool isFront}) =>
      AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            final transform = Matrix4.identity();
            transform.setEntry(3, 2, 0.001);
            if (direction == Axis.vertical) {
              transform.rotateX(animation.value);
            } else {
              transform.rotateY(animation.value);
            }
            return IgnorePointer(
                ignoring: isFront
                    ? controller.state.isBack
                    : controller.state.isFront,
                child: Transform(
                    transform: transform,
                    filterQuality: FilterQuality.none,
                    alignment: FractionalOffset.center,
                    child: child));
          },
          child: child);
}

typedef FlipCardStatefulBuilder = Widget Function(
    BuildContext context, FlipCardController controller);

class FlipCardStateful extends StatefulWidget {
  const FlipCardStateful({
    super.key,
    required this.front,
    required this.back,
    this.duration = const Duration(milliseconds: 250),
    this.onFlipStart,
    this.onFlipEnd,
    this.direction = Axis.horizontal,
    this.initial = FlipCardState.front,
    this.alignment = AlignmentDirectional.topCenter,
    this.fit = StackFit.passthrough,
  });

  /// 初始正面
  final FlipCardState initial;

  /// 正面
  final FlipCardStatefulBuilder front;

  /// 反面
  final FlipCardStatefulBuilder back;

  /// 翻转动画时间
  final Duration duration;

  /// 翻转水平或垂直
  final Axis direction;

  /// 开始翻转
  final FlipCardOnFlipCallback? onFlipStart;

  /// 翻转完成
  final FlipCardOnFlipCallback? onFlipEnd;

  /// alignment
  final AlignmentGeometry alignment;

  /// 子组件布局
  final StackFit fit;

  @override
  State<FlipCardStateful> createState() => _FlipCardStatefulState();
}

class _FlipCardStatefulState extends State<FlipCardStateful>
    with SingleTickerProviderStateMixin {
  late FlipCardController _controller;
  @override
  void initState() {
    super.initState();
    _controller = FlipCardController(
        vsync: this, state: widget.initial, duration: widget.duration);
  }

  @override
  void didUpdateWidget(covariant FlipCardStateful oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initial != oldWidget.initial) {
      _controller.state = widget.initial;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget current = FlipCard(
      front: widget.front(context, _controller),
      back: widget.back(context, _controller),
      fit: widget.fit,
      direction: widget.direction,
      alignment: widget.alignment,
      controller: _controller,
    );
    return GestureDetector(
        onTap: () async {
          widget.onFlipStart?.call(_controller.state);
          await _controller.animateToggle();
          widget.onFlipEnd?.call(_controller.state);
        },
        child: current);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
