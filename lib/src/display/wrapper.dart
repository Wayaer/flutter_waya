import 'dart:math';

import 'package:flutter/material.dart';

/// 尖角所在方位：上、左、右、下。
enum FlSpineStyle { top, left, right, bottom }

/// 带尖角的气泡容器，可配置尖角方位、高度、角度、圆角、描边与阴影。
class FlWrapper extends StatelessWidget {
  const FlWrapper({
    super.key,
    this.spineHeight = 8.0,
    this.angle = 75,
    this.radius = 5.0,
    this.spineRadius = 2.0,
    this.offset = 15,
    this.strokeWidth,
    this.child,
    this.elevation,
    this.shadowColor = Colors.grey,
    this.formEnd = false,
    this.color = Colors.green,
    this.padding = const EdgeInsets.all(8),
    this.style = FlSpineStyle.left,
  }) : assert(spineHeight > 0, 'spineHeight 必须大于 0');

  /// 尖角高度（逻辑像素），默认 8.0。
  final double spineHeight;

  /// 尖角夹角，单位为度，默认 75。
  final double angle;

  /// 主体圆角半径，默认 5.0。
  final double radius;

  /// 尖角端点与连接处的圆角半径，默认 2.0；设为 0 保持尖锐。
  final double spineRadius;

  /// 尖角沿边框方向的偏移，默认 15。
  final double offset;

  /// 尖角所在方位，默认 FlSpineStyle.left。
  final FlSpineStyle style;

  /// 边框/填充颜色，默认 Colors.green。
  final Color color;

  /// 边框线宽，为 null 时按填充方式绘制。
  final double? strokeWidth;

  /// 为 true 时从边的末端反向计算尖角位置，默认 false。
  final bool formEnd;

  /// 内容内边距，默认 EdgeInsets.all(8)。
  final EdgeInsets padding;

  /// 阴影高度，为 null 时不绘制阴影。
  final double? elevation;

  /// 阴影颜色，默认 Colors.grey。
  final Color shadowColor;

  /// 子组件。
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = this.padding;
    switch (style) {
      case FlSpineStyle.top:
        padding = this.padding + EdgeInsets.only(top: spineHeight);
        break;
      case FlSpineStyle.left:
        padding = this.padding + EdgeInsets.only(left: spineHeight);
        break;
      case FlSpineStyle.right:
        padding = this.padding + EdgeInsets.only(right: spineHeight);
        break;
      case FlSpineStyle.bottom:
        padding = this.padding + EdgeInsets.only(bottom: spineHeight);
        break;
    }

