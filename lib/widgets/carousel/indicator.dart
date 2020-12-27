import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 指示器
class Indicator extends StatefulWidget {
  const Indicator(
      {Key key,
      @required this.count,
      @required this.controller,
      this.size = 20.0,
      this.space = 5.0,
      this.activeSize = 20.0,
      this.color = Colors.white30,
      this.layout = IndicatorType.slide,
      this.activeColor = Colors.white,
      this.scale = 0.6,
      this.dropHeight = 20.0})
      : assert(count != null),
        assert(controller != null),
        super(key: key);

  ///  size of the dots
  final double size;

  ///  space between dots.
  final double space;

  ///  count of dots
  final int count;

  ///  active color
  final Color activeColor;

  ///  normal color
  final Color color;

  ///  layout of the dots,default is [IndicatorType.slide]
  final IndicatorType layout;

  ///  Only valid when layout==IndicatorType.scale
  final double scale;

  ///  Only valid when layout==IndicatorType.drop
  final double dropHeight;

  final PageController controller;

  final double activeSize;

  @override
  _IndicatorState createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {
  int index = 0;

  @override
  void initState() {
    widget.controller?.addListener(_onController);
    super.initState();
  }

  _IndicatorPainter createPainter() {
    final Paint _paint = Paint();
    switch (widget.layout) {
      case IndicatorType.none:
        return _NonePainter(
            widget, widget.controller.page ?? 0.0, index, _paint);
      case IndicatorType.slide:
        return _SlidePainter(
            widget, widget.controller.page ?? 0.0, index, _paint);
      case IndicatorType.warm:
        return _WarmPainter(
            widget, widget.controller.page ?? 0.0, index, _paint);
      case IndicatorType.color:
        return _ColorPainter(
            widget, widget.controller.page ?? 0.0, index, _paint);
      case IndicatorType.scale:
        return _ScalePainter(
            widget, widget.controller.page ?? 0.0, index, _paint);
      case IndicatorType.drop:
        return _DropPainter(
            widget, widget.controller.page ?? 0.0, index, _paint);
      default:
        throw Exception('Not a valid layout');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox(
        width: widget.count * widget.size + (widget.count - 1) * widget.space,
        height: widget.size,
        child: CustomPaint(painter: createPainter()));
    if (widget.layout == IndicatorType.scale ||
        widget.layout == IndicatorType.color) child = ClipRect(child: child);
    return IgnorePointer(child: child);
  }

  void _onController() {
    final double page = widget.controller.page ?? 0.0;
    index = page.floor();
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onController);
    super.dispose();
  }
}

class _WarmPainter extends _IndicatorPainter {
  _WarmPainter(Indicator widget, double page, int index, Paint paint)
      : super(widget, page, index, paint);

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
  _DropPainter(Indicator widget, double page, int index, Paint paint)
      : super(widget, page, index, paint);

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
  _NonePainter(Indicator widget, double page, int index, Paint paint)
      : super(widget, page, index, paint);

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
  _SlidePainter(Indicator widget, double page, int index, Paint paint)
      : super(widget, page, index, paint);

  @override
  void draw(Canvas canvas, double space, double size, double radius) =>
      canvas.drawCircle(
          Offset(radius + (page * (size + space)), radius), radius, _paint);
}

class _ScalePainter extends _IndicatorPainter {
  _ScalePainter(Indicator widget, double page, int index, Paint paint)
      : super(widget, page, index, paint);

  @override
  bool _shouldSkip(int i) {
    if (index == widget.count - 1) return i == 0 || i == index;
    return i == index || i == index + 1;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _paint.color = widget.color;
    final double space = widget.space;
    final double size = widget.size;
    final double radius = size / 2;
    for (int i = 0; i < widget.count; ++i) {
      if (_shouldSkip(i)) continue;
      canvas.drawCircle(Offset(i * (size + space) + radius, radius),
          radius * widget.scale, _paint);
    }
    _paint.color = widget.activeColor;
    draw(canvas, space, size, radius);
  }

  @override
  void draw(Canvas canvas, double space, double size, double radius) {
    final double secondOffset = index == widget.count - 1
        ? radius
        : radius + ((index + 1) * (size + space));

    final double progress = page - index;
    _paint.color = Color.lerp(widget.activeColor, widget.color, progress);

    /// last
    canvas.drawCircle(Offset(radius + (index * (size + space)), radius),
        lerp(radius, radius * widget.scale, progress), _paint);

    /// first
    _paint.color = Color.lerp(widget.color, widget.activeColor, progress);
    canvas.drawCircle(Offset(secondOffset, radius),
        lerp(radius * widget.scale, radius, progress), _paint);
  }
}

class _ColorPainter extends _IndicatorPainter {
  _ColorPainter(Indicator widget, double page, int index, Paint paint)
      : super(widget, page, index, paint);

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
    _paint.color = Color.lerp(widget.activeColor, widget.color, progress);

    /// left
    canvas.drawCircle(
        Offset(radius + (index * (size + space)), radius), radius, _paint);

    /// right
    _paint.color = Color.lerp(widget.color, widget.activeColor, progress);
    canvas.drawCircle(Offset(secondOffset, radius), radius, _paint);
  }
}

abstract class _IndicatorPainter extends CustomPainter {
  _IndicatorPainter(this.widget, this.page, this.index, this._paint);

  final Indicator widget;
  final double page;
  final int index;
  final Paint _paint;

  double lerp(double begin, double end, double progress) =>
      begin + (end - begin) * progress;

  void draw(Canvas canvas, double space, double size, double radius);

  bool _shouldSkip(int index) => false;

  @override
  void paint(Canvas canvas, Size size) {
    _paint.color = widget.color;
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
    _paint.color = widget.activeColor;
    draw(canvas, space, size, radius);
  }

  @override
  bool shouldRepaint(_IndicatorPainter oldDelegate) => oldDelegate.page != page;
}
