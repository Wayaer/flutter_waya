import 'package:flutter/material.dart';

const String refreshEvent = 'refreshEvent';

/// icons
class WayIcons {
  WayIcons._();

  /// 箭头右
  static const IconData arrowRight = _IconData(0xe657);

  /// 箭头左
  static const IconData arrowLeft = _IconData(0xe656);

  /// 箭头上
  static const IconData arrowUp = _IconData(0xe658);

  /// 箭头下
  static const IconData arrowDown = _IconData(0xe655);

  /// 搜索
  static const IconData search = _IconData(0xe65f);

  /// 成功
  static const IconData success = _IconData(0xe660);

  /// 错误
  static const IconData fail = _IconData(0xe65d);

  /// 提示
  static const IconData info = _IconData(0xe65a);

  /// 警告
  static const IconData warning = _IconData(0xe65c);

  /// 笑脸
  static const IconData smile = _IconData(0xe65e);

  /// 空数据
  static const IconData empty = _IconData(0xe621);

  /// 眼睛关闭
  static const IconData eyeClose = _IconData(0xe65b);

  /// 眼睛打开
  static const IconData eyeOpen = _IconData(0xe659);
}

class _IconData extends IconData {
  const _IconData(super.codePoint)
      : super(fontFamily: 'WayIcons', fontPackage: 'flutter_waya');
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
