import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_waya/constant/way.dart';
import 'package:flutter_waya/flutter_waya.dart';

part 'root_part.dart';

GlobalKey<NavigatorState> _globalNavigatorKey = GlobalKey();
List<GlobalKey<State>> _scaffoldKeyList = <GlobalKey<State>>[];
List<OverlayEntryMap> _overlayEntryList = <OverlayEntryMap>[];
OverlayState _overlay;

///  GlobalWidgetsApp
class GlobalWidgetsApp extends StatelessWidget {
  GlobalWidgetsApp({
    Key key,
    Map<String, WidgetBuilder> routes,
    String title,
    ThemeMode themeMode,
    Locale locale,
    Color color,
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
    this.theme,
    this.darkTheme,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.shortcuts,
    this.actions,
    this.onGenerateInitialRoutes,
    this.inspectorSelectButtonBuilder,
    this.widgetMode,
    this.cupertinoTheme,
  })  : debugShowMaterialGrid = debugShowMaterialGrid ?? false,
        showPerformanceOverlay = showPerformanceOverlay ?? false,
        checkerboardRasterCacheImages = checkerboardRasterCacheImages ?? false,
        checkerboardOffscreenLayers = checkerboardOffscreenLayers ?? false,
        showSemanticsDebugger = showSemanticsDebugger ?? false,
        debugShowCheckedModeBanner = debugShowCheckedModeBanner ?? false,
        themeMode = themeMode ?? ThemeMode.system,
        title = title ?? '',
        color = color ?? getColors(white),
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

  ///  风格
  final WidgetMode widgetMode;

  ///  导航键
  final GlobalKey<NavigatorState> navigatorKey;

  ///  主页
  final Widget home;

  ///  初始路由
  final String initialRoute;

  ///  生成路由
  final RouteFactory onGenerateRoute;

  ///  未知路由
  final RouteFactory onUnknownRoute;

  ///  建造者
  final TransitionBuilder builder;

  ///  区域分辨回调
  final LocaleListResolutionCallback localeListResolutionCallback;

  final LocaleResolutionCallback localeResolutionCallback;

  ///  生成标题
  final GenerateAppTitle onGenerateTitle;

  ///  主题
  final ThemeData theme;

  ///  Cupertino主题
  final CupertinoThemeData cupertinoTheme;

  final ThemeData darkTheme;

  ///  颜色
  final Color color;

  ///  路由
  final Map<String, WidgetBuilder> routes;

  ///  导航观察器
  final List<NavigatorObserver> navigatorObservers;

  ///  本地化委托
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;

  ///  标题
  final String title;

  final ThemeMode themeMode;

  ///  地点
  final Locale locale;

  ///  支持区域
  final Iterable<Locale> supportedLocales;

  ///  显示性能叠加
  final bool showPerformanceOverlay;

  ///  棋盘格光栅缓存图像
  final bool checkerboardRasterCacheImages;

  final bool checkerboardOffscreenLayers;

  ///  显示语义调试器
  final bool showSemanticsDebugger;

  ///  调试显示检查模式横幅
  final bool debugShowCheckedModeBanner;

  final bool debugShowMaterialGrid;
  final Map<LogicalKeySet, Intent> shortcuts;
  final Map<Type, Action<Intent>> actions;
  final InitialRouteListFactory onGenerateInitialRoutes;
  final InspectorSelectButtonBuilder inspectorSelectButtonBuilder;

