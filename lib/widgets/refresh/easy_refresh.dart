import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_waya/flutter_waya.dart';

void sendRefreshType([RefreshCompletedType? refresh]) =>
    eventBus.emit(refreshEvent, refresh ?? RefreshCompletedType.refreshSuccess);

class EasyRefreshConfig {
  EasyRefreshConfig({
    Header? header,
    this.controller,
    this.onRefresh,
    this.onLoading,
    this.footer,
  }) : header = header ?? BezierCircleHeader();

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

class EasyRefreshed extends StatefulWidget {
  const EasyRefreshed({
    Key? key,
    bool? reverse,
    bool? shrinkWrap,
    Axis? scrollDirection,
    DragStartBehavior? dragStartBehavior,
    this.controller,
    this.onRefresh,
    this.onLoading,
    this.header,
    this.footer,
    required this.slivers,
    this.cacheExtent,
    this.primary,
    this.scrollController,
  })  : scrollDirection = scrollDirection ?? Axis.vertical,
        shrinkWrap = shrinkWrap ?? false,
        reverse = reverse ?? false,
        dragStartBehavior = dragStartBehavior ?? DragStartBehavior.start,
        super(key: key);

  ///  可不传controller，
  ///  若想关闭刷新组件可以通过发送消息
  ///  sendRefreshType(RefreshCompletedType.refresh);
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

  /// 当嵌套在无限长的组件里时必须设置为true
  final bool shrinkWrap;

  @override
  _EasyRefreshedState createState() => _EasyRefreshedState();
}

class _EasyRefreshedState extends State<EasyRefreshed> {
  late EasyRefreshController controller;
  int i = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? EasyRefreshController();
    addPostFrameCallback(
        (Duration callback) => eventBus.add(refreshEvent, (dynamic data) {
              if (data == null) return;
              if (data != null && data is RefreshCompletedType) {
                timer = 1.seconds.timerPeriodic((Timer t) {
                  i += 1;
                  if (i >= 3) {
                    i = 0;
                    if (timer != null) {
                      timer!.cancel();
                      timer = null;
                    }
                  }
                });
                if (i > 0) return;
                log('刷新组件结束');
                switch (data) {
                  case RefreshCompletedType.refresh:
                    controller.callRefresh();
                    break;
                  case RefreshCompletedType.refreshSuccess:
                    controller.finishRefresh(success: true);
                    break;
                  case RefreshCompletedType.refreshFailed:
                    controller.finishRefresh(success: false);
                    break;
                  case RefreshCompletedType.loading:
                    controller.callLoad();
                    break;
                  case RefreshCompletedType.loadingSuccess:
                    controller.finishLoad();
                    break;
                  case RefreshCompletedType.loadFailed:
                    controller.finishLoad(success: false);
                    break;
                }
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.custom(
        enableControlFinishRefresh: true,
        enableControlFinishLoad: true,
        controller: controller,
        header: widget.header,
        footer: widget.footer,
        onLoad: widget.onLoading,
        onRefresh: widget.onRefresh,
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
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
  }
}
