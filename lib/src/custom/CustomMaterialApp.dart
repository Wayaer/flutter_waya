import 'package:flutter/material.dart';
import 'package:flutter_waya/src/utils/NavigatorUtils.dart';
import 'package:oktoast/oktoast.dart';

class CustomMaterialApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey; //导航键
  final Widget home; //主页
  final Map<String, WidgetBuilder> routes; //路由
  final String initialRoute; //初始路由
  final RouteFactory onGenerateRoute; //生成路由
  final RouteFactory onUnknownRoute; //未知路由
  final List<NavigatorObserver> navigatorObservers; //导航观察器
  final TransitionBuilder builder; //建造者
  final String title; //标题
  final GenerateAppTitle onGenerateTitle; //生成标题
  final ThemeData theme; //主题
  final ThemeData darkTheme;
  final ThemeMode themeMode;
  final Color color; //颜色
  final Locale locale; //地点
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates; //本地化委托
  final LocaleListResolutionCallback localeListResolutionCallback; //区域分辨回调
  final LocaleResolutionCallback localeResolutionCallback;
  final Iterable<Locale> supportedLocales; //支持区域
  final bool showPerformanceOverlay; //显示性能叠加
  final bool checkerboardRasterCacheImages; //棋盘格光栅缓存图像
  final bool checkerboardOffscreenLayers;
  final bool showSemanticsDebugger; //显示语义调试器
  final bool debugShowCheckedModeBanner; //调试显示检查模式横幅
  final bool debugShowMaterialGrid;

  final TextStyle toastTextStyle;
  final Color toastBackgroundColor;
  final double toastRadius;
  final ToastPosition toastPosition;
  final TextDirection toastTextDirection;
  final bool toastDismissOtherOnShow;
  final bool toastMovingOnWindowChange;
  final EdgeInsets toastTextPadding;
  final TextAlign toastTextAlign;
  final bool toastHandleTouth;

  const CustomMaterialApp({
    Key key,
    this.navigatorKey,
    this.home,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.navigatorObservers = const <NavigatorObserver>[],
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
    this.toastTextStyle,
    this.toastRadius = 10.0,
    this.toastPosition = ToastPosition.center,
    this.toastTextDirection = TextDirection.ltr,
    this.toastDismissOtherOnShow = false,
    this.toastMovingOnWindowChange = true,
    this.toastBackgroundColor,
    this.toastTextPadding,
    this.toastTextAlign,
    this.toastHandleTouth = false,
  })  : assert(routes != null),
        assert(navigatorObservers != null),
        assert(title != null),
        assert(debugShowMaterialGrid != null),
        assert(showPerformanceOverlay != null),
        assert(checkerboardRasterCacheImages != null),
        assert(checkerboardOffscreenLayers != null),
        assert(showSemanticsDebugger != null),
        assert(debugShowCheckedModeBanner != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return OKToast(
        textStyle: toastTextStyle,
        radius: toastRadius ?? 10.0,
        position: toastPosition ?? ToastPosition.center,
        textDirection: toastTextDirection ?? TextDirection.ltr,
        dismissOtherOnShow: toastDismissOtherOnShow ?? false,
        movingOnWindowChange: toastMovingOnWindowChange ?? true,
        backgroundColor: toastBackgroundColor,
        textPadding: toastTextPadding,
        textAlign: toastTextAlign,
        handleTouth: toastHandleTouth ?? false,
        child: MaterialApp(
          navigatorKey: navigatorKey,
          home: home,
          routes: routes,
          initialRoute: initialRoute,
          onGenerateRoute: onGenerateRoute,
          onUnknownRoute: onUnknownRoute,
          navigatorObservers:
              navigatorObservers ?? [NavigatorManager.getInstance()],
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
        ));
  }
}
