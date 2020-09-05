import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/widgets.dart';

GlobalKey<NavigatorState> _globalNavigatorKey = GlobalKey();
List<GlobalKey<State>> _scaffoldKeyList = [];
List<OverlayEntryMap> _overlayEntryList = [];
var _overlay;

///GlobalMaterial
class GlobalMaterial extends StatelessWidget {
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
  })  : this.debugShowMaterialGrid = debugShowMaterialGrid ?? false,
        this.showPerformanceOverlay = showPerformanceOverlay ?? false,
        this.checkerboardRasterCacheImages = checkerboardRasterCacheImages ?? false,
        this.checkerboardOffscreenLayers = checkerboardOffscreenLayers ?? false,
        this.showSemanticsDebugger = showSemanticsDebugger ?? false,
        this.debugShowCheckedModeBanner = debugShowCheckedModeBanner ?? false,
        this.themeMode = themeMode ?? ThemeMode.system,
        this.title = title ?? "",
        this.routes = routes ?? const <String, WidgetBuilder>{},
        this.navigatorObservers = navigatorObservers ?? [],
        this.locale = locale ?? Locale('zh'),
        this.supportedLocales = supportedLocales ?? [Locale('zh', 'CH'), Locale('en', 'US')],
        this.localizationsDelegates = localizationsDelegates ??
            [
              DefaultCupertinoLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
        super(key: key);

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
      actions: actions,
    );
  }
}

///GlobalCupertino
class GlobalCupertino extends StatelessWidget {
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
  })  : this.showPerformanceOverlay = showPerformanceOverlay ?? false,
        this.checkerboardRasterCacheImages = checkerboardRasterCacheImages ?? false,
        this.checkerboardOffscreenLayers = checkerboardOffscreenLayers ?? false,
        this.showSemanticsDebugger = showSemanticsDebugger ?? false,
        this.debugShowCheckedModeBanner = debugShowCheckedModeBanner ?? false,
        this.title = title ?? "",
        this.routes = routes ?? const <String, WidgetBuilder>{},
        this.navigatorObservers = navigatorObservers ?? [],
        this.locale = locale ?? const Locale('zh', 'CN'),
        this.supportedLocales = supportedLocales ?? [const Locale('zh', 'CN'), const Locale('en', 'US')],
        this.localizationsDelegates = localizationsDelegates ??
            [
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
        super(key: key);

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
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
    );
  }
}

///OverlayScaffold
class OverlayScaffold extends StatefulWidget {
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
  })  : this.isScroll = isScroll ?? false,
        this.isolationBody = isolationBody ?? false,
        this.onWillPopOverlayClose = onWillPopOverlayClose ?? true,
        this.paddingStatusBar = paddingStatusBar ?? false,
        this.enablePullDown = enablePullDown ?? false,
        this.primary = primary ?? true,
        this.extendBody = extendBody ?? false,
        this.drawerDragStartBehavior = drawerDragStartBehavior ?? DragStartBehavior.start,
        super(key: key);

  @override
  _OverlayScaffoldState createState() => _OverlayScaffoldState();
}

