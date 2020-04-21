import 'package:flutter/material.dart';
import 'package:flutter_waya/src/common/CommonWidget.dart';
import 'package:flutter_waya/src/widget/refresh/Refreshed.dart';
import 'package:flutter_waya/waya.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomListView extends StatelessWidget {
  final bool shrinkWrap;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final ScrollPhysics physics;
  final double itemExtent;
  final ScrollController controller;
  final EdgeInsetsGeometry padding;
  final Widget noData;

  //刷新组件相关
  final bool enablePullDown;
  final bool enablePullUp;
  final RefreshController refreshController;
  final VoidCallback onLoading;
  final VoidCallback onRefresh;
  final Widget header;
  final Widget footer;
  final TextStyle footerTextStyle;

  CustomListView({
    Key key,
    @required this.itemBuilder,
    @required this.itemCount,
    this.physics,
    this.controller,
    this.itemExtent,
    this.padding,
    this.noData,
    this.shrinkWrap: true,
    this.enablePullDown: false,
    this.enablePullUp: false,
    this.refreshController,
    this.onLoading,
    this.onRefresh,
    this.header,
    this.footer,
    this.footerTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (enablePullDown || enablePullUp) {
      return refresherListView();
    }
    return listViewBuilder();
  }

  Widget listViewBuilder() {
    return itemCount > 0
        ? ListView.builder(
      physics: physics,
      shrinkWrap: shrinkWrap,
      controller: controller,
      itemBuilder: itemBuilder,
      itemCount: itemCount,
      itemExtent: itemExtent,
      padding: padding,
    )
        : noData ?? CommonWidget.notDataWidget();
  }

  Widget refresherListView() {
    return Refreshed(
        enablePullDown: enablePullDown,
        enablePullUp: enablePullUp,
        controller: refreshController,
        onLoading: onLoading,
        onRefresh: onRefresh,
        child: listViewBuilder(),
        header: header,
        footer: footer,
        footerTextStyle: footerTextStyle);
  }
}
