import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

const String refreshEvent = 'refreshEvent';

/// Constant
class ConstConstant {
  // static const Map<int, HttpStatus> httpStatus = <int, HttpStatus>{
  //   100: HttpStatus(100, '未知异常', 'unknown exception'),
  //   404: HttpStatus(404, '网络请求失败', 'failed'),
  //   420: HttpStatus(420, '网络请求已取消', 'cancel'),
  //   408: HttpStatus(408, '网络连接超时', 'connect timeout'),
  //   450: HttpStatus(450, '网络发送超时', 'send timeout'),
  //   502: HttpStatus(502, '网络接收超时', 'receive timeout'),
  //   500: HttpStatus(500, '服务器错误', 'server error')
  // };

  static const Map<InputTextType, String> regExp = <InputTextType, String>{
    /// 字母和数字
    InputTextType.lettersNumbers: '[a-zA-Z0-9]',

    /// 密码 字母和数字和.
    InputTextType.password: '[a-zA-Z0-9.]',

    /// 整数
    InputTextType.number: '',

    /// 文本
    InputTextType.text: '',

    /// 小数
    InputTextType.decimal: '[0-9.]',

    /// 字母
    InputTextType.letter: '[a-zA-Z]',

    /// 中文
    InputTextType.chinese: '[\u4e00-\u9fa5]',

    /// 邮箱
    InputTextType.email: '[a-zA-Z0-9.@]',

    /// 手机号码
    InputTextType.mobilePhone: '[0-9]',

    /// 电话号码
    InputTextType.phone: '[0-9-]',

    /// 身份证
    InputTextType.idCard: '[0-9Xx]',

    /// ip地址
    InputTextType.ip: '[0-9:.]',

    /// 正数
    InputTextType.positive: '[+0-9.]',

    /// 负数
    InputTextType.negative: '[-0-9.]',
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
