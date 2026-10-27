import 'package:flutter/material.dart';
import 'package:flutter_waya/src/core/extended_state.dart';

/// 手动触旋转的方法，可指定是否重置及是否重建
typedef FlToggleRotateHandleRotation = void Function({bool reset, bool needsBuild});

/// 旋转组件构建器，提供非旋转区域 child 与旋转触发方法
typedef FlToggleRotateBuilder = Widget Function(Widget child, FlToggleRotateHandleRotation rotate);

/// 旋转图标构建器，参数为当前是否处于旋转完成状态
typedef FlToggleRotateIconBuilder = Widget Function(bool isRotation);

/// 旋转状态变化回调
typedef FlToggleRotateCallback = void Function(bool isRotation);

/// 将任意 Widget 转换为旋转图标构建器
extension FlToggleRotateExtension on Widget {
  FlToggleRotateIconBuilder get toToggleRotateIconBuilder =>
      (isRotation) => this;
}

/// 可切换旋转状态的图标组件
class FlToggleRotate extends StatefulWidget {
  const FlToggleRotate({
    super.key,
    required this.icon,
    this.builder,
    this.turns = 1,
    this.clockwise = true,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.fastOutSlowIn,
    this.isRotate = false,
    this.onChanged,
  });

  /// 旋转图标构建器，参数为当前是否旋转完成
  final FlToggleRotateIconBuilder icon;

  /// 非旋转区域构建器，可自定义布局并获取旋转触发方法
  final FlToggleRotateBuilder? builder;

  /// 旋转状态变化回调
  final FlToggleRotateCallback? onChanged;

  /// 是否旋转，默认 false
  final bool isRotate;

  /// 旋转圈数，1 = 一圈，0.5 = 半圈，2 = 两圈，默认 1
  final double turns;

  /// 旋转动画时长，默认 200 毫秒
  final Duration duration;

  /// 是否顺时针旋转，默认 true
  final bool clockwise;

  /// 旋转动画曲线，默认 [Curves.fastOutSlowIn]
  final Curve curve;

  @override
  State<FlToggleRotate> createState() => _ToggleRotateState();
}

class _ToggleRotateState extends FlExtendedState<FlToggleRotate> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> rotate;

  @override
  void initState() {
    controller = AnimationController(duration: widget.duration, vsync: this);
    controller.addStatusListener(statusListener);
    initTween();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.isRotate) controller.forward();
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
    rotate = controller.drive(Tween<double>(begin: begin, end: end).chain(CurveTween(curve: widget.curve)));
  }

  void handleRotation({bool reset = false, bool needsBuild = false}) {
    if (reset) controller.reset();
    if (controller.status == AnimationStatus.forward) {
      controller.reverse();
    } else if (controller.status == AnimationStatus.reverse) {
      controller.forward();
    } else if (controller.value == 0.0) {
      controller.forward();
    } else {
      controller.reverse();
    }

    if (needsBuild) setState(() {});
  }

  @override
  void didUpdateWidget(covariant FlToggleRotate oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.duration = widget.duration;
    initTween();
    if (oldWidget.isRotate != widget.isRotate) {
      if (widget.isRotate) {
        controller.forward();
      } else {
        controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = AnimatedBuilder(
      animation: controller.view,
      builder: (_, Widget? child) => RotationTransition(turns: rotate, child: widget.icon(controller.value == 1.0)),
    );
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
