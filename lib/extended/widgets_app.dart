import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

enum RoutePushStyle {
  /// Cupertino风格
  cupertino,

  /// Material风格
  material,
  ;

  /// Builds the primary contents of the route.
  PageRoute<T> pageRoute<T>(
      {WidgetBuilder? builder,
      Widget? widget,
      bool maintainState = true,
      bool fullscreenDialog = false,
      String? title,
      RouteSettings? settings}) {
    assert(widget != null || builder != null);
    switch (this) {
      case RoutePushStyle.cupertino:
        return CupertinoPageRoute<T>(
            title: title,
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog,
            builder: builder ?? widget!.toWidgetBuilder);
      case RoutePushStyle.material:
        return MaterialPageRoute<T>(
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog,
            builder: builder ?? widget!.toWidgetBuilder);
    }
  }
}

/// ExtendedWidgetsApp
class ExtendedWidgetsApp extends StatelessWidget {
  const ExtendedWidgetsApp({
    super.key,
    this.routes = const <String, WidgetBuilder>{},
    this.title = '',
    this.themeMode = ThemeMode.system,
    this.pushStyle = RoutePushStyle.material,
    this.locale = const Locale('zh'),
    this.localizationsDelegates = const <LocalizationsDelegate<dynamic>>[
      DefaultCupertinoLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    this.supportedLocales = const <Locale>[
      Locale('zh', 'CH'),
      Locale('en', 'US')
    ],
    this.debugShowMaterialGrid = false,
    this.debugShowWidgetInspector = false,
    this.debugShowCheckedModeBanner = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.color,
    this.navigatorKey,
    this.home,
    this.initialRoute,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.builder,
    this.onGenerateTitle,
    this.theme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.shortcuts,
    this.actions,
    this.onGenerateInitialRoutes,
    this.inspectorSelectButtonBuilder,
    this.cupertinoTheme,
    this.scaffoldMessengerKey,
    this.scrollBehavior,
    this.restorationScopeId,
    this.textStyle,
  });

  /// 风格
  final RoutePushStyle pushStyle;

  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  /// 导航键
  final GlobalKey<NavigatorState>? navigatorKey;

  /// 主页
  final Widget? home;

  /// 初始路由
  final String? initialRoute;

  /// 生成路由
  final RouteFactory? onGenerateRoute;

  /// 未知路由
  final RouteFactory? onUnknownRoute;

  /// 建造者
  final TransitionBuilder? builder;

  /// 区域分辨回调
  final LocaleListResolutionCallback? localeListResolutionCallback;

  final LocaleResolutionCallback? localeResolutionCallback;

  /// 生成标题
  final GenerateAppTitle? onGenerateTitle;

  /// Cupertino主题
  final CupertinoThemeData? cupertinoTheme;

  /// Material主题
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeData? highContrastTheme;
  final ThemeData? highContrastDarkTheme;

  /// 颜色
  final Color? color;

  /// 路由
  final Map<String, WidgetBuilder> routes;

  /// 导航观察器
  final List<NavigatorObserver> navigatorObservers;

  /// 本地化委托
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;

  /// 标题
  final String title;

  final ThemeMode themeMode;

  /// 地点
  final Locale? locale;

  /// 支持区域
  final Iterable<Locale> supportedLocales;

  /// 显示性能叠加
  final bool showPerformanceOverlay;

  /// 棋盘格光栅缓存图像
  final bool checkerboardRasterCacheImages;

  final bool checkerboardOffscreenLayers;

  /// 显示语义调试器
  final bool showSemanticsDebugger;

  /// 调试显示检查模式横幅
  final bool debugShowCheckedModeBanner;
  final ScrollBehavior? scrollBehavior;
  final bool debugShowMaterialGrid;
  final Map<LogicalKeySet, Intent>? shortcuts;
  final Map<Type, Action<Intent>>? actions;
  final InitialRouteListFactory? onGenerateInitialRoutes;
  final InspectorSelectButtonBuilder? inspectorSelectButtonBuilder;
  final String? restorationScopeId;
  final bool debugShowWidgetInspector;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    if (navigatorKey != null) {
      GlobalOptions().setGlobalNavigatorKey(navigatorKey!);
    }
    if (theme != null ||
        darkTheme != null ||
        pushStyle == RoutePushStyle.material) {
      return materialApp;
    }
    if (cupertinoTheme != null || pushStyle == RoutePushStyle.cupertino) {
      return cupertinoApp;
    }
    late Color color;
    switch (pushStyle) {
      case RoutePushStyle.cupertino:
        final CupertinoThemeData effectiveThemeData =
            CupertinoTheme.of(context);
        color = CupertinoDynamicColor.resolve(
            this.color ?? effectiveThemeData.primaryColor, context);
        break;
      case RoutePushStyle.material:
        color = this.color ?? theme?.primaryColor ?? Colors.blue;
        break;
    }
    return WidgetsApp(
        key: key,
        navigatorKey: GlobalOptions().globalNavigatorKey,
        onGenerateRoute: onGenerateRoute,
        onGenerateInitialRoutes: onGenerateInitialRoutes,
        onUnknownRoute: onUnknownRoute,
        navigatorObservers: navigatorObservers,
        initialRoute: initialRoute,
        pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
            pushStyle.pageRoute(settings: settings, builder: builder),
        home: home,
        routes: routes,
        builder: builder,
        title: title,
        onGenerateTitle: onGenerateTitle,
        textStyle: textStyle,
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
        debugShowWidgetInspector: debugShowWidgetInspector,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        inspectorSelectButtonBuilder: inspectorSelectButtonBuilder,
        shortcuts: shortcuts,
        actions: actions,
        restorationScopeId: restorationScopeId);
  }

  MaterialApp get materialApp {
    GlobalOptions().setGlobalScaffoldMessengerKey(
        scaffoldMessengerKey ?? GlobalKey<ScaffoldMessengerState>());
    return MaterialApp(
        key: key,
        navigatorKey: GlobalOptions().globalNavigatorKey,
        scaffoldMessengerKey: GlobalOptions().globalScaffoldMessengerKey,
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
        highContrastTheme: highContrastTheme,
        highContrastDarkTheme: highContrastDarkTheme,
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
        actions: actions,
        restorationScopeId: restorationScopeId,
        scrollBehavior: scrollBehavior);
  }

  CupertinoApp get cupertinoApp => CupertinoApp(
      key: key,
      navigatorKey: GlobalOptions().globalNavigatorKey,
      home: home,
      theme: cupertinoTheme,
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
      actions: actions,
      restorationScopeId: restorationScopeId,
      scrollBehavior: scrollBehavior);
}
