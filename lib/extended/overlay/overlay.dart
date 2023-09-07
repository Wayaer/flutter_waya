import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

part 'loading.dart';

part 'toast.dart';

class ExtendedOverlay {
  factory ExtendedOverlay() => _singleton ??= ExtendedOverlay._();

  ExtendedOverlay._();

  static ExtendedOverlay? _singleton;

  final List<ExtendedOverlayEntry> _overlayEntryList = <ExtendedOverlayEntry>[];

  List<ExtendedOverlayEntry> get overlayEntryList => _overlayEntryList;

  /// ********* [Overlay] ********* ///

  /// 自定义Overlay
  ExtendedOverlayEntry? showOverlay(Widget widget, {bool autoOff = false}) {
    assert(GlobalWayUI().navigatorKey.currentState != null,
        'Set GlobalWayUI().navigatorKey to one of [MaterialApp CupertinoApp WidgetsApp]');
    final OverlayState? overlay =
        GlobalWayUI().navigatorKey.currentState!.overlay;
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

  /// 关闭所有Overlay
  void closeAllOverlay() {
    for (final ExtendedOverlayEntry element in _overlayEntryList) {
      element.removeEntry();
    }
  }

  /// ********* [Toast] ********* ///
  /// Toast
  ExtendedOverlayEntry? _toast;

  ExtendedOverlayEntry? get toast => _toast;

  /// Toast 关闭 closeToast();
  Future<ExtendedOverlayEntry?> showToast(Toast toast) async {
    if (_toast != null) return _toast;
    _toast = showOverlay(toast, autoOff: true);
    _toast?.addListener(_toastListener);
    final duration =
        toast.options?.duration ?? GlobalWayUI().toastOptions.duration;
    await duration.delayed<dynamic>();
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

  /// ********* [Loading] ********* ///
  ExtendedOverlayEntry? _loading;

  ExtendedOverlayEntry? get loading => _loading;

  /// loading 加载框 关闭 closeLoading();
  ExtendedOverlayEntry? showLoading(Loading loading) {
    if (_loading != null) return _loading;
    _loading = ExtendedOverlay().showOverlay(loading);
    _loading?.addListener(_loadingListener);
    return _loading;
  }

  void _loadingListener() {
    if (_loading?.mounted == false) {
      _loading?.removeListener(_loadingListener);
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