    return CustomPaint(
      painter: FlWrapperPainter(
        spineHeight: spineHeight,
        angle: angle,
        radius: radius,
        spineRadius: spineRadius,
        offset: offset,
        strokeWidth: strokeWidth,
        color: color,
        shadowColor: shadowColor,
        elevation: elevation,
        style: style,
        formBottom: formEnd,
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

/// FlWrapper 的绘制器，负责绘制圆角框与尖角，参数含义同 FlWrapper。
class FlWrapperPainter extends CustomPainter {
  final Paint mPaint;

  final double? strokeWidth;

  final double? elevation;
  final Color shadowColor;
  final double spineHeight;
  final double angle;
  final bool formBottom;
  final double radius;
  final double spineRadius;
  final double offset;
  final FlSpineStyle style;
  final Color color;

  FlWrapperPainter({
    this.spineHeight = 10.0,
    this.angle = 75,
    this.radius = 5.0,
    this.spineRadius = 2.0,
    this.offset = 15,
    this.elevation,
    this.strokeWidth,
    this.shadowColor = Colors.grey,
    this.color = Colors.green,
    this.formBottom = false,
    this.style = FlSpineStyle.left,
  }) : assert(spineHeight > 0, 'spineHeight 必须大于 0'),
       mPaint = Paint()
         ..color = color
         ..style = strokeWidth == null ? PaintingStyle.fill : PaintingStyle.stroke
         ..strokeWidth = strokeWidth ?? 1;

  @override
  void paint(Canvas canvas, Size size) {
    final Path body = buildBoxBySpineStyle(canvas, style, size.width, size.height);
    if (body.getBounds().isEmpty) return;
    final Path spine = buildDefaultSpinePath(canvas, spineHeight, style, size);
    final Path path = spine.getBounds().isEmpty ? body : Path.combine(PathOperation.union, body, spine);
    if (elevation != null) {
      canvas.drawShadow(path, shadowColor, elevation!, true);
    }
    canvas.drawPath(path, mPaint);
  }

  /// 按方位生成圆角框的主体路径。
  Path buildBoxBySpineStyle(Canvas canvas, FlSpineStyle style, double width, double height) {
    final Rect box;
    switch (style) {
      case FlSpineStyle.top:
        box = Rect.fromLTWH(0, spineHeight, width, height - spineHeight);
        break;
      case FlSpineStyle.left:
        box = Rect.fromLTWH(spineHeight, 0, width - spineHeight, height);
        break;
      case FlSpineStyle.right:
        box = Rect.fromLTWH(0, 0, width - spineHeight, height);
        break;
      case FlSpineStyle.bottom:
        box = Rect.fromLTWH(0, 0, width, height - spineHeight);
        break;
    }
    if (box.width <= 0 || box.height <= 0) return Path();
    final double r = radius.clamp(0.0, min(box.width, box.height) / 2).toDouble();
    return Path()..addRRect(RRect.fromRectAndRadius(box, Radius.circular(r)));
  }

  /// 按方位生成尖角路径，尖端与连接处使用 [spineRadius] 平滑过渡。
  Path buildDefaultSpinePath(Canvas canvas, double spineHeight, FlSpineStyle style, Size size) {
    if (spineHeight <= 0) return Path();

    final bool horizontal = style == FlSpineStyle.top || style == FlSpineStyle.bottom;
    final double edgeLength = horizontal ? size.width : size.height;
    final double tailMove = spineHeight * tan(pi / 180 * angle / 2);
    final double baseWidth = tailMove * 2;
    final double sideLength = sqrt(tailMove * tailMove + spineHeight * spineHeight);
    final double r = spineRadius.clamp(0.0, sideLength * 0.45).toDouble();
    final double margin = radius + r;
    double along = formBottom ? edgeLength - offset - baseWidth : offset;
    if (edgeLength - baseWidth >= 2 * margin) {
      along = along.clamp(margin, edgeLength - baseWidth - margin).toDouble();
    } else {
      along = max(0.0, (edgeLength - baseWidth) / 2);
    }

    final Offset t;
    final Offset n;
    final Offset origin;
    switch (style) {
      case FlSpineStyle.top:
        t = const Offset(1, 0);
        n = const Offset(0, -1);
        origin = Offset(along, spineHeight);
        break;
      case FlSpineStyle.bottom:
        t = const Offset(1, 0);
        n = const Offset(0, 1);
        origin = Offset(along, size.height - spineHeight);
        break;
      case FlSpineStyle.left:
        t = const Offset(0, 1);
        n = const Offset(-1, 0);
        origin = Offset(spineHeight, along);
        break;
      case FlSpineStyle.right:
        t = const Offset(0, 1);
        n = const Offset(1, 0);
        origin = Offset(size.width - spineHeight, along);
        break;
    }

    final Offset a = origin;
    final Offset b = a + t * baseWidth;
    final Offset tip = a + t * tailMove + n * spineHeight;
    if (r <= 0) {
      return Path()
        ..moveTo(a.dx, a.dy)
        ..lineTo(b.dx, b.dy)
        ..lineTo(tip.dx, tip.dy)
        ..close();
    }

    // 连接处圆角不能越过边框两端的可用空间
    final double rA = min(r, along);
    final double rB = min(r, edgeLength - (along + baseWidth));
    final Offset aSide = a + _normalized(tip - a) * rA;
    final Offset tipA = tip + _normalized(a - tip) * r;
    final Offset tipB = tip + _normalized(b - tip) * r;
    final Offset bSide = b + _normalized(tip - b) * rB;
    return Path()
      ..moveTo(a.dx - t.dx * rA, a.dy - t.dy * rA)
      ..quadraticBezierTo(a.dx, a.dy, aSide.dx, aSide.dy)
      ..lineTo(tipA.dx, tipA.dy)
      ..quadraticBezierTo(tip.dx, tip.dy, tipB.dx, tipB.dy)
      ..lineTo(bSide.dx, bSide.dy)
      ..quadraticBezierTo(b.dx, b.dy, b.dx + t.dx * rB, b.dy + t.dy * rB)
      ..close();
  }

  Offset _normalized(Offset offset) {
    final double length = offset.distance;
    if (length == 0) return Offset.zero;
    return offset / length;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is! FlWrapperPainter ||
      oldDelegate.spineHeight != spineHeight ||
      oldDelegate.angle != angle ||
      oldDelegate.radius != radius ||
      oldDelegate.spineRadius != spineRadius ||
      oldDelegate.offset != offset ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.color != color ||
      oldDelegate.shadowColor != shadowColor ||
      oldDelegate.elevation != elevation ||
      oldDelegate.style != style ||
      oldDelegate.formBottom != formBottom;
}
