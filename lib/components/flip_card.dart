library flip_card;

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

enum Fill { none, front, back }

typedef FlipCardOnFlipCallback = void Function(bool isFront);
typedef FlipCardCallback = void Function(FlipCardState flipCard);

class FlipCard extends StatefulWidget {
  const FlipCard({
    super.key,
    required this.front,
    required this.back,
    this.duration = const Duration(milliseconds: 300),
    this.onFlip,
    this.onFlipDone,
    this.direction = Axis.horizontal,
    this.onFlipCardState,
    this.touchFlip = true,
    this.initialFront = true,
    this.alignment = Alignment.center,
    this.fill = Fill.front,
  });

  /// 初始正面
  final bool initialFront;

  /// 正面
  final Widget front;

  /// 反面
  final Widget back;

  /// 翻转动画时间
  final Duration duration;

  /// 翻转水平或垂直
  final Axis direction;

  /// 点击翻转
  final bool touchFlip;

  /// Fill
  final Fill fill;

  /// 开始翻转
  final VoidCallback? onFlip;

  /// 翻转完成
  final FlipCardOnFlipCallback? onFlipDone;

  ///
  final Alignment alignment;

  /// 获取 FlipCardState
  final FlipCardCallback? onFlipCardState;

  @override
  State<StatefulWidget> createState() => FlipCardState();
}

class FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> _frontRotation;
  late Animation<double> _backRotation;

  late bool isFront;

  @override
  void initState() {
    isFront = widget.initialFront;
    super.initState();
    widget.onFlipCardState?.call(this);
    _initController();
  }

  void _initController() {
    controller = AnimationController(
        value: isFront ? 0.0 : 1.0, duration: widget.duration, vsync: this);
    _frontRotation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: pi / 2)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50.0),
      TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2), weight: 50.0)
    ]).animate(controller);
    _backRotation = TweenSequence([
      TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2), weight: 50.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: -pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50.0)
    ]).animate(controller);
  }

  @override
  void didUpdateWidget(FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      controller.duration = widget.duration;
    }
    isFront = widget.initialFront;
    widget.onFlipCardState?.call(this);
  }

  /// Flip the card
  /// If awaited, returns after animation completes.
  void animateToggle() {
    if (!mounted) return;
    widget.onFlip?.call();
    controller.duration = widget.duration;
    final animation = isFront ? controller.forward() : controller.reverse();
    animation.whenComplete(() {
      setState(() => isFront = !isFront);
      widget.onFlipDone?.call(isFront);
    });
  }

  /// Flip the card without playing an animation.
  /// This cancels any ongoing animation.
  void toggle() {
    controller.stop();
    widget.onFlip?.call();
    isFront = !isFront;
    controller.value = isFront ? 0.0 : 1.0;
    setState(() {});
    widget.onFlipDone?.call(isFront);
  }

  @override
  Widget build(BuildContext context) {
    final child = Stack(
        alignment: widget.alignment,
        fit: StackFit.passthrough,
        children: [
          _buildContent(true, widget.fill == Fill.front),
          _buildContent(false, widget.fill == Fill.back),
        ]);
    if (widget.touchFlip) {
      return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: animateToggle,
          child: child);
    }
    return child;
  }

  Widget _buildContent(bool front, bool isFill) {
    final card = IgnorePointer(
        ignoring: front ? !isFront : isFront,
        child: _animationCard(front ? widget.front : widget.back,
            front ? _frontRotation : _backRotation));
    if (isFill) return Positioned.fill(child: card);
    return card;
  }

  Widget _animationCard(Widget child, Animation<double> animation) =>
      AnimatedBuilder(
          animation: animation,
          builder: (_, Widget? child) {
            var transform = Matrix4.identity();
            transform.setEntry(3, 2, 0.001);
            if (widget.direction == Axis.vertical) {
              transform.rotateX(animation.value);
            } else {
              transform.rotateY(animation.value);
            }
            return Transform(
                transform: transform,
                filterQuality: FilterQuality.none,
                alignment: FractionalOffset.center,
                child: child);
          },
          child: child);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Skew by amount percentage (0 - 1.0)
  /// This can be used with a MouseRegion to indicate that the card can
  /// be flipped. skew(0) to go back to original.
  /// If awaited, returns after animation completes.
  Future<void> skew(double amount, {Duration? duration, Curve? curve}) async {
    assert(0 <= amount && amount <= 1);
    final target = isFront ? amount : 1 - amount;
    await controller
        .animateTo(target, duration: duration, curve: curve ?? Curves.linear)
        .asStream()
        .first;
  }

  /// Triggers a flip animation that reverses after the duration
  /// and will run for `total`
  /// If awaited, returns after animation completes.
  Future<void> hint(
      {Duration duration = const Duration(milliseconds: 150),
      Duration? total}) async {
    if (controller.isAnimating || controller.value != 0) return;
    final durationTotal = total ?? controller.duration;
    final completer = Completer();
    Duration? original = controller.duration;
    controller.duration = durationTotal;
    controller.forward();
    Timer(duration, () {
      controller.reverse().whenComplete(() {
        completer.complete();
      });
      controller.duration = original;
    });
    await completer.future;
  }
}