class _OverlayScaffoldState extends State<OverlayScaffold> {
  GlobalKey<State> _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.key != null) _globalKey = widget.key;
  }

  @override
  Widget build(BuildContext context) {
    Widget scaffold = WillPopScope(
        onWillPop: widget.onWillPop ??
            () async {
              if (widget.onWillPopOverlayClose &&
                  _overlayEntryList.length > 0 &&
                  !_overlayEntryList.last.isAutomaticOff) {
                closeOverlay();
                return false;
              }
              return true;
            },
        child: Scaffold(
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
          body: bodyWidget(context),
        ));
    if (!_scaffoldKeyList.contains(_globalKey)) _scaffoldKeyList.add(_globalKey);
    return scaffold;
  }

  Widget bodyWidget(BuildContext context) => widget.enablePullDown ? refresherContainer() : container();

  Widget refresherContainer() => Refreshed(
        enablePullDown: widget.enablePullDown,
        controller: widget.controller,
        onRefresh: widget.onRefresh,
        child: container(),
        header: widget.header,
      );

  PreferredSizeWidget appBar() {
    if (widget.appBar is AppBar && widget.appBarHeight == null) return widget.appBar;
    return widget.appBar == null
        ? null
        : PreferredSize(
            child: widget.appBar,
            preferredSize: Size.fromHeight(MediaQueryTools.getStatusBarHeight() + widget.appBarHeight ?? 30));
  }

  Widget container() => Container(
        color: widget.backgroundColor,
        margin: widget.isolationBody ? EdgeInsets.only(top: ScreenFit.getHeight(10)) : EdgeInsets.zero,
        padding: widget.paddingStatusBar ? EdgeInsets.only(top: MediaQueryTools.getStatusBarHeight()) : widget.padding,
        width: double.infinity,
        height: double.infinity,
        child: widget.isScroll ? SingleChildScrollView(child: widget.body) : widget.body,
      );

  @override
  void dispose() {
    super.dispose();
    if (_scaffoldKeyList.contains(_globalKey)) _scaffoldKeyList.remove(_globalKey);
  }
}

///************ 以下为 路由跳转 *****************///
Future<T> push<T>(
    {WidgetBuilder builder,
    Widget widget,
    String title,
    RouteSettings settings,
    bool maintainState,
    bool fullscreenDialog,
    PushMode pushMode}) {
  var route = _pageRoute(
      title: title,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      settings: settings,
      builder: builder,
      pushMode: pushMode,
      widget: widget);
  return Navigator.of(_globalNavigatorKey.currentContext).push(route);
}

Future<T> pushReplacement<T>(
    {WidgetBuilder builder,
    Widget widget,
    String title,
    RouteSettings settings,
    bool maintainState,
    bool fullscreenDialog,
    PushMode pushMode}) {
  var route = _pageRoute(
      title: title,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      settings: settings,
      builder: builder,
      pushMode: pushMode,
      widget: widget);
  return Navigator.of(_globalNavigatorKey.currentContext).pushReplacement(route);
}

Future<T> pushAndRemoveUntil<T>(
    {WidgetBuilder builder,
    Widget widget,
    String title,
    RouteSettings settings,
    bool maintainState,
    bool fullscreenDialog,
    PushMode pushMode}) {
  var route = _pageRoute(
      title: title,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      settings: settings,
      builder: builder,
      pushMode: pushMode,
      widget: widget);
  return Navigator.of(_globalNavigatorKey.currentContext).pushAndRemoveUntil(route, (route) => false);
}

pop<T extends Object>([T result]) => Navigator.of(_globalNavigatorKey.currentContext).pop(result);

PushMode _pushMode;

setGlobalPushMode(PushMode pushMode) => _pushMode = pushMode;

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
  if (pushMode == null) pushMode = PushMode.cupertino;
  if (pushMode == PushMode.cupertino) {
    return CupertinoPageRoute(
        title: title,
        maintainState: maintainState ?? true,
        fullscreenDialog: fullscreenDialog ?? false,
        settings: settings,
        builder: builder ?? (BuildContext context) => widget);
  }
  return MaterialPageRoute(
      maintainState: maintainState ?? true,
      fullscreenDialog: fullscreenDialog ?? false,
      settings: settings,
      builder: builder ?? (BuildContext context) => widget);
}

///************ 以下为Scaffold Overlay *****************///
class OverlayEntryMap {
  ///叠层
  final OverlayEntry overlayEntry;

  ///是否自动关闭
  final bool isAutomaticOff;

  OverlayEntryMap({this.overlayEntry, this.isAutomaticOff});
}

///自定义叠层
OverlayEntryMap showOverlay(Widget widget, {bool isAutomaticOff}) {
  if (_overlay != null) _overlay = null;
  _overlay = Overlay.of(_scaffoldKeyList?.last?.currentContext, rootOverlay: false);
  if (_overlay == null) return null;
  OverlayEntry entry = OverlayEntry(builder: (context) => widget);
  _overlay.insert(entry);
  var entryMap = OverlayEntryMap(overlayEntry: entry, isAutomaticOff: isAutomaticOff ?? false);
  _overlayEntryList.add(entryMap);
  return entryMap;
}

