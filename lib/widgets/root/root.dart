import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

part 'root_part.dart';

GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey();
GlobalKey<ScaffoldMessengerState>? _scaffoldMessengerKey;
List<ExtendedOverlayEntry> _overlayEntryList = <ExtendedOverlayEntry>[];
EventBus eventBus = EventBus();

enum WidgetMode {
  ///  Cupertino风格
  cupertino,

  ///  Material风格
  material,

  ///
  ripple,
}

///  ExtendedWidgetsApp
class ExtendedWidgetsApp extends StatelessWidget {
  ExtendedWidgetsApp({
    Key? key,
    Map<String, WidgetBuilder>? routes,
    String? title,
    ThemeMode? themeMode = ThemeMode.system,
    WidgetMode? widgetMode = WidgetMode.material,
    Locale? locale,
    Color? color,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    Iterable<Locale>? supportedLocales,
    bool? debugShowMaterialGrid = false,
    bool? debugShowWidgetInspector = false,
    bool? debugShowCheckedModeBanner = false,
    bool? showPerformanceOverlay,
    bool? checkerboardRasterCacheImages,
    bool? checkerboardOffscreenLayers,
    bool? showSemanticsDebugger,
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
    this.useInheritedMediaQuery = false,
  })  : debugShowMaterialGrid = debugShowMaterialGrid ?? false,
        debugShowWidgetInspector = debugShowWidgetInspector ?? false,
        showPerformanceOverlay = showPerformanceOverlay ?? false,
        checkerboardRasterCacheImages = checkerboardRasterCacheImages ?? false,
        checkerboardOffscreenLayers = checkerboardOffscreenLayers ?? false,
        showSemanticsDebugger = showSemanticsDebugger ?? false,
        debugShowCheckedModeBanner = debugShowCheckedModeBanner ?? false,
        themeMode = themeMode ?? ThemeMode.system,
        widgetMode = widgetMode ?? WidgetMode.material,
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
  final WidgetMode widgetMode;

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

  ///  Cupertino主题
  final CupertinoThemeData? cupertinoTheme;

  ///  Material主题
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeData? highContrastTheme;
  final ThemeData? highContrastDarkTheme;

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
  final ScrollBehavior? scrollBehavior;
  final bool debugShowMaterialGrid;
  final Map<LogicalKeySet, Intent>? shortcuts;
  final Map<Type, Action<Intent>>? actions;
  final InitialRouteListFactory? onGenerateInitialRoutes;
  final InspectorSelectButtonBuilder? inspectorSelectButtonBuilder;
  final String? restorationScopeId;
  final bool debugShowWidgetInspector;
  final TextStyle? textStyle;
  final bool useInheritedMediaQuery;

  @override
  Widget build(BuildContext context) {
    if (navigatorKey != null) globalNavigatorKey = navigatorKey!;
    if (theme != null || darkTheme != null || widgetMode == WidgetMode.material)
      return materialApp;
    if (cupertinoTheme != null || widgetMode == WidgetMode.cupertino)
      return cupertinoApp;
    return WidgetsApp(
        key: key,
        navigatorKey: globalNavigatorKey,
        onGenerateRoute: onGenerateRoute,
        onGenerateInitialRoutes: onGenerateInitialRoutes,
        onUnknownRoute: onUnknownRoute,
        navigatorObservers: navigatorObservers,
        initialRoute: initialRoute,
        pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
          switch (widgetMode) {
            case WidgetMode.cupertino:
              return CupertinoPageRoute<T>(
                  settings: settings, builder: builder);
            case WidgetMode.material:
              return MaterialPageRoute<T>(settings: settings, builder: builder);
            case WidgetMode.ripple:
              return RipplePageRoute<T>(
                  builder: builder,
                  routeConfig: RouteConfig.fromContext(context));
          }
        },
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
        useInheritedMediaQuery: useInheritedMediaQuery,
        restorationScopeId: restorationScopeId);
  }

  Widget get materialApp {
    _scaffoldMessengerKey =
        scaffoldMessengerKey ?? GlobalKey<ScaffoldMessengerState>();
    return MaterialApp(
        key: key,
        navigatorKey: globalNavigatorKey,
        scaffoldMessengerKey: _scaffoldMessengerKey,
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
        useInheritedMediaQuery: useInheritedMediaQuery,
        scrollBehavior: scrollBehavior);
  }

  Widget get cupertinoApp => CupertinoApp(
      key: key,
      navigatorKey: globalNavigatorKey,
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
      useInheritedMediaQuery: useInheritedMediaQuery,
      scrollBehavior: scrollBehavior);
}

bool scaffoldWillPop = true;

///  ExtendedScaffold
class ExtendedScaffold extends StatelessWidget {
  const ExtendedScaffold({
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
    this.restorationId,
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
  final String? restorationId;

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
        restorationId: restorationId,
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
Future<T?> push<T extends Object?>(
  Widget widget, {
  bool maintainState = true,
  bool fullscreenDialog = false,
  WidgetMode? widgetMode,
  RouteSettings? settings,
}) =>
    globalNavigatorKey.currentState!.push(widget.buildPageRoute(
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        context: globalNavigatorKey.currentState!.context,
        settings: settings,
        widgetMode: widgetMode ?? _widgetMode));

/// 打开新页面替换当前页面
Future<T?> pushReplacement<T extends Object?, TO extends Object?>(Widget widget,
        {bool maintainState = true,
        bool fullscreenDialog = false,
        WidgetMode? widgetMode,
        RouteSettings? settings,
        TO? result}) =>
    globalNavigatorKey.currentState!.pushReplacement(
        widget.buildPageRoute(
            settings: settings,
            context: globalNavigatorKey.currentState!.context,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog,
            widgetMode: widgetMode ?? _widgetMode),
        result: result);

/// 打开新页面 并移出堆栈所有页面
Future<T?> pushAndRemoveUntil<T extends Object?>(Widget widget,
        {bool maintainState = true,
        bool fullscreenDialog = false,
        WidgetMode? widgetMode,
        RouteSettings? settings,
        RoutePredicate? predicate}) =>
    globalNavigatorKey.currentState!.pushAndRemoveUntil(
        widget.buildPageRoute(
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog,
            context: globalNavigatorKey.currentState!.context,
            widgetMode: widgetMode ?? _widgetMode),
        predicate ?? (_) => false);

/// 可能返回到上一个页面
Future<bool> maybePop<T extends Object>([T? result]) =>
    globalNavigatorKey.currentState!.maybePop<T>(result);

/// 返回上一个页面
void pop<T extends Object>([T? result]) =>
    globalNavigatorKey.currentState!.pop<T>(result);

/// pop 返回简写 带参数  [nullBack] =true  navigator 返回为空 就继续返回上一页面
void popBack(Future<dynamic> navigator,
    {bool nullBack = false, bool useMaybePop = false}) {
  final Future<dynamic> future = navigator;
  future.then((dynamic value) {
    if (nullBack) {
      useMaybePop ? maybePop(value) : pop(value);
    } else {
      if (value != null) useMaybePop ? maybePop(value) : pop(value);
    }
  });
}

/// 循环pop 直到pop至指定页面
void popUntil(RoutePredicate predicate) =>
    globalNavigatorKey.currentState!.popUntil(predicate);

WidgetMode _widgetMode = WidgetMode.cupertino;

void setGlobalPushMode(WidgetMode widgetMode) => _widgetMode = widgetMode;
