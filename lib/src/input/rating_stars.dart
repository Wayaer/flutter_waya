import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_waya/src/core/extended_state.dart';

/// 分值变化回调：realStars 为实际分值，selectedStars 为手指选中的原始分值。
typedef FlRatingStarsChanged = void Function(double realStars, double selectedStars);

/// 单颗星星的构建器，selected 表示该星是否被选中。
typedef FlRatingStarsBuilder = Widget Function(bool selected);

/// 支持点击/滑动选择、可配置步长与最低分的星级评分组件。
class FlRatingStars extends StatefulWidget {
  const FlRatingStars({
    super.key,
    required this.builder,
    this.starCount = 5,
    this.onChanged,
    this.starSize = const Size(20, 20),
    this.starSpacing = 4,
    this.value = 0.0,
    this.step = 0.5,
    this.rounded = false,
    this.minStars = 0,
    this.enable = true,
    this.followChanged = false,
  });

  /// 星星的构建器。
  final FlRatingStarsBuilder builder;

  /// 星星数量，默认 5。
  final int starCount;

  /// 初始分值（支持小数），默认 0.0。
  final double value;

  /// 分阶步长，范围 0.01-1.0，默认 0.5 表示半星。
  final double step;

  /// 单颗星星的尺寸，默认 Size(20, 20)。
  final Size starSize;

  /// 星星间距，默认 4。
  final double starSpacing;

  /// 最低可选分值，默认 0。
  final double minStars;

  /// 是否允许滑动/点击修改分值，默认 true。
  final bool enable;

  /// 分值变化回调。
  final FlRatingStarsChanged? onChanged;

  /// 是否在拖动过程中实时回调，默认 false（仅操作结束后回调）。
  final bool followChanged;

  /// 四舍五入
  /// 默认 false（进一法）: step=1 选择 2.4 结果为 3；step=0.5 选择 2.2 结果为 2.5
  /// 为 true 时（取最近值）: step=1 选择 2.4 结果为 2；step=0.5 选择 2.2 结果为 2.0
  final bool rounded;

  @override
  State<FlRatingStars> createState() => _RatingStarsState();
}

class _RatingStarsState extends FlExtendedState<FlRatingStars> {
  late double _minStars;

  late double _currentStars;

  late double _step;

  @override
  void initState() {
    super.initState();

    /// 0.01 <= step <= 1.0
    _step = min(1.0, max(0.01, widget.step));
    _minStars = min(widget.minStars, widget.starCount * 1.0);
    _currentStars = min(widget.value, widget.starCount * 1.0);
    _currentStars = max(widget.value, widget.minStars);
    setStars(_currentStars, false, false, false);
  }

  @override
  void didUpdateWidget(FlRatingStars oldWidget) {
    if (oldWidget.value != widget.value ||
        oldWidget.minStars != widget.minStars ||
        oldWidget.starCount != widget.starCount ||
        oldWidget.step != widget.step) {
      _step = min(1.0, max(0.01, widget.step));
      _minStars = min(widget.minStars, widget.starCount * 1.0);
      setStars(widget.value, false, false, false);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    return Stack(
      children: [
        widget.enable
            ? Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: (event) {
                  calculateStars(event.localPosition.dx, false);
                },
                onPointerMove: (event) {
                  calculateStars(event.localPosition.dx, false);
                },
                onPointerUp: (event) {
                  calculateStars(event.localPosition.dx, true);
                },
                child: getStars(widget.starCount, false),
              )
            : getStars(widget.starCount, false),
        IgnorePointer(
          child: ClipRect(
            clipper: _RatingStarsClipper(getWidth, isRtl: isRtl),
            child: getStars(widget.starCount, true),
          ),
        ),
      ],
    );
  }

  /// 根据手指横坐标计算分值，needCallback 为 true 时触发回调。
  void calculateStars(double width, bool needCallback) {
    final double step = widget.starSize.width + widget.starSpacing;
    final double totalWidth = widget.starCount * widget.starSize.width + (widget.starCount - 1) * widget.starSpacing;
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final double dx = (isRtl ? totalWidth - width : width).clamp(0.0, totalWidth).toDouble();
    final int starIndex = (dx / step).floor().clamp(0, widget.starCount - 1).toInt();
    final double locationX = min(dx - starIndex * step, widget.starSize.width);
    final double selectedStars = starIndex + locationX / widget.starSize.width;
    setStars(selectedStars, true, true, needCallback);
  }

  /// 应用步长与最低分限制后更新当前分值，并按需刷新与回调。
  void setStars(double selectedStars, bool useStep, bool reload, bool needCallback) {
    double realStars = min(widget.starCount * 1.0, selectedStars);
    realStars = max(_minStars, realStars);
    final double maxValue = widget.starCount * 1.0;
    final int i = realStars.floor();
    if (useStep == true) {
      final double decimalNumber = realStars - i;
      final int stepCount = (decimalNumber / _step).floor();
      final double remainder = decimalNumber % _step;
      if (widget.rounded == true) {
        realStars = i + stepCount * _step + ((remainder >= _step * 0.5) ? _step : 0);
      } else {
        realStars = i + stepCount * _step + ((remainder > 0.0) ? _step : 0);
      }
      realStars = min(maxValue, realStars);
    }
    _currentStars = (realStars * 100).floor() / 100;
    if (reload == true) {
      if (mounted) setState(() {});
      if (needCallback == false && widget.followChanged == false) return;
      if (widget.onChanged == null) return;
      widget.onChanged!(_currentStars, selectedStars);
    }
  }

  /// 当前分值对应的像素宽度，用于裁剪选中层。
  double get getWidth {
    final int i = _currentStars.floor();
    final double width = (widget.starSize.width + widget.starSpacing) * i + (_currentStars - i) * widget.starSize.width;
    return width;
  }

  /// 构建 count 颗星星的横向布局，selected 区分选中与未选中层。
  Widget getStars(int count, bool selected) => Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(max(count * 2 - 1, 0), (index) {
      if (index % 2 == 0) {
        return SizedBox.fromSize(size: widget.starSize, child: widget.builder(selected));
      }
      return SizedBox(width: widget.starSpacing, height: widget.starSize.height);
    }),
  );
}

class _RatingStarsClipper extends CustomClipper<Rect> {
  _RatingStarsClipper(this.width, {required this.isRtl});

  double width;

  final bool isRtl;

  @override
  Rect getClip(Size size) =>
      isRtl ? Rect.fromLTRB(size.width - width, 0, size.width, size.height) : Rect.fromLTRB(0, 0, width, size.height);

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    if (oldClipper is _RatingStarsClipper) {
      return oldClipper.width != width || oldClipper.isRtl != isRtl;
    }
    return false;
  }
}