///关闭最顶层的叠层
void closeOverlay({OverlayEntryMap element}) {
  try {
    if (element != null) {
      element.overlayEntry.remove();
      if (_overlayEntryList.contains(element)) _overlayEntryList.remove(element);
    } else {
      if (_overlayEntryList.length > 0) {
        _overlayEntryList.last.overlayEntry.remove();
        _overlayEntryList.remove(_overlayEntryList.last);
      }
    }
  } catch (e) {
    log(e);
  }
}

///关闭所有Overlay
void closeAllOverlay() {
  _overlayEntryList.forEach((element) => element.overlayEntry.remove());
  _overlayEntryList = [];
}

///loading 加载框
///关闭 closeOverlay();
OverlayEntryMap showLoading({
  String text,
  double value,
  bool gaussian,
  Color backgroundColor,
  Animation<Color> valueColor,
  double strokeWidth,
  String semanticsLabel,
  String semanticsValue,
  LoadingType loadingType,
  TextStyle textStyle,
}) {
  var loading = Loading(
    gaussian: gaussian,
    text: text,
    value: value,
    backgroundColor: backgroundColor,
    valueColor: valueColor,
    strokeWidth: strokeWidth ?? 4.0,
    semanticsLabel: semanticsLabel,
    semanticsValue: semanticsValue,
    loadingType: loadingType ?? LoadingType.circular,
    textStyle: textStyle,
  );
  return showOverlay(loading);
}

///Toast
Duration _duration = Duration(milliseconds: 1500);

///设置全局弹窗时间
void setToastDuration(Duration duration) {
  _duration = duration;
}

bool haveToast = false;

///Toast
///关闭 closeOverlay();
void showToast(String message,
    {Color backgroundColor,
    BoxDecoration boxDecoration,
    GestureTapCallback onTap,
    TextStyle textStyle,
    Duration closeDuration}) {
  if (haveToast) return;
  var entry = showOverlay(
      PopupBase(
          onTap: () => closeOverlay(),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: ScreenFit.getWidth(0) / 5, vertical: ScreenFit.getHeight(0) / 4),
            decoration:
                boxDecoration ?? BoxDecoration(color: getColors(black90), borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.all(10),
            child: Widgets.textDefault(message, color: getColors(white), maxLines: 4),
          )),
      isAutomaticOff: true);
  haveToast = true;
  Tools.timerTools(closeDuration ?? _duration, () {
    closeOverlay(element: entry);
    haveToast = false;
  });
}

///************ 以下为push Popup *****************///

///showGeneralDialog 去除context
///添加popup进入方向属性
///关闭 closePopup()
///Dialog
Future<T> showDialogPopup<T>({
  ///进入方向的距离
  double startOffset,

  ///popup 进入的方向
  PopupFromType popupFromType,

  ///这个参数是一个方法,入参是 context,animation,secondaryAnimation,返回一个 Widget
  ///这个 Widget 就是显示在页面上的 dialog
  RoutePageBuilder pageBuilder,
  Widget widget,

  ///是否可以点击背景关闭
  bool barrierDismissible,

  ///语义化
  String barrierLabel,

  ///背景颜色
  Color backgroundColor,

  ///这个是从开始到完全显示的时间
  Duration transitionDuration,

  ///路由显示和隐藏的过程,这里入参是 animation,secondaryAnimation 和 child, 其中 child 是 是 pageBuilder 构建的 widget
  RouteTransitionsBuilder transitionBuilder,
  bool useRootNavigator,
  RouteSettings routeSettings,
}) {
  assert(pageBuilder != null || widget != null);
  if (transitionBuilder == null && popupFromType != null) {
    transitionBuilder = (context, animation, _, child) {
      var translation = Offset(0, 1 - animation.value);
      switch (popupFromType) {
        case PopupFromType.fromLeft:
          translation = Offset(animation.value - 1, 0);
          break;
        case PopupFromType.fromRight:
          translation = Offset(1 - animation.value, 0);
          break;
        case PopupFromType.fromTop:
          translation = Offset(0, animation.value - 1);
          break;
        case PopupFromType.fromBottom:
          translation = Offset(0, 1 - animation.value);
          break;
      }
      return FractionalTranslation(translation: translation, child: child);
    };
  }
  return showGeneralDialog(
    context: _globalNavigatorKey.currentContext,
    pageBuilder: pageBuilder ?? (BuildContext context, Animation animation, Animation secondaryAnimation) => widget,
    barrierDismissible: barrierDismissible ?? true,
    barrierLabel: barrierLabel ?? '',
    barrierColor: backgroundColor,
    transitionDuration: transitionDuration ?? Duration(milliseconds: 80),
    transitionBuilder: transitionBuilder,
    useRootNavigator: useRootNavigator ?? true,
    routeSettings: routeSettings,
  );
}

