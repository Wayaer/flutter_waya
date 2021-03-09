import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void sendRefreshType([RefreshCompletedType? refresh]) =>
    eventBus.emit(refreshEvent, refresh ?? RefreshCompletedType.refresh);

class RefreshConfig {
  RefreshConfig(
      {Widget? header,
      this.controller,
      this.onRefresh,
      this.onLoading,
      this.footer,
      // this.emptyWidget,
      this.firstRefresh = false,
      this.firstRefreshWidget})
      : header = header ?? BezierCircleHeader();

  // EasyRefreshController? controller;
  RefreshController? controller;

  /// 下拉刷新回调(null为不开启刷新)
  VoidCallback? onRefresh;

  /// 上拉加载回调(null为不开启加载)
  VoidCallback? onLoading;

  /// CustomHeader
  // Header? header;
  Widget? header;

  /// CustomFooter
  // Footer? footer;
  Widget? footer;

  // Widget? emptyWidget;

  /// 首次刷新
  bool firstRefresh;

  /// 首次刷新组件
  /// 不设置时使用header
  Widget? firstRefreshWidget;
}

class Refreshed extends StatefulWidget {
  // Refreshed({
  //   Key? key,
  //   bool? firstRefresh,
  //   // Header? header,
  //   this.firstRefreshWidget,
  //   this.slivers,
  //   this.child,
  //   this.onLoading,
  //   this.onRefresh,
  //   this.footer,
  //   this.controller,
  //   this.scrollDirection,
  //   this.reverse,
  //   this.scrollController,
  //   this.primary,
  //   this.physics,
  //   this.cacheExtent,
  //   this.semanticChildCount,
  //   this.dragStartBehavior,
  //   this.emptyWidget,
  // })  : assert(child == null || slivers == null),
  //       firstRefresh = firstRefresh ?? false,
  //       header = header ?? BezierCircleHeader(),
  //       super(key: key);
  //
  // ///  可不传controller，
  // ///  若想关闭刷新组件可以通过发送消息
  // ///  sendRefreshType(RefreshCompletedType.refresh);
  // final EasyRefreshController? controller;
  //
  // /// 下拉刷新回调(null为不开启刷新)
  // final OnRefreshCallback? onRefresh;
  //
  // /// 上拉加载回调(null为不开启加载)
  // final OnRefreshCallback? onLoading;
  //
  // /// 要刷新的子组件
  // final Widget? child;
  // final List<Widget>? slivers;
  //
  // /// CustomHeader
  // final Header header;
  //
  // /// CustomFooter
  // final Footer? footer;
  // final Widget? emptyWidget;
  //
  // /// 首次刷新
  // final bool firstRefresh;
  //
  // /// 首次刷新组件
  // /// 不设置时使用header
  // final Widget? firstRefreshWidget;
  //
  // final Axis? scrollDirection;
  // final bool? reverse;
  // final ScrollController? scrollController;
  // final bool? primary;
  // final ScrollPhysics? physics;
  // final double? cacheExtent;
  // final int? semanticChildCount;
  // final DragStartBehavior? dragStartBehavior;

  @override
  _RefreshedState createState() => _RefreshedState();
}

class _RefreshedState extends State<Refreshed> {
  // late EasyRefreshController controller;

  // @override
  // void initState() {
  //   super.initState();
  //   controller = widget.controller ?? EasyRefreshController();
  //   addPostFrameCallback(
  //       (Duration callback) => eventBus.add(refreshEvent, (dynamic data) {
  //             if (data == null) return;
  //             if (data != null && data is RefreshCompletedType) {
  //               switch (data) {
  //                 case RefreshCompletedType.refresh:
  //                   controller.finishRefresh(success: true);
  //                   // controller.refreshCompleted();
  //                   break;
  //                 case RefreshCompletedType.refreshFailed:
  //                   controller.finishRefresh(success: false);
  //                   // controller.refreshFailed();
  //                   break;
  //                 case RefreshCompletedType.refreshToIdle:
  //                   // controller.refreshToIdle();
  //                   break;
  //                 case RefreshCompletedType.onLoading:
  //                   controller.finishLoad(success: true);
  //                   // controller.loadComplete();
  //                   break;
  //                 case RefreshCompletedType.loadFailed:
  //                   controller.finishLoad(success: false);
  //                   // controller.loadFailed();
  //                   break;
  //                 case RefreshCompletedType.loadNoData:
  //                   // controller.loadNoData();
  //                   break;
  //                 case RefreshCompletedType.twoLevel:
  //                   // controller.twoLevelComplete();
  //                   break;
  //               }
  //             }
  //           }));
  // }

