import 'package:flutter/material.dart';

enum FlIndicatorStyle { none, slide, warm, color, scale, drop }

/// 指示器
class FlIndicator extends StatelessWidget {
  const FlIndicator(
      {super.key,
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
      required this.position});

  final int index;

  /// usually use `pageController.page`
  final double position;

  /// size of the dots
  final double size;

  /// space between dots.
  final double space;

  /// count of dots
  final int count;

  /// active color
  final Color? activeColor;

  /// normal color
  final Color? color;

  /// layout of the dots,default is [FlIndicatorStyle.slide]
  final FlIndicatorStyle style;

  /// Only valid when layout==FlIndicatorStyle.scale
  final double scale;

  /// Only valid when layout==FlIndicatorStyle.drop
  final double dropHeight;

  final double activeSize;

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
    final colorScheme = Theme.of(context).colorScheme;
    final Widget child = SizedBox(
        width: count * size + (count - 1) * space,
        height: size,
        child: CustomPaint(
            painter: createPainter(activeColor ?? colorScheme.primary,
                color ?? colorScheme.primaryContainer)));
    final isClip =
        style == FlIndicatorStyle.scale || style == FlIndicatorStyle.color;
    return IgnorePointer(child: isClip ? ClipRect(child: child) : child);
  }
}

class _WarmPainter extends FlIndicatorPainter {
  _WarmPainter(super.widget, super.page, super.index, super.paint,
      super.activeColor, super.color);

  @override
  void draw(Canvas canvas, double space, double size, double radius) {
    final double progress = page - index;
    final double distance = size + space;
    final double start = index * (size + space);

    if (progress > 0.5) {
      final double right = start + size + distance;

      final double left = index * distance + distance * (progress - 0.5) * 2;
      canvas.drawRRect(
          RRect.fromLTRBR(left, 0.0, right, size, Radius.circular(radius)),
          _paint);
    } else {
      final double right = start + size + distance * progress * 2;
      canvas.drawRRect(
          RRect.fromLTRBR(start, 0.0, right, size, Radius.circular(radius)),
          _paint);
    }
  }
}

class _DropPainter extends FlIndicatorPainter {
  _DropPainter(super.widget, super.page, super.index, super.paint,
      super.activeColor, super.color);

  @override
  void draw(Canvas canvas, double space, double size, double radius) {
    final double progress = page - index;
    final double dropHeight = widget.dropHeight;
    final double rate = (0.5 - progress).abs() * 2;
    final double scale = widget.scale;
    canvas.drawCircle(
        Offset(
            radius + (page * (size + space)), radius - dropHeight * (1 - rate)),
        radius * (scale + rate * (1.0 - scale)),
        _paint);
  }
}

class _NonePainter extends FlIndicatorPainter {
  _NonePainter(super.widget, super.page, super.index, super.paint,
      super.activeColor, super.color);

  @override
  void draw(Canvas canvas, double space, double size, double radius) {
    final double progress = page - index;
    final double secondOffset = index == widget.count - 1
        ? radius
        : radius + ((index + 1) * (size + space));
    canvas.drawCircle(
        progress > 0.5
            ? Offset(secondOffset, radius)
            : Offset(radius + (index * (size + space)), radius),
        radius,
        _paint);
  }
}

class _SlidePainter extends FlIndicatorPainter {
  _SlidePainter(super.widget, super.page, super.index, super.paint,
      super.activeColor, super.color);

  @override
  void draw(Canvas canvas, double space, double size, double radius) =>
      canvas.drawCircle(
          Offset(radius + (page * (size + space)), radius), radius, _paint);
}

class _ScalePainter extends FlIndicatorPainter {
  _ScalePainter(super.widget, super.page, super.index, super.paint,
      super.activeColor, super.color);

  @override
  bool _shouldSkip(int i) {
    if (index == widget.count - 1) return i == 0 || i == index;
    return i == index || i == index + 1;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _paint.color = _color;
    final double space = widget.space;
    final double size = widget.size;
    final double radius = size / 2;
    for (int i = 0; i < widget.count; ++i) {
      if (_shouldSkip(i)) continue;
      canvas.drawCircle(Offset(i * (size + space) + radius, radius),
          radius * widget.scale, _paint);
    }
    _paint.color = _activeColor;
    draw(canvas, space, size, radius);
  }

  @override
  void draw(Canvas canvas, double space, double size, double radius) {
    final double secondOffset = index == widget.count - 1
        ? radius
        : radius + ((index + 1) * (size + space));

    final double progress = page - index;
    _paint.color = Color.lerp(_activeColor, _color, progress)!;

    /// last
    canvas.drawCircle(Offset(radius + (index * (size + space)), radius),
        lerp(radius, radius * widget.scale, progress), _paint);

    /// first
    _paint.color = Color.lerp(_color, _activeColor, progress)!;
    canvas.drawCircle(Offset(secondOffset, radius),
        lerp(radius * widget.scale, radius, progress), _paint);
  }
}

class _ColorPainter extends FlIndicatorPainter {
  _ColorPainter(super.widget, super.page, super.index, super.paint,
      super.activeColor, super.color);

  @override
  bool _shouldSkip(int i) {
    if (index == widget.count - 1) return i == 0 || i == index;
    return i == index || i == index + 1;
  }

  @override
  void draw(Canvas canvas, double space, double size, double radius) {
    final double progress = page - index;
    final double secondOffset = index == widget.count - 1
        ? radius
        : radius + ((index + 1) * (size + space));
    _paint.color = Color.lerp(_activeColor, _color, progress)!;

    /// left
    canvas.drawCircle(
        Offset(radius + (index * (size + space)), radius), radius, _paint);

    /// right
    _paint.color = Color.lerp(_color, _activeColor, progress)!;
    canvas.drawCircle(Offset(secondOffset, radius), radius, _paint);
  }
}

abstract class FlIndicatorPainter extends CustomPainter {
  FlIndicatorPainter(this.widget, this.page, this.index, this._paint,
      this._activeColor, this._color);

  final FlIndicator widget;
  final double page;
  final int index;
  final Paint _paint;
  final Color _activeColor;
  final Color _color;

  double lerp(double begin, double end, double progress) =>
      begin + (end - begin) * progress;

  void draw(Canvas canvas, double space, double size, double radius);

  bool _shouldSkip(int index) => false;

  @override
  void paint(Canvas canvas, Size size) {
    _paint.color = _color;
    final double space = widget.space;
    final double size = widget.size;
    final double radius = size / 2;
    for (int i = 0; i < widget.count; ++i) {
      if (_shouldSkip(i)) continue;
      canvas.drawCircle(
          Offset(i * (size + space) + radius, radius), radius, _paint);
    }

    double page = this.page;
    if (page < index) page = 0.0;
    _paint.color = _activeColor;
    draw(canvas, space, size, radius);
  }

  @override
  bool shouldRepaint(FlIndicatorPainter oldDelegate) =>
      oldDelegate.page != page;
}
