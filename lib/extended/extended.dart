import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

export 'extended_widgets.dart';
export 'global_options.dart';
export 'icon.dart';
export 'list_wheel.dart';
export 'overlay/overlay.dart';
export 'popup_options.dart';
export 'scroll_view/scroll_view.dart';
export 'tab_bar.dart';
export 'text.dart';
export 'text_field.dart';
export 'universal.dart';

class SystemUiOverlayStyleLight extends SystemUiOverlayStyle {
  const SystemUiOverlayStyleLight(
      {super.systemNavigationBarColor = Colors.transparent,
      super.systemNavigationBarDividerColor = Colors.transparent,
      super.statusBarColor = Colors.transparent,
      super.systemNavigationBarIconBrightness = Brightness.light,
      super.statusBarIconBrightness = Brightness.light,
      super.statusBarBrightness = Brightness.dark});
}

class SystemUiOverlayStyleDark extends SystemUiOverlayStyle {
  const SystemUiOverlayStyleDark(
      {super.systemNavigationBarColor = Colors.transparent,
      super.systemNavigationBarDividerColor = Colors.transparent,
      super.statusBarColor = Colors.transparent,
      super.systemNavigationBarIconBrightness = Brightness.dark,
      super.statusBarIconBrightness = Brightness.dark,
      super.statusBarBrightness = Brightness.light});
}

extension ExtensionWidgetMethod on Widget {
  Future<T?> push<T extends Object?, TO extends Object?>(
      {bool maintainState = true,
      bool fullscreenDialog = false,
      RoutePushStyle pushStyle = RoutePushStyle.material,
      RouteSettings? settings,
      bool replacement = false,
      TO? result}) {
    if (replacement) {
      return pushReplacement(
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          pushStyle: pushStyle,
          result: result);
    } else {
      return GlobalOptions().globalNavigatorKey.currentState!.push(
          buildPageRoute(
              maintainState: maintainState,
              fullscreenDialog: fullscreenDialog,
              settings: settings,
              pushStyle: pushStyle));
    }
  }

  /// 打开新页面替换当前页面
  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
          {bool maintainState = true,
          bool fullscreenDialog = false,
          RoutePushStyle pushStyle = RoutePushStyle.material,
          RouteSettings? settings,
          TO? result}) =>
      GlobalOptions().globalNavigatorKey.currentState!.pushReplacement(
          buildPageRoute(
              settings: settings,
              maintainState: maintainState,
              fullscreenDialog: fullscreenDialog,
              pushStyle: pushStyle),
          result: result);

  /// 打开新页面 并移出堆栈所有页面
  Future<T?> pushAndRemoveUntil<T extends Object?>(
          {bool maintainState = true,
          bool fullscreenDialog = false,
          RoutePushStyle pushStyle = RoutePushStyle.material,
          RouteSettings? settings,
          RoutePredicate? predicate}) =>
      GlobalOptions().globalNavigatorKey.currentState!.pushAndRemoveUntil(
          buildPageRoute(
              settings: settings,
              maintainState: maintainState,
              fullscreenDialog: fullscreenDialog,
              pushStyle: pushStyle),
          predicate ?? (_) => false);

  /// [ExtendedOverlay().showOverlay()]
  ExtendedOverlayEntry? showOverlay({bool autoOff = false}) =>
      ExtendedOverlay().showOverlay(this, autoOff: autoOff);

  /// [ExtendedOverlay().showLoading(this)]
  ExtendedOverlayEntry? showLoading({ModalWindowsOptions? options}) =>
      Loading(custom: this, options: options).show();

  /// [showDialogPopup]
  Future<T?> showDialogPopup<T>({
    /// 这个参数是一个方法,入参是 context,animation,secondaryAnimation,返回一个 Widget
    RoutePageBuilder? builder,

    /// GeneralDialog 配置
    GeneralDialogOptions? options,
  }) {
    options ??= GlobalOptions().dialogOptions;
    RouteTransitionsBuilder? transitionBuilder;
    if (options.fromStyle != PopupFromStyle.fromCenter) {
      transitionBuilder = options.transitionBuilder ??
          (__, Animation<double> animation, _, Widget child) {
            late Offset translation;
            switch (options!.fromStyle) {
              case PopupFromStyle.fromLeft:
                translation = Offset(animation.value - 1, 0);
                break;
              case PopupFromStyle.fromRight:
                translation = Offset(1 - animation.value, 0);
                break;
              case PopupFromStyle.fromTop:
                translation = Offset(0, animation.value - 1);
                break;
              case PopupFromStyle.fromBottom:
                translation = Offset(0, 1 - animation.value);
                break;
              case PopupFromStyle.fromCenter:
                translation = const Offset(0, 0);
                break;
            }
            return FractionalTranslation(
                translation: translation, child: child);
          };
    }
    return showGeneralDialog(
        context: GlobalOptions().globalNavigatorKey.currentContext!,
        pageBuilder: builder ?? (_, Animation<double> animation, __) => this,
        barrierDismissible: options.barrierDismissible,
        barrierLabel: options.barrierLabel,
        barrierColor: options.barrierColor,
        transitionDuration: options.transitionDuration,
        transitionBuilder: transitionBuilder,
        useRootNavigator: options.useRootNavigator,
        routeSettings: options.routeSettings);
  }

  /// showModalBottomSheet
  /// 关闭 closePopup()
  Future<T?> showBottomPopup<T>(
      {WidgetBuilder? builder, BottomSheetOptions? options}) {
    options ??= GlobalOptions().bottomSheetOptions;
    return showModalBottomSheet(
        context: GlobalOptions().globalNavigatorKey.currentContext!,
        builder: builder ?? toWidgetBuilder,
        backgroundColor: options.backgroundColor,
        elevation: options.elevation,
        shape: options.shape,
        clipBehavior: options.clipBehavior,
        barrierColor: options.barrierColor,
        routeSettings: options.routeSettings,
        transitionAnimationController: options.transitionAnimationController,
        isScrollControlled: options.isScrollControlled,
        useRootNavigator: options.useRootNavigator,
        isDismissible: options.isDismissible,
        enableDrag: options.enableDrag);
  }

  /// showCupertinoModalPopup
  /// 关闭 closePopup()
  /// 全屏显示
  Future<T?> showCupertinoBottomPopup<T>({
    WidgetBuilder? builder,
    bool useRootNavigator = true,
    ImageFilter? filter,
    Color barrierColor = kCupertinoModalBarrierColor,
    bool barrierDismissible = true,
    bool? semanticsDismissible,
    RouteSettings? routeSettings,
  }) =>
      showCupertinoModalPopup(
          context: GlobalOptions().globalNavigatorKey.currentContext!,
          builder: builder ?? toWidgetBuilder,
          filter: filter,
          barrierColor: barrierColor,
          barrierDismissible: barrierDismissible,
          semanticsDismissible: semanticsDismissible,
          routeSettings: routeSettings,
          useRootNavigator: useRootNavigator);
}
