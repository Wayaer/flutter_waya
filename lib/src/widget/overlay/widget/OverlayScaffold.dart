import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/constant.dart';

class OverlayScaffold extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Widget body;
  final bool isScroll;
  final bool isolationBody;
  final bool paddingStatusBar;
  final bool enablePullDown;

  ///点击返回是否关闭叠层
  final bool onWillPopOverlayClose;

  ///返回按键监听
  final WillPopCallback onWillPop;

  ///hero 动画标记
  final String heroTag;

  //刷新组件相关
  final RefreshController controller;
  final VoidCallback onRefresh;
  final Widget child;
  final Widget header;
  final Widget footer;
  final TextStyle footerTextStyle;

  //Scaffold相关属性
  final Widget bottomNavigationBar;
  final Widget appBar;
  final double appBarHeight;
  final Widget floatingActionButton;
  final FloatingActionButtonAnimator floatingActionButtonAnimator;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final Widget bottomSheet;
  final Widget endDrawer;
  final Widget drawer;
  final List<Widget> persistentFooterButtons;
  final bool resizeToAvoidBottomPadding;
  final bool resizeToAvoidBottomInset;
  final bool primary;
  final bool extendBody;
  final DragStartBehavior drawerDragStartBehavior;

  //isScroll 和isolationBody（body隔离出一个横条目）  不可同时使用
  OverlayScaffold({
    Key key,
    bool isScroll,
    bool isolationBody,
    bool paddingStatusBar,
    bool enablePullDown,
    bool primary, //试用使用primary主色
    bool extendBody,
    DragStartBehavior drawerDragStartBehavior,
    double appBarHeight,
    bool onWillPopOverlayClose,
    this.appBar,
    this.body,
    this.padding,
    this.controller,
    this.onRefresh,
    this.child,
    this.header,
    this.footer,
    this.footerTextStyle,
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
    this.heroTag,
    this.onWillPop,
  })  : this.isScroll = isScroll ?? false,
        this.appBarHeight = appBarHeight ?? ScreenFit.getHeight(45),
        this.isolationBody = isolationBody ?? false,
        this.onWillPopOverlayClose = onWillPopOverlayClose ?? true,
        this.paddingStatusBar = paddingStatusBar ?? false,
        this.enablePullDown = enablePullDown ?? false,
        this.primary = primary ?? true,
        this.extendBody = extendBody ?? false,
        this.drawerDragStartBehavior =
            drawerDragStartBehavior ?? DragStartBehavior.start,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop ??
            () async {
              if (onWillPopOverlayClose) {
                if (overlayState.overlayEntries.length > 1) {
                  AlertTools.close();
                  return false;
                } else {
                  return true;
                }
              } else {
                return false;
              }
            },
        child: Scaffold(
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
          appBar: appBarHeight == null
              ? appBar
              : (appBar == null
                  ? null
                  : PreferredSize(
                      child: appBar,
                      preferredSize: Size.fromHeight(
                          MediaQueryTools.getStatusBarHeight() +
                              appBarHeight))),
          bottomNavigationBar: bottomNavigationBar,
          body: bodyWidget(context),
        ));
  }

  Widget bodyWidget(BuildContext context) {
    if (enablePullDown) return refresherContainer();
    return container();
  }

  Widget refresherContainer() {
    return Refreshed(
      enablePullDown: enablePullDown,
      controller: controller,
      onRefresh: onRefresh,
      child: container(),
      header: header,
    );
  }

  Widget hero(Widget child) {
    return heroTag == null ? child : Hero(tag: heroTag, child: child);
  }

  Widget container() {
    return hero(Container(
      color: backgroundColor,
      margin: isolationBody
          ? EdgeInsets.only(top: ScreenFit.getHeight(10))
          : EdgeInsets.zero,
      padding: paddingStatusBar
          ? EdgeInsets.only(top: MediaQueryTools.getStatusBarHeight())
          : padding,
      width: double.infinity,
      height: double.infinity,
      child: isScroll ? SingleChildScrollView(child: body) : body,
    ));
  }
}
