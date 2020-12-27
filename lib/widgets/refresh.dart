import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/constant/way.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Refreshed extends StatefulWidget {
  const Refreshed(
      {Key key,
      this.child,
      this.onTwoLevel,
      this.enablePullDown,
      this.onLoading,
      this.enablePullUp,
      this.onRefresh,
      this.header,
      this.footer,
      this.controller,
      this.onOffsetChange,
      this.scrollDirection,
      this.reverse,
      this.scrollController,
      this.primary,
      this.physics,
      this.cacheExtent,
      this.semanticChildCount,
      this.dragStartBehavior,
      this.footerTextStyle,
      this.enableTwoLevel})
      : super(key: key);

  ///  可不传controller，
  ///  若想关闭刷新组件可以通过发送消息
  ///  sendMessage(RefreshCompletedType.refresh);
  final RefreshController controller;
  final VoidCallback onRefresh;
  final VoidCallback onLoading;
  final VoidCallback onTwoLevel;
  final Widget child;
  final bool enablePullDown;
  final bool enablePullUp;
  final bool enableTwoLevel;
  final Widget header;
  final Widget footer;

  final OnOffsetChange onOffsetChange;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController scrollController;
  final bool primary;
  final ScrollPhysics physics;
  final double cacheExtent;
  final int semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final TextStyle footerTextStyle;

  @override
  _RefreshedState createState() => _RefreshedState();
}

class _RefreshedState extends State<Refreshed> {
  RefreshController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? RefreshController(initialRefresh: false);
    Ts.addPostFrameCallback((Duration callback) => eventListen((dynamic data) {
          if (data == null) return;
          if (data != null && data is RefreshCompletedType) {
            switch (data) {
              case RefreshCompletedType.refresh:
                controller?.refreshCompleted();
                break;
              case RefreshCompletedType.refreshFailed:
                controller?.refreshFailed();
                break;
              case RefreshCompletedType.refreshToIdle:
                controller?.refreshToIdle();
                break;
              case RefreshCompletedType.onLoading:
                controller?.loadComplete();
                break;
              case RefreshCompletedType.loadFailed:
                controller?.loadFailed();
                break;
              case RefreshCompletedType.loadNoData:
                controller?.loadNoData();
                break;
              case RefreshCompletedType.twoLevel:
                controller?.twoLevelComplete();
                break;
            }
          }
        }));
  }

  @override
  Widget build(BuildContext context) => SmartRefresher(
      controller: controller,
      enablePullDown: widget.enablePullDown,
      enablePullUp: widget.enablePullUp,
      header: widget.header ??
          BezierCircleHeader(bezierColor: getColors(transparent)),
      footer: widget.footer ?? customFooter,
      onRefresh: widget.onRefresh ?? onRefreshVoid,
      onLoading: widget.onLoading ?? onLoadingVoid,
      child: widget.child,
      enableTwoLevel: widget.enableTwoLevel,
      onTwoLevel: widget.onTwoLevel ?? onTwoLevelVoid,
      onOffsetChange: widget.onOffsetChange,
      dragStartBehavior: widget.dragStartBehavior,
      primary: widget.primary,
      cacheExtent: widget.cacheExtent,
      semanticChildCount: widget.semanticChildCount,
      reverse: widget.reverse,
      physics: widget.physics,
      scrollDirection: widget.scrollDirection,
      scrollController: widget.scrollController);

  Widget get customFooter => CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = footerText('pull loading');
          } else if (mode == LoadStatus.loading) {
            body = footerText('loading');
          } else if (mode == LoadStatus.failed) {
            body = footerText('load failed');
          } else if (mode == LoadStatus.canLoading) {
            body = footerText('load data');
          } else {
            body = footerText('load not data');
          }
          return Container(
              height: 40, alignment: Alignment.center, child: body);
        },
      );

  Widget footerText(String text) => Text(text,
      style: widget.footerTextStyle ??
          BaseTextStyle(fontSize: 13, color: getColors(black70)));

  void onTwoLevelVoid() {
    log('onTwoLevel');
    Ts.timerTs(const Duration(seconds: 2), () => controller.twoLevelComplete());
  }

  void onRefreshVoid() {
    log('onRefresh');
    Ts.timerTs(const Duration(seconds: 2), () => controller.refreshCompleted());
  }

  void onLoadingVoid() {
    log('onLoading');
    Ts.timerTs(const Duration(seconds: 2), () => controller.loadComplete());
  }
}
