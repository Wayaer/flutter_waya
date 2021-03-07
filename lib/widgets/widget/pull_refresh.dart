import 'dart:async';
import 'dart:math';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

const double _kDragContainerExtentPercentage = 0.25;

const double _kDragSizeFactorLimit = 1.5;

const Duration _kIndicatorScaleDuration = Duration(milliseconds: 200);

typedef RefreshCallback = Future<void> Function();

enum _PullRefreshMode {
  drag, // Pointer is down.
  armed, // Dragged far enough that an up event will run the onRefresh callback.
  snap, // Animating to the indicator's final "displacement".
  refresh, // Running the refresh callback.
  done, // Animating the indicator's fade-out after refreshing.
  canceled, // Animating the indicator's fade-out after not arming.
}

class PullRefresh extends StatefulWidget {
  const PullRefresh({
    Key? key,
    this.animSpeedFactor = 1.0,
    required this.child,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
    this.height = 100,
    this.springAnimationDurationInMilliseconds = 1000,
    this.borderWidth = 2.0,
    this.showChildOpacityTransition = true,
  })  : assert(animSpeedFactor >= 1.0),
        super(key: key);

  /// Typically a [ListView] or [CustomScrollView].
  final Widget child;

  /// default is set to 100.0
  final double height;

  /// default to 1000
  final int springAnimationDurationInMilliseconds;

  /// To regulate the "speed of the animation" towards the end.
  /// To hasten it give a value > 1.0 and vice versa.
  ///
  /// default to 1.0
  final double animSpeedFactor;

  /// Border width of progressing circle in Progressing Indicator
  ///
  /// default to 2.0
  final double borderWidth;

  /// Whether to show child opacity transition or not.
  ///
  /// default to true
  final bool showChildOpacityTransition;

  /// A function that's called when the user has dragged the progress indicator
  /// far enough to demonstrate that they want the app to refresh. The returned
  /// [Future] must complete when the refresh operation is finished.
  final RefreshCallback onRefresh;

  /// The progress indicator's foreground color. The current theme's
  /// [ThemeData.accentColor] by default.
  final Color? color;

  /// The progress indicator's background color. The current theme's
  /// [ThemeData.canvasColor] by default.
  final Color? backgroundColor;

  @override
  PullRefreshState createState() => PullRefreshState();
}

