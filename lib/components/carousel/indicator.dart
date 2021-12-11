import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

enum IndicatorType { none, slide, warm, color, scale, drop }

/// 指示器
class Indicator extends StatelessWidget {
  const Indicator(
      {Key? key,
      required this.count,
      this.size = 20.0,
      this.space = 5.0,
      this.activeSize = 20.0,
      this.color,
      this.layout = IndicatorType.slide,
      this.activeColor,
      this.scale = 0.6,
      this.dropHeight = 20.0,
      required this.index,
      required this.position})
      : super(key: key);

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

  /// layout of the dots,default is [IndicatorType.slide]
  final IndicatorType layout;

  /// Only valid when layout==IndicatorType.scale
  final double scale;

  /// Only valid when layout==IndicatorType.drop
  final double dropHeight;

  final double activeSize;

  _IndicatorPainter createPainter(Color activeColor, Color color) {
    final Paint _paint = Paint();
    switch (layout) {
      case IndicatorType.none:
        return _NonePainter(this, position, index, _paint, activeColor, color);
      case IndicatorType.slide:
        return _SlidePainter(this, position, index, _paint, activeColor, color);
      case IndicatorType.warm:
        return _WarmPainter(this, position, index, _paint, activeColor, color);
      case IndicatorType.color:
        return _ColorPainter(this, position, index, _paint, activeColor, color);
      case IndicatorType.scale:
        return _ScalePainter(this, position, index, _paint, activeColor, color);
      case IndicatorType.drop:
        return _DropPainter(this, position, index, _paint, activeColor, color);
      default:
        throw Exception('Not a valid layout');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = SizedBox(
        width: count * size + (count - 1) * space,
        height: size,
        child: CustomPaint(
            painter: createPainter(
                activeColor ?? context.theme.selectedRowColor,
                color ?? context.theme.unselectedWidgetColor)));
    return IgnorePointer(
        child: layout == IndicatorType.scale || layout == IndicatorType.color
            ? ClipRect(child: child)
            : child);
  }
}

class _WarmPainter extends _IndicatorPainter {
  _WarmPainter(Indicator widget, double page, int index, Paint paint,
      Color activeColor, Color color)
      : super(widget, page, index, paint, activeColor, color);

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

class _DropPainter extends _IndicatorPainter {
  _DropPainter(Indicator widget, double page, int index, Paint paint,
      Color activeColor, Color color)
      : super(widget, page, index, paint, activeColor, color);

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

class _NonePainter extends _IndicatorPainter {
  _NonePainter(Indicator widget, double page, int index, Paint paint,
      Color activeColor, Color color)
      : super(widget, page, index, paint, activeColor, color);

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

class _SlidePainter extends _IndicatorPainter {
  _SlidePainter(Indicator widget, double page, int index, Paint paint,
      Color activeColor, Color color)
      : super(widget, page, index, paint, activeColor, color);

  @override
  void draw(Canvas canvas, double space, double size, double radius) =>
      canvas.drawCircle(
          Offset(radius + (page * (size + space)), radius), radius, _paint);
}

class _ScalePainter extends _IndicatorPainter {
  _ScalePainter(
    Indicator widget,
    double page,
    int index,
    Paint paint,
    Color activeColor,
    Color color,
  ) : super(widget, page, index, paint, activeColor, color);

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

class _ColorPainter extends _IndicatorPainter {
  _ColorPainter(Indicator widget, double page, int index, Paint paint,
      Color activeColor, Color color)
      : super(widget, page, index, paint, activeColor, color);

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

abstract class _IndicatorPainter extends CustomPainter {
  _IndicatorPainter(this.widget, this.page, this.index, this._paint,
      this._activeColor, this._color);

  final Indicator widget;
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
  bool shouldRepaint(_IndicatorPainter oldDelegate) => oldDelegate.page != page;
}
