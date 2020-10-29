import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/way.dart';

part 'root_part.dart';

GlobalKey<NavigatorState> _globalNavigatorKey = GlobalKey();
List<GlobalKey<State>> _scaffoldKeyList = <GlobalKey<State>>[];
List<OverlayEntryMap> _overlayEntryList = <OverlayEntryMap>[];
OverlayState _overlay;

///GlobalMaterial
class GlobalMaterial extends StatelessWidget {
  GlobalMaterial({
    Key key,
    Map<String, WidgetBuilder> routes,
    String title,
    ThemeMode themeMode,
    Locale locale,
    Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    Iterable<Locale> supportedLocales,
    bool debugShowMaterialGrid,
    bool showPerformanceOverlay,
    bool checkerboardRasterCacheImages,
    bool checkerboardOffscreenLayers,
    bool showSemanticsDebugger,
    bool debugShowCheckedModeBanner,
    List<NavigatorObserver> navigatorObservers,
    this.navigatorKey,
    this.home,
    this.initialRoute,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.builder,
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.shortcuts,
    this.actions,
    this.onGenerateInitialRoutes,
  })  : debugShowMaterialGrid = debugShowMaterialGrid ?? false,
        showPerformanceOverlay = showPerformanceOverlay ?? false,
        checkerboardRasterCacheImages = checkerboardRasterCacheImages ?? false,
        checkerboardOffscreenLayers = checkerboardOffscreenLayers ?? false,
        showSemanticsDebugger = showSemanticsDebugger ?? false,
        debugShowCheckedModeBanner = debugShowCheckedModeBanner ?? false,
        themeMode = themeMode ?? ThemeMode.system,
        title = title ?? '',
        routes = routes ?? const <String, WidgetBuilder>{},
        navigatorObservers = navigatorObservers ?? <NavigatorObserver>[],
        locale = locale ?? const Locale('zh'),
        supportedLocales = supportedLocales ??
            <Locale>[const Locale('zh', 'CH'), const Locale('en', 'US')],
        localizationsDelegates = localizationsDelegates ??
            <LocalizationsDelegate<dynamic>>[
              DefaultCupertinoLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
        super(key: key);

  ///导航键
  final GlobalKey<NavigatorState> navigatorKey;

  ///主页
  final Widget home;

  ///初始路由
  final String initialRoute;

  ///生成路由
  final RouteFactory onGenerateRoute;

  ///未知路由
  final RouteFactory onUnknownRoute;

  ///建造者
  final TransitionBuilder builder;

  ///区域分辨回调
  final LocaleListResolutionCallback localeListResolutionCallback;

  final LocaleResolutionCallback localeResolutionCallback;

  ///生成标题
  final GenerateAppTitle onGenerateTitle;

  ///主题
  final ThemeData theme;

  final ThemeData darkTheme;

  ///颜色
  final Color color;

  ///路由
  final Map<String, WidgetBuilder> routes;

  ///导航观察器
  final List<NavigatorObserver> navigatorObservers;

  ///本地化委托
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;

  ///标题
  final String title;

  final ThemeMode themeMode;

  ///地点
  final Locale locale;

  ///支持区域
  final Iterable<Locale> supportedLocales;

  ///显示性能叠加
  final bool showPerformanceOverlay;

  ///棋盘格光栅缓存图像
  final bool checkerboardRasterCacheImages;

  final bool checkerboardOffscreenLayers;

  ///显示语义调试器
  final bool showSemanticsDebugger;

  ///调试显示检查模式横幅
  final bool debugShowCheckedModeBanner;

  final bool debugShowMaterialGrid;
  final Map<LogicalKeySet, Intent> shortcuts;
  final Map<Type, Action<Intent>> actions;
  final InitialRouteListFactory onGenerateInitialRoutes;

  @override
  Widget build(BuildContext context) {
    if (navigatorKey != null) _globalNavigatorKey = navigatorKey;
    return MaterialApp(
        key: key,
        navigatorKey: _globalNavigatorKey,
        home: home,
        routes: routes,
        initialRoute: initialRoute,
        onGenerateRoute: onGenerateRoute,
        onGenerateInitialRoutes: onGenerateInitialRoutes,
        onUnknownRoute: onUnknownRoute,
        navigatorObservers: navigatorObservers,
        builder: builder,
        title: title,
        onGenerateTitle: onGenerateTitle,
        color: color,
        theme: theme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        locale: locale,
        localizationsDelegates: localizationsDelegates,
        localeListResolutionCallback: localeListResolutionCallback,
        localeResolutionCallback: localeResolutionCallback,
        supportedLocales: supportedLocales,
        debugShowMaterialGrid: debugShowMaterialGrid,
        showPerformanceOverlay: showPerformanceOverlay,
        checkerboardRasterCacheImages: checkerboardRasterCacheImages,
        checkerboardOffscreenLayers: checkerboardOffscreenLayers,
        showSemanticsDebugger: showSemanticsDebugger,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        shortcuts: shortcuts,
        actions: actions);
  }
}

///GlobalCupertino
class GlobalCupertino extends StatelessWidget {
  GlobalCupertino({
    Key key,
    Iterable<Locale> supportedLocales,
    Locale locale,
    Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    Map<String, WidgetBuilder> routes,
    List<NavigatorObserver> navigatorObservers,
    String title,
    bool showPerformanceOverlay,
    bool checkerboardRasterCacheImages,
    bool checkerboardOffscreenLayers,
    bool showSemanticsDebugger,
    bool debugShowCheckedModeBanner,
    this.navigatorKey,
    this.home,
    this.theme,
    this.initialRoute,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.builder,
    this.onGenerateTitle,
    this.color,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
  })  : showPerformanceOverlay = showPerformanceOverlay ?? false,
        checkerboardRasterCacheImages = checkerboardRasterCacheImages ?? false,
        checkerboardOffscreenLayers = checkerboardOffscreenLayers ?? false,
        showSemanticsDebugger = showSemanticsDebugger ?? false,
        debugShowCheckedModeBanner = debugShowCheckedModeBanner ?? false,
        title = title ?? '',
        routes = routes ?? const <String, WidgetBuilder>{},
        navigatorObservers = navigatorObservers ?? <NavigatorObserver>[],
        locale = locale ?? const Locale('zh', 'CN'),
        supportedLocales = supportedLocales ??
            <Locale>[const Locale('zh', 'CN'), const Locale('en', 'US')],
        localizationsDelegates = localizationsDelegates ??
            <LocalizationsDelegate<dynamic>>[
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
        super(key: key);

  final Iterable<Locale> supportedLocales;
  final Locale locale;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final List<NavigatorObserver> navigatorObservers;
  final Map<String, WidgetBuilder> routes;
  final String title;
  final bool showPerformanceOverlay;
  final bool checkerboardRasterCacheImages;
  final bool checkerboardOffscreenLayers;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget home;
  final CupertinoThemeData theme;
  final String initialRoute;
  final RouteFactory onGenerateRoute;
  final RouteFactory onUnknownRoute;
  final TransitionBuilder builder;
  final GenerateAppTitle onGenerateTitle;
  final Color color;
  final LocaleListResolutionCallback localeListResolutionCallback;
  final LocaleResolutionCallback localeResolutionCallback;

  @override
  Widget build(BuildContext context) {
    if (navigatorKey != null) _globalNavigatorKey = navigatorKey;
    return CupertinoApp(
        key: key,
        navigatorKey: _globalNavigatorKey,
        home: home,
        theme: theme,
        routes: routes,
        initialRoute: initialRoute,
        onGenerateRoute: onGenerateRoute,
        onUnknownRoute: onUnknownRoute,
        navigatorObservers: navigatorObservers,
        builder: builder,
        title: title,
        onGenerateTitle: onGenerateTitle,
        color: color,
        locale: locale,
        localizationsDelegates: localizationsDelegates,
        localeListResolutionCallback: localeListResolutionCallback,
        localeResolutionCallback: localeResolutionCallback,
        supportedLocales: supportedLocales,
        showPerformanceOverlay: showPerformanceOverlay,
        checkerboardRasterCacheImages: checkerboardRasterCacheImages,
        checkerboardOffscreenLayers: checkerboardOffscreenLayers,
        showSemanticsDebugger: showSemanticsDebugger,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner);
  }
}

///OverlayScaffold
class OverlayScaffold extends StatefulWidget {
  //isScroll 和 isolationBody（body隔离出一个横条目）  不可同时使用
  const OverlayScaffold({
    Key key,
    bool isScroll,
    bool isolationBody,
    bool paddingStatusBar,
    bool enablePullDown,
    bool primary, //试用使用primary主色
    bool extendBody,
    DragStartBehavior drawerDragStartBehavior,
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
    this.onWillPop,
    this.appBarHeight,
  })  : isScroll = isScroll ?? false,
        isolationBody = isolationBody ?? false,
        onWillPopOverlayClose = onWillPopOverlayClose ?? false,
        paddingStatusBar = paddingStatusBar ?? false,
        enablePullDown = enablePullDown ?? false,
        primary = primary ?? true,
        extendBody = extendBody ?? false,
        drawerDragStartBehavior =
            drawerDragStartBehavior ?? DragStartBehavior.start,
        super(key: key);

  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Widget body;
  final bool isScroll;
  final bool isolationBody;
  final bool paddingStatusBar;
  final bool enablePullDown;

