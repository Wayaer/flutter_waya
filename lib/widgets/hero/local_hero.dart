import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_waya/widgets/hero/local_hero_layer.dart';

/// Signature for a function that takes two [Rect] instances and returns a
/// [RectTween] that transitions between them.

typedef RectTweenSupplier = Tween<Rect> Function(Rect? begin, Rect? end);

SchedulerBinding? schedulerBinding = SchedulerBinding.instance;

Tween<Rect?> _defaultCreateTweenRect(Rect? begin, Rect? end) =>
    MaterialRectArcTween(begin: begin, end: end);

typedef LocalHeroFlightShuttleBuilder = Widget Function(
    BuildContext context, Animation<double> animation, Widget child);

/// Mark its child as a candidate for local hero animation.
///
/// When the position of this widget (from the perspective of Flutter) changes,
/// an animation is started from the previous position to the new one.
///
/// You'll have to use a [Key] in the top most parent in your container in order
/// to explicitly tell the framework to preserve the state of your children.
class LocalHero extends StatefulWidget {
  /// Creates a [LocalHero].
  ///
  /// If between two frames, the position of a [LocalHero] with the same tag
  /// changes, a local hero animation will be triggered.
  const LocalHero({
    Key? key,
    required this.tag,
    this.flightShuttleBuilder,
    this.enabled = true,
    required this.child,
  }) : super(key: key);

  /// The identifier for this particular local hero. This tag must be unique
  /// under the same [LocalHeroScope].
  /// If between two frames, the position of a [LocalHero] with the same tag
  /// changes, a local hero animation will be triggered.
  final Object tag;

  /// Optional override to supply a widget that's shown during the local hero's
  /// flight.
  ///
  /// If none is provided, the child is shown in-flight by default.
  final LocalHeroFlightShuttleBuilder? flightShuttleBuilder;

  /// Whether the hero animation should be enabled.
  final bool enabled;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  _LocalHeroState createState() => _LocalHeroState();
}

