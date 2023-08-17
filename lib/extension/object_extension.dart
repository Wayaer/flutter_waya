import 'package:flutter/cupertino.dart';
import 'package:flutter_waya/flutter_waya.dart';

extension ExtensionUriData on UriData {
  Map<String, dynamic> toMap() => {
        'charset': charset,
        'contentText': contentText,
        'mimeType': mimeType,
        'parameters': parameters,
        'isBase64': isBase64,
        'uri': uri.toMap(),
      };
}

extension ExtensionUri on Uri {
  Map<String, dynamic> toMap() => {
        'path': path,
        'pathSegments': pathSegments,
        'data': data?.toMap(),
        'host': host,
        'port': port,
        'query': query,
        'scheme': scheme,
        'userInfo': userInfo,
        'queryParameters': queryParameters,
        'queryParametersAll': queryParametersAll,
        'authority': authority,
        'fragment': fragment,
        'hasAbsolutePath': hasAbsolutePath,
        'isAbsolute': isAbsolute,
      };
}

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

  List<T> convertToList() => [this];

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
}

extension ExtensionBool on bool {
  bool toggle() => !this;
}
