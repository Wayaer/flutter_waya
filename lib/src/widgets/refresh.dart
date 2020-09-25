import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Refresh extends StatelessWidget {
  Refresh({
    Key key,
    bool enablePullDown,
    bool enablePullUp,
    bool enableTwoLevel,
    this.controller,
    this.footerTextStyle,
    this.onLoading,
    this.onRefresh,
    this.child,
    this.footer,
    this.header,
    this.onTwoLevel,
    this.onOffsetChange,
    this.dragStartBehavior,
    this.primary,
    this.cacheExtent,
    this.semanticChildCount,
    this.reverse,
    this.physics,
    this.scrollDirection,
    this.scrollController,
  })  : enablePullDown = enablePullDown ?? false,
        enablePullUp = enablePullUp ?? false,
        enableTwoLevel = enableTwoLevel ?? false,
        refreshController = RefreshController(initialRefresh: false),
        super(key: key);

  final RefreshController controller;
  final bool enablePullDown;
  final bool enablePullUp;
  final VoidCallback onLoading;
  final VoidCallback onRefresh;
  final Widget child;
  final Widget header;
  final Widget footer;
  final TextStyle footerTextStyle;
  final bool enableTwoLevel;

  ///二楼是否开启
  final VoidCallback onTwoLevel;
  final OnOffsetChange onOffsetChange;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController scrollController;
  final bool primary;
  final ScrollPhysics physics;
  final double cacheExtent;
  final int semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final RefreshController refreshController;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        controller: controller ?? refreshController,
        enablePullDown: enablePullDown,
        enablePullUp: enablePullUp,
        header: header ?? BezierCircleHeader(bezierColor: getColors(transparent)),
        footer: footer ?? customFooter(),
        onRefresh: onRefresh ?? onRefreshVoid,
        onLoading: onLoading ?? onLoadingVoid,
        child: child,
        enableTwoLevel: enableTwoLevel,
        onTwoLevel: onTwoLevel ?? onTwoLevelVoid,
        onOffsetChange: onOffsetChange,
        dragStartBehavior: dragStartBehavior,
        primary: primary,
        cacheExtent: cacheExtent,
        semanticChildCount: semanticChildCount,
        reverse: reverse,
        physics: physics,
        scrollDirection: scrollDirection,
        scrollController: scrollController);
  }

  Widget customFooter() => CustomFooter(
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
          return Container(height: getHeight(40), child: Center(child: body));
        },
      );

  Widget footerText(String text) =>
      Text(text, style: footerTextStyle ?? TextStyle(fontSize: 13, color: getColors(black70)));

  void onTwoLevelVoid() {
    log('onTwoLevel');
    Tools.timerTools(const Duration(seconds: 2), () => refreshController.twoLevelComplete());
  }

  void onRefreshVoid() {
    log('onRefresh');
    Tools.timerTools(const Duration(seconds: 2), () => refreshController.refreshCompleted());
  }

  void onLoadingVoid() {
    log('onLoading');
    Tools.timerTools(const Duration(seconds: 2), () => refreshController.loadComplete());
  }
}

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

  ///可不传controller，
  ///若想关闭刷新组件可以通过发送消息
  ///sendMessage(RefreshCompletedType.refresh);
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
    if (widget.controller == null) {
      Tools.addPostFrameCallback((Duration callback) => eventListen((dynamic data) {
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
                case RefreshCompletedType.onLoading:
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
  }

  @override
  Widget build(BuildContext context) => Refresh(
      controller: controller,
      enablePullUp: widget.enablePullUp,
      enablePullDown: widget.enablePullDown,
      enableTwoLevel: widget.enableTwoLevel,
      onLoading: widget.onLoading,
      onRefresh: widget.onRefresh,
      header: widget.header,
      footer: widget.footer,
      child: widget.child,
      onTwoLevel: widget.onTwoLevel,
      onOffsetChange: widget.onOffsetChange,
      dragStartBehavior: widget.dragStartBehavior,
      primary: widget.primary,
      cacheExtent: widget.cacheExtent,
      semanticChildCount: widget.semanticChildCount,
      reverse: widget.reverse,
      physics: widget.physics,
      scrollDirection: widget.scrollDirection,
      scrollController: widget.scrollController,
      footerTextStyle: widget.footerTextStyle);
}
