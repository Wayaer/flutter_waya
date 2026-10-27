import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_waya/src/extended_state.dart';

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

class _XSwitchState extends ExtendedState<XSwitch>
    with TickerProviderStateMixin {
  late TapGestureRecognizer tap;
  late HorizontalDragGestureRecognizer drag;
  late AnimationController positionController;
  late AnimationController reactionController;
  late Animation<Color?> color;
  late CurvedAnimation position;
  late Size trackSize;
  late double radius;
  late double kTrackWidth;
  late double kTrackHeight;
  late double kTrackRadius;
  late double kTrackInnerStart;
  late double kTrackInnerEnd;
  late double kTrackInnerLength;
  bool needsPositionAnimation = false;

  @override
  void initState() {
    super.initState();
    tap = TapGestureRecognizer()
      ..onTapDown = handleTapDown
      ..onTap = handleTap
      ..onTapUp = handleTapUp
      ..onTapCancel = handleTapCancel;
    drag = HorizontalDragGestureRecognizer()
      ..onStart = handleDragStart
      ..onUpdate = handleDragUpdate
      ..onEnd = handleDragEnd
      ..dragStartBehavior = widget.dragStartBehavior;
    positionController = AnimationController(
        duration: widget.duration,
        value: widget.value ? 1.0 : 0.0,
        vsync: this);
    position =
        CurvedAnimation(parent: positionController, curve: Curves.bounceOut);
    reactionController =
        AnimationController(duration: widget.duration, vsync: this);
    initSize();
  }

  void initSize() {
    trackSize = widget.size;
    radius = widget.radius;
    kTrackWidth = trackSize.width;
    kTrackHeight = trackSize.height;
    kTrackRadius = kTrackHeight / 2.0;
    kTrackInnerStart = kTrackHeight / 2.0;
    kTrackInnerEnd = kTrackWidth - kTrackInnerStart;
    kTrackInnerLength = kTrackInnerEnd - kTrackInnerStart;
  }

  void handleTapDown(TapDownDetails details) {
    needsPositionAnimation = false;
    reactionController.forward();
  }

  void handleTap() {
    widget.onChanged(!widget.value);
  }

  void handleTapUp(TapUpDetails details) {
    needsPositionAnimation = false;
    reactionController.reverse();
  }

  void handleTapCancel() {
    reactionController.reverse();
  }

  void handleDragStart(DragStartDetails details) {
    needsPositionAnimation = false;
    reactionController.forward();
  }

  void handleDragUpdate(DragUpdateDetails details) {
    final double delta = details.primaryDelta! / kTrackInnerLength;
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        positionController.value -= delta;
        break;
      case TextDirection.ltr:
        positionController.value += delta;
        break;
    }
  }

  void handleDragEnd(DragEndDetails details) {
    if (mounted) {
      setState(() {
        needsPositionAnimation = true;
      });
    }
    if (position.value >= 0.5) {
      positionController.forward();
    } else {
      positionController.reverse();
    }
    reactionController.reverse();
  }

  @override
  void didUpdateWidget(XSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    drag.dragStartBehavior = widget.dragStartBehavior;
    initSize();
    if (needsPositionAnimation || oldWidget.value != widget.value) {
      resumePositionAnimation(isLinear: needsPositionAnimation);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (needsPositionAnimation) {
      resumePositionAnimation();
    }
    final Color activeColor =
        widget.activeColor ?? Theme.of(context).primaryColor;
    Color trackColor = CupertinoDynamicColor.resolve(
        widget.trackColor ?? CupertinoColors.secondarySystemFill, context);
    color = ColorTween(begin: trackColor, end: activeColor)
        .animate(positionController);
    return _XSwitchRenderObjectWidget(
        value: widget.value,
        textDirection: Directionality.of(context),
        activeColor: activeColor,
        onChanged: widget.onChanged,
        thumbColor: widget.thumbColor,
        trackColor: trackColor,
        state: this);
  }

  void resumePositionAnimation({bool isLinear = true}) {
    position
      ..curve = isLinear ? Curves.linear : Curves.ease
      ..reverseCurve = isLinear ? Curves.linear : Curves.ease.flipped;
    if (widget.value) {
      positionController.forward();
    } else {
      positionController.reverse();
    }
  }

  @override
  void dispose() {
    tap.dispose();
    drag.dispose();
    positionController.dispose();
    reactionController.dispose();
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
    _state.position
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
    _state.position
      ..curve = Curves.bounceOut
      ..reverseCurve = Curves.bounceOut.flipped;
    if (value) {
      _state.positionController.forward();
    } else {
      _state.positionController.reverse();
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
      _state.positionController.forward();
    } else {
      _state.positionController.reverse();
    }
    switch (_state.reactionController.status) {
      case AnimationStatus.forward:
        _state.reactionController.forward();
        break;
      case AnimationStatus.reverse:
        _state.reactionController.reverse();
        break;
      case AnimationStatus.dismissed:
      case AnimationStatus.completed:
        break;
    }
  }

  @override
  void detach() {
    _state.positionController.stop();
    _state.reactionController.stop();
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
      _state.drag.addPointer(event);
      _state.tap.addPointer(event);
    }
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.onTap = _state.handleTap;
    config.isEnabled = true;
    config.isToggled = _value;
  }

  final _XThumbPainter _thumbPainter;

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    final double currentValue = _state.position.value;
    late double visualPosition;
    switch (_textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - currentValue;
        break;
      case TextDirection.ltr:
        visualPosition = currentValue;
        break;
    }

    double borderThickness = 1.5 + (_state.kTrackRadius - 1.5) * 1.0;

    final Paint paint = Paint()..color = _state.color.value!;

    final Rect trackRect = Rect.fromLTWH(
        offset.dx + (size.width - _state.kTrackWidth) / 2.0,
        offset.dy + (size.height - _state.kTrackHeight) / 2.0,
        _state.kTrackWidth,
        _state.kTrackHeight);
    final RRect outerRRect = RRect.fromRectAndRadius(
        trackRect, Radius.circular(_state.kTrackRadius));
    final RRect innerRRect = RRect.fromRectAndRadius(
        trackRect.deflate(borderThickness),
        Radius.circular(_state.kTrackRadius));
    canvas.drawDRRect(outerRRect, innerRRect, paint);

    final double thumbLeft = lerpDouble(
      trackRect.left + _state.kTrackInnerStart - _state.radius,
      trackRect.left + _state.kTrackInnerEnd - _state.radius,
      visualPosition,
    )!;
    final double thumbRight = lerpDouble(
      trackRect.left + _state.kTrackInnerStart + _state.radius,
      trackRect.left + _state.kTrackInnerEnd + _state.radius,
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
