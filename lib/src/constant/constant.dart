import 'package:flutter/material.dart';

class ConstConstant {
  static const double Radius = 5; //全局圆角大小
  static const double fontSize = 14; //全局默认字体大小
  static const double appBarHeight = 43; //导航栏高度
  static const int errorCode404 = 404; //网络请求失败
  static const int errorCode420 = 420; //网络请求已取消
  static const int errorCode408 = 408; //网络连接超时
  static const int errorCode502 = 502; //网络接收超时
  static const int errorCode450 = 450; //网络发送超时
  static const double pickerItemHeight = 18; //picker itemHeight
  static const double pickerHeight = 200; //picker 高
  static const double listWheelMagnification = 1.2; //放大倍率
  static const String success = 'success';
  static const String oss = 'https://kingapp.oss-cn-hangzhou.aliyuncs.com';
  static const String unknownException = 'unknown exception';
  static const String errorMessage404 = '网络请求失败'; //网络请求失败
  static const String errorMessage420 = '网络请求已取消'; //网络请求已取消
  static const String errorMessage408 = '网络连接超时'; //网络连接超时
  static const String errorMessage502 = '网络接收超时'; //网络接收超时
  static const String errorMessage450 = '网络发送超时'; //网络发送超时
  static const String errorMessage500 = '服务器错误:'; //服务器错误
  static const String errorMessageT404 = 'Failed'; //网络请求失败
  static const String errorMessageT420 = 'Cancel'; //网络请求已取消
  static const String errorMessageT408 = 'Connect Timeout'; //网络连接超时
  static const String errorMessageT502 = 'Receive Timeout'; //网络接收超时
  static const String errorMessageT450 = 'Send Timeout'; //网络发送超时
  static const String errorMessageT500 = 'Response'; //服务器错误
  static const String regExpPositive = '[+0-9.]'; //正数
  static const String regExpNegative = '[-0-9.]'; //负数
  static const String regExpPassword = '[a-zA-Z0-9.]'; //密码 字母数字和点
  static const String regExpLettersNumbers = '[a-zA-Z0-9]'; //字母和数字
  static const String regExpDecimal = '[0-9.]'; //小数
  static const String regExpLetter = '[a-zA-Z]'; //字母
  static const String regExpChinese = '[\u4e00-\u9fa5]'; //中文
  static const String regExpEmail = '[a-zA-Z0-9.@]'; //邮箱
  static const String regExpPhone = '[0-9-]'; //国内电话号
  static const String regExpMobilePhone = '[0-9]'; //国内手机号
  static const String regExpIdCard = '[0-9Xx]'; //身份证
  static const String regExpIP = '[0-9:.]'; //ip
}

///Colors
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

///icons
class ConstIcon {
  static const IconData arrowRight = IconCode(0xe65b); //箭头右
  static const IconData arrowLeft = IconCode(0xe659); //箭头左
  static const IconData arrowUp = IconCode(0xe658); //箭头上
  static const IconData arrowDown = IconCode(0xe65a); //箭头下
  static const IconData search = IconCode(0xe8ba); //搜索
  static const IconData success = IconCode(0xe645); //成功
  static const IconData fail = IconCode(0xe669); //错误
  static const IconData info = IconCode(0xe631); //提示
  static const IconData warning = IconCode(0xe610); //警告
  static const IconData smile = IconCode(0xe62b); //笑脸

}

class IconCode extends IconData {
  const IconCode(int codePoint)
      : super(codePoint,
            fontFamily: 'Icons',
            matchTextDirection: true,
            fontPackage: 'flutter_waya');
}
