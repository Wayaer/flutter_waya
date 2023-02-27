import 'package:flutter/material.dart';

const String refreshEvent = 'refreshEvent';

/// icons
class ConstIcon {
  /// 箭头右
  static const IconData arrowRight = _IconCode(0xe65b);

  /// 箭头左
  static const IconData arrowLeft = _IconCode(0xe659);

  /// 箭头上
  static const IconData arrowUp = _IconCode(0xe658);

  /// 箭头下
  static const IconData arrowDown = _IconCode(0xe65a);

  /// 搜索
  static const IconData search = _IconCode(0xe8ba);

  /// 成功
  static const IconData success = _IconCode(0xe645);

  /// 错误
  static const IconData fail = _IconCode(0xe669);

  /// 提示
  static const IconData info = _IconCode(0xe631);

  /// 警告
  static const IconData warning = _IconCode(0xe610);

  /// 笑脸
  static const IconData smile = _IconCode(0xe62b);
}

class _IconCode extends IconData {
  const _IconCode(int codePoint)
      : super(codePoint,
            fontFamily: 'Icons',
            matchTextDirection: true,
            fontPackage: 'flutter_waya');
}

typedef Callback<T> = void Function();

typedef CallbackT<T> = T Function();

typedef CallbackFutureT<T> = Future<T> Function();

typedef ValueCallback<T> = void Function(T value);

typedef ValueCallbackT<T> = T Function(T value);

typedef ValueCallbackFutureT<T> = Future<T> Function(T value);

typedef ValueTwoCallback<T, E> = void Function(T value1, E value2);

typedef ValueThreeCallback<T, E, F> = void Function(
    T value1, E value2, F value3);

typedef ValueFourCallback<T, E, F, G> = void Function(
    T value1, E value2, F value3, G value4);