  @override
  Widget build(BuildContext context) {
    // if (widget.child != null)
    //   return EasyRefresh(
    //       child: widget.child,
    //       footer: widget.footer,
    //       controller: controller,
    //       emptyWidget: widget.emptyWidget,
    //       firstRefresh: widget.firstRefresh,
    //       firstRefreshWidget: widget.firstRefreshWidget,
    //       onLoad: widget.onLoading,
    //       onRefresh: widget.onRefresh,
    //       scrollController: widget.scrollController);
    // if (widget.slivers != null)
    //   return EasyRefresh.custom(
    //       slivers: widget.slivers,
    //       header: widget.header,
    //       footer: widget.footer,
    //       controller: controller,
    //       emptyWidget: widget.emptyWidget,
    //       firstRefresh: widget.firstRefresh,
    //       firstRefreshWidget: widget.firstRefreshWidget,
    //       onLoad: widget.onLoading,
    //       onRefresh: widget.onRefresh,
    //       scrollController: widget.scrollController);
    return Container();
  }
}

class PullRefreshed extends StatefulWidget {
  PullRefreshed({
    Key? key,
    required this.child,
    Widget? header,
    this.onLoading,
    this.onRefresh,
    this.footer,
    this.controller,
    this.scrollDirection,
    this.reverse,
    this.scrollController,
    this.primary,
    this.physics,
    this.onTwoLevel,
    this.cacheExtent,
  })  : header =
            header ?? BezierCircleHeader(bezierColor: ConstColors.transparent),
        super(key: key);

  ///  可不传controller，
  ///  若想关闭刷新组件可以通过发送消息
  ///  sendRefreshType(RefreshCompletedType.refresh);
  final RefreshController? controller;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoading;
  final VoidCallback? onTwoLevel;
  final Widget child;

  /// CustomHeader
  final Widget? header;

  /// CustomFooter
  final Widget? footer;

  final Axis? scrollDirection;
  final bool? reverse;
  final ScrollController? scrollController;
  final bool? primary;
  final ScrollPhysics? physics;
  final double? cacheExtent;

  @override
  _PullRefreshedState createState() => _PullRefreshedState();
}

class _PullRefreshedState extends State<PullRefreshed> {
  late RefreshController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? RefreshController(initialRefresh: false);
    addPostFrameCallback(
        (Duration callback) => eventBus.add(refreshEvent, (dynamic data) {
              if (data == null) return;
              if (data != null && data is RefreshCompletedType) {
                switch (data) {
                  case RefreshCompletedType.refresh:
                    controller.refreshCompleted();
                    break;
                  case RefreshCompletedType.refreshFailed:
                    controller.refreshFailed();
                    break;
                  case RefreshCompletedType.refreshToIdle:
                    controller.refreshToIdle();
                    break;
                  case RefreshCompletedType.loading:
                    controller.loadComplete();
                    break;
                  case RefreshCompletedType.loadFailed:
                    controller.loadFailed();
                    break;
                  case RefreshCompletedType.loadNoData:
                    controller.loadNoData();
                    break;
                  case RefreshCompletedType.twoLevel:
                    controller.twoLevelComplete();
                    break;
                }
              }
            }));
  }

  @override
  Widget build(BuildContext context) => SmartRefresher(
      child: widget.child,
      controller: controller,
      enablePullDown: widget.onRefresh != null,
      enablePullUp: widget.onLoading != null,
      enableTwoLevel: widget.onTwoLevel != null,
      header: widget.header,
      footer: widget.footer,
      onRefresh: widget.onRefresh,
      onLoading: widget.onLoading,
      onTwoLevel: widget.onTwoLevel,
      primary: widget.primary,
      cacheExtent: widget.cacheExtent,
      reverse: widget.reverse,
      physics: widget.physics,
      scrollDirection: widget.scrollDirection,
      scrollController: widget.scrollController);
}
