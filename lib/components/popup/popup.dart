import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

export 'spinKit/spin_kit.dart';

part 'loading.dart';

part 'modal.dart';

/// loading 加载框 关闭 closeLoading();
ExtendedOverlayEntry? showLoading({
  /// 通常使用自定义的
  Widget? custom,

  /// 底层模态框配置
  ModalWindowsOptions? options,

  /// 官方 ProgressIndicator 底部加个组件
  Widget? extra,

  /// 以下为官方三个 ProgressIndicator 配置
  double? value,
  Color? backgroundColor,
  Animation<Color>? valueColor,
  double strokeWidth = 4.0,
  String? semanticsLabel,
  String? semanticsValue,
  LoadingStyle? style,
}) =>
    ExtendedOverlay().showLoading(
        custom: custom,
        extra: extra,
        options: options,
        value: value,
        backgroundColor: backgroundColor,
        valueColor: valueColor,
        strokeWidth: strokeWidth,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
        style: style);

bool closeLoading() => ExtendedOverlay().closeLoading();

/// 关闭 closePopup()
/// 弹出双选项
Future<T?>? showDoubleChooseWindows<T>({
  required Widget content,
  Widget? left,
  Widget? right,

  /// 弹窗背景色
  Color? backgroundColor,

  /// 不建议设置 高度
  double? height,

  /// 默认距离left=30  right=30
  double? width,
  EdgeInsetsGeometry? padding,

  /// 弹窗 decoration
  Decoration? decoration,

  /// 是否使用Overlay
  bool isOverlay = false,

  /// GeneralDialog 配置 [isOverlay]=false 有效
  GeneralDialogOptions? options,

  /// 底层modal配置
  ModalWindowsOptions? modelOptions,
}) {
  final PopupDoubleChooseWindows widget = PopupDoubleChooseWindows(
      options: modelOptions,
      width: width,
      content: content,
      left: left,
      right: right,
      decoration: decoration,
      height: height,
      backgroundColor: backgroundColor,
      padding: padding);
  if (isOverlay) {
    showOverlay(widget);
    return null;
  }
  return showDialogPopup(
      widget: widget, options: options ??= GlobalOptions().dialogOptions);
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBar(
    SnackBar snackBar) {
  if (GlobalOptions().globalScaffoldMessengerKey == null) {
    log('Please initialize globalScaffoldMessengerKey or ExtendedWidgetsApp widgetMode must be RoutePushStyle.material');
    return null;
  }
  return GlobalOptions()
      .globalScaffoldMessengerKey
      ?.currentState
      ?.showSnackBar(snackBar);
}

Future<T?> showMenuPopup<T>({
  required RelativeRect position,
  required List<PopupMenuEntry<T>> items,
  T? initialValue,
  double? elevation,
  String? semanticLabel,
  ShapeBorder? shape,
  Color? color,
  bool useRootNavigator = false,
}) =>
    showMenu(
        context: GlobalOptions().globalNavigatorKey.currentContext!,
        position: position,
        useRootNavigator: useRootNavigator,
        initialValue: initialValue,
        elevation: elevation,
        semanticLabel: semanticLabel,
        shape: shape,
        color: color,
        items: items);

Future<T?> showDialogPopup<T>({
  /// 这个参数是一个方法,入参是 context,animation,secondaryAnimation,返回一个 Widget
  RoutePageBuilder? builder,

  /// 这个 [widget] 就是显示在页面上的 dialog
  Widget? widget,

  /// GeneralDialog 配置
  GeneralDialogOptions? options,
}) {
  assert(builder != null || widget != null);
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
          return FractionalTranslation(translation: translation, child: child);
        };
  }
  return showGeneralDialog(
      context: GlobalOptions().globalNavigatorKey.currentContext!,
      pageBuilder: builder ?? (_, Animation<double> animation, __) => widget!,
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
Future<T?> showBottomPopup<T>({
  WidgetBuilder? builder,
  Widget? widget,
  BottomSheetOptions? options,
}) {
  assert(builder != null || widget != null);
  options ??= GlobalOptions().bottomSheetOptions;
  return showModalBottomSheet(
      context: GlobalOptions().globalNavigatorKey.currentContext!,
      builder: builder ?? widget!.toWidgetBuilder,
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
  Widget? widget,
  bool useRootNavigator = true,
  ImageFilter? filter,
  Color barrierColor = kCupertinoModalBarrierColor,
  bool barrierDismissible = true,
  bool? semanticsDismissible,
  RouteSettings? routeSettings,
}) {
  assert(builder != null || widget != null);
  return showCupertinoModalPopup(
      context: GlobalOptions().globalNavigatorKey.currentContext!,
      builder: builder ?? (BuildContext context) => widget!,
      filter: filter,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      semanticsDismissible: semanticsDismissible,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator);
}

/// 关闭弹窗
/// 也可以通过 Navigator.of(context).maybePop()
Future<bool> closePopup([dynamic value]) => maybePop(value);

/// 弹窗进入方向属性
enum PopupFromStyle {
  /// 从左边进入
  fromLeft,

  /// 从右边进入
  fromRight,

  /// 从头部进入
  fromTop,

  /// 从底部进入
  fromBottom,

  /// 默认渐变显示
  fromCenter,
}

/// 关闭 [closePopup]
class GeneralDialogOptions {
  const GeneralDialogOptions({
    this.startOffset,
    this.barrierLabel = '',
    this.barrierDismissible = true,
    this.transitionBuilder,
    this.routeSettings,
    this.barrierColor = const Color(0x80000000),
    this.transitionDuration = const Duration(milliseconds: 200),
    this.useRootNavigator = true,
    this.fromStyle = PopupFromStyle.fromCenter,
  });

  /// 进入方向的距离
  final double? startOffset;

  /// popup 进入的方向
  final PopupFromStyle fromStyle;

  /// 是否可以点击背景关闭 默认为 true 可关闭
  final bool barrierDismissible;

  /// 语义化
  final String barrierLabel;

  /// 背景颜色
  final Color barrierColor;

  /// 这个是从开始到完全显示的时间
  final Duration transitionDuration;

  /// 路由显示和隐藏的过程 这里入参是 animation,secondaryAnimation 和 child, 其中 child 是 是 pageBuilder 构建的 widget
  final RouteTransitionsBuilder? transitionBuilder;

  final bool useRootNavigator;

  final RouteSettings? routeSettings;

  GeneralDialogOptions copyWith({
    double? startOffset,
    PopupFromStyle? fromStyle,
    bool? barrierDismissible,
    String? barrierLabel,
    Color? barrierColor,
    Duration? transitionDuration,
    RouteTransitionsBuilder? transitionBuilder,
    bool? useRootNavigator,
    RouteSettings? routeSettings,
  }) =>
      GeneralDialogOptions(
          startOffset: startOffset ?? this.startOffset,
          fromStyle: fromStyle ?? this.fromStyle,
          barrierDismissible: barrierDismissible ?? this.barrierDismissible,
          barrierLabel: barrierLabel ?? this.barrierLabel,
          barrierColor: barrierColor ?? this.barrierColor,
          transitionDuration: transitionDuration ?? this.transitionDuration,
          transitionBuilder: transitionBuilder ?? this.transitionBuilder,
          useRootNavigator: useRootNavigator ?? this.useRootNavigator,
          routeSettings: routeSettings ?? this.routeSettings);

  GeneralDialogOptions merge([GeneralDialogOptions? options]) =>
      GeneralDialogOptions(
          startOffset: options?.startOffset ?? startOffset,
          fromStyle: options?.fromStyle ?? fromStyle,
          barrierDismissible: options?.barrierDismissible ?? barrierDismissible,
          barrierLabel: options?.barrierLabel ?? barrierLabel,
          barrierColor: options?.barrierColor ?? barrierColor,
          transitionDuration: options?.transitionDuration ?? transitionDuration,
          transitionBuilder: options?.transitionBuilder ?? transitionBuilder,
          useRootNavigator: options?.useRootNavigator ?? useRootNavigator,
          routeSettings: options?.routeSettings ?? routeSettings);
}

class BottomSheetOptions {
  const BottomSheetOptions({
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.barrierColor,
    this.routeSettings,
    this.transitionAnimationController,
    this.useRootNavigator = false,
    this.isDismissible = true,
    this.enableDrag = true,
    this.isScrollControlled = true,
  });

  /// BottomSheet 背景色
  final Color? backgroundColor;

  /// 底部阴影
  final double? elevation;

  final ShapeBorder? shape;

  final Clip? clipBehavior;

  /// 整个背景弹窗背景色 默认[Colors.black54]
  final Color? barrierColor;

  /// [isDismissible] = true 背景点击可关闭弹窗 默认 [true]
  final bool isDismissible;

  /// 开启滑动关闭 默认[true]
  final bool enableDrag;

  /// [isScrollControlled] = true 可全屏显示 默认 [true]
  final bool isScrollControlled;

  final RouteSettings? routeSettings;

  final bool useRootNavigator;

  final AnimationController? transitionAnimationController;

  BottomSheetOptions copyWith({
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    Color? barrierColor,
    bool? isDismissible,
    bool? enableDrag,
    bool? isScrollControlled,
    RouteSettings? routeSettings,
    bool? useRootNavigator,
    AnimationController? transitionAnimationController,
  }) =>
      BottomSheetOptions(
          backgroundColor: backgroundColor ?? this.backgroundColor,
          elevation: elevation ?? this.elevation,
          shape: shape ?? this.shape,
          clipBehavior: clipBehavior ?? this.clipBehavior,
          barrierColor: barrierColor ?? this.barrierColor,
          isDismissible: isDismissible ?? this.isDismissible,
          enableDrag: enableDrag ?? this.enableDrag,
          isScrollControlled: isScrollControlled ?? this.isScrollControlled,
          routeSettings: routeSettings ?? this.routeSettings,
          useRootNavigator: useRootNavigator ?? this.useRootNavigator,
          transitionAnimationController: transitionAnimationController ??
              this.transitionAnimationController);

  BottomSheetOptions merge([BottomSheetOptions? options]) => BottomSheetOptions(
      backgroundColor: options?.backgroundColor ?? backgroundColor,
      elevation: options?.elevation ?? elevation,
      shape: options?.shape ?? shape,
      clipBehavior: options?.clipBehavior ?? clipBehavior,
      barrierColor: options?.barrierColor ?? barrierColor,
      isDismissible: options?.isDismissible ?? isDismissible,
      enableDrag: options?.enableDrag ?? enableDrag,
      isScrollControlled: options?.isScrollControlled ?? isScrollControlled,
      routeSettings: options?.routeSettings ?? routeSettings,
      useRootNavigator: options?.useRootNavigator ?? useRootNavigator,
      transitionAnimationController: options?.transitionAnimationController ??
          transitionAnimationController);
}
