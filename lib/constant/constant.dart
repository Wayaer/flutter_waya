import 'package:flutter/material.dart';
import 'package:flutter_waya/constant/model.dart';

import 'enums.dart';

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

  static const String unknownException = 'unknown exception';

  static const Map<int, HttpStatus> httpStatus = <int, HttpStatus>{
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

///  Colors
const String transparent = 'transparent';
const String white50 = 'white50';
const String white = 'white';
const String background = 'background';
const String blue = 'blue';
const String boxShadowColor = 'boxShadowColor';
const String greenAccent = 'greenAccent';
const String red = 'red';
const String gray = 'gray';
const String line = 'line';
const String black = 'black';
const String black30 = 'black30';
const String black70 = 'black70';
const String black50 = 'black50';
const String black90 = 'black90';

Color getColors(String color) => constColors[color];

const Map<String, Color> constColors = <String, Color>{
  transparent: Colors.transparent,
  white: Colors.white,
  red: Colors.red,
  white50: Color(0x50FFFFFF),
  black: Color(0xFF000000),
  black30: Color(0x30000000),
  black50: Color(0x50000000),
  black70: Color(0x70000000),
  black90: Color(0x90000000),
  greenAccent: Colors.greenAccent,
  blue: Color(0xFF349DFF),
  boxShadowColor: Color(0xFFE0E0E0),
  gray: Colors.grey,
  line: Color(0xFFF5F5F5),
  background: Color(0xFFF5F5F5),
};

///  icons
class ConstIcon {
  /// 箭头右
  static const IconData arrowRight = IconCode(0xe65b);

  /// 箭头左
  static const IconData arrowLeft = IconCode(0xe659);

  /// 箭头上
  static const IconData arrowUp = IconCode(0xe658);

  /// 箭头下
  static const IconData arrowDown = IconCode(0xe65a);

  /// 搜索
  static const IconData search = IconCode(0xe8ba);

  /// 成功
  static const IconData success = IconCode(0xe645);

  /// 错误
  static const IconData fail = IconCode(0xe669);

  /// 提示
  static const IconData info = IconCode(0xe631);

  /// 警告
  static const IconData warning = IconCode(0xe610);

  /// 笑脸
  static const IconData smile = IconCode(0xe62b);
}

class IconCode extends IconData {
  const IconCode(int codePoint)
      : super(codePoint,
            fontFamily: 'Icons',
            matchTextDirection: true,
            fontPackage: 'flutter_waya');
}
