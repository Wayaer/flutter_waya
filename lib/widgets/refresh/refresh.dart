import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void sendRefreshType([RefreshCompletedType? refresh]) =>
    eventBus.emit(refreshEvent, refresh ?? RefreshCompletedType.refresh);

class RefreshConfig {
  RefreshConfig({
    Widget? header,
    this.controller,
    this.onRefresh,
    this.onLoading,
    this.onTwoLevel,
    this.footer,
  }) : header = header ?? BezierCircleHeader();

  RefreshController? controller;

  /// 下拉刷新回调(null为不开启刷新)
  VoidCallback? onRefresh;

  /// 上拉加载回调(null为不开启加载)
  VoidCallback? onLoading;

  /// 二楼
  VoidCallback? onTwoLevel;

  /// CustomHeader
  Widget? header;

  /// CustomFooter
  Widget? footer;
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

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
