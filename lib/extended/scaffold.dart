import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// ExtendedScaffold
class ExtendedScaffold extends StatelessWidget {
  const ExtendedScaffold({
    super.key,
    this.safeLeft = false,
    this.safeTop = false,
    this.safeRight = false,
    this.safeBottom = false,
    this.isStack = false,
    this.isScroll = false,
    this.onWillPopOverlayClose = false,
    this.useSingleChildScrollView = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.appBar,
    this.body,
    this.padding,
    this.floatingActionButton,

    /// 悬浮按钮
    this.floatingActionButtonLocation,

    /// 悬浮按钮位置
    this.floatingActionButtonAnimator,

    /// 悬浮按钮动画
    this.persistentFooterButtons,

    /// 固定在下方显示的按钮，比如对话框下方的确定、取消按钮
    this.drawer,

    /// 侧滑菜单左
    this.endDrawer,

    /// 侧滑菜单右
    this.bottomNavigationBar,

    /// 底部导航
    this.bottomSheet,

    /// 类似于 Android 中的 android:windowSoftInputMode=”adjustResize”，
    /// 控制界面内容 body 是否重新布局来避免底部被覆盖了，比如当键盘显示的时候，
    /// 重新布局避免被键盘盖住内容。默认值为 true。
    this.resizeToAvoidBottomInset,
    this.onDrawerChanged,
    this.onEndDrawerChanged,
    this.drawerEdgeDragWidth,
    this.drawerScrimColor,
    this.onWillPop,
    this.appBarHeight,
    this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.direction = Axis.vertical,
    this.margin,
    this.decoration,
    this.refreshConfig,
    this.restorationId,
    this.backgroundColor,
    this.systemOverlayStyle,
    this.persistentFooterAlignment = AlignmentDirectional.centerEnd,
  });

  /// 相当于给[body] 套用 [Column]、[Row]、[Stack]
  final List<Widget>? children;

  /// [children].length > 0 && [isStack]=false 有效;
  final MainAxisAlignment mainAxisAlignment;

  /// [children].length > 0 && [isStack]=false 有效;
  final CrossAxisAlignment crossAxisAlignment;

  /// [children].length > 0 && [isStack]=false 有效;
  final Axis direction;

  /// [children].length > 0有效;
  /// 添加 [Stack]组件
  final bool isStack;

  /// 是否添加滚动组件
  final bool isScroll;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;

  /// true 点击android实体返回按键先关闭Overlay【toast loading ...】但不pop 当前页面
  /// false 点击android实体返回按键先关闭Overlay【toast loading ...】并pop 当前页面
  final bool onWillPopOverlayClose;

  /// 返回按键监听
  final WillPopCallback? onWillPop;

  /// ****** 刷新组件相关 ******  ///
  final RefreshConfig? refreshConfig;

  final bool useSingleChildScrollView;

  /// 在不设置AppBar的时候 修改状态栏颜色
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// 限制 [appBar] 高度
  final double? appBarHeight;

  /// Scaffold相关属性
  final Widget? body;
  final Color? backgroundColor;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Widget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomSheet;
  final Widget? bottomNavigationBar;
  final DragStartBehavior drawerDragStartBehavior;
  final Widget? drawer;
  final DrawerCallback? onDrawerChanged;
  final Widget? endDrawer;
  final DrawerCallback? onEndDrawerChanged;
  final double? drawerEdgeDragWidth;
  final Color? drawerScrimColor;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final List<Widget>? persistentFooterButtons;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final String? restorationId;
  final AlignmentDirectional persistentFooterAlignment;

  /// ****** [SafeArea] ****** ///
  final bool safeLeft;
  final bool safeTop;
  final bool safeRight;
  final bool safeBottom;

  @override
  Widget build(BuildContext context) {
    final Widget scaffold = Scaffold(
        key: key,
        primary: primary,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        drawerDragStartBehavior: drawerDragStartBehavior,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        extendBody: extendBody,
        drawer: drawer,
        endDrawer: endDrawer,
        onDrawerChanged: onDrawerChanged,
        onEndDrawerChanged: onEndDrawerChanged,
        drawerScrimColor: drawerScrimColor,
        drawerEdgeDragWidth: drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
        persistentFooterButtons: persistentFooterButtons,
        floatingActionButtonLocation: floatingActionButtonLocation,
        floatingActionButton: floatingActionButton,
        floatingActionButtonAnimator: floatingActionButtonAnimator,
        backgroundColor: backgroundColor,
        appBar: buildAppBar(context),
        bottomNavigationBar: bottomNavigationBar,
        bottomSheet: bottomSheet,
        restorationId: restorationId,
        body: universal,
        persistentFooterAlignment: persistentFooterAlignment);
    return onWillPop != null || onWillPopOverlayClose
        ? WillPopScope(onWillPop: onWillPopFun, child: scaffold)
        : scaffold;
  }

  Future<bool> onWillPopFun() async {
    if (!GlobalOptions().scaffoldWillPop) {
      return (await onWillPop?.call()) ?? GlobalOptions().scaffoldWillPop;
    }
    if (onWillPopOverlayClose &&
        ExtendedOverlay().overlayEntryList.isNotEmpty) {
      closeOverlay();
      return (await onWillPop?.call()) ?? false;
    } else {
      return (await onWillPop?.call()) ?? true;
    }
  }

  PreferredSizeWidget? buildAppBar(BuildContext context) {
    if (appBar is AppBar && appBarHeight == null) return appBar as AppBar;
    return appBar == null
        ? null
        : PreferredSize(
            preferredSize:
                Size.fromHeight(context.padding.top + (appBarHeight ?? 30)),
            child: appBar!);
  }

  Universal get universal => Universal(
      expand: true,
      refreshConfig: refreshConfig,
      margin: margin,
      systemOverlayStyle: systemOverlayStyle,
      useSingleChildScrollView: useSingleChildScrollView,
      padding: padding,
      isScroll: isScroll,
      safeLeft: safeLeft,
      safeTop: safeTop,
      safeRight: safeRight,
      safeBottom: safeBottom,
      isStack: isStack,
      direction: direction,
      decoration: decoration,
      children: children,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      child: body);
}
