import 'package:flutter/material.dart';
import 'package:flutter_waya/src/core/extended_state.dart';

/// 弹性动画构建器，回调中提供 elasticUp、elastic、elasticDown 三个触发方法
typedef FlElasticBuilderCallback = Widget Function(
  BuildContext context,
  Function elasticUp,
  Function elastic,
  Function elasticDown,
);

/// 弹性按钮，按下时缩小并在松开后回弹
class FlElasticBuilder extends StatefulWidget {
  const FlElasticBuilder({
    super.key,
    this.withOpacity = false,
    this.alignment = Alignment.center,
    this.scale = 0.9,
    required this.builder,
    this.duration = const Duration(milliseconds: 100),
  }) : assert(scale <= 1.0 && scale > 0);

  /// 是否同时改变透明度，默认 false
  final bool withOpacity;

  /// 缩放动画的中心点，默认 [Alignment.center]
  final Alignment alignment;

  /// 缩小后的缩放比例，取值 (0, 1]，默认 0.9
  final double scale;

  /// 弹性动画时长，默认 100 毫秒
  final Duration duration;

  /// 构建器，可通过回调手动触发弹性动画
  final FlElasticBuilderCallback builder;

  @override
  State<FlElasticBuilder> createState() => _ElasticBuilderState();
}

class _ElasticBuilderState extends FlExtendedState<FlElasticBuilder> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  CurvedAnimation? _curve;

  @override
  void initState() {
    super.initState();
    initController();
    initAnimation();
  }

  void initController() {
    controller = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      reverseDuration: widget.duration,
      duration: widget.duration,
    );
    controller.value = 1;
  }

  void initAnimation() {
    _curve?.dispose();
    _curve = CurvedAnimation(parent: controller, curve: Curves.elasticOut);
    animation = Tween<double>(begin: widget.scale, end: 1.0).animate(_curve!);
  }

  /// 立即缩小到 [FlElasticBuilder.scale]
  void elasticDown() => controller.value = 0;

  /// 先缩小，等待指定时长（默认 [FlElasticBuilder.duration]）后回弹
  Future<void> elastic([Duration? duration]) async {
    controller.value = 0;
    await Future.delayed(duration ?? widget.duration);
    if (!mounted) return;
    controller.value = 1;
  }

  /// 立即恢复到原始大小
  void elasticUp() => controller.value = 1;

  @override
  void didUpdateWidget(covariant FlElasticBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      controller.duration = widget.duration;
      controller.reverseDuration = widget.duration;
    }
    if (widget.scale != oldWidget.scale) initAnimation();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    child: widget.builder(context, elasticUp, elastic, elasticDown),
    builder: (BuildContext context, Widget? child) {
      final scale = Transform.scale(scale: animation.value, alignment: widget.alignment, child: child);
      return widget.withOpacity ? Opacity(opacity: animation.value.clamp(0.5, 1.0).toDouble(), child: scale) : scale;
    },
  );

  @override
  void dispose() {
    _curve?.dispose();
    controller.dispose();
    super.dispose();
  }
}
