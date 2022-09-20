import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ExtendedOverlay {
  factory ExtendedOverlay() => _singleton ??= ExtendedOverlay._();

  ExtendedOverlay._();

  static ExtendedOverlay? _singleton;

  final List<ExtendedOverlayEntry> _overlayEntryList = <ExtendedOverlayEntry>[];

  List<ExtendedOverlayEntry> get overlayEntryList => _overlayEntryList;

  /// 关闭所有Overlay
  void closeAllOverlay() {
    for (final ExtendedOverlayEntry element in _overlayEntryList) {
      element.removeEntry();
    }
  }

  /// 自定义Overlay
  ExtendedOverlayEntry? showOverlay(Widget widget, {bool autoOff = false}) {
    final OverlayState? overlay =
        GlobalOptions().globalNavigatorKey.currentState!.overlay;
    if (overlay == null) return null;
    final ExtendedOverlayEntry entry =
        ExtendedOverlayEntry(autoOff: autoOff, widget: widget);
    overlay.insert(entry);
    if (!autoOff) _overlayEntryList.add(entry);
    return entry;
  }

  /// 关闭最顶层的Overlay
  bool closeOverlay({ExtendedOverlayEntry? entry}) {
    if (entry != null) {
      return entry.removeEntry();
    } else {
      if (_overlayEntryList.isNotEmpty) {
        return _overlayEntryList.last.removeEntry();
      }
    }
    return false;
  }

  /// Toast
  ExtendedOverlayEntry? _toast;

  ExtendedOverlayEntry? get toast => _toast;

  /// Toast 关闭 closeToast();
  Future<ExtendedOverlayEntry?> showToast(String message,
      {ToastOptions? options,
      ToastStyle? style,
      Duration? duration,
      AlignmentGeometry? positioned,
      IconData? customIcon}) async {
    if (_toast != null) return _toast;
    options = (options ??= GlobalOptions().toastOptions)
        .copyWith(positioned: positioned, duration: duration);
    Widget toast =
        BText(message, color: options.iconColor, maxLines: 5, fontSize: 14);
    if (style != null) {
      IconData icon;
      switch (style) {
        case ToastStyle.success:
          icon = ConstIcon.success;
          break;
        case ToastStyle.fail:
          icon = ConstIcon.fail;
          break;
        case ToastStyle.info:
          icon = ConstIcon.info;
          break;
        case ToastStyle.warning:
          icon = ConstIcon.warning;
          break;
        case ToastStyle.smile:
          icon = ConstIcon.smile;
          break;
        case ToastStyle.custom:
          assert(customIcon != null);
          icon = customIcon ?? ConstIcon.info;
          break;
      }
      toast = IconBox(
          icon: icon,
          direction: options.direction,
          spacing: options.spacing,
          size: options.iconSize,
          color: options.iconColor,
          title: toast);
    }
    _toast = showOverlay(
        PopupModalWindows(
            options: options.modalWindowsOptions.copyWith(
                absorbing: options.absorbing,
                ignoring: options.ignoring,
                alignment: options.positioned),
            child: Universal(
                onTap: options.onTap,
                margin: options.margin,
                decoration: options.decoration ??
                    BoxDecoration(
                        color: options.backgroundColor,
                        borderRadius: BorderRadius.circular(4)),
                padding: options.padding,
                child: toast)),
        autoOff: true);
    _toast!.addListener(_toastListener);
    await (options.duration).delayed<dynamic>();
    closeToast();
    return _toast;
  }

  void _toastListener() {
    if (_toast?.mounted == false) {
      _toast?.removeListener(_toastListener);
      _toast?.dispose();
      _toast = null;
    }
  }

  bool closeToast() {
    final value = _toast?.removeEntry() ?? false;
    _toast = null;
    return value;
  }

  ExtendedOverlayEntry? _loading;

  ExtendedOverlayEntry? get loading => _loading;

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
  }) {
    if (_loading != null) return _loading;
    final loadingOptions = GlobalOptions()
        .loadingOptions
        .copyWith(custom: custom, style: style, options: options);
    _loading = ExtendedOverlay().showOverlay(PopupLoadingWindows(
        custom: loadingOptions.custom,
        extra: extra,
        options: loadingOptions.options,
        value: value,
        backgroundColor: backgroundColor,
        valueColor: valueColor,
        strokeWidth: strokeWidth,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
        style: loadingOptions.style));
    _loading!.addListener(_loadingListener);
    return _loading;
  }

  void _loadingListener() {
    if (_loading?.mounted == false) {
      _loading?.removeListener(_loadingListener);
      _loading?.dispose();
      _loading = null;
    }
  }

  bool closeLoading() {
    final value = _loading?.removeEntry() ?? false;
    _loading = null;
    return value;
  }
}

class ExtendedOverlayEntry extends OverlayEntry {
  ExtendedOverlayEntry({
    this.autoOff = false,
    WidgetBuilder? builder,
    Widget? widget,
    super.opaque = false,
    super.maintainState = false,
  })  : assert(builder != null || widget != null),
        super(builder: builder ?? (_) => widget!);

  /// 是否自动关闭
  final bool autoOff;

  bool removeEntry() {
    try {
      super.remove();
      if (!autoOff) ExtendedOverlay()._overlayEntryList.remove(this);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void remove() => removeEntry();
}

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

/// Toast类型
/// 如果使用custom  请设置 [customIcon]
enum ToastStyle { success, fail, info, warning, smile, custom }

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