  @override
  Widget build(BuildContext context) {
    if (navigatorKey != null) _globalNavigatorKey = navigatorKey;
    if (theme != null ||
        debugShowMaterialGrid != null ||
        darkTheme != null ||
        themeMode != null ||
        widgetMode == WidgetMode.material) return materialApp();
    if (cupertinoTheme != null || widgetMode == WidgetMode.cupertino)
      return cupertinoApp();
    return WidgetsApp(
        key: key,
        navigatorKey: _globalNavigatorKey,
        home: home,
        routes: routes,
        initialRoute: initialRoute,
        pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
          if (widgetMode == WidgetMode.cupertino) {
            return CupertinoPageRoute<T>(settings: settings, builder: builder);
          } else {
            return MaterialPageRoute<T>(settings: settings, builder: builder);
          }
        },
        onGenerateRoute: onGenerateRoute,
        onGenerateInitialRoutes: onGenerateInitialRoutes,
        onUnknownRoute: onUnknownRoute,
        navigatorObservers: navigatorObservers,
        builder: builder,
        title: title,
        onGenerateTitle: onGenerateTitle,
        color: color,
        inspectorSelectButtonBuilder: inspectorSelectButtonBuilder,
        locale: locale,
        localizationsDelegates: localizationsDelegates,
        localeListResolutionCallback: localeListResolutionCallback,
        localeResolutionCallback: localeResolutionCallback,
        supportedLocales: supportedLocales,
        showPerformanceOverlay: showPerformanceOverlay,
        checkerboardRasterCacheImages: checkerboardRasterCacheImages,
        checkerboardOffscreenLayers: checkerboardOffscreenLayers,
        showSemanticsDebugger: showSemanticsDebugger,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        shortcuts: shortcuts,
        actions: actions);
  }

  Widget materialApp() => MaterialApp(
      key: key,
      navigatorKey: _globalNavigatorKey,
      home: home,
      routes: routes,
      initialRoute: initialRoute,
      debugShowMaterialGrid: debugShowMaterialGrid,
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
      showPerformanceOverlay: showPerformanceOverlay,
      checkerboardRasterCacheImages: checkerboardRasterCacheImages,
      checkerboardOffscreenLayers: checkerboardOffscreenLayers,
      showSemanticsDebugger: showSemanticsDebugger,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      shortcuts: shortcuts,
      actions: actions);

  Widget cupertinoApp() => CupertinoApp(
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
      theme: cupertinoTheme,
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      localeListResolutionCallback: localeListResolutionCallback,
      localeResolutionCallback: localeResolutionCallback,
      supportedLocales: supportedLocales,
      showPerformanceOverlay: showPerformanceOverlay,
      checkerboardRasterCacheImages: checkerboardRasterCacheImages,
      checkerboardOffscreenLayers: checkerboardOffscreenLayers,
      showSemanticsDebugger: showSemanticsDebugger,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      shortcuts: shortcuts,
      actions: actions);
}

///  OverlayScaffold
class OverlayScaffold extends StatefulWidget {
  const OverlayScaffold({
    Key key,
    bool paddingStatusBar,
    bool enablePullDown,
    bool enablePullUp,
    bool enableTwoLevel,
    bool primary,
    bool extendBody,
    bool isStack,
    bool isScroll,
    DragStartBehavior drawerDragStartBehavior,
    bool onWillPopOverlayClose,
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
    this.backgroundColor,

    /// 内容的背景颜色，默认使用的是 ThemeData.scaffoldBackgroundColor 的值
    this.resizeToAvoidBottomPadding,

    /// 类似于 Android 中的 android:windowSoftInputMode=”adjustResize”，
    /// 控制界面内容 body 是否重新布局来避免底部被覆盖了，比如当键盘显示的时候，
    /// 重新布局避免被键盘盖住内容。默认值为 true。
    this.resizeToAvoidBottomInset,
    this.onWillPop,
    this.appBarHeight,
    this.children,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.direction,
    this.onLoading,
    this.onTwoLevel,
    this.controller,
    this.onRefresh,
    this.header,
    this.footer,
  })  : onWillPopOverlayClose = onWillPopOverlayClose ?? false,
        paddingStatusBar = paddingStatusBar ?? false,
        enablePullDown = enablePullDown ?? false,
        enablePullUp = enablePullUp ?? false,
        enableTwoLevel = enableTwoLevel ?? false,
        primary = primary ?? true,
        extendBody = extendBody ?? false,
        isStack = isStack ?? false,
        isScroll = isScroll ?? false,
        drawerDragStartBehavior =
            drawerDragStartBehavior ?? DragStartBehavior.start,
        super(key: key);

  final Color backgroundColor;

  /// 主体部分
  final Widget body;

  /// 相当于给[body] 套用 [Column]、[Row]、[Stack]
  final List<Widget> children;

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

  /// [body]top padding 出状态栏高度 [padding]!=null 时此参数无效
  final bool paddingStatusBar;
  final EdgeInsetsGeometry padding;

  ///  true 点击android实体返回按键先关闭Overlay【toast loading ...】但不pop 当前页面
  ///  false 点击android实体返回按键先关闭Overlay【toast loading ...】并pop 当前页面
  final bool onWillPopOverlayClose;

