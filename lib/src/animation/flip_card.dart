import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// 卡片朝向：正面 front、反面 back。
enum FlFlipCardState {
  /// 正面
  front,

  /// 反面
  back;

  /// 取反后的状态。
  FlFlipCardState get toggle {
    if (this == FlFlipCardState.front) {
      return FlFlipCardState.back;
    } else {
      return FlFlipCardState.front;
    }
  }

  /// 是否为正面。
  bool get isFront => this == FlFlipCardState.front;

  /// 是否为反面。
  bool get isBack => this == FlFlipCardState.back;
}

/// 翻页回调，参数为当前朝向。
typedef FlFlipCardOnFlipCallback = void Function(FlFlipCardState state);

/// 卡片翻转控制器，管理正反面状态与翻转动画。
class FlFlipCardController {
  FlFlipCardController({
    required this.vsync,
    FlFlipCardState state = FlFlipCardState.front,
    this.duration = const Duration(milliseconds: 250),
  }) {
    _state = state;
    _initController();
  }

  /// 动画驱动，通常传 State 的 TickerProvider。
  final TickerProvider vsync;

  /// 翻转动画时间
  final Duration duration;

  late AnimationController _animationController;

  bool _disposed = false;

  /// 底层的动画控制器。
  AnimationController get animationController => _animationController;

  /// 正面旋转动画
  Animation<double>? _frontRotation;

  Animation<double> get frontRotation => _frontRotation ??= TweenSequence([
    TweenSequenceItem<double>(
      tween: Tween(begin: 0.0, end: pi / 2).chain(CurveTween(curve: Curves.easeIn)),
      weight: 50.0,
    ),
    TweenSequenceItem<double>(tween: ConstantTween<double>(pi / 2), weight: 50.0),
  ]).animate(_animationController);

  /// 反面旋转动画
  Animation<double>? _backRotation;

  Animation<double> get backRotation => _backRotation ??= TweenSequence([
    TweenSequenceItem<double>(tween: ConstantTween<double>(pi / 2), weight: 50.0),
    TweenSequenceItem<double>(
      tween: Tween(begin: -pi / 2, end: 0.0).chain(CurveTween(curve: Curves.easeOut)),
      weight: 50.0,
    ),
  ]).animate(_animationController);

  /// 卡片状态
  FlFlipCardState _state = FlFlipCardState.front;

  /// 获取卡片状态
  FlFlipCardState get state => _state;

  /// 设置卡片状态
  set state(FlFlipCardState state) {
    _state = state;
    _animationController.value = state.index.toDouble();
  }

  void _initController() {
    _animationController = AnimationController(value: _state.index.toDouble(), duration: duration, vsync: vsync);
  }

  /// 立即翻转，无动画。
  void toggle() {
    _animationController.value = (_state = state.toggle).index.toDouble();
  }

  /// 带动画翻转；正在动画时返回 false，正常完成返回 true。
  Future<bool> animateToggle() async {
    if (_animationController.isAnimating) return false;
    final TickerFuture animation = state.isFront
        ? _animationController.forward(from: 0)
        : _animationController.reverse(from: 1);
    try {
      await animation.orCancel;
    } on TickerCanceled {
      return false;
    }
    _state = state.toggle;
    return true;
  }

  /// 动画倾斜到 0~1 之间的进度，正在动画时返回 false。
  Future<bool> skew(double amount, {Duration? duration, Curve curve = Curves.linear}) async {
    if (_animationController.isAnimating) return false;
    if (amount < 0) amount = 0;
    if (amount > 1) amount = 1;
    final target = state.isFront ? amount : 1 - amount;
    await _animationController.animateTo(target, duration: duration, curve: curve);
    return true;
  }

  /// 提示性翻转后自动复位，正在动画或已销毁时返回 false。
  Future<bool> hint({Duration duration = const Duration(milliseconds: 150), Duration? total}) async {
    if (_animationController.isAnimating || _disposed) return false;
    final Duration durationTotal = total ?? _animationController.duration ?? duration;
    final Duration? original = _animationController.duration;
    _animationController.duration = durationTotal;
    state.isFront ? _animationController.forward() : _animationController.reverse();
    try {
      await Future.delayed(duration);
      if (_disposed) return false;
      final TickerFuture animation = state.isFront ? _animationController.reverse() : _animationController.forward();
      await animation.orCancel;
    } on TickerCanceled {
      return false;
    } finally {
      if (!_disposed) _animationController.duration = original;
    }
    return true;
  }

