import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';


/// 可刷新的滚动组件
/// 嵌套 sliver 家族组件
class RefreshScrollView extends StatelessWidget {
  const RefreshScrollView(
      {super.key,
      this.refreshConfig,
      this.padding,
      this.slivers = const <Widget>[],
      this.noScrollBehavior = false,
      this.shrinkWrap = false,
      this.reverse = false,
      this.scrollDirection = Axis.vertical,
      this.anchor = 0.0,
      this.cacheExtent,
      this.controller,
      this.primary,
      this.physics,
      this.center,
      this.semanticChildCount,
      this.dragStartBehavior = DragStartBehavior.start,
      this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
      this.clipBehavior = Clip.hardEdge,
      this.scrollBehavior,
      this.restorationId});

  /// CustomScrollView
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;
  final DragStartBehavior dragStartBehavior;
  final int? semanticChildCount;
  final double? cacheExtent;
  final double anchor;
  final Key? center;
  final ScrollBehavior? scrollBehavior;
  final ScrollPhysics? physics;
  final bool? primary;
  final ScrollController? controller;
  final bool shrinkWrap;
  final bool reverse;
  final Axis scrollDirection;
  final List<Widget> slivers;

  /// Extra parameters
  final bool noScrollBehavior;
  final EdgeInsetsGeometry? padding;
  final RefreshConfig? refreshConfig;

  bool _shrinkWrap(bool shrinkWrap, ScrollPhysics? physics) {
    if (physics == const NeverScrollableScrollPhysics()) return true;
    return shrinkWrap;
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = buildCustomScrollView(physics);
    if (noScrollBehavior) {
      widget = ScrollConfiguration(behavior: NoScrollBehavior(), child: widget);
    }
    if (refreshConfig != null) {
      widget = EasyRefreshed(
          config: refreshConfig!..scrollController = controller,
          builder: (_, ScrollPhysics physics) =>
              buildCustomScrollView(physics));
    }
    if (padding != null) widget = Padding(padding: padding!, child: widget);
    return widget;
  }

  List<Widget> buildSlivers() => slivers;

  CustomScrollView buildCustomScrollView(ScrollPhysics? physics) =>
      CustomScrollView(
          physics: physics,
          controller: controller,
          primary: primary,
          shrinkWrap: _shrinkWrap(shrinkWrap, physics),
          cacheExtent: cacheExtent,
          dragStartBehavior: dragStartBehavior,
          scrollDirection: scrollDirection,
          reverse: reverse,
          slivers: buildSlivers(),
          anchor: anchor,
          center: center,
          scrollBehavior: scrollBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
          semanticChildCount: semanticChildCount);
}

class RefreshConfig {
  RefreshConfig(
      {this.controller,
      this.onRefresh,
      this.onLoading,
      this.header,
      this.footer,
      this.spring,
      this.frictionFactor,
      this.simultaneously = false,
      this.noMoreRefresh = false,
      this.noMoreLoad = false,
      this.resetAfterRefresh = true,
      this.refreshOnStart = false,
      this.refreshOnStartHeader,
      this.callRefreshOverOffset = 20,
      this.callLoadOverOffset = 20,
      this.fit = StackFit.loose,
      this.clipBehavior = Clip.hardEdge,
      this.scrollController,
      this.notLoadFooter,
      this.notRefreshHeader});

  /// 可不传controller，
  /// 若想关闭刷新组件可以通过发送消息
  /// sendRefreshType(RefreshCompletedType.refresh);
  EasyRefreshController? controller;

  /// 下拉刷新回调(null为不开启刷新)
  FutureOr Function()? onRefresh;

  /// 上拉加载回调(null为不开启加载)
  FutureOr Function()? onLoading;

  /// CustomHeader
  Header? header;

  /// CustomFooter
  Footer? footer;

  /// Structure that describes a spring's constants.
  /// When spring is not set in [Header] and [Footer].
  SpringDescription? spring;

  /// Friction factor when list is out of bounds.
  FrictionFactor? frictionFactor;

  /// Refresh and load can be performed simultaneously.
  bool simultaneously;

  /// Is it possible to refresh after there is no more.
  bool noMoreRefresh;

  /// Is it loadable after no more.
  bool noMoreLoad;

  /// Reset after refresh when no more deactivation is loaded.
  bool resetAfterRefresh;

  /// Refresh on start.
  /// When the EasyRefresh build is complete, trigger the refresh.
  bool refreshOnStart;

  /// Header for refresh on start.
  /// Use [header] when null.
  Header? refreshOnStartHeader;

  /// Offset beyond trigger offset when calling refresh.
  /// Used when refreshOnStart is true and [EasyRefreshController.callRefresh].
  double callRefreshOverOffset;

  /// Offset beyond trigger offset when calling load.
  /// Used when [EasyRefreshController.callLoad].
  double callLoadOverOffset;

  /// See [Stack.StackFit]
  StackFit fit;

  /// See [Stack.clipBehavior].
  Clip clipBehavior;

  /// When the position cannot be determined, such as [NestedScrollView].
  /// Mainly used to trigger events.
  ScrollController? scrollController;

