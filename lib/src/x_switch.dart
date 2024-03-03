import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class XSwitch extends StatefulWidget {
  const XSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.trackColor,
    this.thumbColor = Colors.white,
    this.radius = 12.0,
    this.size = const Size(48.0, 24.0),
    this.duration = const Duration(milliseconds: 250),
    this.dragStartBehavior = DragStartBehavior.start,
  });

  /// Whether this switch is on or off.
  /// Must not be null.
  final bool value;

  /// ```dart
  /// XSwitch(
  ///   value: _giveVerse,
  ///   onChanged: (bool newValue) {
  ///     setState(() {
  ///       _giveVerse = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<bool> onChanged;

  /// The color to use for the track when the switch is on.
  final Color? activeColor;

  /// The color to use for the track when the switch is off.
  final Color? trackColor;

  /// The color to use for the thumb of the switch.
  final Color thumbColor;

  /// The radius of the middle circle
  final double radius;

  /// XSwitch size
  final Size size;

  /// animate duration
  final Duration duration;

  /// {@template flutter.cupertino.CupertinoSwitch.dragStartBehavior}
  /// Determines the way that drag start behavior is handled.
  ///
  /// If set to [DragStartBehavior.start], the drag behavior used to move the
  /// switch from on to off will begin at the position where the drag gesture won
  /// the arena. If set to [DragStartBehavior.down] it will begin at the position
  /// where a down event was first detected.
  ///
  /// In general, setting this to [DragStartBehavior.start] will make drag
  /// animation smoother and setting it to [DragStartBehavior.down] will make
  /// drag behavior feel slightly more reactive.
  ///
  /// By default, the drag start behavior is [DragStartBehavior.start].
  ///
  /// See also:
  ///
  ///  * [DragGestureRecognizer.dragStartBehavior], which gives an example for
  ///    the different behaviors.
  ///
  /// {@endtemplate}
  final DragStartBehavior dragStartBehavior;

  @override
  State createState() => _XSwitchState();
}

class _XSwitchState extends State<XSwitch> with TickerProviderStateMixin {
  late TapGestureRecognizer _tap;
  late HorizontalDragGestureRecognizer _drag;
  late AnimationController _positionController;
  late AnimationController _reactionController;
  late Animation<Color?> _color;
  late CurvedAnimation _position;
  late Size trackSize;
  late double radius;
  late double _kTrackWidth;
  late double _kTrackHeight;
  late double _kTrackRadius;
  late double _kTrackInnerStart;
  late double _kTrackInnerEnd;
  late double _kTrackInnerLength;
  bool needsPositionAnimation = false;

  @override
  void initState() {
    super.initState();
    _tap = TapGestureRecognizer()
      ..onTapDown = _handleTapDown
      ..onTap = _handleTap
      ..onTapUp = _handleTapUp
      ..onTapCancel = _handleTapCancel;
    _drag = HorizontalDragGestureRecognizer()
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..dragStartBehavior = widget.dragStartBehavior;
    _positionController = AnimationController(
        duration: widget.duration,
        value: widget.value ? 1.0 : 0.0,
        vsync: this);
    _position =
        CurvedAnimation(parent: _positionController, curve: Curves.bounceOut);
    _reactionController =
        AnimationController(duration: widget.duration, vsync: this);
    initSize();
  }

  void initSize() {
    trackSize = widget.size;
    radius = widget.radius;
    _kTrackWidth = trackSize.width;
    _kTrackHeight = trackSize.height;
    _kTrackRadius = _kTrackHeight / 2.0;
    _kTrackInnerStart = _kTrackHeight / 2.0;
    _kTrackInnerEnd = _kTrackWidth - _kTrackInnerStart;
    _kTrackInnerLength = _kTrackInnerEnd - _kTrackInnerStart;
  }

  void _handleTapDown(TapDownDetails details) {
    needsPositionAnimation = false;
    _reactionController.forward();
  }

  void _handleTap() {
    widget.onChanged(!widget.value);
  }

  void _handleTapUp(TapUpDetails details) {
    needsPositionAnimation = false;
    _reactionController.reverse();
  }

  void _handleTapCancel() {
    _reactionController.reverse();
  }

  void _handleDragStart(DragStartDetails details) {
    needsPositionAnimation = false;
    _reactionController.forward();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final double delta = details.primaryDelta! / _kTrackInnerLength;
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        _positionController.value -= delta;
        break;
      case TextDirection.ltr:
        _positionController.value += delta;
        break;
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() {
      needsPositionAnimation = true;
    });
    if (_position.value >= 0.5) {
      _positionController.forward();
    } else {
      _positionController.reverse();
    }
    _reactionController.reverse();
  }

  @override
  void didUpdateWidget(XSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    _drag.dragStartBehavior = widget.dragStartBehavior;
    initSize();
    if (needsPositionAnimation || oldWidget.value != widget.value) {
      _resumePositionAnimation(isLinear: needsPositionAnimation);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (needsPositionAnimation) {
      _resumePositionAnimation();
    }
    final Color activeColor =
        widget.activeColor ?? Theme.of(context).primaryColor;
    Color trackColor = CupertinoDynamicColor.resolve(
        widget.trackColor ?? CupertinoColors.secondarySystemFill, context);
    _color = ColorTween(begin: trackColor, end: activeColor)
        .animate(_positionController);
    return _XSwitchRenderObjectWidget(
        value: widget.value,
        textDirection: Directionality.of(context),
        activeColor: activeColor,
        onChanged: widget.onChanged,
        thumbColor: widget.thumbColor,
        trackColor: trackColor,
        state: this);
  }

  void _resumePositionAnimation({bool isLinear = true}) {
    _position
      ..curve = isLinear ? Curves.linear : Curves.ease
      ..reverseCurve = isLinear ? Curves.linear : Curves.ease.flipped;
    if (widget.value) {
      _positionController.forward();
    } else {
      _positionController.reverse();
    }
  }

  @override
  void dispose() {
    _tap.dispose();
    _drag.dispose();
    _positionController.dispose();
    _reactionController.dispose();
    super.dispose();
  }
}

