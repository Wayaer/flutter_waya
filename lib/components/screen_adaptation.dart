import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef ScreenAdaptationChildBuilder = Widget Function(
    BuildContext context, bool scaled);

/// none: 不做缩放 auto: 竖屏按宽缩放，横屏（宽 >= 高 * 1.1）不缩放 width: 按宽缩放
enum ScreenAdaptationScaleType { none, auto, width }

class ScreenAdaptation extends StatefulWidget {
  const ScreenAdaptation({
    super.key,
    required this.designWidth,
    required this.builder,
    this.scaleType = ScreenAdaptationScaleType.auto,
  });

  final double designWidth;
  final ScreenAdaptationChildBuilder builder;
  final ScreenAdaptationScaleType scaleType;

  @override
  State<ScreenAdaptation> createState() => _ScreenAdaptationState();
}

class _ScreenAdaptationState extends ExtendedState<ScreenAdaptation>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (context.view.physicalSize.isEmpty) {
      return ScreenAdaptationScope._(
          designWidth: widget.designWidth,
          scaleType: widget.scaleType,
          scaleRatio: 1,
          child: const SizedBox());
    }
    final Size sceneSize =
        context.view.physicalSize / context.view.devicePixelRatio;
    if (widget.scaleType == ScreenAdaptationScaleType.none ||
        (widget.scaleType == ScreenAdaptationScaleType.auto &&
            sceneSize.width >= sceneSize.height * 1.1)) {
      return ScreenAdaptationScope._(
          designWidth: widget.designWidth,
          scaleType: widget.scaleType,
          scaleRatio: 1,
          child: Builder(
              builder: (BuildContext context) =>
                  widget.builder(context, false)));
    }

    final double scale = sceneSize.width / widget.designWidth;

    /// 如果filterQuality为null，则是渲染时直接应用transform，否则会先渲染，再对bitmap应用
    return FractionallySizedBox(
        widthFactor: 1 / scale,
        heightFactor: 1 / scale,
        child: Transform.scale(
            scale: scale,
            child: ScreenAdaptationScope._(
                designWidth: widget.designWidth,
                scaleType: widget.scaleType,
                scaleRatio: scale,
                child: widget.builder(context, true))));
  }
}

class ScreenAdaptationScope extends InheritedWidget {
  ScreenAdaptationScope._({
    required this.designWidth,
    required this.scaleType,
    required this.scaleRatio,
    required Widget child,
  }) : super(child: _MediaQueryDataProvider(child: child));

  final double designWidth;
  final ScreenAdaptationScaleType scaleType;
  final double scaleRatio;

  static ScreenAdaptationScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType()!;

  static ScreenAdaptationScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();

  // double toPhysicalWidth(double width) =>
  //     width * scaleRatio * window.devicePixelRatio;
  //
  // double toPhysicalHeight(double height) =>
  //     height * scaleRatio * window.devicePixelRatio;

  @override
  bool updateShouldNotify(covariant ScreenAdaptationScope oldWidget) =>
      oldWidget.designWidth != designWidth ||
      oldWidget.scaleType != scaleType ||
      oldWidget.scaleRatio != scaleRatio;
}

class _MediaQueryDataProvider extends StatelessWidget {
  const _MediaQueryDataProvider({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ScreenAdaptationScope data = ScreenAdaptationScope.of(context);
    final MediaQueryData parent = context.mediaQuery;
    return MediaQuery(
        data: parent.copyWith(
            size: parent.size / data.scaleRatio,
            devicePixelRatio: parent.devicePixelRatio * data.scaleRatio,
            padding: parent.padding / data.scaleRatio,
            viewPadding: parent.viewPadding / data.scaleRatio,
            viewInsets: parent.viewInsets / data.scaleRatio,
            systemGestureInsets: parent.systemGestureInsets / data.scaleRatio),
        child: child);
  }
}
