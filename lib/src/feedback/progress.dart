import 'package:flutter/material.dart';
import 'package:flutter_waya/src/core/extended_state.dart';

/// 线性进度条内部内容的构建器，回调当前进度值 0.0 ~ 1.0。
typedef FlLinearProgressChildBuilder = Widget Function(BuildContext context, double percent);

/// 线性进度条，支持纯色或渐变填充、动画过渡与自定义内容。
class FlLinearProgress extends StatefulWidget {
  const FlLinearProgress({
    super.key,
    required this.progressColor,
    this.percent = 0.0,
    this.height = 5.0,
    this.width = double.infinity,
    this.backgroundColor,
    this.animation = false,
    this.repeat = false,
    this.duration = const Duration(seconds: 2),
    this.curve = Curves.fastLinearToSlowEaseIn,
    this.isRTL = false,
    this.builder,
    this.strokeCap = StrokeCap.butt,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.maskFilter,
    this.onChanged,
  }) : assert(percent >= 0 && percent <= 1),
       assert(progressColor != null),
       isClip = false,
       linearGradient = null;

  const FlLinearProgress.gradient({
    super.key,
    required this.linearGradient,
    this.percent = 0.0,
    this.height = 5.0,
    this.width = double.infinity,
    this.backgroundColor,
    this.animation = false,
    this.repeat = false,
    this.duration = const Duration(seconds: 2),
    this.curve = Curves.fastLinearToSlowEaseIn,
    this.isRTL = false,
    this.builder,
    this.strokeCap = StrokeCap.square,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.maskFilter,
    this.isClip = true,
    this.onChanged,
  }) : assert(percent >= 0 && percent <= 1),
       assert(linearGradient != null),
       progressColor = null;

  /// 当前进度值，范围 0.0 ~ 1.0，默认 0.0。
  final double percent;

  /// 进度条底色，默认取主题的 colorScheme.primary。
  final Color? backgroundColor;

  /// 进度条前景色，默认取主题进度条颜色或 primaryColor。
  final Color? progressColor;

  /// 是否播放进度动画，默认 false。
  final bool animation;

  /// 动画时长，默认 2 秒，仅 [animation] 为 true 时生效。
  final Duration duration;

  /// 进度条内部的自定义内容构建器，回调当前进度值。
  final FlLinearProgressChildBuilder? builder;

  /// 渐变色填充，使用 .gradient 构造时生效，与 [progressColor] 互斥。
  final LinearGradient? linearGradient;

  /// 前景遮罩滤镜，用于模糊进度绘制边缘。
  final MaskFilter? maskFilter;

  /// 进度动画曲线，默认 Curves.fastLinearToSlowEaseIn。
  final Curve curve;

  /// 是否在进度到达 1.0 后重新开始动画，默认 false。
  final bool repeat;

  /// 进度条宽度，默认 double.infinity，即占满父级可用宽度。
  final double width;

  /// 进度条高度（线宽），默认 5.0。
  final double height;

  /// 线段端点样式，普通构造默认 butt，渐变构造默认 square。
  final StrokeCap strokeCap;

  /// 内部 Row 的主轴对齐方式，默认 MainAxisAlignment.start。
  final MainAxisAlignment mainAxisAlignment;

  /// 是否从右向左绘制进度，默认 false。
  final bool isRTL;

  /// 进度变化时回调当前进度值 0.0 ~ 1.0。
  final ValueChanged<double>? onChanged;

  /// 是否按百分比裁剪渐变色，渐变构造固定为 true，普通构造为 false。
  final bool isClip;

  @override
  State<StatefulWidget> createState() => _FlLinearProgressState();
}

class _FlLinearProgressState extends FlExtendedState<FlLinearProgress> with SingleTickerProviderStateMixin {
  AnimationController? controller;

  /// [AnimationController.drive] 返回的动画，用于正确移除 listener，避免重复回调
  Animation<double>? driven;

  @override
  void initState() {
    super.initState();
    initAnimationController();
    startAnimation();
  }

