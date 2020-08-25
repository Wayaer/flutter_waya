import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/widget/custom/dialog/overlay.dart';

GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey();

///OverlayMaterial
class OverlayMaterial extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  ///导航键
  final Widget home;

  ///主页
  final String initialRoute;

  ///初始路由
  final RouteFactory onGenerateRoute;

  ///生成路由
  final RouteFactory onUnknownRoute;

  ///未知路由
  final TransitionBuilder builder;

  ///建造者
  final LocaleListResolutionCallback localeListResolutionCallback;

  ///区域分辨回调
  final LocaleResolutionCallback localeResolutionCallback;
  final GenerateAppTitle onGenerateTitle;

  ///生成标题
  final ThemeData theme;

  ///主题
  final ThemeData darkTheme;
  final Color color;

  ///颜色
  final Map<String, WidgetBuilder> routes;

  ///路由
  final List<NavigatorObserver> navigatorObservers;

  ///导航观察器
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;

  ///本地化委托
  final String title;

  ///标题
  final ThemeMode themeMode;
  final Locale locale;

  ///地点
  final Iterable<Locale> supportedLocales;

  ///支持区域
  final bool showPerformanceOverlay;

  ///显示性能叠加
  final bool checkerboardRasterCacheImages;

  ///棋盘格光栅缓存图像
  final bool checkerboardOffscreenLayers;
  final bool showSemanticsDebugger;

  ///显示语义调试器
  final bool debugShowCheckedModeBanner;

  ///调试显示检查模式横幅
  final bool debugShowMaterialGrid;
  final TextDirection textDirection;

  OverlayMaterial({
    Key key,
    TextDirection textDirection,
    Map<String, WidgetBuilder> routes,
    String title,
    List<NavigatorObserver> navigatorObservers,
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
  })  : this.debugShowMaterialGrid = debugShowMaterialGrid ?? false,
        this.showPerformanceOverlay = showPerformanceOverlay ?? false,
        this.checkerboardRasterCacheImages = checkerboardRasterCacheImages ?? false,
        this.checkerboardOffscreenLayers = checkerboardOffscreenLayers ?? false,
        this.showSemanticsDebugger = showSemanticsDebugger ?? false,
        this.debugShowCheckedModeBanner = debugShowCheckedModeBanner ?? false,
        this.themeMode = themeMode ?? ThemeMode.system,
        this.title = title ?? "",
        this.routes = routes = const <String, WidgetBuilder>{},
        this.textDirection = textDirection ?? TextDirection.ltr,
        this.navigatorObservers = navigatorObservers ?? [NavigatorTools.getInstance()],
        this.locale = locale ?? Locale('zh'),
        this.supportedLocales = supportedLocales ?? [Locale('zh', 'CH')],
        this.localizationsDelegates = localizationsDelegates ??
            [
              ///解决ios 长按输入框报错
              ChineseCupertinoLocalizations.delegate,
              CustomLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (navigatorKey != null) globalNavigatorKey = navigatorKey;
    return OverlayBase(
        textDirection: textDirection,
        child: MaterialApp(
          home: home,
          navigatorObservers: navigatorObservers,
          locale: locale,
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales,
          navigatorKey: globalNavigatorKey,
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
        ));
  }
}

///OverlayCupertino
class OverlayCupertino extends StatelessWidget {
  final TextDirection textDirection;
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