  ///true 点击android实体返回按键先关闭Overlay【toast loading ...】但不pop 当前页面
  ///false 点击android实体返回按键先关闭Overlay【toast loading ...】并pop 当前页面
  final bool onWillPopOverlayClose;

  ///返回按键监听
  final WillPopCallback onWillPop;

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

  @override
  _OverlayScaffoldState createState() => _OverlayScaffoldState();
}

bool scaffoldWillPop = true;

class _OverlayScaffoldState extends State<OverlayScaffold> {
  GlobalKey<State> _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.key != null)
      _globalKey = widget.key as GlobalKey<State<StatefulWidget>>;
  }

  @override
  Widget build(BuildContext context) {
    Widget scaffold = Scaffold(
        key: _globalKey,
        primary: widget.primary,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        drawerDragStartBehavior: widget.drawerDragStartBehavior,
        bottomSheet: widget.bottomSheet,
        extendBody: widget.extendBody,
        resizeToAvoidBottomPadding: widget.resizeToAvoidBottomPadding,
        endDrawer: widget.endDrawer,
        drawer: widget.drawer,
        persistentFooterButtons: widget.persistentFooterButtons,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
        backgroundColor: widget.backgroundColor ?? getColors(background),
        appBar: appBar(),
        bottomNavigationBar: widget.bottomNavigationBar,
        body: widget.enablePullDown ? refresherContainer() : container());
    if (widget.onWillPop != null ||
        (isAndroid && widget.onWillPopOverlayClose)) {
      scaffold = WillPopScope(
          child: scaffold, onWillPop: widget.onWillPop ?? onWillPop);
    }
    if (!_scaffoldKeyList.contains(_globalKey))
      _scaffoldKeyList.add(_globalKey);
    return scaffold;
  }

