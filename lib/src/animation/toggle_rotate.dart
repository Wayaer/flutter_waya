import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef ToggleBuilder = Widget Function(Widget child);

/// 旋转组件
class ToggleRotate extends StatefulWidget {
  const ToggleRotate(
      {super.key,
      required this.child,
      this.onTap,
      this.rad = pi / 2,
      this.clockwise = true,
      this.duration = const Duration(milliseconds: 200),
      this.curve = Curves.fastOutSlowIn,
      this.toggleBuilder,
      this.isRotate = false});

  final Widget child;

  /// 是否旋转
  final bool isRotate;

  /// 点击事件
  final GestureTapCallback? onTap;

  /// 旋转角度 pi / 2
  /// 1=180℃  2=90℃
  final double rad;

  /// 动画时长
  final Duration duration;

  /// 是否顺时针旋转
  final bool clockwise;

  /// 动画曲线
  final Curve curve;

  /// 自定义非旋转区域
  final ToggleBuilder? toggleBuilder;

  @override
  State<ToggleRotate> createState() => _ToggleRotateState();
}

class _ToggleRotateState extends State<ToggleRotate>
    with SingleTickerProviderStateMixin {
  double _rad = 0;
  bool _rotated = false;
  late AnimationController _controller;
  late Animation<double> _rotate;

  @override
  void initState() {
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..addListener(listener)
      ..addStatusListener(statusListener);
    _rotate = CurvedAnimation(parent: _controller, curve: widget.curve);
    super.initState();
  }

  void statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) _rotated = !_rotated;
  }

  void listener() {
    setState(() =>
        _rad = (_rotated ? (1 - _rotate.value) : _rotate.value) * widget.rad);
  }

  @override
  void dispose() {
    _controller.removeListener(listener);
    _controller.removeStatusListener(statusListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ToggleRotate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isRotate != widget.isRotate) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget current = Transform(
        transform: Matrix4.rotationZ(widget.clockwise ? _rad : -_rad),
        alignment: Alignment.center,
        child: widget.child);
    if (widget.toggleBuilder != null) current = widget.toggleBuilder!(current);
    if (widget.onTap != null) current = current.onTap(widget.onTap!);
    return current;
  }
}