  ///  返回按键监听
  final WillPopCallback onWillPop;

  ///  刷新组件相关
  final RefreshController controller;
  final bool enablePullDown;
  final bool enablePullUp;
  final bool enableTwoLevel;
  final Widget header;
  final Widget footer;
  final VoidCallback onRefresh;
  final VoidCallback onLoading;
  final VoidCallback onTwoLevel;

  ///  Scaffold相关属性
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
        body: widget.enablePullDown ||
                widget.enablePullUp ||
                widget.enableTwoLevel
            ? refresherUniversal
            : universal);
    if (widget.onWillPop != null || widget.onWillPopOverlayClose) {
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

  Refreshed get refresherUniversal => Refreshed(
      enablePullDown: widget.enablePullDown,
      enablePullUp: widget.enablePullUp,
      enableTwoLevel: widget.enableTwoLevel,
      onLoading: widget.onLoading,
      onTwoLevel: widget.onTwoLevel,
      controller: widget.controller,
      onRefresh: widget.onRefresh,
      child: universal,
      header: widget.header,
      footer: widget.footer);

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

  Universal get universal => Universal(
      color: widget.backgroundColor,
      padding: widget.paddingStatusBar
          ? EdgeInsets.only(top: getStatusBarHeight)
          : widget.padding,
      isScroll: widget.isScroll,
      isStack: widget.isStack,
      direction: widget.direction,
      children: widget.children,
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      child: widget.body);

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

///  ************ 以下为 路由跳转 *****************  ///
///
///  打开新页面
Future<dynamic> push(Widget widget,
    {WidgetBuilder builder,
    String title,
    RouteSettings settings,
    bool maintainState,
    bool fullscreenDialog,
    WidgetMode widgetMode}) {
  return _globalNavigatorKey.currentState.push(_pageRoute(
      title: title,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      settings: settings,
      pushMode: widgetMode,
      widget: widget));
}

/// 打开新页面替换当前页面
Future<dynamic> pushReplacement(Widget widget,
    {WidgetBuilder builder,
    String title,
    RouteSettings settings,
    bool maintainState,
    bool fullscreenDialog,
    WidgetMode widgetMode}) {
  return _globalNavigatorKey.currentState.pushReplacement(_pageRoute(
      title: title,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      settings: settings,
      pushMode: widgetMode,
      widget: widget));
}

/// 打开新页面 并移出堆栈所有页面
Future<dynamic> pushAndRemoveUntil(Widget widget,
    {WidgetBuilder builder,
    String title,
    RouteSettings settings,
    bool maintainState,
    bool fullscreenDialog,
    WidgetMode widgetMode}) {
  return _globalNavigatorKey.currentState.pushAndRemoveUntil(
      _pageRoute(
          title: title,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          settings: settings,
          builder: builder,
          pushMode: widgetMode,
          widget: widget),
      (_) => false);
}

/// 可能返回到上一个页面
Future<bool> maybePop<T extends Object>([dynamic result]) =>
    _globalNavigatorKey.currentState.maybePop<dynamic>(result);

/// 返回上一个页面
void pop<T extends Object>([dynamic result]) =>
    _globalNavigatorKey.currentState.pop<dynamic>(result);

/// 循环pop 直到pop至指定页面
void popUntil(RoutePredicate predicate) =>
    _globalNavigatorKey.currentState.popUntil(predicate);

WidgetMode _widgetMode;

void setGlobalPushMode(WidgetMode widgetMode) => _widgetMode = widgetMode;

Route<T> _pageRoute<T>(
    {WidgetBuilder builder,
    Widget widget,
    String title,
    RouteSettings settings,
    bool maintainState,
    bool fullscreenDialog,
    WidgetMode pushMode}) {
  assert(builder != null || widget != null);
  _widgetMode = pushMode ?? _widgetMode ?? WidgetMode.cupertino;
  if (_widgetMode == WidgetMode.cupertino) {
    return CupertinoPageRoute<T>(
        title: title,
        maintainState: maintainState ?? true,
        fullscreenDialog: fullscreenDialog ?? false,
        settings: settings,
        builder: builder ?? (_) => widget);
  }
  return MaterialPageRoute<T>(
      maintainState: maintainState ?? true,
      fullscreenDialog: fullscreenDialog ?? false,
      settings: settings,
      builder: builder ?? (_) => widget);
}
