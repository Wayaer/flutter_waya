import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

part 'root_part.dart';

GlobalKey<NavigatorState> _globalNavigatorKey = GlobalKey();
GlobalKey<ScaffoldMessengerState>? _scaffoldMessengerKey;
List<ExtendOverlayEntry> _overlayEntryList = <ExtendOverlayEntry>[];
EventBus eventBus = EventBus();

enum WidgetMode {
  ///  Cupertino风格
  cupertino,

  ///  Material风格
  material,

  ///
  ripple,
}

///  GlobalWidgetsApp
class GlobalWidgetsApp extends StatelessWidget {
  GlobalWidgetsApp({
    Key? key,
    Map<String, WidgetBuilder>? routes,
    String? title,
    ThemeMode? themeMode,
    Locale? locale,
    Color? color,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    Iterable<Locale>? supportedLocales,
    bool? debugShowMaterialGrid,
    bool? showPerformanceOverlay,
    bool? checkerboardRasterCacheImages,
    bool? checkerboardOffscreenLayers,
    bool? showSemanticsDebugger,
    bool? debugShowCheckedModeBanner,
    List<NavigatorObserver>? navigatorObservers,
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
    this.scaffoldMessengerKey,
  })  : debugShowMaterialGrid = debugShowMaterialGrid ?? false,
        showPerformanceOverlay = showPerformanceOverlay ?? false,
        checkerboardRasterCacheImages = checkerboardRasterCacheImages ?? false,
        checkerboardOffscreenLayers = checkerboardOffscreenLayers ?? false,
        showSemanticsDebugger = showSemanticsDebugger ?? false,
        debugShowCheckedModeBanner = debugShowCheckedModeBanner ?? false,
        themeMode = themeMode ?? ThemeMode.system,
        title = title ?? '',
        color = color ?? ConstColors.white,
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
  final WidgetMode? widgetMode;

  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  ///  导航键
  final GlobalKey<NavigatorState>? navigatorKey;

  ///  主页
  final Widget? home;

  ///  初始路由
  final String? initialRoute;

  ///  生成路由
  final RouteFactory? onGenerateRoute;

  ///  未知路由
  final RouteFactory? onUnknownRoute;

  ///  建造者
  final TransitionBuilder? builder;

  ///  区域分辨回调
  final LocaleListResolutionCallback? localeListResolutionCallback;

  final LocaleResolutionCallback? localeResolutionCallback;

  ///  生成标题
  final GenerateAppTitle? onGenerateTitle;

  ///  主题
  final ThemeData? theme;

  ///  Cupertino主题
  final CupertinoThemeData? cupertinoTheme;

  final ThemeData? darkTheme;

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
  final Map<LogicalKeySet, Intent>? shortcuts;
  final Map<Type, Action<Intent>>? actions;
  final InitialRouteListFactory? onGenerateInitialRoutes;
  final InspectorSelectButtonBuilder? inspectorSelectButtonBuilder;