class PullRefreshState extends State<PullRefresh>
    with TickerProviderStateMixin<PullRefresh> {
  late AnimationController _springController;
  late Animation<double> _springAnimation;

  late AnimationController _progressingController;
  late Animation<double> _progressingRotateAnimation;
  late Animation<double> _progressingPercentAnimation;
  late Animation<double> _progressingStartAngleAnimation;

  late AnimationController _ringDisappearController;
  late Animation<double> _ringRadiusAnimation;
  late Animation<double> _ringOpacityAnimation;

  late AnimationController _showPeakController;
  late Animation<double> _peakHeightUpAnimation;
  late Animation<double> _peakHeightDownAnimation;

  late AnimationController _indicatorMoveWithPeakController;
  late Animation<double> _indicatorTranslateWithPeakAnimation;
  late Animation<double> _indicatorRadiusWithPeakAnimation;

  late AnimationController _indicatorTranslateInOutController;
  late Animation<double> _indicatorTranslateAnimation;

  late AnimationController _radiusController;
  late Animation<double> _radiusAnimation;

  late Animation<double> _childOpacityAnimation;

  late AnimationController _positionController;
  late Animation<double> _value;
  late Animation<Color> _valueColor;

  _PullRefreshMode? _mode;
  Future<void>? _pendingRefreshFuture;
  bool? _isIndicatorAtTop;
  late double _dragOffset;

  static final Animatable<double> _threeQuarterTween =
      Tween<double>(begin: 0.0, end: 0.75);
  static final Animatable<double> _oneToZeroTween =
      Tween<double>(begin: 1.0, end: 0.0);

  @override
  void initState() {
    super.initState();
    _springController = AnimationController(vsync: this);
    _springAnimation =
        _springController.drive(Tween<double>(begin: 1.0, end: -1.0));

    _progressingController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _progressingRotateAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _progressingController,
      curve: const Interval(0.0, 1.0),
    ));
    _progressingPercentAnimation =
        Tween<double>(begin: 0.25, end: 5 / 6).animate(CurvedAnimation(
      parent: _progressingController,
      curve: Interval(0.0, 1.0, curve: ProgressRingCurve()),
    ));
    _progressingStartAngleAnimation =
        Tween<double>(begin: -2 / 3, end: 1 / 2).animate(CurvedAnimation(
      parent: _progressingController,
      curve: const Interval(0.5, 1.0),
    ));

    _ringDisappearController = AnimationController(vsync: this);
    _ringRadiusAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
        CurvedAnimation(
            parent: _ringDisappearController,
            curve: const Interval(0.0, 0.2, curve: Curves.easeOut)));
    _ringOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _ringDisappearController,
            curve: const Interval(0.0, 0.2, curve: Curves.easeIn)));

    _showPeakController = AnimationController(vsync: this);
    _peakHeightUpAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _showPeakController,
            curve: const Interval(0.1, 0.2, curve: Curves.easeOut)));
    _peakHeightDownAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _showPeakController,
            curve: const Interval(0.2, 0.3, curve: Curves.easeIn)));

    _indicatorMoveWithPeakController = AnimationController(vsync: this);
    _indicatorTranslateWithPeakAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: _indicatorMoveWithPeakController,
            curve: const Interval(0.1, 0.2, curve: Curves.easeOut)));
    _indicatorRadiusWithPeakAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: _indicatorMoveWithPeakController,
            curve: const Interval(0.1, 0.2, curve: Curves.easeOut)));

    _indicatorTranslateInOutController = AnimationController(vsync: this);
    _indicatorTranslateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _indicatorTranslateInOutController,
            curve: const Interval(0.2, 0.6, curve: Curves.easeOut)));

    _radiusController = AnimationController(vsync: this);
    _radiusAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _radiusController, curve: Curves.easeIn));

    _positionController = AnimationController(vsync: this);
    _value = _positionController.drive(_threeQuarterTween);

    _childOpacityAnimation = _positionController.drive(_oneToZeroTween);
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    final ColorTween colorTween = ColorTween(
        begin: (widget.color ?? theme.accentColor).withOpacity(0.0),
        end: (widget.color ?? theme.accentColor).withOpacity(1.0));
    final CurveTween curveTween =
        CurveTween(curve: const Interval(0.0, 1.0 / _kDragSizeFactorLimit));
    colorTween.chain(curveTween);
    _valueColor = _positionController.drive(colorTween as Animatable<Color>);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _springController.dispose();
    _progressingController.dispose();
    _positionController.dispose();
    _ringDisappearController.dispose();
    _showPeakController.dispose();
    _indicatorMoveWithPeakController.dispose();
    _indicatorTranslateInOutController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification &&
        notification.metrics.extentBefore == 0.0 &&
        _mode == null &&
        _start(notification.metrics.axisDirection)) {
      _mode = _PullRefreshMode.drag;
      setState(() {});
      return false;
    }
    bool? indicatorAtTopNow;
    switch (notification.metrics.axisDirection) {
      case AxisDirection.down:
        indicatorAtTopNow = true;
        break;
      case AxisDirection.up:
        indicatorAtTopNow = false;
        break;
      case AxisDirection.left:
      case AxisDirection.right:
        indicatorAtTopNow = null;
        break;
    }
    if (indicatorAtTopNow != _isIndicatorAtTop) {
      if (_mode == _PullRefreshMode.drag || _mode == _PullRefreshMode.armed)
        _dismiss(_PullRefreshMode.canceled);
    } else if (notification is ScrollUpdateNotification) {
      if (_mode == _PullRefreshMode.drag || _mode == _PullRefreshMode.armed) {
        if (notification.metrics.extentBefore > 0.0) {
          _dismiss(_PullRefreshMode.canceled);
        } else {
          _dragOffset -= notification.scrollDelta!;
          _checkDragOffset(notification.metrics.viewportDimension);
        }
      }
      if (_mode == _PullRefreshMode.armed && notification.dragDetails == null) {
        // On iOS start the refresh when the Scrollable bounces back from the
        // OverScroll (ScrollNotification indicating this don't have dragDetails
        // because the scroll activity is not directly triggered by a drag).
        _show();
      }
    } else if (notification is OverscrollNotification) {
      if (_mode == _PullRefreshMode.drag || _mode == _PullRefreshMode.armed) {
        _dragOffset -= notification.overscroll / 2.0;
        _checkDragOffset(notification.metrics.viewportDimension);
      }
    } else if (notification is ScrollEndNotification) {
      switch (_mode) {
        case _PullRefreshMode.armed:
          _show();
          break;
        case _PullRefreshMode.drag:
          _dismiss(_PullRefreshMode.canceled);
          break;
        default:
          break;
      }
    }
    return false;
  }

  bool _handleGlowNotification(OverscrollIndicatorNotification notification) {
    if (notification.depth != 0 || !notification.leading) return false;
    if (_mode == _PullRefreshMode.drag) {
      notification.disallowGlow();
      return true;
    }
    return false;
  }

  Future<void> _dismiss(_PullRefreshMode newMode) async {
    await Future<void>.value();

    assert(newMode == _PullRefreshMode.canceled ||
        newMode == _PullRefreshMode.done);
    _mode = newMode;
    setState(() {});
    switch (_mode) {
      case _PullRefreshMode.done:
        _progressingController.stop();

        _ringDisappearController.animateTo(1.0,
            duration: Duration(
                milliseconds: (widget.springAnimationDurationInMilliseconds /
                        widget.animSpeedFactor)
                    .round()),
            curve: Curves.linear);

        _indicatorMoveWithPeakController.animateTo(0.0,
            duration: Duration(
                milliseconds: (widget.springAnimationDurationInMilliseconds /
                        widget.animSpeedFactor)
                    .round()),
            curve: Curves.linear);
        _indicatorTranslateInOutController.animateTo(0.0,
            duration: Duration(
                milliseconds: (widget.springAnimationDurationInMilliseconds /
                        widget.animSpeedFactor)
                    .round()),
            curve: Curves.linear);

        await _showPeakController.animateTo(0.3,
            duration: Duration(
                milliseconds: (widget.springAnimationDurationInMilliseconds /
                        widget.animSpeedFactor)
                    .round()),
            curve: Curves.linear);

        _radiusController.animateTo(0.0,
            duration: Duration(
                milliseconds: (widget.springAnimationDurationInMilliseconds /
                        (widget.animSpeedFactor * 5))
                    .round()),
            curve: Curves.linear);

        _showPeakController.value = 0.175;
        await _showPeakController.animateTo(0.1,
            duration: Duration(
                milliseconds: (widget.springAnimationDurationInMilliseconds /
                        (widget.animSpeedFactor * 5))
                    .round()),
            curve: Curves.easeOut);
        _showPeakController.value = 0.0;

        await _positionController.animateTo(0.0,
            duration: Duration(
                milliseconds: (widget.springAnimationDurationInMilliseconds /
                        widget.animSpeedFactor)
                    .round()));
        break;

      case _PullRefreshMode.canceled:
        await _positionController.animateTo(0.0,
            duration: _kIndicatorScaleDuration);
        break;
      default:
        assert(false);
    }
    if (mounted && _mode == newMode) {
      // _dragOffset = null;
      _dragOffset = 0.0;
      _isIndicatorAtTop = null;
      _mode = null;
      setState(() {});
    }
  }

  bool _start(AxisDirection direction) {
    assert(_mode == null);
    assert(_isIndicatorAtTop == null);
    // assert(_dragOffset == null);
    switch (direction) {
      case AxisDirection.down:
        _isIndicatorAtTop = true;
        break;
      case AxisDirection.up:
        _isIndicatorAtTop = false;
        break;
      case AxisDirection.left:
      case AxisDirection.right:
        _isIndicatorAtTop = null;
        return false;
    }
    _dragOffset = 0.0;
    _positionController.value = 0.0;
    _springController.value = 0.0;
    _progressingController.value = 0.0;
    _ringDisappearController.value = 1.0;
    _showPeakController.value = 0.0;
    _indicatorMoveWithPeakController.value = 0.0;
    _indicatorTranslateInOutController.value = 0.0;
    _radiusController.value = 1.0;
    return true;
  }

  void _checkDragOffset(double containerExtent) {
    assert(_mode == _PullRefreshMode.drag || _mode == _PullRefreshMode.armed);
    double newValue =
        _dragOffset / (containerExtent * _kDragContainerExtentPercentage);
    if (_mode == _PullRefreshMode.armed)
      newValue = math.max(newValue, 1.0 / _kDragSizeFactorLimit);
    _positionController.value = newValue.clamp(0.0, 1.0);
    if (_mode == _PullRefreshMode.drag && _valueColor.value.alpha == 0xFF)
      _mode = _PullRefreshMode.armed;
  }

  void _show() {
    assert(_mode != _PullRefreshMode.refresh);
    assert(_mode != _PullRefreshMode.snap);
    final Completer<void> completer = Completer<void>();
    _pendingRefreshFuture = completer.future;
    _mode = _PullRefreshMode.snap;

    _positionController.animateTo(1.0 / _kDragSizeFactorLimit,
        duration: Duration(
            milliseconds: widget.springAnimationDurationInMilliseconds),
        curve: Curves.linear);

    _showPeakController.animateTo(1.0,
        duration: Duration(
            milliseconds: widget.springAnimationDurationInMilliseconds),
        curve: Curves.linear);

    _indicatorMoveWithPeakController.animateTo(1.0,
        duration: Duration(
            milliseconds: widget.springAnimationDurationInMilliseconds),
        curve: Curves.linear);

    _indicatorTranslateInOutController.animateTo(1.0,
        duration: Duration(
            milliseconds: widget.springAnimationDurationInMilliseconds),
        curve: Curves.linear);

    _ringDisappearController.animateTo(0.0,
        duration: Duration(
            milliseconds: widget.springAnimationDurationInMilliseconds));

    _springController
        .animateTo(0.5,
            duration: Duration(
                milliseconds: widget.springAnimationDurationInMilliseconds),
            curve: Curves.elasticOut)
        .then<void>((void value) {
      if (mounted && _mode == _PullRefreshMode.snap) {
        _mode = _PullRefreshMode.refresh;
        setState(() {});
        _progressingController.repeat();

        final Future<void>? refreshResult = widget.onRefresh();
        assert(() {
          if (refreshResult == null) {
            // final bool _useDiagnosticsNode =
            //     FlutterError('text') is Diagnosticable;
            // dynamic safeContext(String context) {
            //   return _useDiagnosticsNode
            //       ? DiagnosticsNode.message(context)
            //       : context;
            // }

            FlutterError.reportError(FlutterErrorDetails(
              exception: FlutterError('The onRefresh callback returned null.\n'
                  'The PullRefresh onRefresh callback must return a Future.'),
              // context: safeContext('when calling onRefresh'),
              library: 'PullRefresh library',
            ));
          }
          return true;
        }());
        if (refreshResult == null) return;
        refreshResult.whenComplete(() {
          if (mounted && _mode == _PullRefreshMode.refresh) {
            completer.complete();
            _dismiss(_PullRefreshMode.done);
          }
        });
      }
    });
  }

  Future<void>? show({bool atTop = true}) {
    if (_mode != _PullRefreshMode.refresh && _mode != _PullRefreshMode.snap) {
      if (_mode == null) _start(atTop ? AxisDirection.down : AxisDirection.up);
      _show();
    }
    return _pendingRefreshFuture;
  }

  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));

    // checking whether to take default values or not
    late final Color color = widget.color ?? Theme.of(context).accentColor;
    late final Color backgroundColor =
        widget.backgroundColor ?? Theme.of(context).canvasColor;
    late final double height = widget.height;

    //Code Added for testing