  /// 释放动画资源。
  void dispose() {
    _disposed = true;
    _animationController.dispose();
  }
}

/// 翻转卡片组件，正反两面堆叠显示。
class FlFlipCard extends StatelessWidget {
  const FlFlipCard({
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

  /// 翻转轴方向，默认水平。
  final Axis direction;

  /// 正反面的对齐方式。
  final AlignmentGeometry alignment;

  /// Stack 的布局方式，默认 [StackFit.loose]。
  final StackFit fit;

  /// 翻转控制器。
  final FlFlipCardController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: alignment,
      fit: fit,
      children: [
        buildAnimatedBuilder(child: front, animation: controller.frontRotation),
        buildAnimatedBuilder(child: back, animation: controller.backRotation),
      ],
    );
  }

  /// 构建单面的翻转动画包装。
  Widget buildAnimatedBuilder({required Widget child, required Animation<double> animation}) => AnimatedBuilder(
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
        // 旋转到 90° 时该面不可见，也无法响应点击：frontRotation 达到 π/2 或
        // backRotation 停留在 π/2 时都满足该条件，避免依赖尚未更新的 controller.state
        ignoring: animation.value >= pi / 2 - 1e-3,
        child: Transform(
          transform: transform,
          filterQuality: FilterQuality.none,
          alignment: FractionalOffset.center,
          child: child,
        ),
      );
    },
    child: child,
  );
}

/// 有状态翻转卡片的正面/反面构建器。
typedef FlFlipCardStatefulBuilder = Widget Function(BuildContext context, FlFlipCardController controller);

/// 带状态管理的翻转卡片，点击即可翻转。
class FlFlipCardStateful extends StatefulWidget {
  const FlFlipCardStateful({
    super.key,
    required this.front,
    required this.back,
    this.duration = const Duration(milliseconds: 250),
    this.onFlipStart,
    this.onFlipEnd,
    this.direction = Axis.horizontal,
    this.initial = FlFlipCardState.front,
    this.alignment = AlignmentDirectional.topCenter,
    this.fit = StackFit.passthrough,
  });

  /// 初始朝向，默认 [FlFlipCardState.front]。
  final FlFlipCardState initial;

  /// 正面
  final FlFlipCardStatefulBuilder front;

  /// 反面
  final FlFlipCardStatefulBuilder back;

  /// 翻转动画时间
  final Duration duration;

  /// 翻转轴方向，默认水平。
  final Axis direction;

  /// 翻转开始回调。
  final FlFlipCardOnFlipCallback? onFlipStart;

  /// 翻转结束回调。
  final FlFlipCardOnFlipCallback? onFlipEnd;

  /// 正反面的对齐方式。
  final AlignmentGeometry alignment;

  /// Stack 的布局方式，默认 [StackFit.passthrough]。
  final StackFit fit;

  @override
  State<FlFlipCardStateful> createState() => _FlipCardStatefulState();
}

class _FlipCardStatefulState extends State<FlFlipCardStateful> with SingleTickerProviderStateMixin {
  late FlFlipCardController _controller;
  @override
  void initState() {
    super.initState();
    _controller = FlFlipCardController(vsync: this, state: widget.initial, duration: widget.duration);
  }

  @override
  void didUpdateWidget(covariant FlFlipCardStateful oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initial != oldWidget.initial) {
      _controller.state = widget.initial;
    }
    if (widget.duration != oldWidget.duration) {
      _controller.animationController.duration = widget.duration;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget current = FlFlipCard(
      front: widget.front(context, _controller),
      back: widget.back(context, _controller),
      fit: widget.fit,
      direction: widget.direction,
      alignment: widget.alignment,
      controller: _controller,
    );
    return GestureDetector(
      onTap: () async {
        if (_controller.animationController.isAnimating) return;
        widget.onFlipStart?.call(_controller.state);
        final bool flipped = await _controller.animateToggle();
        if (flipped && mounted) widget.onFlipEnd?.call(_controller.state);
      },
      child: current,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
