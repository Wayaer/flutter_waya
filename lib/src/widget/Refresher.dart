import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/utils/BaseUtils.dart';
import 'package:flutter_waya/src/utils/LogUtils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Refresher extends StatelessWidget {
  final RefreshController controller;
  final bool enablePullDown;
  final bool enablePullUp;
  final VoidCallback onLoading;
  final VoidCallback onRefresh;
  final Widget child;
  final Widget header;
  final Widget footer;
  final TextStyle footerTextStyle;

  //
  final bool enableTwoLevel; //二楼是否开启
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

  Refresher({
    Key key,
    this.controller,
    this.footerTextStyle,
    this.enablePullDown: false,
    this.enablePullUp: false,
    this.onLoading,
    this.onRefresh,
    this.child,
    this.footer,
    this.header,
    this.enableTwoLevel: false,
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
  }) : super(key: key);

  RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller ?? refreshController,
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      header: header ??
          BezierCircleHeader(
            bezierColor: Colors.transparent,
          ),
      footer: footer ??
          CustomFooter(
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
                height: BaseUtils.getHeight(40),
                child: Center(child: body),
              );
            },
          ),
      onRefresh: onRefresh ?? onRefreshed,
      onLoading: onLoading ?? onLoadings,
      child: child,
      enableTwoLevel: false,
      onTwoLevel: onTwoLevel,
      onOffsetChange: onOffsetChange,
      dragStartBehavior: dragStartBehavior,
      primary: primary,
      cacheExtent: cacheExtent,
      semanticChildCount: semanticChildCount,
      reverse: reverse,
      physics: physics,
      scrollDirection: scrollDirection,
      scrollController: scrollController,
    );
  }

  Widget footerText(String text) {
    return Text(
      text,
      style: footerTextStyle ?? TextStyle(fontSize: 13, color: getColors(black70)),
    );
  }

  onRefreshed() {
    log('onRefreshed');
    BaseUtils.timerUtils(Duration(seconds: 4), () {
      refreshController.refreshCompleted();
    });
  }

  onLoadings() {
    log('onLoadings');
    BaseUtils.timerUtils(Duration(seconds: 4), () {
      refreshController.loadComplete();
    });
  }
}
