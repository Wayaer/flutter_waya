import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 指示器样式：无、滑动、渐变、变色、缩放、下坠。
enum FlIndicatorStyle { none, slide, warm, color, scale, drop }

/// 轮播页码指示器，可自定义样式、尺寸与颜色。
class FlIndicator extends StatelessWidget {
  const FlIndicator({
    super.key,
    required this.count,
    this.size = 12.0,
    this.space = 5.0,
    this.activeSize = 12.0,
    this.color,
    this.style = FlIndicatorStyle.slide,
    this.activeColor,
    this.scale = 0.6,
    this.dropHeight = 12.0,
    required this.index,
    required this.position,
  });

  /// 当前选中的真实 item 索引。
  final int index;

  /// 当前滚动位置，通常传 `pageController.page`。
  final double position;

  /// 圆点直径，默认 12。
  final double size;

  /// 圆点间距，默认 5。
  final double space;

  /// 圆点数量，一般等于 item 数量。
  final int count;

  /// 选中颜色，默认取主题 primary。
  final Color? activeColor;

  /// 未选中颜色，默认取主题 primaryContainer。
  final Color? color;

  /// 指示器样式，默认 [FlIndicatorStyle.slide]。
  final FlIndicatorStyle style;

  /// 缩放比例，仅 [FlIndicatorStyle.scale] 生效，默认 0.6。
  final double scale;

  /// 下坠高度，仅 [FlIndicatorStyle.drop] 生效，默认 12。
  final double dropHeight;

  /// 选中圆点直径，默认 12。
  final double activeSize;

  /// 按当前样式创建对应的绘制器。
  FlIndicatorPainter createPainter(Color activeColor, Color color) {
    final Paint paint = Paint();
    switch (style) {
      case FlIndicatorStyle.none:
        return _NonePainter(this, position, index, paint, activeColor, color);
      case FlIndicatorStyle.slide:
        return _SlidePainter(this, position, index, paint, activeColor, color);
      case FlIndicatorStyle.warm:
        return _WarmPainter(this, position, index, paint, activeColor, color);
      case FlIndicatorStyle.color:
        return _ColorPainter(this, position, index, paint, activeColor, color);
      case FlIndicatorStyle.scale:
        return _ScalePainter(this, position, index, paint, activeColor, color);
      case FlIndicatorStyle.drop:
        return _DropPainter(this, position, index, paint, activeColor, color);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    // 选中圆点可能比普通圆点大，画布需要同时容纳两者。
    final double maxSize = math.max(size, activeSize);
    final Widget child = SizedBox(
      width: count * size + (count - 1) * space + (maxSize - size),
      height: maxSize,
      child: CustomPaint(
        painter: createPainter(activeColor ?? colorScheme.primary, color ?? colorScheme.primaryContainer),
      ),
    );
    return IgnorePointer(child: child);
  }
}

class _WarmPainter extends FlIndicatorPainter {
  _WarmPainter(super.widget, super.page, super.index, super.paint, super.activeColor, super.color);

  @override
  void draw(Canvas canvas, double space, double size, double radius) {
    final double progress = activePage - index;
    final double distance = size + space;
    final double start = _startX + index * distance;
    final double activeHeight = widget.activeSize;
    final double top = _centerY - activeHeight / 2;
    final double bottom = _centerY + activeHeight / 2;
    final double capsuleRadius = activeHeight / 2;

    if (progress > 0.5) {
      final double right = start + size + distance;
      final double left = _startX + index * distance + distance * (progress - 0.5) * 2;
      canvas.drawRRect(RRect.fromLTRBR(left, top, right, bottom, Radius.circular(capsuleRadius)), _paint);
    } else {
      final double right = start + size + distance * progress * 2;
      canvas.drawRRect(RRect.fromLTRBR(start, top, right, bottom, Radius.circular(capsuleRadius)), _paint);
    }
  }
}

class _DropPainter extends FlIndicatorPainter {
  _DropPainter(super.widget, super.page, super.index, super.paint, super.activeColor, super.color);

  @override
  void draw(Canvas canvas, double space, double size, double radius) {
    final double progress = activePage - index;
    final double dropHeight = widget.dropHeight;
    final double rate = (0.5 - progress).abs() * 2;
    final double scale = widget.scale;
    canvas.drawCircle(
      Offset(_startX + radius + (activePage * (size + space)), _centerY - dropHeight * (1 - rate)),
      activeRadius * (scale + rate * (1.0 - scale)),
      _paint,
    );
  }
}

class _NonePainter extends FlIndicatorPainter {
  _NonePainter(super.widget, super.page, super.index, super.paint, super.activeColor, super.color);

  @override
  void draw(Canvas canvas, double space, double size, double radius) {
    final double progress = activePage - index;
    final double secondOffset = _nextDotOffset(space, size, radius);
    canvas.drawCircle(
      progress > 0.5 ? Offset(secondOffset, _centerY) : Offset(_startX + radius + (index * (size + space)), _centerY),
      activeRadius,
      _paint,
    );
  }
}

class _SlidePainter extends FlIndicatorPainter {
  _SlidePainter(super.widget, super.page, super.index, super.paint, super.activeColor, super.color);