  Future<bool> onWillPop() async {
    if (!scaffoldWillPop) return scaffoldWillPop;
    if (widget.onWillPopOverlayClose &&
        _overlayEntryList.isNotEmpty &&
        !_overlayEntryList.last.isAutomaticOff) {
      closeOverlay();
      return false;
    }
    return true;
  }

  Widget refresherContainer() => Refreshed(
      enablePullDown: widget.enablePullDown,
      controller: widget.controller,
      onRefresh: widget.onRefresh,
      child: container(),
      header: widget.header);

  PreferredSizeWidget appBar() {
    if (widget.appBar is AppBar && widget.appBarHeight == null)
      return widget.appBar as AppBar;
    return widget.appBar == null
        ? null
        : PreferredSize(
            child: widget.appBar,
            preferredSize: Size.fromHeight(
                getStatusBarHeight + widget.appBarHeight ?? 30));
  }

  Widget container() => Container(
      color: widget.backgroundColor,
      margin: widget.isolationBody
          ? EdgeInsets.only(top: getHeight(10))
          : EdgeInsets.zero,
      padding: widget.paddingStatusBar
          ? EdgeInsets.only(top: getStatusBarHeight)
          : widget.padding,
      width: double.infinity,
      height: double.infinity,
      child: widget.isScroll
          ? SingleChildScrollView(child: widget.body)
          : widget.body);