///showModalBottomSheet 去除context
///关闭 closePopup()
///最高只有屏幕的一半
Future<T> showBottomPopup<T>({
  WidgetBuilder builder,
  Widget widget,
  Color backgroundColor,
  double elevation,
  ShapeBorder shape,
  Clip clipBehavior,
  Color barrierColor,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  assert(builder != null || widget != null);
  return showModalBottomSheet(
    context: _globalNavigatorKey.currentContext,
    builder: builder ?? (BuildContext context) => widget,
    backgroundColor: backgroundColor,
    elevation: elevation,
    shape: shape,
    clipBehavior: clipBehavior,
    barrierColor: barrierColor,
    isScrollControlled: isScrollControlled,
    useRootNavigator: useRootNavigator,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
  );
}

///showCupertinoModalPopup
///去除context 简化参数
///关闭 closePopup()
///全屏显示
Future<T> showBottomPagePopup<T>({
  WidgetBuilder builder,
  Widget widget,
  ImageFilter filter,
  bool useRootNavigator = true,
  bool semanticsDismissible,
}) {
  assert(builder != null || widget != null);
  return showCupertinoModalPopup(
    context: _globalNavigatorKey.currentContext,
    builder: builder ?? (BuildContext context) => widget,
    filter: filter,
    useRootNavigator: useRootNavigator,
    semanticsDismissible: semanticsDismissible,
  );
}

///关闭 closePopup()
///popup 确定和取消
///Dialog
Future<T> dialogSureCancel<T>({
  @required List<Widget> children,
  GestureTapCallback sureTap,
  GestureTapCallback cancelTap,
  String cancelText,
  String sureText,
  Widget sure,
  Widget cancel,
  PopupMode popupMode,
  Color backgroundColor,
  TextStyle cancelTextStyle,
  TextStyle sureTextStyle,
  double height,
  bool isDismissible: true,
  EdgeInsetsGeometry padding,
  EdgeInsetsGeometry margin,
  AlignmentGeometry alignment,
  Decoration decoration,
  bool animatedOpacity,
  bool gaussian,
  double width,
  bool addMaterial, //是否添加Material Widget 部分组件需要基于Material
}) {
  var popup = PopupSureCancel(
    backsideTap: () {
      if (isDismissible) closePopup();
    },
    width: width,
    popupMode: popupMode,
    addMaterial: addMaterial,
    animatedOpacity: animatedOpacity,
    gaussian: gaussian,
    children: children,
    sureTap: sureTap ?? () => closePopup(),
    cancelTap: cancelTap ?? () => closePopup(),
    decoration: decoration,
    alignment: alignment,
    cancelText: cancelText,
    sureText: sureText,
    height: height,
    cancelTextStyle: cancelTextStyle,
    sureTextStyle: sureTextStyle,
    sure: sure,
    cancel: cancel,
    backgroundColor: backgroundColor,
    padding: padding,
    margin: margin,
  );
  return showDialogPopup(widget: popup);
}

///关闭弹窗
///也可以通过 Navigator.of(context).pop()
closePopup() {
  pop();
}

///日期选择器
///关闭 closePopup()
Future<T> showDateTimePicker<T>({
  ///背景色
  Color backgroundColor,

  ///头部
  Widget titleBottom,
  Widget title,

  ///头部右侧 确定
  Widget sure,

  ///头部左侧 取消
  Widget cancel,

  ///内容文字样式
  TextStyle contentStyle,

  ///选择框内单位文字样式
  TextStyle unitStyle,

  ///取消点击事件
  GestureTapCallback cancelTap,

  ///确认点击事件
  ValueChanged<String> sureTap,

  ///单个item的高度
  double itemHeight,

  ///单个item的宽度
  double itemWidth,

  ///整个弹框高度
  double height,

  ///开始时间
  DateTime startDate,

  ///默认选中时间
  DateTime defaultDate,

  ///结束时间
  DateTime endDate,

  ///补全双位数
  bool dual,

  ///是否显示单位
  bool showUnit,

  ///单位设置
  DateTimePickerUnit unit,

  /// 半径大小,越大则越平面,越小则间距越大
  double diameterRatio,

  /// 选中item偏移
  double offAxisFraction,

  ///表示车轮水平偏离中心的程度  范围[0,0.01]
  double perspective,

  ///放大倍率
  double magnification,

  ///是否启用放大镜
  bool useMagnifier,

  ///1或者2
  double squeeze,
  ScrollPhysics physics,
}) {
  Tools.closeKeyboard(_globalNavigatorKey.currentContext);
  Widget widget = DateTimePicker(
      diameterRatio: diameterRatio,
      offAxisFraction: offAxisFraction,
      perspective: perspective,
      magnification: magnification,
      useMagnifier: useMagnifier,
      squeeze: squeeze,
      itemHeight: itemHeight,
      itemWidth: itemWidth,
      height: height,
      startDate: startDate,
      endDate: endDate,
      defaultDate: defaultDate,
      dual: dual,
      showUnit: showUnit,
      unit: unit,
      backgroundColor: backgroundColor,
      sure: sure,
      title: title,
      cancel: cancel,
      titleBottom: titleBottom,
      contentStyle: contentStyle,
      unitStyle: unitStyle,
      cancelTap: cancelTap ?? () => closePopup(),
      sureTap: sureTap ?? () => closePopup());
  return showBottomPopup(widget: widget);
}

///地区选择器
///关闭 closePopup()
Future<T> showAreaPicker<T>({
  ///背景色
  Color backgroundColor,

  ///头部
  Widget titleBottom,
  Widget title,

  ///头部右侧 确定
  Widget sure,

  ///头部左侧 取消
  Widget cancel,

  ///内容文字样式
  TextStyle contentStyle,

  ///取消点击事件
  GestureTapCallback cancelTap,

  ///确认点击事件
  ValueChanged<String> sureTap,

  ///单个item的高度
  double itemHeight,

  ///单个item的宽度
  double itemWidth,

  ///整个弹框高度
  double height,

  /// 半径大小,越大则越平面,越小则间距越大
  double diameterRatio,

  /// 选中item偏移
  double offAxisFraction,

  ///表示车轮水平偏离中心的程度  范围[0,0.01]
  double perspective,

  ///放大倍率
  double magnification,

  ///是否启用放大镜
  bool useMagnifier,

  ///1或者2
  double squeeze,
  ScrollPhysics physics,
  String defaultProvince,
  String defaultCity,
  String defaultDistrict,
}) {
  Tools.closeKeyboard(_globalNavigatorKey.currentContext);
  Widget widget = AreaPicker(
      defaultProvince: defaultProvince,
      defaultCity: defaultCity,
      defaultDistrict: defaultDistrict,
      diameterRatio: diameterRatio,
      offAxisFraction: offAxisFraction,
      perspective: perspective,
      magnification: magnification,
      useMagnifier: useMagnifier,
      squeeze: squeeze,
      itemHeight: itemHeight,
      itemWidth: itemWidth,
      height: height,
      backgroundColor: backgroundColor,
      sure: sure,
      title: title,
      cancel: cancel,
      titleBottom: titleBottom,
      contentStyle: contentStyle,
      cancelTap: cancelTap ?? () => closePopup(),
      sureTap: sureTap ?? () => closePopup());
  return showBottomPopup(widget: widget);
}

///wheel 单列 取消确认 选择
///关闭 closePopup()
Future<T> showMultipleChoicePicker<T>({
  ///默认选中
  int initialIndex,

  ///背景色
  Color color,

  ///确认按钮
  Widget sure,

  ///取消按钮
  Widget cancel,

  ///头部文字
  Widget title,

  ///取消点击事件
  GestureTapCallback cancelTap,

  ///确认点击事件
  ValueChanged<int> sureTap,

  ///单个item的高度
  double itemHeight,

  ///单个item的宽度
  double itemWidth,

  ///整个弹框高度
  double height,

  /// 半径大小,越大则越平面,越小则间距越大
  double diameterRatio,

  /// 选中item偏移
  double offAxisFraction,

  ///表示车轮水平偏离中心的程度  范围[0,0.01]
  double perspective,

  ///放大倍率
  double magnification,

  ///是否启用放大镜
  bool useMagnifier,

  ///1或者2
  double squeeze,
  ScrollPhysics physics,
  @required int itemCount,
  @required IndexedWidgetBuilder itemBuilder,
}) {
  Tools.closeKeyboard(_globalNavigatorKey.currentContext);
  Widget widget = MultipleChoicePicker(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      diameterRatio: diameterRatio,
      offAxisFraction: offAxisFraction,
      perspective: perspective,
      magnification: magnification,
      useMagnifier: useMagnifier,
      squeeze: squeeze,
      itemHeight: itemHeight,
      itemWidth: itemWidth,
      height: height,
      initialIndex: initialIndex,
      sure: sure,
      cancel: cancel,
      title: title,
      color: color,
      cancelTap: cancelTap ?? () => closePopup(),
      sureTap: sureTap ?? () => closePopup());
  return showBottomPopup(widget: widget);
}

///不常用

///showCupertinoDialog
///去除context 简化参数
///关闭 closePopup()
Future<T> showSimpleCupertinoDialog<T>({
  WidgetBuilder builder,
  Widget widget,
  bool useRootNavigator = true,
  bool barrierDismissible = false,
  RouteSettings routeSettings,
}) {
  assert(builder != null || widget != null);
  return showCupertinoDialog(
    context: _globalNavigatorKey.currentContext,
    builder: builder ?? (BuildContext context) => widget,
    useRootNavigator: useRootNavigator,
    barrierDismissible: barrierDismissible,
    routeSettings: routeSettings,
  );
}

///showDialog 去除context
///关闭 closePopup()
///Dialog
Future<T> showSimpleDialog<T>({
  WidgetBuilder builder,
  Widget widget,
  bool barrierDismissible = true,
  Color barrierColor,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings routeSettings,
  Widget child,
}) {
  assert(builder != null || widget != null);
  return showDialog(
    context: _globalNavigatorKey.currentContext,
    builder: builder ?? (BuildContext context) => widget,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    useSafeArea: useSafeArea,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    child: child,
  );
}

///showMenu 去除context
///关闭 closePopup()
Future<T> showMenuPopup<T>({
  @required RelativeRect position,
  @required List<PopupMenuEntry<T>> items,
  T initialValue,
  double elevation,
  String semanticLabel,
  ShapeBorder shape,
  Color color,
  bool captureInheritedThemes = true,
  bool useRootNavigator = false,
}) {
  return showMenu(
    context: _globalNavigatorKey.currentContext,
    items: items,
    initialValue: initialValue,
    elevation: elevation,
    semanticLabel: semanticLabel,
    shape: shape,
    color: color,
    captureInheritedThemes: captureInheritedThemes,
    useRootNavigator: useRootNavigator,
    position: position,
  );
}