//    slivers.insert(
//      0,
//      SliverToBoxAdapter(
//        child: ClipPath(
//          clipper: HillClipper(
//            centreHeight: 100,
//            curveHeight: 50.0,
//            peakHeight: 30.0,
//            peakWidth: 15.0 * 5 / 2,
//          ),
//          child: Container(
//            height: 100.0,
//            color: Colors.yellow,
//            child: Align(
//              alignment: Alignment(0.0, 1.0),
//              child: Opacity(
//                opacity: 1.0,
//                child: CircularProgress(
//                  progressCircleOpacity: 1.0,
//                  innerCircleRadius: 15.0,
//                  progressCircleBorderWidth: 0.0,
//                  progressCircleRadius: 0.0,
//                  progressPercent: 0.5,
//                ),
//              ),
//            ),
//          ),
//        ),
//      ),
//    );

    final Widget child = NotificationListener<ScrollNotification>(
      key: _key,
      onNotification: _handleScrollNotification,
      child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: _handleGlowNotification, child: widget.child),
    );

    if (_mode == null) {
      // assert(_dragOffset == null);
      assert(_isIndicatorAtTop == null);
      return child;
    }
    // assert(_dragOffset != null);
    assert(_isIndicatorAtTop != null);

    return Stack(children: <Widget>[
      AnimatedBuilder(
        animation: _positionController,
        child: child,
        builder: (BuildContext buildContext, Widget? child) {
          if (widget.showChildOpacityTransition) {
            return Opacity(
                opacity: (widget.showChildOpacityTransition)
                    ? (_childOpacityAnimation.value - (1 / 3) - 0.01)
                        .clamp(0.0, 1.0)
                    : 1.0,
                child: child);
          }
          return Transform.translate(
              offset: Offset(0.0, _positionController.value * height * 1.5),
              child: child);
        },
      ),
      AnimatedBuilder(
          animation: Listenable.merge(<AnimationController>[
            _positionController,
            _springController,
            _showPeakController
          ]),
          builder: (BuildContext buildContext, Widget? child) {
            return ClipPath(
                clipper: CurveHillClipper(
                    centreHeight: height,
                    curveHeight: height / 2 * _springAnimation.value,
                    // 50.0
                    peakHeight: height *
                        3 /
                        10 *
                        ((_peakHeightUpAnimation.value != 1.0) //30.0
                            ? _peakHeightUpAnimation.value
                            : _peakHeightDownAnimation.value),
                    peakWidth: (_peakHeightUpAnimation.value != 0.0 &&
                            _peakHeightDownAnimation.value != 0.0)
                        ? height * 35 / 100 //35.0
                        : 0.0),
                child: Container(
                    height: _value.value * height * 2, // 100.0
                    color: color));
          }),
      Container(
        height: height, //100.0
        child: AnimatedBuilder(
            animation: Listenable.merge(<AnimationController>[
              _progressingController,
              _ringDisappearController,
              _indicatorMoveWithPeakController,
              _indicatorTranslateInOutController,
              _radiusController
            ]),
            builder: (BuildContext buildContext, Widget? child) => Align(
                alignment: Alignment(
                    0.0,
                    1.0 -
                        (0.36 * _indicatorTranslateWithPeakAnimation.value) -
                        (0.64 * _indicatorTranslateAnimation.value)),
                child: Transform(
                    transform: Matrix4.identity()
                      ..rotateZ(_progressingRotateAnimation.value * 5 * pi / 6),
                    alignment: FractionalOffset.center,
                    child: CircularProgress(
                        backgroundColor: backgroundColor,
                        progressCircleOpacity: _ringOpacityAnimation.value,
                        innerCircleRadius: height *
                            15 /
                            100 * // 15.0
                            ((_mode != _PullRefreshMode.done)
                                ? _indicatorRadiusWithPeakAnimation.value
                                : _radiusAnimation.value),
                        progressCircleBorderWidth: widget.borderWidth,
                        //2.0
                        progressCircleRadius:
                            (_ringOpacityAnimation.value != 0.0)
                                ? (height * 2 / 10) *
                                    _ringRadiusAnimation.value //20.0
                                : 0.0,
                        startAngle: _progressingStartAngleAnimation.value * pi,
                        progressPercent: _progressingPercentAnimation.value)))),
      )
    ]);
  }
}

