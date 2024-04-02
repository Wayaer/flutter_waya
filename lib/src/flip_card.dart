import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_waya/src/extended_state.dart';

enum FlipCardState {
  front,
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
  _FlipCardState? _flipCardState;

  FlipCardState? get flipCardState => _flipCardState?.flipCardState;

  /// Flip the card without playing an animation.
  /// This cancels any ongoing animation.
  void toggle() {
    _flipCardState?.toggle();
  }

  /// Flip the card
  /// If awaited, returns after animation completes.
  Future<void> animateToggle() async {
    _flipCardState?.animateToggle();
  }

  /// Skew by amount percentage (0 - 1.0)
  /// This can be used with a MouseRegion to indicate that the card can
  /// be flipped. skew(0) to go back to original.
  /// If awaited, returns after animation completes.
  Future<void> skew(double amount,
      {Duration? duration, Curve curve = Curves.linear}) async {
    await _flipCardState?.skew(amount, duration: duration, curve: curve);
  }

  /// Triggers a flip animation that reverses after the duration
  /// and will run for `total`
  /// If awaited, returns after animation completes.
  Future<void> hint(
      {Duration duration = const Duration(milliseconds: 150),
      Duration? total}) async {
    await _flipCardState?.hint(duration: duration, total: total);
  }
}

class FlipCard extends StatefulWidget {
  const FlipCard({
    super.key,
    required this.front,
    required this.back,
    this.duration = const Duration(milliseconds: 250),
    this.onFlip,
    this.onFlipDone,
    this.direction = Axis.horizontal,
    this.touchFlip = true,
    this.initial = FlipCardState.front,
    this.alignment = Alignment.center,
    this.fill,
    this.controller,
  });

  /// 初始正面
  final FlipCardState initial;

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
  final FlipCardState? fill;

  /// 开始翻转
  final FlipCardOnFlipCallback? onFlip;

  /// 翻转完成
  final FlipCardOnFlipCallback? onFlipDone;

  /// alignment
  final Alignment alignment;

  /// controller
  final FlipCardController? controller;

  @override
  State<StatefulWidget> createState() => _FlipCardState();
}

class _FlipCardState extends ExtendedState<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  FlipCardController? controller;
  late Animation<double> frontRotation;
  late Animation<double> backRotation;

  FlipCardState flipCardState = FlipCardState.front;

  @override
  void initState() {
    controller = widget.controller;
    flipCardState = widget.initial;
    super.initState();
    controller?._flipCardState = this;
    initController();
  }

  void initController() {
    animationController = AnimationController(
        value: flipCardState.index.toDouble(),
        duration: widget.duration,
        vsync: this);
    frontRotation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: pi / 2)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50.0),
      TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2), weight: 50.0)
    ]).animate(animationController);
    backRotation = TweenSequence([
      TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2), weight: 50.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: -pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50.0)
    ]).animate(animationController);
  }

  @override
  void didUpdateWidget(FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    animationController.duration = widget.duration;
    controller = widget.controller;
    controller?._flipCardState = this;
  }

  Future<void> animateToggle() async {
    if (!mounted) return;
    widget.onFlip?.call(flipCardState);
    animationController.duration = widget.duration;
    final animation = flipCardState.isFront
        ? animationController.forward(from: 0)
        : animationController.reverse(from: 1);
    log(flipCardState.index);
    await animation.whenComplete(() {
      flipCardState = flipCardState.toggle;
      log(flipCardState.index);
      widget.onFlipDone?.call(flipCardState);
    });
  }

  void toggle() {
    widget.onFlip?.call(flipCardState);
    flipCardState = flipCardState.toggle;
    animationController.value = flipCardState.index.toDouble();
    widget.onFlipDone?.call(flipCardState);
  }

  @override
  Widget build(BuildContext context) {
    final child = Stack(
        alignment: widget.alignment,
        fit: StackFit.passthrough,
        children: [
          buildContent(true, widget.fill == FlipCardState.front),
          buildContent(false, widget.fill == FlipCardState.back),
        ]);
    if (widget.touchFlip) {
      return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: animateToggle,
          child: child);
    }
    return child;
  }

  Widget buildContent(bool front, bool isFill) {
    final card = IgnorePointer(
        ignoring: front ? flipCardState.isBack : flipCardState.isFront,
        child: animationCard(front ? widget.front : widget.back,
            front ? frontRotation : backRotation));
    if (isFill) return Positioned.fill(child: card);
    return card;
  }

  Widget animationCard(Widget child, Animation<double> animation) =>
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
    animationController.dispose();
    super.dispose();
  }

  Future<void> skew(double amount,
      {Duration? duration, Curve curve = Curves.linear}) async {
    assert(0 <= amount && amount <= 1);
    final target = flipCardState.isFront ? amount : 1 - amount;
    await animationController
        .animateTo(target, duration: duration, curve: curve)
        .asStream()
        .first;
  }

  Future<void> hint(
      {Duration duration = const Duration(milliseconds: 150),
      Duration? total}) async {
    if (animationController.isAnimating) return;
    final durationTotal = total ?? animationController.duration;
    final completer = Completer();
    Duration? original = animationController.duration;
    animationController.duration = durationTotal;
    flipCardState.isFront
        ? animationController.forward()
        : animationController.reverse();
    Timer(duration, () {
      (flipCardState.isFront
              ? animationController.reverse()
              : animationController.forward())
          .whenComplete(() {
        completer.complete();
      });
      animationController.duration = original;
    });
    await completer.future;
  }
}
