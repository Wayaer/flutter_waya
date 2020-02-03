import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/utils/BaseUtils.dart';
import 'package:flutter_waya/src/utils/MediaQueryUtils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BaseScaffold extends StatelessWidget {
  final Widget bottomNavigationBar;
  final CustomAppBar appBar;
  final EdgeInsetsGeometry padding;
  final bool isScroll;
  final bool expandedBody;
  final bool paddingStatusBar;
  final Color backgroundColor;
  final Widget body;
  final bool enablePullDown;

  //刷新组件相关
  final RefreshController refreshController;
  final VoidCallback onRefresh;
  final Widget child;
  final Widget header;
  final Widget footer;
  final TextStyle footerTextStyle;

  //isScroll  和expandedBody  不可同时使用
  BaseScaffold({
    Key key,
    this.appBar,
    this.bottomNavigationBar,
    this.isScroll: false,
    this.expandedBody: false,
    this.body,
    this.backgroundColor,
    this.paddingStatusBar: false,
    this.padding,
    this.refreshController,
    this.onRefresh,
    this.child,
    this.header,
    this.footer,
    this.footerTextStyle,
    this.enablePullDown: false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? getColors(background),
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      body: bodyWidget(context),
    );
  }

  Widget bodyWidget(BuildContext context) {
    if (enablePullDown) {
      return refresherContainer();
    }
    return container();
  }

  Widget refresherContainer() {
    return Refresher(
        enablePullDown: enablePullDown,
        controller: refreshController,
        onRefresh: onRefresh,
        child: container(),
        header: header,
        footer: footer,
        footerTextStyle: footerTextStyle);
  }

  Widget container() {
    return Container(
      color: backgroundColor,
      margin: expandedBody
          ? EdgeInsets.only(top: BaseUtils.getHeight(10))
          : EdgeInsets.zero,
      padding: paddingStatusBar
          ? EdgeInsets.only(top: MediaQueryUtils.getStatusBarHeight())
          : padding,
      width: double.infinity,
      height: double.infinity,
      child: isScroll ? SingleChildScrollView(child: body) : body,
    );
  }
}
