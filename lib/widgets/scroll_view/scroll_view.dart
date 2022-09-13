import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

export 'extended_scroll_view.dart';
export 'list_view.dart';
export 'sliver/sliver.dart';

/// 可刷新的滚动组件
/// 嵌套 sliver 家族组件
class RefreshScrollView extends ScrollView {
  RefreshScrollView({
    super.key,
    this.refreshConfig,
    this.noScrollBehavior = false,
    this.padding,
    this.slivers = const <Widget>[],
    bool shrinkWrap = false,
    super.reverse = false,
    super.scrollDirection = Axis.vertical,
    super.anchor = 0.0,
    super.cacheExtent,
    super.controller,
    super.primary,
    super.physics,
    super.center,
    super.semanticChildCount,
    super.dragStartBehavior = DragStartBehavior.start,
    super.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    super.clipBehavior = Clip.hardEdge,
    super.scrollBehavior,
    super.restorationId,
  }) : super(shrinkWrap: _shrinkWrap(shrinkWrap, physics));

  static bool _shrinkWrap(bool shrinkWrap, ScrollPhysics? physics) {
    if (physics == const NeverScrollableScrollPhysics()) return true;
    return shrinkWrap;
  }

  final List<Widget> slivers;
  final bool noScrollBehavior;
  final EdgeInsetsGeometry? padding;
  final RefreshConfig? refreshConfig;

  @override
  Widget build(BuildContext context) {
    Widget widget = super.build(context);
    if (noScrollBehavior) {
      widget = ScrollConfiguration(behavior: NoScrollBehavior(), child: widget);
    }
    if (padding != null) widget = Padding(padding: padding!, child: widget);
    if (refreshConfig != null) {
      widget = EasyRefreshed(
          config: refreshConfig!..scrollController = controller,
          builder: (_, ScrollPhysics physics) => CustomScrollView(
              physics: physics,
              controller: controller,
              primary: primary,
              shrinkWrap: shrinkWrap,
              cacheExtent: cacheExtent,
              dragStartBehavior: dragStartBehavior,
              scrollDirection: scrollDirection,
              reverse: reverse,
              slivers: buildSlivers(context)));
    }
    return widget;
  }

  @override
  List<Widget> buildSlivers(BuildContext context) => slivers;
}

void sendRefreshType([EasyRefreshType? refresh]) {
  EventBus().emit(_eventName, refresh ?? EasyRefreshType.refreshSuccess);
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
}

EasyRefreshController? _holdController;

String get _eventName => refreshEvent + _holdController.hashCode.toString();

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

class EasyRefreshed extends StatefulWidget {
  const EasyRefreshed({
    super.key,
    this.child,
    this.builder,
    required this.config,
  }) : assert(child != null || builder != null);

  final Widget? child;
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
    config = widget.config;
    controller = config.controller ??
        EasyRefreshController(
            controlFinishRefresh: config.onRefresh != null,
            controlFinishLoad: config.onLoading != null);
  }

  @override
  void didUpdateWidget(covariant EasyRefreshed oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      controller.dispose();
      config = widget.config;
      controller = config.controller ??
          EasyRefreshController(
              controlFinishRefresh: config.onRefresh != null,
              controlFinishLoad: config.onLoading != null);
    }
  }

  void initEventBus() {
    EventBus().add(_eventName, (dynamic data) {
      if (data != null && data is EasyRefreshType) {
        switch (data) {
          case EasyRefreshType.refresh:
            _holdController!.callRefresh();
            break;
          case EasyRefreshType.refreshSuccess:
            _holdController!.finishRefresh(IndicatorResult.success);
            break;
          case EasyRefreshType.refreshFailed:
            _holdController!.finishRefresh(IndicatorResult.fail);
            break;
          case EasyRefreshType.refreshNoMore:
            _holdController!.finishRefresh(IndicatorResult.noMore);
            break;
          case EasyRefreshType.loading:
            _holdController!.callLoad();
            break;
          case EasyRefreshType.loadingSuccess:
            _holdController!.finishLoad(IndicatorResult.success);
            break;
          case EasyRefreshType.loadFailed:
            _holdController!.finishLoad(IndicatorResult.fail);
            break;
          case EasyRefreshType.loadNoMore:
            _holdController!.finishLoad(IndicatorResult.noMore);
            break;
        }
      }
      EventBus().remove(_eventName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.builder(
        controller: controller,
        header: config.header ?? GlobalOptions().globalRefreshHeader,
        footer: config.footer ?? GlobalOptions().globalRefreshFooter,
        onLoad: config.onLoading == null
            ? null
            : () async {
                _holdController = controller;
                initEventBus();
                config.onLoading!.call();
              },
        onRefresh: config.onRefresh == null
            ? null
            : () async {
                _holdController = controller;
                initEventBus();
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
    super.dispose();
    controller.dispose();
  }
}
