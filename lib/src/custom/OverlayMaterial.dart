import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/custom/OverlayBase.dart';

// ignore: must_be_immutable
class OverlayMaterial extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey; //导航键
  final Widget home; //主页
  final Map<String, WidgetBuilder> routes; //路由
  final String initialRoute; //初始路由
  final RouteFactory onGenerateRoute; //生成路由
  final RouteFactory onUnknownRoute; //未知路由
  List<NavigatorObserver> navigatorObservers; //导航观察器
  final TransitionBuilder builder; //建造者
  final String title; //标题
  final GenerateAppTitle onGenerateTitle; //生成标题
  final ThemeData theme; //主题
  final ThemeData darkTheme;
  final ThemeMode themeMode;
  final Color color; //颜色
  Locale locale; //地点
  Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates; //本地化委托
  final LocaleListResolutionCallback localeListResolutionCallback; //区域分辨回调
  final LocaleResolutionCallback localeResolutionCallback;
  Iterable<Locale> supportedLocales; //支持区域
  final bool showPerformanceOverlay; //显示性能叠加
  final bool checkerboardRasterCacheImages; //棋盘格光栅缓存图像
  final bool checkerboardOffscreenLayers;
  final bool showSemanticsDebugger; //显示语义调试器
  final bool debugShowCheckedModeBanner; //调试显示检查模式横幅
  final bool debugShowMaterialGrid;
  TextDirection textDirection;

  OverlayMaterial({
    Key key,
    this.textDirection,
    this.navigatorKey,
    this.home,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.navigatorObservers,
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = false,
  })  : assert(routes != null),
        assert(navigatorObservers != null),
        assert(title != null),
        assert(debugShowMaterialGrid != null),
        assert(showPerformanceOverlay != null),
        assert(checkerboardRasterCacheImages != null),
        assert(checkerboardOffscreenLayers != null),
        assert(showSemanticsDebugger != null),
        assert(debugShowCheckedModeBanner != null),
        super(key: key) {
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
