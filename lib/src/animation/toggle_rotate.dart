import 'package:flutter/material.dart';
import 'package:flutter_waya/src/extended_state.dart';

typedef ToggleRotateHandleRotation = void Function(
    {bool reset, bool needsBuild});

typedef ToggleRotateBuilder = Widget Function(
    Widget child, ToggleRotateHandleRotation rotate);

typedef ToggleRotateIconBuilder = Widget Function(bool isRotation);

typedef ToggleRotateCallback = void Function(bool isRotation);

extension ExtensionWidgetToggleRotate on Widget {
  ToggleRotateIconBuilder get toToggleRotateIconBuilder => (isRotation) => this;
}

/// 旋转组件
class ToggleRotate extends StatefulWidget {
  const ToggleRotate(
      {super.key,
      required this.icon,
      this.builder,
      this.turns = 1,
      this.clockwise = true,
      this.duration = const Duration(milliseconds: 200),
      this.curve = Curves.fastOutSlowIn,
      this.isRotate = false,
      this.onChanged});

  /// 旋转的icon
  final ToggleRotateIconBuilder icon;

  /// 自定义非旋转区域
  final ToggleRotateBuilder? builder;

  /// 变化监听
  final ToggleRotateCallback? onChanged;

  /// 是否旋转
  final bool isRotate;

  /// 旋转圈数
  /// 1 = 一圈    0.5 = 半圈    2 = 两圈
  final double turns;

  /// 动画时长
  final Duration duration;

  /// 是否顺时针旋转
  final bool clockwise;

  /// 动画曲线
  final Curve curve;

  @override
  State<ToggleRotate> createState() => _ToggleRotateState();
}

class _ToggleRotateState extends ExtendedState<ToggleRotate>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> rotate;

  @override
  void initState() {
    controller = AnimationController(duration: widget.duration, vsync: this);
    controller.addStatusListener(statusListener);
    initTween();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isRotate) controller.forward();
    });
  }

  void statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onChanged?.call(true);
    } else if (status == AnimationStatus.dismissed) {
      widget.onChanged?.call(false);
    }
  }

  void initTween() {
    double begin = 0;
    double end = widget.turns;
    if (!widget.clockwise) {
      begin = end;
      end = 0;
    }
    rotate = controller.drive(Tween<double>(begin: begin, end: end)
        .chain(CurveTween(curve: widget.curve)));
  }

  void handleRotation({bool reset = false, bool needsBuild = false}) {
    if (reset) controller.reset();
    if (controller.value == 0.0) {
      controller.forward();
    } else {
      controller.reverse();
    }

    if (needsBuild) setState(() {});
  }

  @override
  void didUpdateWidget(covariant ToggleRotate oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.duration = widget.duration;
    initTween();
    if (oldWidget.isRotate != widget.isRotate) {
      handleRotation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = AnimatedBuilder(
        animation: controller.view,
        builder: (_, Widget? child) => RotationTransition(
            turns: rotate, child: widget.icon(controller.value == 1.0)));
    if (widget.builder == null) return current;
    return widget.builder!(current, handleRotation);
  }

  @override
  void dispose() {
    controller.removeStatusListener(statusListener);
    controller.dispose();
    super.dispose();
  }
}
