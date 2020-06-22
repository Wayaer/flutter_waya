import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/widgets.dart';
import 'package:flutter_waya/src/widget/refresh/Refreshed.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListBuilder extends StatelessWidget {
  final bool shrinkWrap;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final ScrollPhysics physics;
  final double itemExtent;
  final ScrollController controller;
  final EdgeInsetsGeometry padding;
  final Widget noData;

  ///刷新组件相关
  final bool enablePullDown;
  final bool enablePullUp;
  final RefreshController refreshController;
  final VoidCallback onLoading;
  final VoidCallback onRefresh;
  final Widget header;
  final Widget footer;
  final TextStyle footerTextStyle;
  final Axis scrollDirection;

  ///是否逆转
  final bool reverse;

  ListBuilder({
    Key key,
    @required this.itemBuilder,
    @required this.itemCount,
    this.physics,
    this.controller,
    this.itemExtent,
    Axis scrollDirection,
    EdgeInsetsGeometry padding,
    bool reverse,
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
  })  : this.padding = padding ?? EdgeInsets.zero,
        this.scrollDirection = scrollDirection ?? Axis.vertical,
        this.reverse = reverse ?? false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (enablePullDown || enablePullUp) {
      return refresherListView();
    }
    return listViewBuilder();
  }

  Widget listViewBuilder() {
    if (itemCount == 0) {
      return noData ??
          Widgets.notDataWidget(
              margin: EdgeInsets.all(Tools.getWidth(10)));
    }
    return ListView.builder(
      scrollDirection: scrollDirection,
      physics: physics,
      reverse: reverse,
      shrinkWrap: shrinkWrap,
      controller: controller,
      itemBuilder: itemBuilder,
      itemCount: itemCount,
      itemExtent: itemExtent,
      padding: padding,
    );
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
