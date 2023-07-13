import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class XSwitch extends StatefulWidget {
  const XSwitch(
      {Key? key,
      required this.value,
      required this.onChanged,
      this.activeColor,
      this.trackColor = Colors.black54,
      this.thumbColor = CupertinoColors.white,
      this.radius = 14.0,
      this.size = const Size(51.0, 30.0),
      this.animateDuration = const Duration(milliseconds: 250)})
      : super(key: key);

  final bool value;

  final ValueChanged<bool> onChanged;

  final Color? activeColor;

  final Color trackColor;

  final Color thumbColor;

  final double radius;

  final Size size;

  final Duration animateDuration;

  @override
  State createState() => _XSwitchState();
}

class _XSwitchState extends State<XSwitch> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return _XSwitchRenderObjectWidget(
        value: widget.value,
        radius: widget.radius,
        size: widget.size,
        animateDuration: widget.animateDuration,
        activeColor: widget.activeColor ?? Theme.of(context).primaryColor,
        onChanged: widget.onChanged,
        thumbColor: widget.thumbColor,
        trackColor: widget.trackColor,
        key: const Key('key'),
        vsync: this);
  }
}

class _XSwitchRenderObjectWidget extends LeafRenderObjectWidget {
  const _XSwitchRenderObjectWidget(
      {super.key,
      required this.value,
      required this.activeColor,
      required this.trackColor,
      required this.thumbColor,
      required this.onChanged,
      required this.vsync,
      required this.radius,
      required this.size,
      required this.animateDuration});

  final double radius;
  final Size size;
  final Duration animateDuration;
  final bool value;
  final Color activeColor;
  final Color trackColor;
  final Color thumbColor;
  final ValueChanged<bool> onChanged;
  final TickerProvider vsync;

  @override
  _RenderXSwitch createRenderObject(BuildContext context) {
    return _RenderXSwitch(
        value: value,
        activeColor: activeColor,
        onChanged: onChanged,
        trackColor: trackColor,
        thumbColor: thumbColor,
        textDirection: Directionality.of(context),
        vsync: vsync,
        radius: radius,
        trackSize: size,
        animateDuration: animateDuration);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderXSwitch renderObject) {
    renderObject
      ..value = value
      ..activeColor = activeColor
      ..trackColor = trackColor
      ..onChanged = onChanged
      ..thumbColor = thumbColor
      ..textDirection = Directionality.of(context)
      ..vsync = vsync
      ..radius = radius
      ..trackSize = size;
  }
}

class _RenderXSwitch extends RenderConstrainedBox {
  _RenderXSwitch(
      {required bool value,
      required Color activeColor,
      required Color trackColor,
      required Color thumbColor,
      required ValueChanged<bool> onChanged,
      required TextDirection textDirection,
      required TickerProvider vsync,
      required this.radius,
      required this.trackSize,
      required Duration animateDuration})
      : _value = value,
        _activeColor = activeColor,
        _trackColor = trackColor,
        _onChanged = onChanged,
        _textDirection = textDirection,
        _thumbColor = thumbColor,
        _thumbPainter = _XThumbPainter(color: thumbColor),
        _vsync = vsync,
        super(
            additionalConstraints: BoxConstraints.tightFor(
                width: trackSize.width, height: trackSize.height)) {
    _tap = TapGestureRecognizer()
      ..onTapDown = _handleTapDown
      ..onTap = _handleTap
      ..onTapUp = _handleTapUp
      ..onTapCancel = _handleTapCancel;
    _drag = HorizontalDragGestureRecognizer()
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd;
    _positionController = AnimationController(
        duration: animateDuration, value: value ? 1.0 : 0.0, vsync: vsync);
    _position =
        CurvedAnimation(parent: _positionController, curve: Curves.bounceOut)
          ..addListener(markNeedsPaint)
          ..addStatusListener(_handlePositionStateChanged);
    _reactionController =
        AnimationController(duration: animateDuration, vsync: vsync);

    _color = ColorTween(begin: _trackColor, end: _activeColor)
        .animate(_positionController);
    _kTrackWidth = trackSize.width;
    _kTrackHeight = trackSize.height;
    _kTrackRadius = _kTrackHeight / 2.0;
    _kTrackInnerStart = _kTrackHeight / 2.0;
    _kTrackInnerEnd = _kTrackWidth - _kTrackInnerStart;
    _kTrackInnerLength = _kTrackInnerEnd - _kTrackInnerStart;
  }

  late double _kTrackWidth;
  late double _kTrackHeight;
  late double _kTrackRadius;
  late double _kTrackInnerStart;
  late double _kTrackInnerEnd;
  late double _kTrackInnerLength;
  late Size trackSize;
  late double radius;
  late TapGestureRecognizer _tap;
  late HorizontalDragGestureRecognizer _drag;
  late AnimationController _positionController;
  late AnimationController _reactionController;

  late Animation<Color?> _color;

  Color _thumbColor;

  set thumbColor(Color value) {
    if (value == _thumbColor) return;
    _thumbColor = value;
    markNeedsPaint();
  }

  CurvedAnimation? _position;
  bool _value;

  set value(bool value) {
    if (value == _value) return;
    _value = value;
    markNeedsSemanticsUpdate();
    _position
      ?..curve = Curves.bounceOut
      ..reverseCurve = Curves.bounceOut.flipped;
    if (value) {
      _positionController.forward();
    } else {
      _positionController.reverse();
    }
  }