  OverlayCupertino({
    Key key,
    TextDirection textDirection,
    Iterable<Locale> supportedLocales,
    Locale locale,
    Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    List<NavigatorObserver> navigatorObservers,
    Map<String, WidgetBuilder> routes,
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
  })  : this.showPerformanceOverlay = showPerformanceOverlay ?? false,
        this.checkerboardRasterCacheImages = checkerboardRasterCacheImages ?? false,
        this.checkerboardOffscreenLayers = checkerboardOffscreenLayers ?? false,
        this.showSemanticsDebugger = showSemanticsDebugger ?? false,
        this.debugShowCheckedModeBanner = debugShowCheckedModeBanner ?? true,
        this.title = title ?? "",
        this.routes = routes ?? const <String, WidgetBuilder>{},
        this.textDirection = textDirection ?? TextDirection.ltr,
        this.navigatorObservers = navigatorObservers ?? [NavigatorTools.getInstance()],
        this.locale = locale ?? const Locale('zh'),
        this.supportedLocales = supportedLocales ?? [const Locale('zh', 'CH')],
        this.localizationsDelegates =
            localizationsDelegates ?? [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (navigatorKey != null) globalNavigatorKey = navigatorKey;
    return OverlayBase(
        textDirection: textDirection,
        child: CupertinoApp(
          navigatorKey: globalNavigatorKey,
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
          debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        ));
  }
}

///Scaffold
class OverlayScaffold extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Widget body;
  final bool isScroll;
  final bool isolationBody;
  final bool paddingStatusBar;
  final bool enablePullDown;

  ///点击返回是否关闭叠层
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

  //isScroll 和isolationBody（body隔离出一个横条目）  不可同时使用
  OverlayScaffold({
    Key key,
    bool isScroll,
    bool isolationBody,
    bool paddingStatusBar,
    bool enablePullDown,
    bool primary, //试用使用primary主色
    bool extendBody,
    DragStartBehavior drawerDragStartBehavior,
    double appBarHeight,
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
  })  : this.isScroll = isScroll ?? false,
        this.appBarHeight = appBarHeight ?? ScreenFit.getHeight(45),
        this.isolationBody = isolationBody ?? false,
        this.onWillPopOverlayClose = onWillPopOverlayClose ?? true,
        this.paddingStatusBar = paddingStatusBar ?? false,
        this.enablePullDown = enablePullDown ?? false,
        this.primary = primary ?? true,
        this.extendBody = extendBody ?? false,
        this.drawerDragStartBehavior = drawerDragStartBehavior ?? DragStartBehavior.start,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop ??
            () async {
              if (onWillPopOverlayClose && overlayEntryList.length > 0 && !overlayEntryList.last.isAutomaticOff) {
                closeOverlay();
                return false;
              }
              return true;
            },
        child: Scaffold(
          primary: primary,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          drawerDragStartBehavior: drawerDragStartBehavior,
          bottomSheet: bottomSheet,
          extendBody: extendBody,
          resizeToAvoidBottomPadding: resizeToAvoidBottomPadding,
          endDrawer: endDrawer,
          drawer: drawer,
          persistentFooterButtons: persistentFooterButtons,
          floatingActionButtonLocation: floatingActionButtonLocation,
          floatingActionButton: floatingActionButton,
          floatingActionButtonAnimator: floatingActionButtonAnimator,
          backgroundColor: backgroundColor ?? getColors(background),
          appBar: appBarHeight == null
              ? appBar
              : (appBar == null
                  ? null
                  : PreferredSize(
                      child: appBar,
                      preferredSize: Size.fromHeight(MediaQueryTools.getStatusBarHeight() + appBarHeight))),
          bottomNavigationBar: bottomNavigationBar,
          body: bodyWidget(context),
        ));
  }

  Widget bodyWidget(BuildContext context) {
    if (enablePullDown) return refresherContainer();
    return container();
  }

  Widget refresherContainer() {
    return Refreshed(
      enablePullDown: enablePullDown,
      controller: controller,
      onRefresh: onRefresh,
      child: container(),
      header: header,
    );
  }

  Widget container() {
    return Container(
      color: backgroundColor,
      margin: isolationBody ? EdgeInsets.only(top: ScreenFit.getHeight(10)) : EdgeInsets.zero,
      padding: paddingStatusBar ? EdgeInsets.only(top: MediaQueryTools.getStatusBarHeight()) : padding,
      width: double.infinity,
      height: double.infinity,
      child: isScroll ? SingleChildScrollView(child: body) : body,
    );
  }
}
