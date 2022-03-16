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
    Key? key,
    this.refreshConfig,
    this.noScrollBehavior = false,
    this.padding,
    this.slivers = const <Widget>[],
    bool reverse = false,
    bool shrinkWrap = false,
    Axis? scrollDirection = Axis.vertical,
    double anchor = 0.0,
    double? cacheExtent,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    Key? center,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    Clip clipBehavior = Clip.hardEdge,
    ScrollBehavior? scrollBehavior,
    String? restorationId,
  }) : super(
            key: key,
            controller: controller,
            scrollDirection: scrollDirection ?? Axis.vertical,
            shrinkWrap: _shrinkWrap(shrinkWrap, physics),
            reverse: reverse,
            clipBehavior: clipBehavior,
            dragStartBehavior: dragStartBehavior,
            cacheExtent: cacheExtent,
            restorationId: restorationId,
            physics: physics,
            primary: primary,
            center: center,
            anchor: anchor,
            scrollBehavior: scrollBehavior,
            semanticChildCount: semanticChildCount,
            keyboardDismissBehavior: keyboardDismissBehavior);

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
    if (refreshConfig != null) {
      widget = EasyRefreshed(
          slivers: buildSlivers(context),
          scrollDirection: scrollDirection,
          reverse: reverse,
          scrollController: controller,
          controller: refreshConfig!.controller,
          onLoading: refreshConfig!.onLoading,
          onRefresh: refreshConfig!.onRefresh,
          header: refreshConfig!.header,
          footer: refreshConfig!.footer,
          primary: primary,
          shrinkWrap: shrinkWrap,
          cacheExtent: cacheExtent,
          dragStartBehavior: dragStartBehavior);
    }
    if (noScrollBehavior) {
      widget = ScrollConfiguration(behavior: NoScrollBehavior(), child: widget);
    }
    if (padding != null) widget = Padding(padding: padding!, child: widget);
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
      {this.header,
      this.controller,
      this.onRefresh,
      this.onLoading,
      this.footer});

  EasyRefreshController? controller;

  /// 下拉刷新回调(null为不开启刷新)
  OnRefreshCallback? onRefresh;

  /// 上拉加载回调(null为不开启加载)
  OnLoadCallback? onLoading;

  /// CustomHeader
  Header? header;

  /// CustomFooter
  Footer? footer;
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
    Key? key,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.reverse = false,
    this.dragStartBehavior = DragStartBehavior.start,
    this.controller,
    this.onRefresh,
    this.onLoading,
    this.header,
    this.footer,
    required this.slivers,
    this.cacheExtent,
    this.primary,
    this.scrollController,
  }) : super(key: key);

  /// 可不传controller，
  /// 若想关闭刷新组件可以通过发送消息
  /// sendRefreshType(RefreshCompletedType.refresh);
  final EasyRefreshController? controller;
  final OnRefreshCallback? onRefresh;
  final OnLoadCallback? onLoading;

  /// CustomHeader
  final Header? header;

  /// CustomFooter
  final Footer? footer;

  final List<Widget> slivers;

  /// 是否倒置列表
  final bool reverse;

  /// 设置预加载的区域
  final double? cacheExtent;

  /// 如果内容不足，则用户无法滚动 而如果[primary]为true，它们总是可以尝试滚动。
  final bool? primary;

  /// 滚动方向
  /// [Axis.vertical] 垂直滚动
  /// [Axis.horizontal] 水平滚动
  final Axis scrollDirection;
  final DragStartBehavior dragStartBehavior;

  /// 整个滚动控制器
  final ScrollController? scrollController;

  /// 当嵌套在无限长的组件里时必须设置为 false
  final bool shrinkWrap;

  @override
  _EasyRefreshedState createState() => _EasyRefreshedState();
}

class _EasyRefreshedState extends State<EasyRefreshed> {
  late EasyRefreshController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? EasyRefreshController();
  }

  @override
  void didUpdateWidget(covariant EasyRefreshed oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null && controller != widget.controller) {
      controller.dispose();
      controller = widget.controller!;
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
            _holdController!.finishRefresh(success: true);
            break;
          case EasyRefreshType.refreshFailed:
            _holdController!.finishRefresh(success: false);
            break;
          case EasyRefreshType.refreshNoMore:
            _holdController!.finishRefresh(success: true, noMore: true);
            break;
          case EasyRefreshType.loading:
            _holdController!.callLoad();
            break;
          case EasyRefreshType.loadingSuccess:
            _holdController!.finishLoad(success: true);
            break;
          case EasyRefreshType.loadFailed:
            _holdController!.finishLoad(success: false);
            break;
          case EasyRefreshType.loadNoMore:
            _holdController!.finishLoad(success: true, noMore: true);
            break;
        }
      }
      EventBus().remove(_eventName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.custom(
        enableControlFinishRefresh: true,
        enableControlFinishLoad: true,
        controller: controller,
        header: widget.header ?? GlobalOptions().globalRefreshHeader,
        footer: widget.footer ?? GlobalOptions().globalRefreshFooter,
        onLoad: widget.onLoading == null
            ? null
            : () async {
                _holdController = controller;
                initEventBus();
                widget.onLoading!.call();
              },
        onRefresh: widget.onRefresh == null
            ? null
            : () async {
                _holdController = controller;
                initEventBus();
                widget.onRefresh!.call();
              },
        slivers: widget.slivers,
        scrollDirection: widget.scrollDirection,
        reverse: widget.reverse,
        scrollController: widget.scrollController,
        primary: widget.primary,
        shrinkWrap: widget.shrinkWrap,
        cacheExtent: widget.cacheExtent,
        dragStartBehavior: widget.dragStartBehavior);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