  void initAnimationController() {
    driven?.removeListener(listener);
    driven = null;
    if (!widget.animation) {
      controller?.stop();
      return;
    }
    final AnimationController current = controller ??= AnimationController(vsync: this, duration: widget.duration);
    current.duration = widget.duration;
    driven = current.drive(CurveTween(curve: widget.curve))..addListener(listener);
    if (widget.percent <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.percent <= 0) widget.onChanged?.call(percent);
      });
    }
  }

  void disposeController() {
    driven?.removeListener(listener);
    driven = null;
    controller?.stop();
    controller?.dispose();
    controller = null;
  }

  void listener() {
    final double currentPercent = percent;
    lastPercent = currentPercent;
    widget.onChanged?.call(currentPercent);
    if (mounted) setState(() {});
  }

  void startAnimation() {
    if (!widget.animation) return;
    final AnimationController? controller = this.controller;
    if (controller == null) return;
    if (widget.repeat) {
      if (widget.percent > 0) controller.repeat(max: widget.percent);
    } else {
      controller.animateTo(widget.percent);
    }
  }

  double lastPercent = 0;

  double get percent => (driven?.value ?? widget.percent);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double? width = widget.width.isFinite
            ? widget.width
            : (constraints.hasBoundedWidth ? constraints.maxWidth : null);
        return SizedBox(
          height: widget.height,
          width: width,
          child: CustomPaint(
            painter: _LinearProgressPainter(
              isRTL: widget.isRTL,
              progress: percent,
              progressColor:
                  widget.progressColor ??
                  Theme.of(context).progressIndicatorTheme.color ??
                  Theme.of(context).primaryColor,
              linearGradient: widget.linearGradient,
              backgroundColor: widget.backgroundColor ?? Theme.of(context).colorScheme.primary,
              strokeCap: widget.strokeCap,
              width: widget.height,
              maskFilter: widget.maskFilter,
              isClip: widget.isClip,
            ),
            child: widget.builder?.call(context, percent),
          ),
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant FlLinearProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animation != widget.animation) initAnimationController();
    if (oldWidget.duration != widget.duration) {
      controller?.duration = widget.duration;
    }
    if (oldWidget.curve != widget.curve) {
      driven?.removeListener(listener);
      driven = null;
      final AnimationController? current = controller;
      if (current != null) {
        driven = current.drive(CurveTween(curve: widget.curve))..addListener(listener);
      }
    }
    if (oldWidget.animation != widget.animation ||
        oldWidget.percent != widget.percent ||
        oldWidget.repeat != widget.repeat) {
      startAnimation();
    }
  }

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }
}

class _LinearProgressPainter extends CustomPainter {
  final Paint background = Paint();
  final Paint line = Paint();
  final double width;
  final double progress;
  final bool isRTL;
  final Color backgroundColor;
  final StrokeCap strokeCap;
  final MaskFilter? maskFilter;
  final bool isClip;
  final LinearGradient? linearGradient;
  final Color progressColor;

  _LinearProgressPainter({
    required this.width,
    required this.progress,
    required this.isRTL,
    required this.progressColor,
    required this.backgroundColor,
    this.strokeCap = StrokeCap.butt,
    this.linearGradient,
    this.maskFilter,
    required this.isClip,
  }) {
    line.color = progress == 0 ? Colors.transparent : progressColor;
    background.color = backgroundColor;

    line.style = PaintingStyle.stroke;
    background.style = PaintingStyle.stroke;

    line.strokeWidth = width;
    background.strokeWidth = width;

    line.strokeCap = strokeCap;
    background.strokeCap = strokeCap;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Offset start = Offset(0.0, size.height / 2);
    final Offset end = Offset(size.width, size.height / 2);
    canvas.drawLine(start, end, background);
    if (maskFilter != null) line.maskFilter = maskFilter;

    if (isRTL) {
      final double xProgress = size.width - size.width * progress;
      if (linearGradient != null) {
        line.shader = _createGradientShaderRightToLeft(size, xProgress);
      }
      canvas.drawLine(end, Offset(xProgress, size.height / 2), line);
    } else {
      final double xProgress = size.width * progress;
      if (linearGradient != null) {
        line.shader = _createGradientShaderLeftToRight(size, xProgress);
      }
      canvas.drawLine(start, Offset(xProgress, size.height / 2), line);
    }
  }

  Shader _createGradientShaderRightToLeft(Size size, double xProgress) {
    final Offset shaderEndPoint = isClip ? Offset.zero : Offset(xProgress, size.height);
    return linearGradient!.createShader(Rect.fromPoints(Offset(size.width, size.height), shaderEndPoint));
  }

  Shader _createGradientShaderLeftToRight(Size size, double x) {
    final Offset shaderEndPoint = isClip ? Offset(size.width, size.height) : Offset(x, size.height);
    return linearGradient!.createShader(Rect.fromPoints(Offset.zero, shaderEndPoint));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
