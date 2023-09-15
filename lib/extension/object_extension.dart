import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_waya/flutter_waya.dart';

extension ExtensionT<T> on T {
  /// 判空后执行方法 返回新的参数
  E? let<E>(E Function(T it) operation) {
    if (this != null) {
      return operation(this);
    }
    return null;
  }

  /// 做了某个操作后还返回本身啊
  T also(void Function(T it) operation) {
    if (this != null) {
      operation(this!);
    }
    return this;
  }

  /// Check if the T is null
  bool get isNull => this == null;

  /// Check if the T is not null
  bool get isNotNull => this != null;

  /// 转为 ValueNotifier
  ValueNotifier<T> get notifier => ValueNotifier<T>(this);

  /// toast 显示
  Future<ExtendedOverlayEntry?> toast(
          {ToastStyle? style, IconData? customIcon, ToastOptions? options}) =>
      Toast(toString(), options: options, customIcon: customIcon, style: style)
          .show();

  List<T> get toList => [this];

  void log({bool? crossLine}) {
    if (!(kDebugMode || kProfileMode)) return;
    dynamic msg = this;
    crossLine ??= GlobalWayUI().logCrossLine;
    final String message = msg.toString();
    if (crossLine) {
      debugPrint(
          '┌------------------------------------------------------------------------------');
    }
    const int limitLength = 800;
    if (message.length < limitLength) {
      debugPrint('$msg');
    } else {
      final StringBuffer outStr = StringBuffer();
      for (int index = 0; index < message.length; index++) {
        outStr.write(message[index]);
        if (index % limitLength == 0 && index != 0) {
          debugPrint(outStr.toString());
          outStr.clear();
          final int lastIndex = index + 1;
          if (message.length - lastIndex < limitLength) {
            final String remainderStr =
                message.substring(lastIndex, message.length);
            debugPrint(remainderStr);
            break;
          }
        }
      }
    }
    if (crossLine) {
      debugPrint(
          '└------------------------------------------------------------------------------');
    }
  }
}

extension ExtensionBool on bool {
  bool get toggle => !this;
}
