import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 关闭所有Overlay
void closeAllOverlay() => ExtendedOverlay().closeAllOverlay();

/// 关闭最顶层的Overlay
bool closeOverlay({ExtendedOverlayEntry? entry}) =>
    ExtendedOverlay().closeOverlay(entry: entry);

/// 自定义Overlay
ExtendedOverlayEntry? showOverlay(Widget widget, {bool autoOff = false}) =>
    ExtendedOverlay().showOverlay(widget, autoOff: autoOff);

/// Toast
/// 关闭 closeOverlay();
/// 添加 await Toast 关闭后继续执行之后的方法
Future<void> showToast(String message,
        {ToastStyle? style,
        AlignmentGeometry? positioned,
        IconData? customIcon,
        Duration? duration,
        ToastOptions? options}) =>
    ExtendedOverlay().showToast(message,
        options: options,
        duration: duration,
        positioned: positioned,
        customIcon: customIcon,
        style: style);

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
  var _options = options ?? GlobalOptions().dialogOptions;
  RouteTransitionsBuilder? transitionBuilder;
  if (_options.fromStyle != PopupFromStyle.fromCenter) {
    transitionBuilder = _options.transitionBuilder ??
        (__, Animation<double> animation, _, Widget child) {
          late Offset translation;
          switch (_options.fromStyle) {
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
      barrierDismissible: _options.barrierDismissible,
      barrierLabel: _options.barrierLabel,
      barrierColor: _options.barrierColor,
      transitionDuration: _options.transitionDuration,
      transitionBuilder: transitionBuilder,
      useRootNavigator: _options.useRootNavigator,
      routeSettings: _options.routeSettings);
}

/// showModalBottomSheet
/// 关闭 closePopup()
Future<T?> showBottomPopup<T>({
  WidgetBuilder? builder,
  Widget? widget,
  BottomSheetOptions? options,
}) {
  assert(builder != null || widget != null);
  BottomSheetOptions _options = options ?? GlobalOptions().bottomSheetOptions;
  return showModalBottomSheet(
      context: GlobalOptions().globalNavigatorKey.currentContext!,
      builder: builder ?? widget!.toWidgetBuilder,
      backgroundColor: _options.backgroundColor,
      elevation: _options.elevation,
      shape: _options.shape,
      clipBehavior: _options.clipBehavior,
      barrierColor: _options.barrierColor,
      routeSettings: _options.routeSettings,
      transitionAnimationController: _options.transitionAnimationController,
      isScrollControlled: _options.isScrollControlled,
      useRootNavigator: _options.useRootNavigator,
      isDismissible: _options.isDismissible,
      enableDrag: _options.enableDrag);
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

/// 关闭 closePopup()
/// 弹出双选项
Future<T?>? showDoubleChooseWindows<T>({
  required Widget content,
  Widget? left,
  Widget? right,

  /// 弹窗背景色
  Color? backgroundColor,

  /// 高度不建议设置
  double? height,
  double width = 300,
  EdgeInsetsGeometry? padding,

  /// 弹窗 decoration
  Decoration? decoration,

  /// 是否使用Overlay
  bool isOverlay = false,

  /// GeneralDialog 配置 [isOverlay]=false 有效
  GeneralDialogOptions? options,

  /// 低层modal配置
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
  var _options = GlobalOptions()
      .dialogOptions
      .copyWith(fromStyle: PopupFromStyle.fromCenter);
  return showDialogPopup(widget: widget, options: _options);
}

/// 关闭弹窗
/// 也可以通过 Navigator.of(context).maybePop()
Future<bool> closePopup([dynamic value]) => maybePop(value);

/// 日期选择器
/// 关闭 closePopup()
Future<DateTime?> showDateTimePicker<T>({
  /// 选择框内单位文字样式
  TextStyle? unitStyle,

  /// 开始时间
  DateTime? startDate,

  /// 默认选中时间
  DateTime? defaultDate,

  /// 结束时间
  DateTime? endDate,

  /// 补全双位数
  bool dual = true,

  /// 是否显示单位
  bool showUnit = true,

  /// 单位设置
  DateTimePickerUnit unit = const DateTimePickerUnit(),

  /// 头部和背景色配置
  PickerOptions<DateTime>? options,

  /// Wheel配置信息
  PickerWheelOptions? wheelOptions,

  /// BottomSheet 配置
  BottomSheetOptions? bottomSheetOptions,
}) {
  GlobalOptions().globalNavigatorKey.currentContext!.focusNode();
  final Widget widget = DateTimePicker(
      options: options,
      wheelOptions: wheelOptions,
      unitStyle: unitStyle,
      startDate: startDate,
      endDate: endDate,
      defaultDate: defaultDate,
      dual: dual,
      showUnit: showUnit,
      unit: unit);
  return showBottomPopup<DateTime?>(
      widget: widget, options: bottomSheetOptions);
}

/// 地区选择器
/// 关闭 closePopup()
Future<String?> showAreaPicker<T>({
  /// 默认选择的省
  String? defaultProvince,

  /// 默认选择的市
  String? defaultCity,

  /// 默认选择的区
  String? defaultDistrict,

  /// 头部和背景色配置
  PickerOptions<String>? options,

  /// Wheel配置信息
  PickerWheelOptions? wheelOptions,

  /// BottomSheet 配置
  BottomSheetOptions? bottomSheetOptions,
}) {
  GlobalOptions().globalNavigatorKey.currentContext!.focusNode();
  final Widget widget = AreaPicker(
      defaultProvince: defaultProvince,
      defaultCity: defaultCity,
      defaultDistrict: defaultDistrict,
      options: options,
      wheelOptions: wheelOptions ?? GlobalOptions().pickerWheelOptions);
  return showBottomPopup<String?>(widget: widget, options: bottomSheetOptions);
}

/// wheel 单列 取消确认 选择
/// 关闭 closePopup()
Future<int?> showMultipleChoicePicker<T>({
  /// 默认选中
  int? initialIndex,
  required int itemCount,
  required IndexedWidgetBuilder itemBuilder,

  /// 头部和背景色配置
  PickerOptions<int>? options,

  /// Wheel配置信息
  PickerWheelOptions? wheelOptions,

  /// BottomSheet 配置
  BottomSheetOptions? bottomSheetOptions,
}) {
  GlobalOptions().globalNavigatorKey.currentContext!.focusNode();
  final Widget widget = MultipleChoicePicker(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      options: options,
      wheelOptions: wheelOptions,
      initialIndex: initialIndex);
  return showBottomPopup(widget: widget, options: bottomSheetOptions);
}

/// 关闭 closePopup()
Future<T?> showCustomPicker<T>({
  required Widget content,

  /// 自定义 确定 按钮 返回参数
  PickerSubjectTapCallback<T>? sureTap,

  /// 自定义 取消 按钮 返回参数
  PickerSubjectTapCallback<T?>? cancelTap,

  /// 头部和背景色配置
  PickerOptions<T?>? options,

  /// BottomSheet 配置
  BottomSheetOptions? bottomSheetOptions,
}) {
  GlobalOptions().globalNavigatorKey.currentContext!.focusNode();
  options ??= PickerOptions<T?>();
  return showBottomPopup(
      options: bottomSheetOptions,
      widget: PickerSubject<T?>(
          sureTap: sureTap,
          cancelTap: cancelTap,
          options: options,
          child: content));
}