class ProgressRingCurve extends Curve {
  @override
  double transform(double t) => t <= 0.5 ? 2 * t : 2 * (1 - t);
}

class CircularProgress extends StatefulWidget {
  const CircularProgress({
    Key? key,
    required this.innerCircleRadius,
    required this.progressPercent,
    required this.progressCircleRadius,
    required this.progressCircleBorderWidth,
    required this.backgroundColor,
    required this.progressCircleOpacity,
    required this.startAngle,
  }) : super(key: key);

  final double innerCircleRadius;
  final double progressPercent;
  final double progressCircleOpacity;
  final double progressCircleRadius;
  final double progressCircleBorderWidth;
  final Color backgroundColor;
  final double startAngle;

  @override
  _CircularProgressState createState() => _CircularProgressState();
}

class _CircularProgressState extends State<CircularProgress> {
  @override
  Widget build(BuildContext context) {
    final double containerLength =
        2 * max(widget.progressCircleRadius, widget.innerCircleRadius);

    return Universal(
        isStack: true,
        height: containerLength,
        width: containerLength,
        children: <Widget>[
          Universal(
              opacity: widget.progressCircleOpacity,
              height: widget.progressCircleRadius * 2,
              width: widget.progressCircleRadius * 2,
              child: CustomPaint(
                  painter: _RingPainter(
                startAngle: widget.startAngle,
                paintWidth: widget.progressCircleBorderWidth,
                progressPercent: widget.progressPercent,
                trackColor: widget.backgroundColor,
              ))),
          Align(
              alignment: Alignment.center,
              child: Container(
                  width: widget.innerCircleRadius * 2,
                  height: widget.innerCircleRadius * 2,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: widget.backgroundColor)))
        ]);
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.startAngle,
    required this.paintWidth,
    required this.progressPercent,
    required this.trackColor,
  }) : trackPaint = Paint()
          ..color = trackColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = paintWidth
          ..strokeCap = StrokeCap.square;

  final double paintWidth;
  final Paint trackPaint;
  final Color trackColor;
  final double progressPercent;
  final double startAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (min(size.width, size.height) - paintWidth) / 2;

    final double progressAngle = 2 * pi * progressPercent;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        progressAngle, false, trackPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class CurveHillClipper extends CustomClipper<Path> {
  CurveHillClipper(
      {required this.centreHeight,
      required this.curveHeight,
      this.peakHeight,
      this.peakWidth});

  final double centreHeight;

  final double? peakHeight;
  final double? peakWidth;
  double curveHeight;

  @override
  Path getClip(Size size) {
    final Path path = Path();
    if (peakHeight == null && peakWidth == null) {
      if (size.height > centreHeight) {
        if (curveHeight > (size.height - centreHeight)) {
          curveHeight = size.height - centreHeight;
        }

        path.lineTo(0.0, centreHeight);

        path.quadraticBezierTo(size.width / 4, centreHeight + curveHeight,
            size.width / 2, centreHeight + curveHeight);

        path.quadraticBezierTo(size.width * 3 / 4, centreHeight + curveHeight,
            size.width, centreHeight);

        path.lineTo(size.width, 0.0);

        path.lineTo(0.0, 0.0);
      } else {
        path.lineTo(0.0, size.height);
        path.lineTo(size.width, size.height);
        path.lineTo(size.width, 0.0);
        path.lineTo(0.0, 0.0);
      }
    } else {
      if (size.height >= centreHeight) {
        if (curveHeight > (size.height - centreHeight)) {
          curveHeight = size.height - centreHeight;
        }

        path.lineTo(0.0, centreHeight);

        path.quadraticBezierTo(size.width / 4, centreHeight + curveHeight,
            (size.width / 2) - (peakWidth! / 2), centreHeight + curveHeight);

        path.quadraticBezierTo(
            (size.width / 2) - (peakWidth! / 4),
            centreHeight + curveHeight - peakHeight!,
            size.width / 2,
            centreHeight + curveHeight - peakHeight!);

        path.quadraticBezierTo(
            (size.width / 2) + (peakWidth! / 4),
            centreHeight + curveHeight - peakHeight!,
            (size.width / 2) + (peakWidth! / 2),
            centreHeight + curveHeight);

        path.quadraticBezierTo(size.width * 3 / 4, centreHeight + curveHeight,
            size.width, centreHeight);

        path.lineTo(size.width, 0.0);

        path.lineTo(0.0, 0.0);
      } else {
        path.lineTo(0.0, size.height);
        path.lineTo(size.width, size.height);
        path.lineTo(size.width, 0.0);
        path.lineTo(0.0, 0.0);
      }
    }
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
