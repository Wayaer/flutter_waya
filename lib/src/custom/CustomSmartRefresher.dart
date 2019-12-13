import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/src/utils/Utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'CustomListView.dart';

class CustomSmartRefresher extends StatelessWidget {
  final RefreshController controller;
  final bool enablePullDown;
  final bool enablePullUp;
  final bool shrinkWrap;
  final VoidCallback onLoading;
  final VoidCallback onRefresh;
  final Widget loadingWidget;
  final Widget child;
  final Widget header;
  final Widget footer;
  ScrollPhysics physics;
  IndexedWidgetBuilder itemBuilder;
  int itemCount;

  CustomSmartRefresher({
    Key key,
    this.controller,
    this.enablePullDown: false,
    this.enablePullUp: false,
    this.onLoading,
    this.onRefresh,
    this.loadingWidget,
    this.child,
    this.footer,
    this.header,
    this.itemBuilder,
    this.itemCount,
    this.physics,
    this.shrinkWrap: true,
  }) : super(key: key);

  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  Timer timer;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller ?? refreshController,
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      header: header ?? WaterDropHeader(),
      footer: footer == null
          ? CustomFooter(
              builder: (BuildContext context, LoadStatus mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text('pull loading');
                } else if (mode == LoadStatus.loading) {
                  body = loadingWidget;
                } else if (mode == LoadStatus.failed) {
                  body = Text('load failed');
                } else if (mode == LoadStatus.canLoading) {
                  body = Text('load data');
                } else {
                  body = Text('load not data');
                }
                return Container(
                  height: 40,
                  child: Center(child: body),
                );
              },
            )
          : footer,
      onRefresh: onRefresh ?? onRefreshed,
      onLoading: onLoading ?? onLoadings,
      child: child == null
          ? CustomListView(
              physics: physics ?? ScrollPhysics(),
              shrinkWrap: shrinkWrap,
              itemCount: itemCount,
              itemBuilder: itemBuilder,
            )
          : child,
    );
  }

  onRefreshed() {
    Utils.log('onRefreshed');
    Utils.timerUtils(Duration(seconds: 4), () {
      refreshController.loadComplete();
    });
  }

  onLoadings() {
    Utils.log('onLoadings');
    Utils.timerUtils(Duration(seconds: 4), () {
      refreshController.loadComplete();
    });
  }
}
