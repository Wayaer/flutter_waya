import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ToastOptions {
  const ToastOptions(
      {this.backgroundColor = const Color(0xCC000000),
      this.iconColor = const Color(0xFFFFFFFF),
      this.decoration,
      this.onTap,
      this.textStyle,
      this.duration = const Duration(milliseconds: 1500),
      this.positioned = Alignment.center,
      this.ignoring = false,
      this.absorbing = false,
      this.iconSize = 30,
      this.spacing = 10,
      this.padding = const EdgeInsets.all(10),
      this.margin = const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      this.direction = Axis.vertical,
      this.modalWindowsOptions = const ModalWindowsOptions()});

  /// 背景色
  final Color? backgroundColor;

  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  final BoxDecoration? decoration;

  /// Toast onTap
  final GestureTapCallback? onTap;

  /// 显示文字样式
  final TextStyle? textStyle;

  /// Toast显示时间
  final Duration duration;

  /// Toast 定位
  final AlignmentGeometry positioned;

  /// toast 是否忽略子组件点击事件响应背景点击事件 默认 false
  /// true [onTap] 和 [modalWindowsOptions.onTap] 都会失效
  final bool ignoring;

  /// 是否吸收子组件的点击事件且不响应背景点击事件 默认 false
  /// [onTap] != null 时  无效
  final bool absorbing;

  /// icon
  final Color iconColor;

  /// icon size
  final double iconSize;

  final double spacing;

  final Axis direction;

  /// 全局Toast的 modalWindowsOptions
  final ModalWindowsOptions modalWindowsOptions;

  ToastOptions copyWith({
    AlignmentGeometry? positioned,
    bool? ignoring,
    bool? absorbing,
    Color? backgroundColor,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    BoxDecoration? decoration,
    GestureTapCallback? onTap,
    TextStyle? textStyle,
    Duration? duration,
    Color? iconColor,
    double? iconSize,
    double? spacing,
    Axis? direction,
    ModalWindowsOptions? modalWindowsOptions,
  }) =>
      ToastOptions(
          modalWindowsOptions: modalWindowsOptions ?? this.modalWindowsOptions,
          positioned: positioned ?? this.positioned,
          ignoring: ignoring ?? this.ignoring,
          absorbing: ignoring ?? this.absorbing,
          backgroundColor: backgroundColor ?? this.backgroundColor,
          margin: margin ?? this.margin,
          padding: padding ?? this.padding,
          decoration: decoration ?? this.decoration,
          onTap: onTap ?? this.onTap,
          textStyle: textStyle ?? this.textStyle,
          duration: duration ?? this.duration,
          iconColor: iconColor ?? this.iconColor,
          iconSize: iconSize ?? this.iconSize,
          spacing: spacing ?? this.spacing,
          direction: direction ?? this.direction);
}

/// Toast类型
/// 如果使用custom  请设置 [customIcon]
enum ToastStyle { success, fail, info, warning, smile, custom }

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
}

class GlobalOptions {
  factory GlobalOptions() => _singleton ??= GlobalOptions._();

  GlobalOptions._();

  static GlobalOptions? _singleton;

  WidgetsBinding widgetsBinding = WidgetsBinding.instance;

  SchedulerBinding schedulerBinding = SchedulerBinding.instance;

  GlobalKey<NavigatorState> _globalNavigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get globalNavigatorKey => _globalNavigatorKey;

