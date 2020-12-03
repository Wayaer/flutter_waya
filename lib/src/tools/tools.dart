import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'dart:ui' as ui show Image;

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/enums.dart';

bool get isDebug => !kReleaseMode;
const int _limitLength = 800;

void log(dynamic msg) {
  final String message = msg.toString();
  if (isDebug) {
    if (message.length < _limitLength) {
      print(msg);
    } else {
      _segmentationLog(message);
    }
  }
}

void _segmentationLog(String msg) {
  final StringBuffer outStr = StringBuffer();
  for (int index = 0; index < msg.length; index++) {
    outStr.write(msg[index]);
    if (index % _limitLength == 0 && index != 0) {
      print(outStr);
      outStr.clear();
      final int lastIndex = index + 1;
      if (msg.length - lastIndex < _limitLength) {
        final String remainderStr = msg.substring(lastIndex, msg.length);
        print(remainderStr);
        break;
      }
    }
  }
}

/// Tools
class Ts {
  static Future<void> exitApp() async => await SystemNavigator.pop();

  ///  手机号验证
  static bool isChinaPhoneLegal(String str) =>
      RegExp(r'^1([38][0-9]|4[579]|5[0-3,5-9]|6[6]|7[0135678]|9[89])\d{8}$')
          .hasMatch(str);

  ///  邮箱验证
  static bool isEmail(String str) =>
      RegExp(r'^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$').hasMatch(str);

  ///  截屏
  static Future<ByteData> screenshots(GlobalKey globalKey,
      {ImageByteFormat format}) async {
    final RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image =
        await boundary.toImage(pixelRatio: window.devicePixelRatio);
    final ByteData byteData =
        await image.toByteData(format: format ?? ImageByteFormat.rawRgba);

    ///  Uint8List uint8list = byteData.buffer.asUint8List();
    return byteData;
  }

  ///  复制到粘贴板
  static void copy(String text) => Clipboard.setData(ClipboardData(text: text));

  ///  时间戳转换
  static String stampToDate(int s, {DateType dateType, bool micro}) {
    micro ??= false;

    ///  微秒:毫秒
    return micro
        ? formatDate(DateTime.fromMicrosecondsSinceEpoch(s), dateType)
        : formatDate(DateTime.fromMillisecondsSinceEpoch(s), dateType);
  }

  ///  格式化时间
  static String formatDate(DateTime date, [DateType dateType]) {
    dateType ??= DateType.yearSecond;
    final String year = date.year.toString();
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    final String hour = date.hour.toString().padLeft(2, '0');
    final String minute = date.minute.toString().padLeft(2, '0');
    final String second = date.second.toString().padLeft(2, '0');
    switch (dateType) {
      case DateType.yearSecond:
        return '$year-$month-$day $hour:$minute:$second';
      case DateType.yearMinute:
        return '$year-$month-$day $hour:$minute';
        break;
      case DateType.yearDay:
        return '$year-$month-$day';
        break;
      case DateType.monthSecond:
        return '$month-$day $hour:$minute:$second';
        break;
      case DateType.monthMinute:
        return '$month-$day $hour:$minute';
        break;
      case DateType.monthDay:
        return '$month-$day';
        break;
      case DateType.hourSecond:
        return '$hour:$minute:$second';
        break;
      case DateType.hourMinute:
        return '$hour:$minute';
        break;
    }
    return date.toString();
  }

  ///  移出焦点 focusNode==null  移出焦点 （可用于关闭键盘） focusNode！!= null 获取焦点
  static void focusNode(BuildContext context, {FocusNode focusNode}) =>
      FocusScope.of(context).requestFocus(focusNode ?? FocusNode());

  ///  自动获取焦点
  static void autoFocus(BuildContext context) =>
      FocusScope.of(context).autofocus(FocusNode());

  static void addPostFrameCallback(FrameCallback callback) =>
      WidgetsBinding.instance.addPostFrameCallback(callback);

  /// 时间工具
  static Timer timerTs(Duration duration, [Function function]) {
    Timer timer;
    timer = Timer(duration, () {
      if (function != null) function();
      timer?.cancel();
    });
    return timer;
  }

  ///  需要手动释放timer
  static Timer timerPeriodic(Duration duration, [void callback(Timer timer)]) =>
      Timer.periodic(duration, (Timer time) => callback(time));

  ///  md5 加密
  static String setMd5(String data) =>
      md5.convert(utf8.encode(data)).toString();

  ///  Base64加密
  static String encodeBase64(String data) => base64Encode(utf8.encode(data));

  ///  Base64解密
  static String decodeBase64(String data) =>
      String.fromCharCodes(base64Decode(data));

  static void setStatusBarLight(bool isLight) {
    final Color color = getColors(transparent);
    if (isLight is bool) {
      SystemChrome.setSystemUIOverlayStyle(isLight
          ? SystemUiOverlayStyle(
              systemNavigationBarColor: getColors(black70),
              systemNavigationBarDividerColor: getColors(transparent),
              statusBarColor: color,
              systemNavigationBarIconBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark)
          : SystemUiOverlayStyle(
              systemNavigationBarColor: getColors(black70),
              systemNavigationBarDividerColor: color,
              statusBarColor: color,
              systemNavigationBarIconBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light));
    }
  }

  /// pop 返回简写 带参数  nullBack  navigator 返回为空 就继续返回上一页面
  static void popBack(Future<dynamic> navigator, {bool nullBack = true}) {
    final Future<dynamic> future = navigator;
    future.then((dynamic value) {
      if (value == null) {
        if (nullBack) pop();
      } else {
        pop(value);
      }
    });
  }
}
