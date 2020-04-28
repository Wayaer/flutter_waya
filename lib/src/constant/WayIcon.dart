import 'package:flutter/material.dart';

class WayIcon {
  static const IconData checked = Icons.check_box;
  static const IconData unChecked = Icons.check_box_outline_blank;
  static const IconData eyeOpen = const IconInfo(0xe633); //眼睛打开
  static const IconData eyeClose = const IconInfo(0xe634); //眼睛关闭
  static const IconData arrowRight = const IconInfo(0xe65b); //箭头右
  static const IconData arrowLeft = const IconInfo(0xe659); //箭头左
  static const IconData arrowUp = const IconInfo(0xe658); //箭头上
  static const IconData arrowDown = const IconInfo(0xe65a); //箭头下
  static const IconData download = const IconInfo(0xe640); //下载
  static const IconData region = const IconInfo(0xe641); //地区
  static const IconData location = const IconInfo(0xe8ae); //定位
  static const IconData map = const IconInfo(0xe8ad); //地图
  static const IconData copy = const IconInfo(0xe8b0); //复制
  static const IconData share = const IconInfo(0xe8b1); //分享
  static const IconData man = const IconInfo(0xe8b3); //男
  static const IconData woman = const IconInfo(0xe8b4); //女
  static const IconData scanner = const IconInfo(0xe8b5); //扫描
  static const IconData upload = const IconInfo(0xe60c); //上传
  static const IconData horn = const IconInfo(0xe8b8); //小喇叭
  static const IconData collect = const IconInfo(0xe8b9); //五角星空
  static const IconData collected = const IconInfo(0xe8c6); //五角星填充
  static const IconData search = const IconInfo(0xe8ba); //搜索
  static const IconData discuss = const IconInfo(0xe8bb); //讨论
  static const IconData message = const IconInfo(0xe8bd); //消息
  static const IconData heart = const IconInfo(0xe8c3); //心
  static const IconData comment = const IconInfo(0xe8c5); //评论
}

class IconInfo extends IconData {
  const IconInfo(int codePoint) : super(codePoint, fontFamily: 'Icons', matchTextDirection: true, fontPackage: "flutter_waya");
}
