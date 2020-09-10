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
const String black = 'black';
const String black30 = 'black30';
const String black70 = 'black70';
const String black50 = 'black50';
const String black90 = 'black90';

Color getColors(String color) => constColors[color];

const constColors = {
  '$transparent': Colors.transparent,
  '$white': Colors.white,
  '$red': Colors.red,
  '$white50': Color(0x50FFFFFF),
  '$black': Color(0xFF000000),
  '$black30': Color(0x30000000),
  '$black50': Color(0x50000000),
  '$black70': Color(0x70000000),
  '$black90': Color(0x90000000),
  '$greenAccent': Colors.greenAccent,
  '$blue': Color(0xFF349DFF),
  '$boxShadowColor': Color(0xFFE0E0E0),
  '$background': Color.fromRGBO(246, 246, 246, 1),
};

///icons
class ConstIcon {
  static const IconData checked = Icons.check_box;
  static const IconData unChecked = Icons.check_box_outline_blank;
  static const IconData eyeOpen = IconCode(0xe633); //眼睛打开
  static const IconData eyeClose = IconCode(0xe634); //眼睛关闭
  static const IconData arrowRight = IconCode(0xe65b); //箭头右
  static const IconData arrowLeft = IconCode(0xe659); //箭头左
  static const IconData arrowUp = IconCode(0xe658); //箭头上
  static const IconData arrowDown = IconCode(0xe65a); //箭头下
  static const IconData download = IconCode(0xe640); //下载
  static const IconData region = IconCode(0xe641); //地区
  static const IconData location = IconCode(0xe8ae); //定位
  static const IconData map = IconCode(0xe8ad); //地图
  static const IconData copy = IconCode(0xe8b0); //复制
  static const IconData share = IconCode(0xe8b1); //分享
  static const IconData man = IconCode(0xe8b3); //男
  static const IconData woman = IconCode(0xe60d); //女
  static const IconData scanner = IconCode(0xe8b5); //扫描
  static const IconData upload = IconCode(0xe60c); //上传
  static const IconData horn = IconCode(0xe8b8); //小喇叭
  static const IconData collect = IconCode(0xe8b9); //五角星空
  static const IconData collected = IconCode(0xe8c6); //五角星填充
  static const IconData search = IconCode(0xe8ba); //搜索
  static const IconData discuss = IconCode(0xe8bb); //讨论
  static const IconData message = IconCode(0xe8bd); //消息
  static const IconData heart = IconCode(0xe8c3); //心
  static const IconData comment = IconCode(0xe8c5); //评论
  static const IconData menu = IconCode(0xe644); //菜单
  static const IconData modify = IconCode(0xe63e); //修改
}

class IconCode extends IconData {
  const IconCode(int codePoint)
      : super(codePoint, fontFamily: 'Icons', matchTextDirection: true, fontPackage: "flutter_waya");
}
