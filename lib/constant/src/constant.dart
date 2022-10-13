import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

const String refreshEvent = 'refreshEvent';

/// Constant
class ConstConstant {
  static const Map<TextInputLimitFormatter, String> regExp =
      <TextInputLimitFormatter, String>{
    /// 字母和数字
    TextInputLimitFormatter.lettersNumbers: '[a-zA-Z0-9]',

    /// 密码 字母和数字和.
    TextInputLimitFormatter.password: '[a-zA-Z0-9.]',

    /// 整数
    TextInputLimitFormatter.number: '[0-9]',

    /// 文本
    TextInputLimitFormatter.text: '',

    /// 小数
    TextInputLimitFormatter.decimal: '[0-9.]',

    /// 字母
    TextInputLimitFormatter.letter: '[a-zA-Z]',

    /// 中文
    TextInputLimitFormatter.chinese: '[\u4e00-\u9fa5]',

    /// 邮箱
    TextInputLimitFormatter.email: '[a-zA-Z0-9.@]',

    /// 电话号码
    TextInputLimitFormatter.phone: '[0-9-+]',

    /// 身份证
    TextInputLimitFormatter.idCard: '[0-9Xx]',

    /// 正数
    TextInputLimitFormatter.positive: '[+0-9.]',

    /// 负数
    TextInputLimitFormatter.negative: '[-0-9.]',
  };
}

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