class _LocalHeroState extends State<LocalHero>
    with SingleTickerProviderStateMixin<LocalHero> {
  late LocalHeroController controller;
  late _LocalHeroScopeState scopeState;

  @override
  void initState() {
    super.initState();
    scopeState = context.getLocalHeroScopeState();
    controller = scopeState.track(context, widget);
  }

  @override
  void dispose() {
    scopeState.untrack(widget);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.enabled
      ? LocalHeroLeader(controller: controller, child: widget.child)
      : widget.child;
}

/// A widget under which you can create [LocalHero] widgets.
class LocalHeroScope extends StatefulWidget {
  /// Creates a [LocalHeroScope].
  /// All local hero animations under this widget, will have the specified
  /// [duration], [curve], and [createRectTween].
  const LocalHeroScope({
    Key? key,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
    this.createRectTween = _defaultCreateTweenRect,
    required this.child,
  }) : super(key: key);

  /// The duration of the animation.
  final Duration duration;

  /// The curve for the hero animation.
  final Curve curve;

  /// Defines how the destination hero's bounds change as it flies from the
  /// starting position to the destination position.
  ///
  /// The default value creates a [MaterialRectArcTween].
  final CreateRectTween createRectTween;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  __LocalHeroScopeState createState() => __LocalHeroScopeState();
}

class __LocalHeroScopeState extends State<LocalHeroScope>
    with TickerProviderStateMixin
    implements _LocalHeroScopeState {
  final Map<Object, _LocalHeroTracker> trackers = <Object, _LocalHeroTracker>{};

  @override
  LocalHeroController track(BuildContext context, LocalHero? localHero) {
    final _LocalHeroTracker tracker = trackers.putIfAbsent(
        localHero!.tag, () => createTracker(context, localHero));
    tracker.count++;
    return tracker.controller;
  }

  _LocalHeroTracker createTracker(BuildContext context, LocalHero localHero) {
    final LocalHeroController controller = LocalHeroController(
        duration: widget.duration,
        createRectTween: widget.createRectTween,
        curve: widget.curve,
        tag: localHero.tag,
        vsync: this);
    final Widget shuttle = localHero.flightShuttleBuilder?.call(
          context,
          controller.view,
          localHero.child,
        ) ??
        localHero.child;

    final OverlayEntry overlayEntry = OverlayEntry(
        builder: (BuildContext context) =>
            LocalHeroFollower(controller: controller, child: shuttle));

    final _LocalHeroTracker tracker = _LocalHeroTracker(
      controller: controller,
      overlayEntry: overlayEntry,
    );

    tracker.addOverlay(context);
    return tracker;
  }

  @override
  void untrack(LocalHero localHero) {
    final _LocalHeroTracker? tracker = trackers[localHero.tag];
    if (tracker != null) {
      tracker.count--;
      if (tracker.count == 0) {
        trackers.remove(localHero.tag);
        disposeTracker(tracker);
      }
    }
  }

  @override
  void dispose() {
    trackers.values.forEach(disposeTracker);
    super.dispose();
  }

  void disposeTracker(_LocalHeroTracker tracker) {
    tracker.controller.dispose();
    tracker.removeOverlay();
  }

  @override
  Widget build(BuildContext context) =>
      _InheritedLocalHeroScopeState(state: this, child: widget.child);
}

abstract class _LocalHeroScopeState {
  LocalHeroController track(BuildContext context, LocalHero localHero);

  void untrack(LocalHero localHero);
}

class _LocalHeroTracker {
  _LocalHeroTracker({
    required this.overlayEntry,
    required this.controller,
  });

  final OverlayEntry overlayEntry;
  final LocalHeroController controller;
  int count = 0;

  bool _removeRequested = false;
  bool _overlayInserted = false;

  void addOverlay(BuildContext context) {
    final OverlayState overlayState = Overlay.of(context)!;
    schedulerBinding!.addPostFrameCallback((_) {
      if (!_removeRequested) {
        overlayState.insert(overlayEntry);
        _overlayInserted = true;
      }
    });
  }

  void removeOverlay() {
    _removeRequested = true;
    if (_overlayInserted) {
      overlayEntry.remove();
    }
  }
}

class _InheritedLocalHeroScopeState extends InheritedWidget {
  const _InheritedLocalHeroScopeState({
    Key? key,
    required this.state,
    required Widget child,
  }) : super(key: key, child: child);

  final _LocalHeroScopeState state;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

extension BuildContextExtensions on BuildContext {
  T? getInheritedWidget<T extends InheritedWidget>() {
    final InheritedElement? elem = getElementForInheritedWidgetOfExactType<T>();
    if (elem == null) return null;
    return elem.widget as T;
  }

  _LocalHeroScopeState getLocalHeroScopeState() {
    final _InheritedLocalHeroScopeState? inheritedState =
        getInheritedWidget<_InheritedLocalHeroScopeState>();
    assert(() {
      if (inheritedState == null) {
        throw FlutterError('No LocalHeroScope for a LocalHero\n'
            'When creating a LocalHero, you must ensure that there\n'
            'is a LocalHeroScope above the LocalHero.\n');
      }
      return true;
    }());

    return inheritedState!.state;
  }
}

class LocalHeroController {
  LocalHeroController({
    required TickerProvider vsync,
    required Duration duration,
    required this.curve,
    required this.createRectTween,
    required this.tag,
  }) : link = LayerLink() {
    _controller = AnimationController(vsync: vsync, duration: duration)
      ..addStatusListener(_onAnimationStatusChanged);
  }

  final Object tag;

  final LayerLink link;

  late AnimationController _controller;
  Animation<Rect>? _animation;
  Rect? _lastRect;

  Curve curve;

  CreateRectTween createRectTween;

  Duration? get duration => _controller.duration;

  void setDuration(Duration value) => _controller.duration = value;

  bool get isAnimating => _isAnimating;
  bool _isAnimating = false;

  Animation<double> get view => _controller.view;

  Offset get linkedOffset => _animation?.value.topLeft ?? _lastRect!.topLeft;

  Size get linkedSize => _animation?.value.size ?? _lastRect!.size;

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _isAnimating = false;
      _animation = null;
      _controller.value = 0;
    }
  }

  void animateIfNeeded(Rect rect) {
    if (_lastRect != null && _lastRect != rect) {
      final bool inAnimation = isAnimating;
      Rect from = Rect.fromLTWH(
        _lastRect!.left - rect.left,
        _lastRect!.top - rect.top,
        _lastRect!.width,
        _lastRect!.height,
      );
      if (inAnimation) {
        final Rect currentRect = _animation!.value;
        from = Rect.fromLTWH(
            currentRect.left + _lastRect!.left - rect.left,
            currentRect.top + _lastRect!.top - rect.top,
            currentRect.width,
            currentRect.height);
      }
      _isAnimating = true;

      final Tween<Rect> tween =
          createRectTween(from, Rect.fromLTWH(0, 0, rect.width, rect.height))
              as Tween<Rect>;
      _animation = _controller.drive(CurveTween(curve: curve)).drive(tween);

      if (!inAnimation) {
        schedulerBinding!.addPostFrameCallback((_) {
          _controller.forward();
        });
      } else {
        schedulerBinding!.addPostFrameCallback((_) {
          final Duration? _duration = _controller.duration;
          if (_duration == null) return;
          final Duration duration = _duration * (1 - _controller.value);
          _controller.reset();
          _controller.animateTo(1, duration: duration);
        });
      }
    }
    _lastRect = rect;
  }

  void dispose() {
    _controller.stop();
    _controller.removeStatusListener(_onAnimationStatusChanged);
    _controller.dispose();
  }

  void addListener(VoidCallback listener) {
    _controller.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    _controller.removeListener(listener);
  }

  void addStatusListener(AnimationStatusListener listener) {
    _controller.addStatusListener(listener);
  }

  void removeStatusListener(AnimationStatusListener listener) {
    _controller.removeStatusListener(listener);
  }
}
