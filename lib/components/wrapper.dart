import 'dart:math';

import 'package:flutter/material.dart';

typedef WrapperSpinePathBuilder = Path Function(
    Canvas canvas, SpineStyle style, Rect range);

enum SpineStyle { top, left, right, bottom }

class Wrapper extends StatelessWidget {
  const Wrapper(
      {super.key,
      this.spineHeight = 8.0,
      this.angle = 75,
      this.radius = 5.0,
      this.offset = 15,
      this.strokeWidth,
      this.child,
      this.elevation,
      this.shadowColor = Colors.grey,
      this.formEnd = false,
      this.color = Colors.green,
      this.spinePathBuilder,
      this.padding = const EdgeInsets.all(8),
      this.style = SpineStyle.left});

  const Wrapper.just({
    super.key,
    this.radius = 5.0,
    this.strokeWidth,
    this.child,
    this.elevation,
    this.shadowColor = Colors.grey,
    this.color = Colors.green,
    this.padding = const EdgeInsets.all(8),
  })  : spineHeight = 0,
        angle = 0,
        offset = 0,
        style = SpineStyle.bottom,
        spinePathBuilder = null,
        formEnd = false;

  /// 针尖高度
  final double spineHeight;

  /// 针尖角度 (角度值)
  final double angle;

  /// 圆角半径
  final double radius;

  /// 偏移量
  final double offset;

  /// 样式
  final SpineStyle style;

  /// 框框颜色
  final Color color;

  /// 边线宽
  final double? strokeWidth;

  /// 是否从尾部偏移
  final bool formEnd;

  /// 内边距
  final EdgeInsets padding;

  /// 影深
  final double? elevation;

  /// 阴影颜色
  final Color shadowColor;
  final Widget? child;

  /// 尖端路径构造器
  final WrapperSpinePathBuilder? spinePathBuilder;

  @override
  Widget build(BuildContext context) {
    var padding = this.padding;
    switch (style) {
      case SpineStyle.top:
        padding = this.padding + EdgeInsets.only(top: spineHeight);
        break;
      case SpineStyle.left:
        padding = this.padding + EdgeInsets.only(left: spineHeight);
        break;
      case SpineStyle.right:
        padding = this.padding + EdgeInsets.only(right: spineHeight);
        break;
      case SpineStyle.bottom:
        padding = this.padding + EdgeInsets.only(bottom: spineHeight);
        break;
    }

    return CustomPaint(
        painter: WrapperPainter(
            spineHeight: spineHeight,
            angle: angle,
            radius: radius,
            offset: offset,
            strokeWidth: strokeWidth,
            color: color,
            shadowColor: shadowColor,
            elevation: elevation,
            style: style,
            formBottom: formEnd,
            spinePathBuilder: spinePathBuilder),
        child: Padding(padding: padding, child: child));
  }
}

class WrapperPainter extends CustomPainter {
  static Path _path = Path();

  final Paint mPaint;

  final double? strokeWidth;
  final WrapperSpinePathBuilder? spinePathBuilder;

  final double? elevation;
  final Color shadowColor;
  final double spineHeight;
  final double angle;
  final bool formBottom;
  final double radius;
  final double offset;
  final SpineStyle style;
  final Color color;

  WrapperPainter(
      {this.spineHeight = 10.0,
      this.angle = 75,
      this.spinePathBuilder,
      this.radius = 5.0,
      this.offset = 15,
      this.elevation,
      this.strokeWidth,
      this.shadowColor = Colors.grey,
      this.color = Colors.green,
      this.formBottom = false,
      this.style = SpineStyle.left})
      : mPaint = Paint()
          ..color = color
          ..style =
              strokeWidth == null ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeWidth = strokeWidth ?? 1;

