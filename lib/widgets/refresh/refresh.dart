import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_waya/flutter_waya.dart';

void sendRefreshType([RefreshCompletedType? refresh]) =>
    eventBus.emit(refreshEvent, refresh ?? RefreshCompletedType.refresh);

class RefreshConfig {
  RefreshConfig(
      {Header? header,
      this.controller,
      this.onRefresh,
      this.onLoading,
      this.footer,
      this.emptyWidget,
      this.firstRefresh = false,
      this.firstRefreshWidget})
      : header = header ?? BezierCircleHeader();

  EasyRefreshController? controller;

  /// 下拉刷新回调(null为不开启刷新)
  OnRefreshCallback? onRefresh;

  /// 上拉加载回调(null为不开启加载)
  OnRefreshCallback? onLoading;

  /// CustomHeader
  Header? header;

  /// CustomFooter
  Footer? footer;
  Widget? emptyWidget;

  /// 首次刷新
  bool firstRefresh;

  /// 首次刷新组件
  /// 不设置时使用header
  Widget? firstRefreshWidget;
}

class Refreshed extends StatefulWidget {
  Refreshed({
    Key? key,
    bool? firstRefresh,
    Header? header,
    this.firstRefreshWidget,
    required this.child,
    this.onLoading,
    this.onRefresh,
    this.footer,
    this.controller,
    this.scrollDirection,
    this.reverse,
    this.scrollController,
    this.primary,
    this.physics,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior,
    this.onTwoLevel,
    this.emptyWidget,
  })  : firstRefresh = firstRefresh ?? false,
        header = header ?? BezierCircleHeader(),
        super(key: key);

  ///  可不传controller，
  ///  若想关闭刷新组件可以通过发送消息
  ///  sendRefreshType(RefreshCompletedType.refresh);
  final EasyRefreshController? controller;

  /// 下拉刷新回调(null为不开启刷新)
  final OnRefreshCallback? onRefresh;

  /// 上拉加载回调(null为不开启加载)
  final OnRefreshCallback? onLoading;

  /// 二楼开启回调
  final VoidCallback? onTwoLevel;

  /// 要刷新的子组件
  final Widget child;

  /// CustomHeader
  final Header header;

  /// CustomFooter
  final Footer? footer;
  final Widget? emptyWidget;

  /// 首次刷新
  final bool firstRefresh;

  /// 首次刷新组件
  /// 不设置时使用header
  final Widget? firstRefreshWidget;

  final Axis? scrollDirection;
  final bool? reverse;
  final ScrollController? scrollController;
  final bool? primary;
  final ScrollPhysics? physics;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior? dragStartBehavior;

  @override
  _RefreshedState createState() => _RefreshedState();
}

class _RefreshedState extends State<Refreshed> {
  late EasyRefreshController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? EasyRefreshController();
    addPostFrameCallback(
        (Duration callback) => eventBus.add(refreshEvent, (dynamic data) {
              if (data == null) return;
              if (data != null && data is RefreshCompletedType) {
                switch (data) {
                  case RefreshCompletedType.refresh:
                    // controller.refreshCompleted();
                    break;
                  case RefreshCompletedType.refreshFailed:
                    // controller.refreshFailed();
                    break;
                  case RefreshCompletedType.refreshToIdle:
                    // controller.refreshToIdle();
                    break;
                  case RefreshCompletedType.onLoading:
                    // controller.loadComplete();
                    break;
                  case RefreshCompletedType.loadFailed:
                    // controller.loadFailed();
                    break;
                  case RefreshCompletedType.loadNoData:
                    // controller.loadNoData();
                    break;
                  case RefreshCompletedType.twoLevel:
                    // controller.twoLevelComplete();
                    break;
                }
              }
            }));
  }

  @override
  Widget build(BuildContext context) => EasyRefresh(
      child: widget.child,
      header: widget.header,
      footer: widget.footer,
      controller: controller,
      emptyWidget: widget.emptyWidget,
      firstRefresh: widget.firstRefresh,
      firstRefreshWidget: widget.firstRefreshWidget,
      onLoad: widget.onLoading,
      onRefresh: widget.onRefresh,
      scrollController: widget.scrollController);
}
