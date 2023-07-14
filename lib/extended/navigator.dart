import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ExtendedWillPopScope extends WillPopScope {
  ExtendedWillPopScope({
    super.key,
    required super.child,
    WillPopCallback? onWillPop,

    /// true 点击android实体返回按键先关闭Overlay【toast loading ...】但不pop 当前页面
    /// false 点击android实体返回按键先关闭Overlay【toast loading ...】并pop 当前页面
    bool isCloseOverlay = false,
  }) : super(onWillPop: () async {
          bool result = (await onWillPop?.call()) ?? true;
          if (result == false) return result;
          if (isCloseOverlay && ExtendedOverlay().overlayEntryList.isNotEmpty) {
            closeOverlay();
            return false;
          }
          result = GlobalOptions().isWillPop;
          return result;
        });
}

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
Future<bool> maybePop<T extends Object>([T? result]) {
  assert(GlobalOptions().navigatorKey.currentState != null);
  return GlobalOptions().navigatorKey.currentState!.maybePop<T>(result);
}

/// 返回上一个页面
Future<bool?> pop<T extends Object>([T? result, bool isMaybe = false]) {
  if (isMaybe) {
    return maybePop<T>(result);
  } else {
    assert(GlobalOptions().navigatorKey.currentState != null);
    GlobalOptions().navigatorKey.currentState!.pop<T>(result);
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
void popUntil(RoutePredicate predicate) {
  assert(GlobalOptions().navigatorKey.currentState != null);
  return GlobalOptions().navigatorKey.currentState!.popUntil(predicate);
}