  @override
  void paint(Canvas canvas, Size size) {
    _path = buildBoxBySpineStyle(canvas, style, size.width, size.height);

    Path? spinePath;

    if (spinePathBuilder == null) {
      spinePath = buildDefaultSpinePath(canvas, spineHeight, style, size);
    } else {
      Rect range;
      switch (style) {
        case SpineStyle.top:
          range = Rect.fromLTRB(0, -spineHeight, size.width, 0);
          break;
        case SpineStyle.left:
          range = Rect.fromLTRB(-spineHeight, 0, 0, size.height);
          break;
        case SpineStyle.right:
          range = Rect.fromLTRB(-spineHeight, 0, 0, size.height)
              .translate(size.width, 0);
          break;
        case SpineStyle.bottom:
          range = Rect.fromLTRB(0, 0, size.width, spineHeight)
              .translate(0, size.height - spineHeight);
          break;
      }
      if (spinePathBuilder != null) {
        spinePath = spinePathBuilder!(canvas, style, range);
      }
    }

    if (spinePath != null) {
      _path = Path.combine(PathOperation.union, spinePath, _path);

      if (elevation != null) {
        canvas.drawShadow(_path, shadowColor, elevation!, true);
      }
      canvas.drawPath(_path, mPaint);
    }
  }

  buildDefaultSpinePath(
      Canvas canvas, double spineHeight, SpineStyle style, Size size) {
    switch (style) {
      case SpineStyle.top:
        return _drawTop(size.width, size.height, canvas);
      case SpineStyle.left:
        return _drawLeft(size.width, size.height, canvas);
      case SpineStyle.right:
        return _drawRight(size.width, size.height, canvas);
      case SpineStyle.bottom:
        return _drawBottom(size.width, size.height, canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  Path _drawTop(double width, double height, Canvas canvas) {
    var angleRad = pi / 180 * angle;
    var spineMoveX = spineHeight * tan(angleRad / 2);
    var spineMoveY = spineHeight;
    if (spineHeight != 0) {
      return Path()
        ..moveTo(!formBottom ? offset : width - offset - spineHeight, 0)
        ..relativeLineTo(spineMoveX, -spineMoveY)
        ..relativeLineTo(spineMoveX, spineMoveY);
    }
    return Path();
  }

  Path _drawBottom(double width, double height, Canvas canvas) {
    var lineHeight = height - spineHeight;
    var angleRad = pi / 180 * angle;
    var spineMoveX = spineHeight * tan(angleRad / 2);
    var spineMoveY = spineHeight;
    if (spineHeight != 0) {
      return Path()
        ..moveTo(
            !formBottom ? offset : width - offset - spineHeight, lineHeight)
        ..relativeLineTo(spineMoveX, spineMoveY)
        ..relativeLineTo(spineMoveX, -spineMoveY);
    }
    return Path();
  }

  Path _drawLeft(double width, double height, Canvas canvas) {
    var angleRad = pi / 180 * angle;
    var spineMoveX = spineHeight;
    var spineMoveY = spineHeight * tan(angleRad / 2);
    if (spineHeight != 0) {
      return Path()
        ..moveTo(0, !formBottom ? offset : height - offset - spineHeight)
        ..relativeLineTo(-spineMoveX, spineMoveY)
        ..relativeLineTo(spineMoveX, spineMoveY);
    }
    return Path();
  }

  Path _drawRight(double width, double height, Canvas canvas) {
    var lineWidth = width - spineHeight;
    var angleRad = pi / 180 * angle;
    var spineMoveX = spineHeight;
    var spineMoveY = spineHeight * tan(angleRad / 2);
    if (spineHeight != 0) {
      return Path()
        ..moveTo(
            lineWidth, !formBottom ? offset : height - offset - spineHeight)
        ..relativeLineTo(spineMoveX, spineMoveY)
        ..relativeLineTo(-spineMoveX, spineMoveY);
    }
    return Path();
  }

  Path buildBoxBySpineStyle(
      Canvas canvas, SpineStyle style, double width, double height) {
    double lineHeight, lineWidth;

    switch (style) {
      case SpineStyle.top:
        lineHeight = height - spineHeight;
        canvas.translate(0, spineHeight);
        lineWidth = width;
        break;
      case SpineStyle.left:
        lineWidth = width - spineHeight;
        lineHeight = height;
        canvas.translate(spineHeight, 0);
        break;
      case SpineStyle.right:
        lineWidth = width - spineHeight;
        lineHeight = height;
        break;
      case SpineStyle.bottom:
        lineHeight = height - spineHeight;
        lineWidth = width;
        break;
    }

    Rect box = Rect.fromCenter(
        center: Offset(lineWidth / 2, lineHeight / 2),
        width: lineWidth,
        height: lineHeight);

    return Path()..addRRect(RRect.fromRectXY(box, radius, radius));
  }
}