  @override
  Widget build(BuildContext context) {
    if (navigatorKey != null) _globalNavigatorKey = navigatorKey!;
    if (theme != null || darkTheme != null || widgetMode == WidgetMode.material)
      return materialApp;
    if (cupertinoTheme != null || widgetMode == WidgetMode.cupertino)
      return cupertinoApp;
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

  Widget get materialApp {
    _scaffoldMessengerKey =
        scaffoldMessengerKey ?? GlobalKey<ScaffoldMessengerState>();
    return MaterialApp(
        key: key,
        navigatorKey: _globalNavigatorKey,
        scaffoldMessengerKey: _scaffoldMessengerKey,
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
  }

  Widget get cupertinoApp => CupertinoApp(
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

bool scaffoldWillPop = true;

///  OverlayScaffold
class OverlayScaffold extends StatelessWidget {
  const OverlayScaffold({
    Key? key,
    bool? paddingStatusBar,
    bool? primary,
    bool? extendBody,
    bool? extendBodyBehindAppBar,
    bool? isStack,
    bool? isScroll,
    DragStartBehavior? drawerDragStartBehavior,
    bool? onWillPopOverlayClose,
    bool? useSingleChildScrollView,
    bool? drawerEnableOpenDragGesture,
    bool? endDrawerEnableOpenDragGesture,
    Color? backgroundColor,
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
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.direction,
    this.margin,
    this.decoration,
    this.refreshConfig,
  })  : onWillPopOverlayClose = onWillPopOverlayClose ?? false,
        paddingStatusBar = paddingStatusBar ?? false,
        useSingleChildScrollView = useSingleChildScrollView ?? true,
        primary = primary ?? true,
        drawerEnableOpenDragGesture = drawerEnableOpenDragGesture ?? true,
        endDrawerEnableOpenDragGesture = endDrawerEnableOpenDragGesture ?? true,
        extendBody = extendBody ?? false,
        extendBodyBehindAppBar = extendBodyBehindAppBar ?? false,
        isStack = isStack ?? false,
        isScroll = isScroll ?? false,
        backgroundColor = backgroundColor ?? ConstColors.background,
        drawerDragStartBehavior =
            drawerDragStartBehavior ?? DragStartBehavior.start,
        super(key: key);

  /// 相当于给[body] 套用 [Column]、[Row]、[Stack]
  final List<Widget>? children;

  /// [children].length > 0 && [isStack]=false 有效;
  final MainAxisAlignment? mainAxisAlignment;

  /// [children].length > 0 && [isStack]=false 有效;
  final CrossAxisAlignment? crossAxisAlignment;

  /// [children].length > 0 && [isStack]=false 有效;
  final Axis? direction;

  /// [children].length > 0有效;
  /// 添加 [Stack]组件
  final bool? isStack;

  /// 是否添加滚动组件
  final bool? isScroll;

  /// [body]top padding 出状态栏高度 [padding]!=null 时此参数无效
  final bool paddingStatusBar;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;

  ///  true 点击android实体返回按键先关闭Overlay【toast loading ...】但不pop 当前页面
  ///  false 点击android实体返回按键先关闭Overlay【toast loading ...】并pop 当前页面
  final bool onWillPopOverlayClose;

  ///  返回按键监听
  final WillPopCallback? onWillPop;

  ///  ****** 刷新组件相关 ******  ///
  final RefreshConfig? refreshConfig;

  final bool useSingleChildScrollView;

  ///  Scaffold相关属性
  final Widget? body;
  final Color backgroundColor;

  final bool extendBody;
  final bool extendBodyBehindAppBar;

  final Widget? appBar;
  final double? appBarHeight;
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
        appBar: appBarFun,
        bottomNavigationBar: bottomNavigationBar,
        bottomSheet: bottomSheet,
        body: universal);
    if (onWillPop != null || onWillPopOverlayClose)
      return WillPopScope(
          child: scaffold, onWillPop: onWillPop ?? onWillPopFun);
    return scaffold;
  }

  Future<bool> onWillPopFun() async {
    if (!scaffoldWillPop) return scaffoldWillPop;
    if (onWillPopOverlayClose && _overlayEntryList.isNotEmpty) {
      closeOverlay();
      return false;
    }
    return true;
  }

  PreferredSizeWidget? get appBarFun {
    if (appBar is AppBar && appBarHeight == null) return appBar as AppBar;
    return appBar == null
        ? null
        : PreferredSize(
            child: appBar!,
            preferredSize:
                Size.fromHeight(getStatusBarHeight + (appBarHeight ?? 30)));
  }

  Universal get universal => Universal(
      expand: true,
      refreshConfig: refreshConfig,
      margin: margin,
      useSingleChildScrollView: useSingleChildScrollView,
      padding:
          paddingStatusBar ? EdgeInsets.only(top: getStatusBarHeight) : padding,
      isScroll: isScroll,
      isStack: isStack,
      direction: direction,
      decoration: decoration,
      children: children,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      child: body);
}

///  ************ 以下为 路由跳转 *****************  ///
///
///  打开新页面
Future<T?> push<T extends Object?>(Widget widget,
        {bool? maintainState,
        bool? fullscreenDialog,
        WidgetMode? widgetMode,
        RouteSettings? settings,
        BuildContext? context}) =>
    _globalNavigatorKey.currentState!.push(_pageRoute(widget,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        context: context,
        settings: settings,
        widgetMode: widgetMode));

/// 打开新页面替换当前页面
Future<T?> pushReplacement<T extends Object?, TO extends Object?>(Widget widget,
        {bool? maintainState,
        bool? fullscreenDialog,
        WidgetMode? widgetMode,
        RouteSettings? settings,
        TO? result}) =>
    _globalNavigatorKey.currentState!.pushReplacement(
        _pageRoute(widget,
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog,
            widgetMode: widgetMode),
        result: result);

/// 打开新页面 并移出堆栈所有页面
Future<T?> pushAndRemoveUntil<T extends Object?>(Widget widget,
        {bool? maintainState,
        bool? fullscreenDialog,
        WidgetMode? widgetMode,
        RouteSettings? settings,
        RoutePredicate? predicate}) =>
    _globalNavigatorKey.currentState!.pushAndRemoveUntil(
        _pageRoute(widget,
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog,
            widgetMode: widgetMode),
        predicate ?? (_) => false);

/// 可能返回到上一个页面
Future<bool> maybePop<T extends Object>([T? result]) =>
    _globalNavigatorKey.currentState!.maybePop<T>(result);

/// 返回上一个页面
void pop<T extends Object>([T? result]) =>
    _globalNavigatorKey.currentState!.pop<T>(result);

/// pop 返回简写 带参数  [nullBack] =true  navigator 返回为空 就继续返回上一页面
void popBack(Future<dynamic> navigator, {bool nullBack = false}) {
  final Future<dynamic> future = navigator;
  future.then((dynamic value) {
    if (nullBack) {
      maybePop(value);
    } else {
      if (value != null) pop(value);
    }
  });
}

/// 循环pop 直到pop至指定页面
void popUntil(RoutePredicate predicate) =>
    _globalNavigatorKey.currentState!.popUntil(predicate);

WidgetMode? _widgetMode;

void setGlobalPushMode(WidgetMode widgetMode) => _widgetMode = widgetMode;

PageRoute<T> _pageRoute<T>(Widget widget,
    {bool? maintainState,
    bool? fullscreenDialog,
    WidgetMode? widgetMode,
    RouteSettings? settings,
    BuildContext? context}) {
  switch (widgetMode ?? _widgetMode) {
    case WidgetMode.cupertino:
      return CupertinoPageRoute<T>(
          settings: settings,
          maintainState: maintainState ?? true,
          fullscreenDialog: fullscreenDialog ?? false,
          builder: (_) => widget);
    case WidgetMode.material:
      return MaterialPageRoute<T>(
          settings: settings,
          maintainState: maintainState ?? true,
          fullscreenDialog: fullscreenDialog ?? false,
          builder: (_) => widget);
    case WidgetMode.ripple:
      return RipplePageRoute<T>(
          widget: widget,
          routeConfig: RouteConfig.fromContext(
              (context ?? _globalNavigatorKey.currentContext)!));
    default:
      return CupertinoPageRoute<T>(
          maintainState: maintainState ?? true,
          settings: settings,
          fullscreenDialog: fullscreenDialog ?? false,
          builder: (_) => widget);
  }
}
