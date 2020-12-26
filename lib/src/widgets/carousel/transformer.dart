import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_waya/src/widgets/carousel/transformer_page.dart';
import 'package:vector_math/vector_math_64.dart';

typedef PageTransformerBuilderCallback = Widget Function(
    Widget child, TransformInfo info);

class TransformInfo {
  TransformInfo(
      {this.index,
      this.position,
      this.width,
      this.height,
      this.activeIndex,
      this.fromIndex,
      this.forward,
      this.done,
      this.viewportFraction,
      this.scrollDirection});

  ///  The `width` of the `TransformerPageView`
  final double width;

  ///  The `height` of the `TransformerPageView`
  final double height;

  ///  The `position` of the widget pass to [PageTransformer.transform]
  ///  A `position` describes how visible the widget is.
  ///  The widget in the center of the screen' which is  full visible, position is 0.0.
  ///  The width in the left ,may be hidden, of the screen's position is less than 0.0, -1.0 when out of the screen.
  ///  The width in the right ,may be hidden, of the screen's position is greater than 0.0,  1.0 when out of the screen
  ///
  final double position;

  ///  The `index` of the widget pass to [PageTransformer.transform]
  final int index;

  ///  The `activeIndex` of the PageView
  final int activeIndex;

  ///  The `activeIndex` of the PageView, from user start to swipe
  ///  It will change when user end drag
  final int fromIndex;

  ///  Next `index` is greater than this `index`
  final bool forward;

  ///  User drag is done.
  final bool done;

  ///  Same as [TransformerPageView.viewportFraction]
  final double viewportFraction;

  ///  Copy from [TransformerPageView.scrollDirection]
  final Axis scrollDirection;
}

abstract class PageTransformer {
  PageTransformer({this.reverse = false});

  final bool reverse;

  Widget transform(Widget child, TransformInfo info);
}

class PageTransformerBuilder extends PageTransformer {
  PageTransformerBuilder({bool reverse = false, @required this.builder})
      : assert(builder != null),
        super(reverse: reverse);
  final PageTransformerBuilderCallback builder;

  @override
  Widget transform(Widget child, TransformInfo info) => builder(child, info);
}

class AccordionTransformer extends PageTransformer {
  @override
  Widget transform(Widget child, TransformInfo info) {
    final double position = info.position;
    return position < 0.0
        ? Transform.scale(
            scale: 1 + position, alignment: Alignment.topRight, child: child)
        : Transform.scale(
            scale: 1 - position, alignment: Alignment.bottomLeft, child: child);
  }
}

class ThreeDTransformer extends PageTransformer {
  @override
  Widget transform(Widget child, TransformInfo info) {
    final double position = info.position;
    final double height = info.height;
    final double width = info.width;
    double pivotX = 0.0;
    if (position < 0 && position >= -1) pivotX = width;
    return Transform(
        transform: Matrix4.identity()
          ..rotate(Vector3(0.0, 2.0, 0.0), position * 1.5),
        origin: Offset(pivotX, height / 2),
        child: child);
  }
}

class ZoomInPageTransformer extends PageTransformer {
  @override
  Widget transform(Widget child, TransformInfo info) {
    final double position = info.position;
    final double width = info.width;
    if (position > 0 && position <= 1)
      return Transform.translate(
          offset: Offset(-width * position, 0.0),
          child: Transform.scale(scale: 1 - position, child: child));
    return child;
  }
}

class ZoomOutPageTransformer extends PageTransformer {
  static const double minScale = 0.85;
  static const double minAlpha = 0.5;

  @override
  Widget transform(Widget child, TransformInfo info) {
    final double position = info.position;
    if (position <= 1) {
      final double pageWidth = info.width;
      final double pageHeight = info.height;
      final double scaleFactor = math.max(minScale, 1 - position.abs());
      final double vMargin = pageHeight * (1 - scaleFactor) / 2;
      final double hMargin = pageWidth * (1 - scaleFactor) / 2;
      double dx;
      if (position < 0) {
        dx = hMargin - vMargin / 2;
      } else {
        dx = -hMargin + vMargin / 2;
      }
      final double opacity =
          minAlpha + (scaleFactor - minScale) / (1 - minScale) * (1 - minAlpha);
      return Opacity(
          opacity: opacity,
          child: Transform.translate(
              offset: Offset(dx, 0.0),
              child: Transform.scale(scale: scaleFactor, child: child)));
    }
    return child;
  }
}

