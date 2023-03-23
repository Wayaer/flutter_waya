import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

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

class GlobalOptions {
  factory GlobalOptions() => _singleton ??= GlobalOptions._();

  GlobalOptions._();

  static GlobalOptions? _singleton;

  WidgetsBinding widgetsBinding = WidgetsBinding.instance;

  SchedulerBinding schedulerBinding = SchedulerBinding.instance;

  /// 统一全局控制 是否可返回
  /// true 允许的返回
  /// false 不允许返回
  ///  [ExtendedScaffold.onWillPop] 方法优先于 [scaffoldWillPop]
  bool _scaffoldWillPop = true;

  bool get scaffoldWillPop => _scaffoldWillPop;

  void setScaffoldWillPop(bool value) => _scaffoldWillPop = value;

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

  LoadingOptions _loadingOptions = const LoadingOptions();

  LoadingOptions get loadingOptions => _loadingOptions;

  /// 设置全局 [LoadingOptions] 配置
  /// Set the global [LoadingOptions] configuration
  void setLoadingOptions(LoadingOptions options) {
    _loadingOptions = options;
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

  CupertinoModalPopupOptions _cupertinoModalPopupOptions =
      const CupertinoModalPopupOptions();

  CupertinoModalPopupOptions get cupertinoModalPopupOptions =>
      _cupertinoModalPopupOptions;

  /// 设置全局 [CupertinoBottomSheet] 配置
  /// Set the global [BottomSheet] configuration
  void setCupertinoModalPopupOptions(CupertinoModalPopupOptions options) {
    _cupertinoModalPopupOptions = options;
  }

  DialogOptions _dialogOptions = const DialogOptions();

  DialogOptions get dialogOptions => _dialogOptions;

  /// 设置全局 [DialogOptions] 配置
  /// Set the global [DialogOptions] configuration
  void setDialogOptions(DialogOptions options) {
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

  bool _logCrossLine = true;

  bool get logCrossLine => _logCrossLine;

  void setLogCrossLine(bool has) => _logCrossLine = has;

  Header globalRefreshHeader = const ClassicHeader(
      dragText: '请尽情拉我',
      armedText: '可以松开我了',
      readyText: '我要开始刷新了',
      processingText: '我在拼命刷新中',
      processedText: '我已经刷新完成了',
      failedText: '我刷新失败了唉',
      noMoreText: '没有更多了',
      showMessage: false);

  Footer globalRefreshFooter = const ClassicFooter(
      dragText: '请尽情拉我',
      armedText: '可以松开我了',
      readyText: '我要准备加载了',
      processingText: '我在拼命加载中',
      processedText: '我已经加载完成了',
      failedText: '我加载失败了唉',
      noMoreText: '没有更多了哦',
      showMessage: false);
}

abstract class ExtendedState<T extends StatefulWidget> extends State<T> {
  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }
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