  /// Overscroll behavior when [onRefresh] is null.
  /// Won't build widget.
  NotRefreshHeader? notRefreshHeader;

  /// Overscroll behavior when [onLoad] is null.
  /// Won't build widget.
  NotLoadFooter? notLoadFooter;

  /// get Controller
  EasyRefreshControllerCallback? onController;
}

class RefreshControllers {
  factory RefreshControllers() => _singleton ??= RefreshControllers._();

  RefreshControllers._();

  static RefreshControllers? _singleton;

  final Map<int, EasyRefreshController> _controllers = {};

  void set(EasyRefreshController controller) {
    _controllers[controller.hashCode] = controller;
  }

  EasyRefreshController? get(int hashCode) => _controllers[hashCode];

  void remove(int hashCode) {
    _controllers.remove(hashCode);
  }

  /// 最近一次调用刷新组件的 Controller
  EasyRefreshController? current;

  /// 调用当前刷新
  void call(EasyRefreshType data, {EasyRefreshController? controller}) {
    switch (data) {
      case EasyRefreshType.refresh:
        (controller ?? current)?.callRefresh();
        break;
      case EasyRefreshType.refreshSuccess:
        (controller ?? current)?.finishRefresh(IndicatorResult.success);
        break;
      case EasyRefreshType.refreshFailed:
        (controller ?? current)?.finishRefresh(IndicatorResult.fail);
        break;
      case EasyRefreshType.refreshNoMore:
        (controller ?? current)?.finishRefresh(IndicatorResult.noMore);
        break;
      case EasyRefreshType.loading:
        (controller ?? current)?.callLoad();
        break;
      case EasyRefreshType.loadingSuccess:
        (controller ?? current)?.finishLoad(IndicatorResult.success);
        break;
      case EasyRefreshType.loadFailed:
        (controller ?? current)?.finishLoad(IndicatorResult.fail);
        break;
      case EasyRefreshType.loadNoMore:
        (controller ?? current)?.finishLoad(IndicatorResult.noMore);
        break;
    }
  }
}

/// 刷新类型
enum EasyRefreshType {
  /// 触发刷新
  refresh,

  /// 刷新成功
  refreshSuccess,

  /// 刷新完成 没有数据
  refreshNoMore,

  /// 刷新失败
  refreshFailed,

  /// 触发加载
  loading,

  /// 加载成功
  loadingSuccess,

  /// 加载失败
  loadFailed,

  /// 加载完成 没有数据
  loadNoMore,
}

typedef EasyRefreshControllerCallback = void Function(
    EasyRefreshController controller);

class EasyRefreshed extends StatefulWidget {
  const EasyRefreshed({
    super.key,
    this.child,
    this.builder,
    required this.config,
  }) : assert(child != null || builder != null);

  /// 用于 非ScrollView
  final Widget? child;

  /// 用于 ScrollView
  final ERChildBuilder? builder;
  final RefreshConfig config;

  @override
  State<EasyRefreshed> createState() => _EasyRefreshedState();
}

class _EasyRefreshedState extends State<EasyRefreshed> {
  late EasyRefreshController controller;
  late RefreshConfig config;

  @override
  void initState() {
    super.initState();
    initConfig();
  }

  void initConfig() {
    config = widget.config;
    controller = config.controller ??
        EasyRefreshController(
            controlFinishRefresh: config.onRefresh != null,
            controlFinishLoad: config.onLoading != null);
    widget.config.onController?.call(controller);
    RefreshControllers().set(controller);
  }

  @override
  void didUpdateWidget(covariant EasyRefreshed oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      if (config.controller != null && controller != config.controller) {
        controller.dispose();
      }
      initConfig();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.builder(
        controller: controller,
        header: config.header ?? GlobalOptions().globalRefreshHeader,
        footer: config.footer ?? GlobalOptions().globalRefreshFooter,
        onLoad: config.onLoading == null
            ? null
            : () {
                RefreshControllers().current = controller;
                config.onLoading!.call();
              },
        onRefresh: config.onRefresh == null
            ? null
            : () {
                RefreshControllers().current = controller;
                config.onRefresh!.call();
              },
        scrollController: config.scrollController,
        spring: config.spring,
        frictionFactor: config.frictionFactor,
        notRefreshHeader: config.notRefreshHeader,
        notLoadFooter: config.notLoadFooter,
        simultaneously: config.simultaneously,
        noMoreRefresh: config.noMoreRefresh,
        noMoreLoad: config.noMoreLoad,
        resetAfterRefresh: config.resetAfterRefresh,
        refreshOnStart: config.refreshOnStart,
        refreshOnStartHeader: config.refreshOnStartHeader,
        callRefreshOverOffset: config.callRefreshOverOffset,
        callLoadOverOffset: config.callLoadOverOffset,
        fit: config.fit,
        clipBehavior: config.clipBehavior,
        childBuilder: widget.builder ?? (_, __) => widget.child!);
  }

  @override
  void dispose() {
    controller.dispose();
    if (RefreshControllers().current == controller) {
      RefreshControllers().current = null;
    }
    super.dispose();
  }
}
