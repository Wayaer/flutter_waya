import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

enum RoutePushStyle {
  /// Cupertino风格
  cupertino,

  /// Material风格
  material,
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

/// ************ 以下为 路由跳转 *****************  ///
///
/// 打开新页面
Future<T?> push<T extends Object?, TO extends Object?>(Widget widget,
        {bool maintainState = true,
        bool fullscreenDialog = false,
        RoutePushStyle? pushStyle,
        RouteSettings? settings,
        bool replacement = false,
        TO? result}) =>
    widget.push(
        settings: settings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        pushStyle: pushStyle ?? GlobalOptions().pushStyle,
        result: result,
        replacement: replacement);

/// 打开新页面替换当前页面
Future<T?> pushReplacement<T extends Object?, TO extends Object?>(Widget widget,
        {bool maintainState = true,
        bool fullscreenDialog = false,
        RoutePushStyle? pushStyle,
        RouteSettings? settings,
        TO? result}) =>
    widget.pushReplacement(
        settings: settings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        pushStyle: pushStyle ?? GlobalOptions().pushStyle);

/// 打开新页面 并移出堆栈所有页面
Future<T?> pushAndRemoveUntil<T extends Object?>(Widget widget,
        {bool maintainState = true,
        bool fullscreenDialog = false,
        RoutePushStyle? pushStyle,
        RouteSettings? settings,
        RoutePredicate? predicate}) =>
    widget.pushAndRemoveUntil(
        settings: settings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        pushStyle: pushStyle ?? GlobalOptions().pushStyle);

/// 可能返回到上一个页面
Future<bool> maybePop<T extends Object>([T? result]) =>
    GlobalOptions().globalNavigatorKey.currentState!.maybePop<T>(result);

/// 返回上一个页面
Future<bool?> pop<T extends Object>([T? result, bool isMaybe = false]) {
  if (isMaybe) {
    return maybePop<T>(result);
  } else {
    GlobalOptions().globalNavigatorKey.currentState!.pop<T>(result);
    return Future.value(true);
  }
}

/// pop 返回简写 带参数  [nullBack] =true  navigator 返回为空 就继续返回上一页面
void popBack(Future<dynamic> navigator,
    {bool nullBack = false, bool useMaybePop = false}) {
  final Future<dynamic> future = navigator;
  future.then((dynamic value) {
    if (nullBack) {
      pop(value, useMaybePop);
    } else {
      if (value != null) pop(value, useMaybePop);
    }
  });
}

/// 循环pop 直到pop至指定页面
void popUntil(RoutePredicate predicate) =>
    GlobalOptions().globalNavigatorKey.currentState!.popUntil(predicate);
