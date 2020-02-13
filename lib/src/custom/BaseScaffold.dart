import 'package:flutter/gestures.dart';
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
  final bool isolationBody;
  final bool paddingStatusBar;
  final Color backgroundColor;
  final Widget body;
  final bool enablePullDown;

  //刷新组件相关
  RefreshController refreshController;
  final VoidCallback onRefresh;
  final Widget child;
  final Widget header;
  final Widget footer;
  final TextStyle footerTextStyle;

  //Scaffold相关属性
  Widget floatingActionButton;
  FloatingActionButtonAnimator floatingActionButtonAnimator;
  FloatingActionButtonLocation floatingActionButtonLocation;
  Widget bottomSheet;
  Widget endDrawer;
  Widget drawer;
  List<Widget> persistentFooterButtons;
  bool resizeToAvoidBottomPadding;
  bool extendBody;
  bool resizeToAvoidBottomInset;
  bool primary;
  DragStartBehavior drawerDragStartBehavior;

  //isScroll  和isolationBody（body隔离出一个横条目）  不可同时使用
  BaseScaffold({
    Key key,
    this.appBar,
    this.isScroll: false,
    this.isolationBody: false,
    this.body,
    this.paddingStatusBar: false,
    this.padding,
    this.refreshController,
    this.onRefresh,
    this.child,
    this.header,
    this.footer,
    this.footerTextStyle,
    this.enablePullDown: false,
    //
    this.floatingActionButton, //悬浮按钮
    this.floatingActionButtonLocation, //悬浮按钮位置
    this.floatingActionButtonAnimator, //悬浮按钮动画
    this.persistentFooterButtons, //固定在下方显示的按钮，比如对话框下方的确定、取消按钮
    this.drawer, //侧滑菜单左
    this.endDrawer, //侧滑菜单右
    this.bottomNavigationBar, //底部导航
    this.bottomSheet,
    this.backgroundColor, //内容的背景颜色，默认使用的是 ThemeData.scaffoldBackgroundColor 的值
    this.resizeToAvoidBottomPadding, //类似于 Android 中的 android:windowSoftInputMode=”adjustResize”，控制界面内容 body 是否重新布局来避免底部被覆盖了，比如当键盘显示的时候，重新布局避免被键盘盖住内容。默认值为 true。
    this.resizeToAvoidBottomInset,
    this.primary = true, //试用使用primary主色
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
  }) : super(key: key) {
    if (refreshController == null) {
      refreshController = RefreshController(initialRefresh: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: primary,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      drawerDragStartBehavior: drawerDragStartBehavior,
      bottomSheet: bottomSheet,
      extendBody: extendBody,
      resizeToAvoidBottomPadding: resizeToAvoidBottomPadding,
      endDrawer: endDrawer,
      drawer: drawer,
      persistentFooterButtons: persistentFooterButtons,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButton: floatingActionButton,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
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
    );
  }

  Widget container() {
    return Container(
      color: backgroundColor,
      margin: isolationBody ? EdgeInsets.only(top: BaseUtils.getHeight(10)) : EdgeInsets.zero,
      padding: paddingStatusBar ? EdgeInsets.only(top: MediaQueryUtils.getStatusBarHeight()) : padding,
      width: double.infinity,
      height: double.infinity,
      child: isScroll ? SingleChildScrollView(child: body) : body,
    );
  }
}
