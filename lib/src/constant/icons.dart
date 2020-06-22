import 'package:flutter/material.dart';

class WayIcon {
  static const IconData checked = Icons.check_box;
  static const IconData unChecked = Icons.check_box_outline_blank;
  static const IconData eyeOpen = const IconCode(0xe633); //眼睛打开
  static const IconData eyeClose = const IconCode(0xe634); //眼睛关闭
  static const IconData arrowRight = const IconCode(0xe65b); //箭头右
  static const IconData arrowLeft = const IconCode(0xe659); //箭头左
  static const IconData arrowUp = const IconCode(0xe658); //箭头上
  static const IconData arrowDown = const IconCode(0xe65a); //箭头下
  static const IconData download = const IconCode(0xe640); //下载
  static const IconData region = const IconCode(0xe641); //地区
  static const IconData location = const IconCode(0xe8ae); //定位
  static const IconData map = const IconCode(0xe8ad); //地图
  static const IconData copy = const IconCode(0xe8b0); //复制
  static const IconData share = const IconCode(0xe8b1); //分享
  static const IconData man = const IconCode(0xe8b3); //男
  static const IconData woman = const IconCode(0xe60d); //女
  static const IconData scanner = const IconCode(0xe8b5); //扫描
  static const IconData upload = const IconCode(0xe60c); //上传
  static const IconData horn = const IconCode(0xe8b8); //小喇叭
  static const IconData collect = const IconCode(0xe8b9); //五角星空
  static const IconData collected = const IconCode(0xe8c6); //五角星填充
  static const IconData search = const IconCode(0xe8ba); //搜索
  static const IconData discuss = const IconCode(0xe8bb); //讨论
  static const IconData message = const IconCode(0xe8bd); //消息
  static const IconData heart = const IconCode(0xe8c3); //心
  static const IconData comment = const IconCode(0xe8c5); //评论
  static const IconData menu = const IconCode(0xe644); //菜单
  static const IconData modify = const IconCode(0xe63e); //修改
}

class IconCode extends IconData {
  const IconCode(int codePoint)
      : super(codePoint,
            fontFamily: 'Icons',
            matchTextDirection: true,
            fontPackage: "flutter_waya");
}
