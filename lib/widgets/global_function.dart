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
/// 关闭 closeToast();
/// 添加 await Toast 关闭后继续执行之后的方法
Future<ExtendedOverlayEntry?> showToast(String message,
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

bool closeToast() => ExtendedOverlay().closeToast();

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
  LoadingStyle style = LoadingStyle.circular,
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
  DateTimePickerUnit unit = const DateTimePickerUnit.all(),

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
Future<int?> showSingleColumnPicker<T>({
  /// 默认选中
  int initialIndex = 0,

  /// 渲染子组件
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
  final Widget widget = SingleColumnPicker(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      options: options,
      wheelOptions: wheelOptions,
      initialIndex: initialIndex);
  return showBottomPopup(widget: widget, options: bottomSheetOptions);
}

/// wheel 多列 取消 确认 选择 不联动
/// 关闭 closePopup()
Future<List<int>?> showMultiColumnPicker<T>({
  required List<PickerEntry> entry,

  /// 头部和背景色配置
  PickerOptions<List<int>>? options,

  /// Wheel配置信息
  PickerWheelOptions? wheelOptions,

  /// 是否可以横向滚动
  /// [horizontalScroll]==true 使用[SingleChildScrollView]创建,[wheelOptions]中的[itemWidth]控制宽度，如果不设置则为[kPickerDefaultWidth]
  /// [horizontalScroll]==false 使用[Row] 创建每个滚动，居中显示
  bool horizontalScroll = false,

  /// [horizontalScroll]==false
  bool addExpanded = true,

  /// BottomSheet 配置
  BottomSheetOptions? bottomSheetOptions,
}) {
  GlobalOptions().globalNavigatorKey.currentContext!.focusNode();
  final Widget widget = MultiColumnPicker(
      horizontalScroll: horizontalScroll,
      addExpanded: addExpanded,
      entry: entry,
      options: options,
      wheelOptions: wheelOptions);
  return showBottomPopup(widget: widget, options: bottomSheetOptions);
}

/// wheel 多列 取消 确认 选择 联动
/// 关闭 closePopup()
Future<List<int>?> showMultiColumnLinkagePicker<T>({
  /// 头部和背景色配置
  PickerOptions<List<int>>? options,

  /// 要渲染的数据
  required List<PickerLinkageEntry> entry,

  /// 是否可以横向滚动
  /// [horizontalScroll]==true 使用[SingleChildScrollView]创建,[wheelOptions]中的[itemWidth]控制宽度，如果不设置则为[kPickerDefaultWidth]
  /// [horizontalScroll]==false 使用[Row] 创建每个滚动，居中显示
  bool horizontalScroll = false,

  /// [horizontalScroll]==false
  bool addExpanded = true,

  /// Wheel配置信息
  PickerWheelOptions? wheelOptions,

  /// BottomSheet 配置
  BottomSheetOptions? bottomSheetOptions,
}) {
  GlobalOptions().globalNavigatorKey.currentContext!.focusNode();
  final Widget widget = MultiColumnLinkagePicker(
      horizontalScroll: horizontalScroll,
      addExpanded: addExpanded,
      entry: entry,
      options: options,
      wheelOptions: wheelOptions);
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
