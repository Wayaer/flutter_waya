import 'package:flutter/material.dart';
import 'package:flutter_waya/src/core/extended_state.dart';

/// 屏幕适配的构建器，scaled 表示当前是否进行了缩放。
typedef FlScreenAdaptationChildBuilder = Widget Function(BuildContext context, bool scaled);

/// none: 不做缩放 auto: 竖屏按宽缩放，横屏（宽 >= 高 * 1.1）不缩放 width: 按宽缩放
enum FlScreenAdaptationScaleType { none, auto, width }

/// 按设计稿宽度等比缩放子组件的屏幕适配容器。
class FlScreenAdaptation extends StatefulWidget {
  const FlScreenAdaptation({
    super.key,
    required this.designWidth,
    required this.builder,
    this.scaleType = FlScreenAdaptationScaleType.auto,
  }) : assert(designWidth > 0);

  /// 设计稿宽度（逻辑像素），必须大于 0。
  final double designWidth;

  /// 子组件构建回调。
  final FlScreenAdaptationChildBuilder builder;

  /// 缩放方式，默认 FlScreenAdaptationScaleType.auto。
  final FlScreenAdaptationScaleType scaleType;

  @override
  State<FlScreenAdaptation> createState() => _ScreenAdaptationState();
}

class _ScreenAdaptationState extends FlExtendedState<FlScreenAdaptation> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData? mediaQuery = MediaQuery.maybeOf(context);
    final Size sceneSize = mediaQuery?.size ?? View.of(context).physicalSize / View.of(context).devicePixelRatio;
    if (sceneSize.isEmpty) {
      return FlScreenAdaptationScope._(
        designWidth: widget.designWidth,
        scaleType: widget.scaleType,
        scaleRatio: 1,
        child: const SizedBox(),
      );
    }
    if (widget.scaleType == FlScreenAdaptationScaleType.none ||
        (widget.scaleType == FlScreenAdaptationScaleType.auto && sceneSize.width >= sceneSize.height * 1.1)) {
      return FlScreenAdaptationScope._(
        designWidth: widget.designWidth,
        scaleType: widget.scaleType,
        scaleRatio: 1,
        child: Builder(builder: (BuildContext context) => widget.builder(context, false)),
      );
    }

    final double scale = sceneSize.width / widget.designWidth;

    /// 如果filterQuality为null，则是渲染时直接应用transform，否则会先渲染，再对bitmap应用
    return FractionallySizedBox(
      widthFactor: 1 / scale,
      heightFactor: 1 / scale,
      child: Transform.scale(
        scale: scale,
        child: FlScreenAdaptationScope._(
          designWidth: widget.designWidth,
          scaleType: widget.scaleType,
          scaleRatio: scale,
          child: Builder(builder: (BuildContext context) => widget.builder(context, true)),
        ),
      ),
    );
  }
}

/// 向下传递设计稿宽度、缩放方式与缩放比例的 InheritedWidget。
class FlScreenAdaptationScope extends InheritedWidget {
  FlScreenAdaptationScope._({
    required this.designWidth,
    required this.scaleType,
    required this.scaleRatio,
    required Widget child,
  }) : super(child: _MediaQueryDataProvider(child: child));

  /// 设计稿宽度。
  final double designWidth;

  /// 缩放方式。
  final FlScreenAdaptationScaleType scaleType;

  /// 实际缩放比例，未缩放时为 1。
  final double scaleRatio;

  /// 获取最近的适配信息，不存在时抛出异常。
  static FlScreenAdaptationScope of(BuildContext context) => context.dependOnInheritedWidgetOfExactType()!;

  /// 获取最近的适配信息，不存在时返回 null。
  static FlScreenAdaptationScope? maybeOf(BuildContext context) => context.dependOnInheritedWidgetOfExactType();

  // double toPhysicalWidth(double width) =>
  //     width * scaleRatio * window.devicePixelRatio;
  //
  // double toPhysicalHeight(double height) =>
  //     height * scaleRatio * window.devicePixelRatio;

  @override
  bool updateShouldNotify(covariant FlScreenAdaptationScope oldWidget) =>
      oldWidget.designWidth != designWidth || oldWidget.scaleType != scaleType || oldWidget.scaleRatio != scaleRatio;
}

class _MediaQueryDataProvider extends StatelessWidget {
  const _MediaQueryDataProvider({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final FlScreenAdaptationScope data = FlScreenAdaptationScope.of(context);
    final MediaQueryData? parent = MediaQuery.maybeOf(context);
    if (parent == null) return child;
    return MediaQuery(
      data: parent.copyWith(
        size: parent.size / data.scaleRatio,
        devicePixelRatio: parent.devicePixelRatio * data.scaleRatio,
        padding: parent.padding / data.scaleRatio,
        viewPadding: parent.viewPadding / data.scaleRatio,
        viewInsets: parent.viewInsets / data.scaleRatio,
        systemGestureInsets: parent.systemGestureInsets / data.scaleRatio,
      ),
      child: child,
    );
  }
}
