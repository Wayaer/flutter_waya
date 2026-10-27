import 'package:flutter/material.dart';
import 'package:flutter_waya/src/core/extended_state.dart';

/// 数值展示构建器，参数为当前要显示的数字字符串
typedef FlAnimationCounterBuilder = Widget Function(String value);

/// 数字切换动画样式
enum FlCounterStyle {
  /// 仅动画变化的数字部分
  part,

  /// 整个数字一起动画
  all,
}

/// 数字变化时带滑动动画的计数器
class FlAnimationCounter extends StatefulWidget {
  /// 新数字从下往上升起（向下滚动入场）
  const FlAnimationCounter.down({
    super.key,
    this.style = FlCounterStyle.part,
    this.duration = const Duration(milliseconds: 300),
    required this.value,
    required this.builder,
  }) : isDown = true;

  /// 新数字从上方落下（向上滚动入场）
  const FlAnimationCounter.up({
    super.key,
    this.style = FlCounterStyle.part,
    this.duration = const Duration(milliseconds: 300),
    required this.value,
    required this.builder,
  }) : isDown = false;

  /// 当前要显示的数字字符串
  final String value;

  /// 切换动画时长，默认 300 毫秒
  final Duration duration;

  /// 动画样式，默认 [FlCounterStyle.part]
  final FlCounterStyle style;

  /// 数字展示构建器
  final FlAnimationCounterBuilder builder;

  /// 动画方向，true 表示新数字从下往上升起
  final bool isDown;

  @override
  State<FlAnimationCounter> createState() => _AnimationCounterState();
}

class _AnimationCounterState extends FlExtendedState<FlAnimationCounter> with SingleTickerProviderStateMixin {
  late Animation<Offset> preSlideAnimation;
  late Animation<Offset> slideAnimation;
  late String value;
  late String preValue;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: widget.duration, value: 1, vsync: this)
      ..addStatusListener(handleAnimationStatus);
    value = widget.value;
    preValue = value;
    slideAnimation = controller.drive(Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero));
    preSlideAnimation = controller.drive(Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, 1.0)));
  }

  /// 动画结束后合并回单个文本，避免 `part` 样式残留拆分布局。
  void handleAnimationStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || value == preValue || !mounted) return;
    setState(() => preValue = value);
  }

  @override
  void didUpdateWidget(FlAnimationCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (controller.duration != widget.duration) {
      controller.duration = widget.duration;
    }
    if (widget.value != value) {
      if (mounted) animation(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    int didIndex = 0;
    if (preValue.length == value.length) {
      for (; didIndex < value.length; didIndex++) {
        if (value[didIndex] != preValue[didIndex]) break;
      }
    }
    final bool allChange = preValue.length != value.length || didIndex == 0;
    return ClipRect(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, child) {
          if (value == preValue) {
            return builder(value);
          } else if (widget.style == FlCounterStyle.part && !allChange) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                builder(value.substring(0, didIndex)),
                buildStack(value.substring(didIndex, value.length), preValue.substring(didIndex, preValue.length)),
              ],
            );
          }
          return buildStack(value, preValue);
        },
      ),
    );
  }

  Widget buildStack(String value, String preValue) => Stack(
    fit: StackFit.passthrough,
    alignment: Alignment.center,
    children: [
      FractionalTranslation(
        translation: widget.isDown ? slideAnimation.value : -slideAnimation.value,
        child: builder(value),
      ),
      if (controller.value < 1)
        FractionalTranslation(
          translation: widget.isDown ? preSlideAnimation.value : -preSlideAnimation.value,
          child: builder(preValue),
        ),
    ],
  );

  Widget builder(String value) => widget.builder(value);

  void animation(String newValue) {
    preValue = value;
    value = newValue;
    if (mounted) {
      controller.reset();
      controller.forward();
    }
  }

  @override
  void dispose() {
    controller.stop();
    controller.dispose();
    super.dispose();
  }
}
