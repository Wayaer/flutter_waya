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
  ///  [ExtendedWillPopScope.onWillPop] 方法优先于 [isWillPop]
  bool isWillPop = true;

  /// 设置全局 [NavigatorKey]
  /// Set the global [NavigatorKey]
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// 设置全局 [ScaffoldMessengerKey]
  /// Set the global [ScaffoldMessengerKey]
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// 设置全局路由跳转样式
  /// Set the global route push style
  RoutePushStyle pushStyle = RoutePushStyle.cupertino;

  final EventBus eventBus = EventBus();

  /// 设置全局 ModalWindowsOptions 配置
  /// Set the global [ModalWindowsOptions] 配置
  ModalWindowsOptions modalWindowsOptions = const ModalWindowsOptions();

  /// 设置全局 [LoadingOptions] 配置
  /// Set the global [LoadingOptions] configuration
  LoadingOptions loadingOptions = const LoadingOptions();

  /// 设置全局 [ToastOptions] 配置
  /// Set the global [ToastOptions] configuration
  ToastOptions toastOptions = const ToastOptions();

  /// 设置全局 [BottomSheet] 配置
  /// Set the global [BottomSheet] configuration
  BottomSheetOptions bottomSheetOptions = const BottomSheetOptions();

  /// 设置全局 [CupertinoBottomSheet] 配置
  /// Set the global [BottomSheet] configuration
  CupertinoModalPopupOptions cupertinoModalPopupOptions =
      const CupertinoModalPopupOptions();

  /// 设置全局 [DialogOptions] 配置
  /// Set the global [DialogOptions] configuration
  DialogOptions dialogOptions = const DialogOptions();

  /// 设置全局 [ListWheel] 配置
  /// Set the global [ListWheel] configuration
  WheelOptions wheelOptions = const WheelOptions.cupertino();

  bool logCrossLine = true;

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
