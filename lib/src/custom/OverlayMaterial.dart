import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_waya/src/custom/OverlayBase.dart';
import 'package:flutter_waya/waya.dart';

// ignore: must_be_immutable
class OverlayMaterial extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey; //导航键
  final Widget home; //主页
  final String initialRoute; //初始路由
  final RouteFactory onGenerateRoute; //生成路由
  final RouteFactory onUnknownRoute; //未知路由
  final TransitionBuilder builder; //建造者
  final LocaleListResolutionCallback localeListResolutionCallback; //区域分辨回调
  final LocaleResolutionCallback localeResolutionCallback;
  final GenerateAppTitle onGenerateTitle; //生成标题
  final ThemeData theme; //主题
  final ThemeData darkTheme;
  final Color color; //颜色
  Map<String, WidgetBuilder> routes; //路由
  List<NavigatorObserver> navigatorObservers; //导航观察器
  Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates; //本地化委托
  String title; //标题
  ThemeMode themeMode;
  Locale locale; //地点
  Iterable<Locale> supportedLocales; //支持区域
  bool showPerformanceOverlay; //显示性能叠加
  bool checkerboardRasterCacheImages; //棋盘格光栅缓存图像
  bool checkerboardOffscreenLayers;
  bool showSemanticsDebugger; //显示语义调试器
  bool debugShowCheckedModeBanner; //调试显示检查模式横幅
  bool debugShowMaterialGrid;
  TextDirection textDirection;

  OverlayMaterial({
    Key key,
    this.textDirection,
    this.navigatorKey,
    this.home,
    this.routes,
    this.initialRoute,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.navigatorObservers,
    this.builder,
    this.title,
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.themeMode,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales,
    this.debugShowMaterialGrid,
    this.showPerformanceOverlay,
    this.checkerboardRasterCacheImages,
    this.checkerboardOffscreenLayers,
    this.showSemanticsDebugger,
    this.debugShowCheckedModeBanner,
  }) : super(key: key) {
    if (debugShowMaterialGrid == null) debugShowMaterialGrid = false;
    if (showPerformanceOverlay == null) showPerformanceOverlay = false;
    if (checkerboardRasterCacheImages == null) checkerboardRasterCacheImages = false;
    if (checkerboardOffscreenLayers == null) checkerboardOffscreenLayers = false;
    if (showSemanticsDebugger == null) showSemanticsDebugger = false;
    if (debugShowCheckedModeBanner == null) debugShowCheckedModeBanner = false;
    if (themeMode == null) themeMode = ThemeMode.system;
    if (title == null) title = "";
    if (routes == null) routes = const <String, WidgetBuilder>{};
    if (textDirection == null) textDirection = TextDirection.ltr;
    if (navigatorObservers == null) navigatorObservers = [BaseNavigatorUtils.getInstance()];
    if (locale == null) locale = const Locale('zh');
    if (supportedLocales == null) supportedLocales = [const Locale('zh', 'CH')];
    if (localizationsDelegates == null)
      localizationsDelegates = [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate];
  }

  @override
  Widget build(BuildContext context) {
    return OverlayBase(
      textDirection: textDirection,
      child: MaterialApp(
        home: home,
        navigatorObservers: navigatorObservers,
        locale: locale,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        navigatorKey: navigatorKey,
        routes: routes,
        initialRoute: initialRoute,
        onGenerateRoute: onGenerateRoute,
        onUnknownRoute: onUnknownRoute,
        builder: builder,
        title: title,
        onGenerateTitle: onGenerateTitle,
        color: color,
        theme: theme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        localeListResolutionCallback: localeListResolutionCallback,
        localeResolutionCallback: localeResolutionCallback,
        debugShowMaterialGrid: debugShowMaterialGrid,
        showPerformanceOverlay: showPerformanceOverlay,
        checkerboardRasterCacheImages: checkerboardRasterCacheImages,
        checkerboardOffscreenLayers: checkerboardOffscreenLayers,
        showSemanticsDebugger: showSemanticsDebugger,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      ),
    );
  }
}