  @override
  void deactivate() {
    super.deactivate();
    if (!widget.onWillPopOverlayClose &&
        _overlayEntryList.isNotEmpty &&
        !_overlayEntryList.last.isAutomaticOff) closeOverlay();
  }

  @override
  void dispose() {
    super.dispose();
    if (_scaffoldKeyList.contains(_globalKey))
      _scaffoldKeyList.remove(_globalKey);
  }
}

///************ 以下为 路由跳转 *****************///
Future<dynamic> push(
    {WidgetBuilder builder,
    Widget widget,
    String title,
    RouteSettings settings,
    bool maintainState,
    bool fullscreenDialog,
    PushMode pushMode}) {
  return Navigator.of(_globalNavigatorKey.currentContext).push(_pageRoute(
      title: title,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      settings: settings,
      builder: builder,
      pushMode: pushMode,
      widget: widget));
}

Future<dynamic> pushReplacement(
    {WidgetBuilder builder,
    Widget widget,
    String title,
    RouteSettings settings,
    bool maintainState,
    bool fullscreenDialog,
    PushMode pushMode}) {
  return Navigator.of(_globalNavigatorKey.currentContext).pushReplacement(
      _pageRoute(
          title: title,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          settings: settings,
          builder: builder,
          pushMode: pushMode,
          widget: widget));
}

Future<dynamic> pushAndRemoveUntil(
    {WidgetBuilder builder,
    Widget widget,
    String title,
    RouteSettings settings,
    bool maintainState,
    bool fullscreenDialog,
    PushMode pushMode}) {
  return Navigator.of(_globalNavigatorKey.currentContext).pushAndRemoveUntil(
      _pageRoute(
          title: title,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          settings: settings,
          builder: builder,
          pushMode: pushMode,
          widget: widget),
      (_) => false);
}

void pop<T extends Object>([dynamic result]) =>
    Navigator.of(_globalNavigatorKey.currentContext).pop<dynamic>(result);

PushMode _pushMode;

void setGlobalPushMode(PushMode pushMode) => _pushMode = pushMode;

Route<T> _pageRoute<T>({
  WidgetBuilder builder,
  Widget widget,
  String title,
  RouteSettings settings,
  bool maintainState,
  bool fullscreenDialog,
  PushMode pushMode,
}) {
  assert(builder != null || widget != null);
  if (pushMode == null && _pushMode != null) pushMode = _pushMode;
  pushMode ??= PushMode.cupertino;
  if (pushMode == PushMode.cupertino) {
    return CupertinoPageRoute<T>(
        title: title,
        maintainState: maintainState ?? true,
        fullscreenDialog: fullscreenDialog ?? false,
        settings: settings,
        builder: builder ?? (BuildContext context) => widget);
  }
  return MaterialPageRoute<T>(
      maintainState: maintainState ?? true,
      fullscreenDialog: fullscreenDialog ?? false,
      settings: settings,
      builder: builder ?? (BuildContext context) => widget);
}

