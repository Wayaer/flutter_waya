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
    final OverlayState? _overlay =
        GlobalOptions().globalNavigatorKey.currentState!.overlay;
    if (_overlay == null) return null;
    final ExtendedOverlayEntry entry =
        ExtendedOverlayEntry(autoOff: autoOff, widget: widget);
    _overlay.insert(entry);
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

  bool _haveToast = false;

  Future<void> showToast(String message,
      {ToastOptions? options,
      ToastStyle? style,
      Duration? duration,
      AlignmentGeometry? positioned,
      IconData? customIcon}) async {
    var _options = (options ?? GlobalOptions().toastOptions).copyWith(
        style: style,
        positioned: positioned,
        customIcon: customIcon,
        duration: duration);
    if (_haveToast) return;
    Widget toast =
        BText(message, color: _options.iconColor, maxLines: 5, fontSize: 14);
    if (_options.style != null) {
      IconData icon;
      switch (_options.style!) {
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
          assert(_options.customIcon != null);
          icon = _options.customIcon ?? ConstIcon.success;
          break;
      }
      toast = IconBox(
          icon: icon,
          direction: _options.direction,
          spacing: _options.spacing,
          size: _options.iconSize,
          color: _options.iconColor,
          title: toast);
    }
    final ExtendedOverlayEntry? entry = showOverlay(
        PopupModalWindows(
            options: (_options.modalWindowsOptions ??
                    GlobalOptions().modalWindowsOptions)
                .copyWith(
                    absorbing: _options.absorbing,
                    ignoring: _options.ignoring,
                    alignment: _options.positioned),
            child: Universal(
                onTap: _options.onTap,
                margin: _options.margin,
                decoration: _options.decoration ??
                    BoxDecoration(
                        color: _options.backgroundColor,
                        borderRadius: BorderRadius.circular(5)),
                padding: _options.padding,
                child: toast)),
        autoOff: true);
    _haveToast = true;
    await (_options.duration).delayed<dynamic>();
    closeOverlay(entry: entry);
    _haveToast = false;
  }
}

class ExtendedOverlayEntry extends OverlayEntry {
  ExtendedOverlayEntry({
    this.autoOff = false,
    WidgetBuilder? builder,
    Widget? widget,
    bool opaque = false,
    bool maintainState = false,
  })  : assert(builder != null || widget != null),
        super(
            builder: builder ?? (_) => widget!,
            opaque: opaque,
            maintainState: maintainState);

  /// 是否自动关闭
  final bool autoOff;

  bool removeEntry() {
    try {
      super.remove();
      if (!autoOff) ExtendedOverlay()._overlayEntryList.remove(this);
      if (scaffoldWillPop) scaffoldWillPop = false;
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void remove() => removeEntry();
}

/// loading 加载框 关闭 closeOverlay();
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
    ExtendedOverlay().showOverlay(PopupLoadingWindows(
        custom: custom,
        extra: extra,
        options: options,
        value: value,
        backgroundColor: backgroundColor,
        valueColor: valueColor,
        strokeWidth: strokeWidth,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
        style: style));