class _XSwitchRenderObjectWidget extends LeafRenderObjectWidget {
  const _XSwitchRenderObjectWidget(
      {required this.value,
      required this.activeColor,
      required this.trackColor,
      required this.thumbColor,
      required this.onChanged,
      required this.state,
      required this.textDirection});

  final bool value;
  final Color activeColor;
  final Color trackColor;
  final Color thumbColor;
  final ValueChanged<bool> onChanged;
  final _XSwitchState state;
  final TextDirection textDirection;

  @override
  _RenderXSwitch createRenderObject(BuildContext context) {
    return _RenderXSwitch(
      value: value,
      activeColor: activeColor,
      onChanged: onChanged,
      trackColor: trackColor,
      thumbColor: thumbColor,
      textDirection: textDirection,
      state: state,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderXSwitch renderObject) {
    renderObject
      ..value = value
      ..activeColor = activeColor
      ..trackColor = trackColor
      ..onChanged = onChanged
      ..thumbColor = thumbColor
      ..textDirection = textDirection;
  }
}

class _RenderXSwitch extends RenderConstrainedBox {
  _RenderXSwitch({
    required bool value,
    required Color activeColor,
    required Color trackColor,
    required Color thumbColor,
    required ValueChanged<bool> onChanged,
    required TextDirection textDirection,
    required _XSwitchState state,
  })  : _value = value,
        _state = state,
        _activeColor = activeColor,
        _trackColor = trackColor,
        _onChanged = onChanged,
        _textDirection = textDirection,
        _thumbColor = thumbColor,
        _thumbPainter = _XThumbPainter(color: thumbColor),
        super(
            additionalConstraints: BoxConstraints.tightFor(
                width: state.trackSize.width, height: state.trackSize.height)) {
    _state._position
      ..addListener(markNeedsPaint)
      ..addStatusListener(_handlePositionStateChanged);
  }

  final _XSwitchState _state;

  Color _thumbColor;

  set thumbColor(Color value) {
    if (value == _thumbColor) return;
    _thumbColor = value;
    markNeedsPaint();
  }

  bool _value;

  set value(bool value) {
    if (value == _value) return;
    _value = value;
    markNeedsSemanticsUpdate();
    _state._position
      ..curve = Curves.bounceOut
      ..reverseCurve = Curves.bounceOut.flipped;
    if (value) {
      _state._positionController.forward();
    } else {
      _state._positionController.reverse();
    }
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
      _state._positionController.forward();
    } else {
      _state._positionController.reverse();
    }
    switch (_state._reactionController.status) {
      case AnimationStatus.forward:
        _state._reactionController.forward();
        break;
      case AnimationStatus.reverse:
        _state._reactionController.reverse();
        break;
      case AnimationStatus.dismissed:
      case AnimationStatus.completed:
        break;
    }
  }

  @override
  void detach() {
    _state._positionController.stop();
    _state._reactionController.stop();
    super.detach();
  }

  void _handlePositionStateChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_value) {
      _onChanged(true);
    } else if (status == AnimationStatus.dismissed && _value) {
      _onChanged(false);
    }
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent) {
      _state._drag.addPointer(event);
      _state._tap.addPointer(event);
    }
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.onTap = _state._handleTap;
    config.isEnabled = true;
    config.isToggled = _value;
  }

  final _XThumbPainter _thumbPainter;

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    final double currentValue = _state._position.value;
    late double visualPosition;
    switch (_textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - currentValue;
        break;
      case TextDirection.ltr:
        visualPosition = currentValue;
        break;
    }

    double borderThickness = 1.5 + (_state._kTrackRadius - 1.5) * 1.0;

    final Paint paint = Paint()..color = _state._color.value!;

    final Rect trackRect = Rect.fromLTWH(
        offset.dx + (size.width - _state._kTrackWidth) / 2.0,
        offset.dy + (size.height - _state._kTrackHeight) / 2.0,
        _state._kTrackWidth,
        _state._kTrackHeight);
    final RRect outerRRect = RRect.fromRectAndRadius(
        trackRect, Radius.circular(_state._kTrackRadius));
    final RRect innerRRect = RRect.fromRectAndRadius(
        trackRect.deflate(borderThickness),
        Radius.circular(_state._kTrackRadius));
    canvas.drawDRRect(outerRRect, innerRRect, paint);

    final double thumbLeft = lerpDouble(
      trackRect.left + _state._kTrackInnerStart - _state.radius,
      trackRect.left + _state._kTrackInnerEnd - _state.radius,
      visualPosition,
    )!;
    final double thumbRight = lerpDouble(
      trackRect.left + _state._kTrackInnerStart + _state.radius,
      trackRect.left + _state._kTrackInnerEnd + _state.radius,
      visualPosition,
    )!;
    final double thumbCenterY = offset.dy + size.height / 2.0;
    _thumbPainter.paint(
        canvas,
        Rect.fromLTRB(
            thumbLeft + (currentValue / 2).abs() * 8.0,
            thumbCenterY - _state.radius,
            thumbRight - (currentValue / 2).abs() * 8.0,
            thumbCenterY + _state.radius));
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
