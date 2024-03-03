import 'dart:math';
import 'package:flutter/material.dart';

typedef RatingStarsChanged = void Function(
    double realStars, double selectedStars);

typedef RatingStarsBuilder = Widget Function(bool selected);

/// 评级星星
class RatingStars extends StatefulWidget {
  const RatingStars({
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

  final RatingStarsBuilder builder;

  final int starCount;

  /// 初始数量(支持小数).
  final double value;

  /// 分阶, 范围0.01-1.0, 0.01表示任意星, 1.0表示整星星, 0.5表示半星, 范围内自定义.
  final double step;

  /// star size
  final Size starSize;

  /// spacing 间距.
  final double starSpacing;

  /// 最低分
  final double minStars;

  /// 是否开始滑动修改
  final bool enable;

  /// 数值发生变化的回调.
  final RatingStarsChanged? onChanged;

  /// 是否需要实时回调, 若开启, 拖动时会回调多次, 否则仅在用户操作结束后回调.
  final bool followChanged;

  /// 四舍五入
  /// 默认false: 举例: step=1, 实际选择2.4则结果为: 3. step=0.5, 实际选择2.2则结果为2.5.("进一法")
  /// 为true时:  举例: step=1, 实际选择2.4则结果为: 2. step=0.5, 实际选择2.2则结果为2.0.("四舍五入-取最近值")
  final bool rounded;

  @override
  State<RatingStars> createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  late double _minStars;

  late double _currentStars;

  late double _step;

  @override
  void initState() {
    super.initState();

    /// 0.01 <= step <= 1.0
    _step = min(1.0, widget.step);
    _step = max(0.01, widget.step);
    _minStars = min(widget.minStars, widget.starCount * 1.0);
    _currentStars = min(widget.value, widget.starCount * 1.0);
    _currentStars = max(widget.value, widget.minStars);
    setStars(_currentStars, false, false, false);
  }

  @override
  void didUpdateWidget(RatingStars oldWidget) {
    setStars(widget.value, false, false, false);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      widget.enable
          ? Listener(
              onPointerDown: (event) {
                calculateStars(event.localPosition.dx, false);
              },
              onPointerMove: (event) {
                calculateStars(event.localPosition.dx, false);
              },
              onPointerUp: (event) {
                calculateStars(event.localPosition.dx, true);
              },
              child: getStars(widget.starCount, false))
          : getStars(widget.starCount, false),
      IgnorePointer(
          child: ClipRect(
              clipper: _RatingStarsClipper(getWidth),
              child: getStars(widget.starCount, true))),
    ]);
  }

  /// 计算多少分
  void calculateStars(double width, bool needCallback) {
    var starIndex =
        (width / (widget.starSize.width + widget.starSpacing)).floor();
    var locationX = min(
        width - starIndex * (widget.starSize.width + widget.starSpacing),
        widget.starSize.width);
    var selectedStars = starIndex + locationX / widget.starSize.width;
    setStars(selectedStars, true, true, needCallback);
  }

  /// 实际得分
  void setStars(
      double selectedStars, bool useStep, bool reload, bool needCallback) {
    var realStars = min(widget.starCount, selectedStars);
    realStars = max(_minStars, realStars);
    var i = realStars.floor();
    if (useStep == true) {
      var decimalNumber = (realStars - i);
      int floor = (decimalNumber / _step).floor();
      double remainder = decimalNumber % _step;
      if (widget.rounded == true) {
        realStars =
            i + floor * _step + ((remainder >= _step * 0.5) ? _step : 0);
      } else {
        realStars = i + floor * _step + ((remainder > 0.0) ? _step : 0);
      }
    }
    _currentStars = (realStars * 100).floor() / 100;
    if (reload == true) {
      setState(() {});
      if (needCallback == false && widget.followChanged == false) return;
      if (widget.onChanged == null) return;
      widget.onChanged!(_currentStars, selectedStars);
    }
  }

  double get getWidth {
    var i = _currentStars.floor();
    var width = (widget.starSize.width + widget.starSpacing) * i +
        (_currentStars - i) * widget.starSize.width;
    return width;
  }

  /// 获取要显示的所有星星
  Widget getStars(int count, bool selected) => Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(max(count * 2 - 1, 0), (index) {
        if (index % 2 == 0) {
          return SizedBox.fromSize(
              size: widget.starSize, child: widget.builder(selected));
        }
        return SizedBox(
            width: widget.starSpacing, height: widget.starSize.height);
      }));
}

class _RatingStarsClipper extends CustomClipper<Rect> {
  _RatingStarsClipper(this.width);

  double width;

  @override
  Rect getClip(Size size) => Rect.fromLTRB(0, 0, width, size.height);

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    if (oldClipper is _RatingStarsClipper) {
      return oldClipper.width != width;
    }
    return false;
  }
}