  /// 设置全局 [NavigatorKey]
  /// Set the global [NavigatorKey]
  void setGlobalNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _globalNavigatorKey = navigatorKey;
  }

  GlobalKey<ScaffoldMessengerState>? _globalScaffoldMessengerKey;

  GlobalKey<ScaffoldMessengerState>? get globalScaffoldMessengerKey =>
      _globalScaffoldMessengerKey;

  /// 设置全局 [ScaffoldMessengerKey]
  /// Set the global [ScaffoldMessengerKey]
  void setGlobalScaffoldMessengerKey(
      GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) {
    _globalScaffoldMessengerKey = scaffoldMessengerKey;
  }

  RoutePushStyle _pushStyle = RoutePushStyle.cupertino;

  RoutePushStyle get pushStyle => _pushStyle;

  /// 设置全局路由跳转样式
  /// Set the global route push style
  void setGlobalPushMode(RoutePushStyle style) {
    _pushStyle = style;
  }

  final EventBus _eventBus = EventBus();

  EventBus get eventBus => _eventBus;

  ModalWindowsOptions _modalWindowsOptions = const ModalWindowsOptions();

  ModalWindowsOptions get modalWindowsOptions => _modalWindowsOptions;

  /// 设置全局 ModalWindowsOptions 配置
  /// Set the global [ModalWindowsOptions] 配置
  void setModalWindowsOptions(ModalWindowsOptions modalWindowsOptions) {
    _modalWindowsOptions = modalWindowsOptions;
  }

  Widget? _globalCustomLoading;

  Widget? get globalCustomLoading => _globalCustomLoading;

  /// 设置全局 [LoadingStyle.custom] 配置
  /// Set the global [LoadingStyle.custom] configuration
  void setGlobalCustomLoading(Widget custom) {
    _globalCustomLoading = custom;
  }

  ToastOptions _toastOptions = const ToastOptions();

  ToastOptions get toastOptions => _toastOptions;

  /// 设置全局 [ToastOptions] 配置
  /// Set the global [ToastOptions] configuration
  void setToastOptions(ToastOptions options) {
    _toastOptions = options;
  }

  BottomSheetOptions _bottomSheetOptions = const BottomSheetOptions();

  BottomSheetOptions get bottomSheetOptions => _bottomSheetOptions;

  /// 设置全局 [BottomSheet] 配置
  /// Set the global [BottomSheet] configuration
  void setBottomSheetOptions(BottomSheetOptions options) {
    _bottomSheetOptions = options;
  }

  GeneralDialogOptions _dialogOptions = const GeneralDialogOptions();

  GeneralDialogOptions get dialogOptions => _dialogOptions;

  /// 设置全局 [GeneralDialogOptions] 配置
  /// Set the global [GeneralDialogOptions] configuration
  void setGeneralDialogOptions(GeneralDialogOptions options) {
    _dialogOptions = options;
  }

  WheelOptions _wheelOptions = const WheelOptions();

  WheelOptions get wheelOptions => _wheelOptions;

  /// 设置全局 [ListWheel] 配置
  /// Set the global [ListWheel] configuration
  void setWheelOptions(WheelOptions options) {
    _wheelOptions = options;
  }

  PickerWheelOptions _pickerWheelOptions = const PickerWheelOptions();

  PickerWheelOptions get pickerWheelOptions => _pickerWheelOptions;

  /// 设置全局 [PickerWheelOptions] 配置
  /// Set the global [PickerWheelOptions] configuration
  void setPickerWheelOptions(PickerWheelOptions options) {
    _pickerWheelOptions = options;
  }

  bool _logHasDottedLine = true;

  bool get logHasDottedLine => _logHasDottedLine;

  void setLogDottedLine(bool has) => _logHasDottedLine = has;

  Header globalRefreshHeader = ClassicalHeader(
      refreshText: '请尽情拉我',
      refreshReadyText: '我要开始刷新了',
      refreshingText: '我在拼命刷新中',
      refreshedText: '我已经刷新完成了',
      refreshFailedText: '我刷新失败了唉',
      noMoreText: '没有更多了',
      infoText: '现在时刻 : ${DateTime.now().format(DateTimeDist.hourMinute)}');

  Footer globalRefreshFooter = ClassicalFooter(
      loadText: '请尽情拉我',
      loadReadyText: '我要准备加载了',
      loadingText: '我在拼命加载中',
      loadedText: '我已经加载完成了',
      loadFailedText: '我加载失败了唉',
      noMoreText: '没有更多了哦',
      infoText: '现在时刻 : ${DateTime.now().format(DateTimeDist.hourMinute)}');
}

void addPostFrameCallback(FrameCallback duration) =>
    GlobalOptions().widgetsBinding.addPostFrameCallback(duration);

void addObserver(WidgetsBindingObserver observer) =>
    GlobalOptions().widgetsBinding.addObserver(observer);

void removeObserver(WidgetsBindingObserver observer) =>
    GlobalOptions().widgetsBinding.removeObserver(observer);

void addPersistentFrameCallback(FrameCallback duration) =>
    GlobalOptions().widgetsBinding.addPersistentFrameCallback(duration);

void addTimingsCallback(TimingsCallback callback) =>
    GlobalOptions().widgetsBinding.addTimingsCallback(callback);