class DepthPageTransformer extends PageTransformer {
  DepthPageTransformer() : super(reverse: true);

  @override
  Widget transform(Widget child, TransformInfo info) {
    final double position = info.position;
    if (position <= 0) {
      return Opacity(
          opacity: 1.0,
          child: Transform.translate(
              offset: const Offset(0.0, 0.0),
              child: Transform.scale(scale: 1.0, child: child)));
    } else if (position <= 1) {
      const double minScale = 0.75;
      final double scaleFactor = minScale + (1 - minScale) * (1 - position);
      return Opacity(
          opacity: 1.0 - position,
          child: Transform.translate(
              offset: Offset(info.width * -position, 0.0),
              child: Transform.scale(scale: scaleFactor, child: child)));
    }
    return child;
  }
}

class ScaleAndFadeTransformer extends PageTransformer {
  ScaleAndFadeTransformer({double fade, double scale})
      : _fade = fade ?? 0.3,
        _scale = scale ?? 0.8;
  final double _scale;
  final double _fade;

  @override
  Widget transform(Widget child, TransformInfo info) {
    final double position = info.position;
    final double scaleFactor = (1 - position.abs()) * (1 - _scale);
    final double fadeFactor = (1 - position.abs()) * (1 - _fade);
    final double opacity = _fade + fadeFactor;
    final double scale = _scale + scaleFactor;
    return Opacity(
        opacity: opacity, child: Transform.scale(scale: scale, child: child));
  }
}
///
/// abstract class TransformBuilder<T> {
///   TransformBuilder({this.values});
///
///   List<T> values;
///
///   Widget build(int i, double animationValue, Widget widget);
/// }
///
/// double _getValue(List<double> values, double animationValue, int index) {
///   double s = values[index];
///   if (animationValue >= 0.5) {
///     if (index < values.length - 1)
///       s = s + (values[index + 1] - s) * (animationValue - 0.5) * 2.0;
///   } else {
///     if (index != 0)
///       s = s - (s - values[index - 1]) * (0.5 - animationValue) * 2.0;
///   }
///   return s;
/// }
///
/// class ScaleTransformBuilder extends TransformBuilder<double> {
///   ScaleTransformBuilder(
///       {List<double> values, this.alignment = Alignment.center})
///       : super(values: values);
///
///   final Alignment alignment;
///
///   @override
///   Widget build(int i, double animationValue, Widget widget) {
///     final double s = _getValue(values, animationValue, i);
///     return Transform.scale(scale: s, child: widget);
///   }
/// }
///
/// class OpacityTransformBuilder extends TransformBuilder<double> {
///   OpacityTransformBuilder({List<double> values}) : super(values: values);
///
///   @override
///   Widget build(int i, double animationValue, Widget widget) {
///     final double v = _getValue(values, animationValue, i);
///     return Opacity(opacity: v, child: widget);
///   }
/// }
///
/// class RotateTransformBuilder extends TransformBuilder<double> {
///   RotateTransformBuilder({List<double> values}) : super(values: values);
///
///   @override
///   Widget build(int i, double animationValue, Widget widget) {
///     final double v = _getValue(values, animationValue, i);
///     return Transform.rotate(angle: v, child: widget);
///   }
/// }
///
/// class TranslateTransformBuilder extends TransformBuilder<Offset> {
///   TranslateTransformBuilder({List<Offset> values}) : super(values: values);
///
///   @override
///   Widget build(int i, double animationValue, Widget widget) {
///     final Offset s = _getOffsetValue(values, animationValue, i);
///     return Transform.translate(offset: s, child: widget);
///   }
/// }
///
/// Offset _getOffsetValue(List<Offset> values, double animationValue, int index) {
///   final Offset s = values[index];
///   double dx = s.dx;
///   double dy = s.dy;
///   if (animationValue >= 0.5) {
///     if (index < values.length - 1) {
///       dx = dx + (values[index + 1].dx - dx) * (animationValue - 0.5) * 2.0;
///       dy = dy + (values[index + 1].dy - dy) * (animationValue - 0.5) * 2.0;
///     }
///   } else {
///     if (index != 0) {
///       dx = dx - (dx - values[index - 1].dx) * (0.5 - animationValue) * 2.0;
///       dy = dy - (dy - values[index - 1].dy) * (0.5 - animationValue) * 2.0;
///     }
///   }
///   return Offset(dx, dy);
/// }
