// 私有字段无法在命名参数上使用 initializing formal（命名参数不能以下划线开头）
// ignore_for_file: prefer_initializing_formals
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_waya/src/core/extended_state.dart';

/// 自定义开关组件，支持点击、拖拽切换与颜色、尺寸配置。
class FlSwitch extends StatefulWidget {
  const FlSwitch({
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

  /// 开关是否打开，必填。
  final bool value;

  /// 开关状态变化回调，参数为切换后的新值。
  final ValueChanged<bool> onChanged;

  /// 打开时的轨道颜色，默认取主题 primaryColor。
  final Color? activeColor;

  /// 关闭时的轨道颜色，默认取 secondarySystemFill。
  final Color? trackColor;

  /// 滑块颜色，默认白色。
  final Color thumbColor;

  /// 滑块半径，默认 12.0。
  final double radius;

  /// 开关整体尺寸，默认 Size(48.0, 24.0)。
  final Size size;

  /// 状态切换动画时长，默认 250 毫秒。
  final Duration duration;

  /// 拖拽起始行为的判定方式，默认 DragStartBehavior.start。
  final DragStartBehavior dragStartBehavior;

  @override
  State createState() => _SwitchState();
}

class _SwitchState extends FlExtendedState<FlSwitch> with TickerProviderStateMixin {
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
    positionController = AnimationController(duration: widget.duration, value: widget.value ? 1.0 : 0.0, vsync: this);
    position = CurvedAnimation(parent: positionController, curve: Curves.bounceOut);
    reactionController = AnimationController(duration: widget.duration, vsync: this);
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

  /// 渲染对象使用的轨道尺寸约束。
  BoxConstraints get trackConstraints => BoxConstraints.tightFor(width: trackSize.width, height: trackSize.height);

  void handleTapDown(TapDownDetails details) => reactionController.forward();

  void handleTap() {
    widget.onChanged(!widget.value);
  }

  void handleTapUp(TapUpDetails details) => reactionController.reverse();

  void handleTapCancel() {
    reactionController.reverse();
  }

  void handleDragStart(DragStartDetails details) {
    final double visualValue = position.value;
    positionController
      ..stop()
      ..value = visualValue;
    position
      ..curve = Curves.linear
      ..reverseCurve = Curves.linear;
    reactionController.forward();
  }

  void handleDragUpdate(DragUpdateDetails details) {
    final double delta = kTrackInnerLength == 0 ? 0 : details.primaryDelta! / kTrackInnerLength;
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
    if (positionController.value >= 0.5) {
      positionController.forward();
    } else {
      positionController.reverse();
    }
    reactionController.reverse();
  }

  @override
  void didUpdateWidget(FlSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    drag.dragStartBehavior = widget.dragStartBehavior;
    initSize();
  }

  @override
  Widget build(BuildContext context) {
    final Color activeColor = widget.activeColor ?? Theme.of(context).primaryColor;
    Color trackColor = CupertinoDynamicColor.resolve(widget.trackColor ?? CupertinoColors.secondarySystemFill, context);
    color = ColorTween(begin: trackColor, end: activeColor).animate(positionController);
    return _SwitchRenderObjectWidget(
      value: widget.value,
      textDirection: Directionality.of(context),
      activeColor: activeColor,
      onChanged: widget.onChanged,
      thumbColor: widget.thumbColor,
      trackColor: trackColor,
      state: this,
    );
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

class _SwitchRenderObjectWidget extends LeafRenderObjectWidget {
  const _SwitchRenderObjectWidget({
    required this.value,
    required this.activeColor,
    required this.trackColor,
    required this.thumbColor,
    required this.onChanged,
    required this.state,
    required this.textDirection,
  });

  final bool value;
  final Color activeColor;
  final Color trackColor;
  final Color thumbColor;
  final ValueChanged<bool> onChanged;
  final _SwitchState state;
  final TextDirection textDirection;

  @override
  _RenderSwitch createRenderObject(BuildContext context) {
    return _RenderSwitch(
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
  void updateRenderObject(BuildContext context, _RenderSwitch renderObject) {
    renderObject
      ..additionalConstraints = state.trackConstraints
      ..value = value
      ..activeColor = activeColor
      ..trackColor = trackColor
      ..onChanged = onChanged
      ..thumbColor = thumbColor
      ..textDirection = textDirection;
  }
}

class _RenderSwitch extends RenderConstrainedBox {
  _RenderSwitch({
    required bool value,
    required Color activeColor,
    required Color trackColor,
    required Color thumbColor,
    required ValueChanged<bool> onChanged,
    required TextDirection textDirection,
    required _SwitchState state,
  }) : _value = value,
       _state = state,
       _activeColor = activeColor,
       _trackColor = trackColor,
       _onChanged = onChanged,
       _textDirection = textDirection,
       _thumbColor = thumbColor,
       _thumbPainter = _XThumbPainter(color: thumbColor),
       super(additionalConstraints: state.trackConstraints) {
    _state.position
      ..addListener(markNeedsPaint)
      ..addStatusListener(_handlePositionStateChanged);
  }

  final _SwitchState _state;

  Color _thumbColor;

  set thumbColor(Color value) {
    if (value == _thumbColor) return;
    _thumbColor = value;
    _thumbPainter = _XThumbPainter(color: value);
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

  @override
  void dispose() {
    _state.position
      ..removeListener(markNeedsPaint)
      ..removeStatusListener(_handlePositionStateChanged);
    super.dispose();
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

  _XThumbPainter _thumbPainter;

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
      _state.kTrackHeight,
    );
    final RRect outerRRect = RRect.fromRectAndRadius(trackRect, Radius.circular(_state.kTrackRadius));
    final RRect innerRRect = RRect.fromRectAndRadius(
      trackRect.deflate(borderThickness),
      Radius.circular(_state.kTrackRadius),
    );
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
        thumbCenterY + _state.radius,
      ),
    );
  }
}

class _XThumbPainter {
  _XThumbPainter({required this.color, this.shadowColor = const Color(0x00FFFFFF)})
    : shadowPaint = BoxShadow(color: shadowColor, blurRadius: 1.0).toPaint();

  final Color color;

  final Color shadowColor;

  final Paint shadowPaint;

  void paint(Canvas canvas, Rect rect) {
    final double unit = rect.shortestSide / 24.0;
    final RRect parent = RRect.fromRectAndRadius(rect.deflate(4.0 * unit), Radius.circular(rect.shortestSide / 2.0));

    final RRect childRect = RRect.fromRectAndRadius(
      rect.deflate(10.0 * unit),
      Radius.circular(rect.shortestSide / 2.0),
    );

    canvas.drawDRRect(parent, childRect, shadowPaint);
    canvas.drawDRRect(parent.shift(const Offset(0.0, 3.0)), childRect.shift(const Offset(0.0, 3.0)), shadowPaint);
    canvas.drawDRRect(
      RRect.fromLTRBR(parent.left, parent.top, parent.right, parent.bottom, Radius.circular(rect.shortestSide / 2.0)),
      childRect,
      Paint()..color = color,
    );
  }
}