  TickerProvider _vsync;

  set vsync(TickerProvider value) {
    if (value == _vsync) return;
    _vsync = value;
    _positionController.resync(_vsync);
    _reactionController.resync(_vsync);
  }

  Color _activeColor;
  Color _trackColor;

  set activeColor(Color value) {
    if (value == _activeColor) return;
    _activeColor = value;
    markNeedsPaint();
  }

  set trackColor(Color value) {
    if (value == _trackColor) return;
    _trackColor = value;
    markNeedsPaint();
  }

  ValueChanged<bool> _onChanged;

  set onChanged(ValueChanged<bool> value) {
    if (value == _onChanged) return;
    _onChanged = value;
  }

  TextDirection _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (_value) {
      _positionController.forward();
    } else {
      _positionController.reverse();
    }
    switch (_reactionController.status) {
      case AnimationStatus.forward:
        _reactionController.forward();
        break;
      case AnimationStatus.reverse:
        _reactionController.reverse();
        break;
      case AnimationStatus.dismissed:
      case AnimationStatus.completed:
        break;
    }
  }

  @override
  void detach() {
    _positionController.stop();
    _reactionController.stop();
    super.detach();
  }

  void _handlePositionStateChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_value) {
      _onChanged(true);
    } else if (status == AnimationStatus.dismissed && _value) {
      _onChanged(false);
    }
  }

  void _handleTapDown(TapDownDetails details) {
    _reactionController.forward();
  }

  void _handleTap() {
    _onChanged(!_value);
  }

  void _handleTapUp(TapUpDetails details) {
    _reactionController.reverse();
  }

  void _handleTapCancel() {
    _reactionController.reverse();
  }

  void _handleDragStart(DragStartDetails details) {
    _reactionController.forward();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final double delta = details.primaryDelta! / _kTrackInnerLength;
    switch (_textDirection) {
      case TextDirection.rtl:
        _positionController.value -= delta;
        break;
      case TextDirection.ltr:
        _positionController.value += delta;
        break;
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_position!.value >= 0.5) {
      _positionController.forward();
    } else {
      _positionController.reverse();
    }
    _reactionController.reverse();
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent) {
      _drag.addPointer(event);
      _tap.addPointer(event);
    }
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.onTap = _handleTap;
    config.isEnabled = true;
    config.isToggled = _value;
  }

  final _XThumbPainter _thumbPainter;

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;

    final double currentValue = _position!.value;

    late double visualPosition;
    switch (_textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - currentValue;
        break;
      case TextDirection.ltr:
        visualPosition = currentValue;
        break;
    }

    final trackColor = _color.value!;
    double borderThickness = 1.5 + (_kTrackRadius - 1.5) * 1.0;

    final Paint paint = Paint()..color = trackColor;

    final Rect trackRect = Rect.fromLTWH(
        offset.dx + (size.width - _kTrackWidth) / 2.0,
        offset.dy + (size.height - _kTrackHeight) / 2.0,
        _kTrackWidth,
        _kTrackHeight);
    final RRect outerRRect =
        RRect.fromRectAndRadius(trackRect, Radius.circular(_kTrackRadius));
    final RRect innerRRect = RRect.fromRectAndRadius(
        trackRect.deflate(borderThickness), Radius.circular(_kTrackRadius));
    canvas.drawDRRect(outerRRect, innerRRect, paint);

    final double thumbLeft = lerpDouble(
      trackRect.left + _kTrackInnerStart - radius,
      trackRect.left + _kTrackInnerEnd - radius,
      visualPosition,
    )!;
    final double thumbRight = lerpDouble(
      trackRect.left + _kTrackInnerStart + radius,
      trackRect.left + _kTrackInnerEnd + radius,
      visualPosition,
    )!;
    final double thumbCenterY = offset.dy + size.height / 2.0;

    _thumbPainter.paint(
        canvas,
        Rect.fromLTRB(
            thumbLeft + (currentValue / 2).abs() * 8.0,
            thumbCenterY - radius,
            thumbRight - (currentValue / 2).abs() * 8.0,
            thumbCenterY + radius));
  }
}

class _XThumbPainter {
  _XThumbPainter({
    required this.color,
    this.shadowColor = const Color(0x00FFFFFF),
  }) : shadowPaint = BoxShadow(color: shadowColor, blurRadius: 1.0).toPaint();

  final Color color;

  final Color shadowColor;

  final Paint shadowPaint;

  void paint(Canvas canvas, Rect rect) {
    final RRect parent = RRect.fromRectAndRadius(
        rect.deflate(4.0), Radius.circular(rect.shortestSide / 2.0));

    final RRect childRect = RRect.fromRectAndRadius(
        rect.deflate(10.0), Radius.circular(rect.shortestSide / 2.0));

    canvas.drawDRRect(parent, childRect, shadowPaint);
    canvas.drawDRRect(parent.shift(const Offset(0.0, 3.0)),
        childRect.shift(const Offset(0.0, 3.0)), shadowPaint);
    canvas.drawDRRect(
        RRect.fromLTRBR(parent.left, parent.top, parent.right, parent.bottom,
            Radius.circular(rect.shortestSide / 2.0)),
        childRect,
        Paint()..color = color);
  }
}
