import 'package:flutter/material.dart';
import 'package:flutter_waya/constant/model.dart';
import 'package:flutter_waya/flutter_waya.dart';

const String refreshEvent = 'refreshEvent';

/// Constant
class ConstConstant {
  /// 全局圆角大小
  static const double Radius = 5;

  /// 全局默认字体大小
  static const double fontSize = 14;

  /// 导航栏高度
  static const double appBarHeight = 43;

  /// picker itemHeight
  static const double pickerItemHeight = 22;

  /// picker 高
  static const double pickerHeight = 200;

  /// 放大倍率
  static const double listWheelMagnification = 1.1;

  static const String success = 'success';

  static const Map<int, HttpStatus> httpStatus = <int, HttpStatus>{
    100: HttpStatus(100, '未知异常', 'unknown exception'),
    404: HttpStatus(404, '网络请求失败', 'Failed'),
    420: HttpStatus(420, '网络请求已取消', 'Cancel'),
    408: HttpStatus(408, '网络连接超时', 'Connect Timeout'),
    450: HttpStatus(450, '网络发送超时', 'Send Timeout'),
    502: HttpStatus(502, '网络接收超时', 'Receive Timeout'),
    500: HttpStatus(500, '服务器错误', 'Server Error')
  };

  static const Map<InputTextType, String> regExp = <InputTextType, String>{
    ///  字母和数字
    InputTextType.lettersNumbers: '[a-zA-Z0-9]',

    ///  密码 字母和数字和.
    InputTextType.password: '[a-zA-Z0-9.]',

    ///  整数
    InputTextType.number: null,

    ///  文本
    InputTextType.text: null,

    ///  小数
    InputTextType.decimal: '[0-9.]',

    ///  字母
    InputTextType.letter: '[a-zA-Z]',

    ///  中文
    InputTextType.chinese: '[\u4e00-\u9fa5]',

    ///  邮箱
    InputTextType.email: '[a-zA-Z0-9.@]',

    ///  手机号码
    InputTextType.mobilePhone: '[0-9]',

    ///  电话号码
    InputTextType.phone: '[0-9-]',

    ///  身份证
    InputTextType.idCard: '[0-9Xx]',

    ///  ip地址
    InputTextType.ip: '[0-9:.]',

    ///  正数
    InputTextType.positive: '[+0-9.]',

    ///  负数
    InputTextType.negative: '[-0-9.]',
  };
}

/// Colors
class ConstColors {
  static const Color transparent = Colors.transparent;
  static const Color white50 = Color(0x50FFFFFF);
  static const Color white = Colors.white;
  static const Color background = Color(0xFFF5F5F5);
  static const Color blue = Color(0xFF349DFF);
  static const Color boxShadowColor = Color(0xFFE0E0E0);
  static const Color greenAccent = Colors.greenAccent;
  static const Color red = Colors.red;
  static const Color gray = Colors.grey;
  static const Color black = Colors.black;
  static const Color black30 = Color(0x30000000);
  static const Color black50 = Color(0x50000000);
  static const Color black70 = Color(0x70000000);
  static const Color black90 = Color(0x90000000);
}

///  icons
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