  @override
  void draw(Canvas canvas, double space, double size, double radius) =>
      canvas.drawCircle(Offset(_startX + radius + (activePage * (size + space)), _centerY), activeRadius, _paint);
}

class _ScalePainter extends FlIndicatorPainter {
  _ScalePainter(super.widget, super.page, super.index, super.paint, super.activeColor, super.color);

  @override
  bool _shouldSkip(int i) => _skipWithNext(i);

  @override
  void paint(Canvas canvas, Size canvasSize) {
    _updateLayout(canvasSize);
    _paint.color = _color;
    final double space = widget.space;
    final double size = widget.size;
    final double radius = size / 2;
    for (int i = 0; i < widget.count; ++i) {
      if (_shouldSkip(i)) continue;
      canvas.drawCircle(Offset(_startX + i * (size + space) + radius, _centerY), radius * widget.scale, _paint);
    }
    _paint.color = _activeColor;
    draw(canvas, space, size, radius);
  }

  @override
  void draw(Canvas canvas, double space, double size, double radius) {
    final double secondOffset = _nextDotOffset(space, size, radius);
    final double progress = activePage - index;
    _paint.color = Color.lerp(_activeColor, _color, progress)!;

    /// last
    canvas.drawCircle(
      Offset(_startX + radius + (index * (size + space)), _centerY),
      lerp(activeRadius, activeRadius * widget.scale, progress),
      _paint,
    );

    /// first
    _paint.color = Color.lerp(_color, _activeColor, progress)!;
    canvas.drawCircle(
      Offset(secondOffset, _centerY),
      lerp(activeRadius * widget.scale, activeRadius, progress),
      _paint,
    );
  }
}

class _ColorPainter extends FlIndicatorPainter {
  _ColorPainter(super.widget, super.page, super.index, super.paint, super.activeColor, super.color);

  @override
  bool _shouldSkip(int i) => _skipWithNext(i);

  @override
  void draw(Canvas canvas, double space, double size, double radius) {
    final double progress = activePage - index;
    final double secondOffset = _nextDotOffset(space, size, radius);
    _paint.color = Color.lerp(_activeColor, _color, progress)!;

    /// left
    canvas.drawCircle(Offset(_startX + radius + (index * (size + space)), _centerY), activeRadius, _paint);

    /// right
    _paint.color = Color.lerp(_color, _activeColor, progress)!;
    canvas.drawCircle(Offset(secondOffset, _centerY), activeRadius, _paint);
  }
}

/// 指示器绘制基类，统一绘制未选中圆点并暴露选中圆点的绘制钩子。
abstract class FlIndicatorPainter extends CustomPainter {
  FlIndicatorPainter(this.widget, this.page, this.index, this._paint, this._activeColor, this._color);

  /// 所属指示器。
  final FlIndicator widget;

  /// 当前滚动页码。
  final double page;

  /// 当前索引。
  final int index;
  final Paint _paint;
  final Color _activeColor;
  final Color _color;

  /// 第一个圆点前的水平留白，用于让放大的选中圆点完整显示。
  double _startX = 0;

  /// 圆点的垂直中心。
  double _centerY = 0;

  /// 按画布尺寸计算圆点起始偏移与垂直中心。
  void _updateLayout(Size canvasSize) {
    _startX = (canvasSize.width - (widget.count * widget.size + (widget.count - 1) * widget.space)) / 2;
    _centerY = canvasSize.height / 2;
  }

  /// 当前生效的页码，小于当前索引时固定为当前索引。
  double get activePage => page < index ? index.toDouble() : page;

  /// 选中圆点的半径，由 [FlIndicator.activeSize] 决定。
  double get activeRadius => widget.activeSize / 2;

  /// 线性插值。
  double lerp(double begin, double end, double progress) => begin + (end - begin) * progress;

  /// 下一个圆点的水平中心偏移，最后一颗回绕到第一颗。
  double _nextDotOffset(double space, double size, double radius) =>
      index == widget.count - 1 ? _startX + radius : _startX + radius + ((index + 1) * (size + space));

  /// 是否需要跳过当前圆点与下一个圆点（`scale` / `color` 样式共用）。
  bool _skipWithNext(int i) {
    if (index == widget.count - 1) return i == 0 || i == index;
    return i == index || i == index + 1;
  }

  /// 绘制选中圆点，由子类实现。
  void draw(Canvas canvas, double space, double size, double radius);

  bool _shouldSkip(int index) => false;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    _updateLayout(canvasSize);
    _paint.color = _color;
    final double space = widget.space;
    final double size = widget.size;
    final double radius = size / 2;
    for (int i = 0; i < widget.count; ++i) {
      if (_shouldSkip(i)) continue;
      canvas.drawCircle(Offset(_startX + i * (size + space) + radius, _centerY), radius, _paint);
    }

    _paint.color = _activeColor;
    draw(canvas, space, size, radius);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is! FlIndicatorPainter ||
      oldDelegate.page != page ||
      oldDelegate.index != index ||
      oldDelegate._activeColor != _activeColor ||
      oldDelegate._color != _color ||
      oldDelegate.widget.count != widget.count ||
      oldDelegate.widget.size != widget.size ||
      oldDelegate.widget.activeSize != widget.activeSize ||
      oldDelegate.widget.space != widget.space ||
      oldDelegate.widget.style != widget.style ||
      oldDelegate.widget.scale != widget.scale ||
      oldDelegate.widget.dropHeight != widget.dropHeight;
}
