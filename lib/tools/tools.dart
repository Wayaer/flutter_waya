import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'dart:ui' as ui show Image;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

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

/// int 字节转 k MB GB
String getFileSize(int size) {
  if (size < 1024) {
    return '$size字节';
  } else if (size >= 1024 && size < pow(1024, 2)) {
    size = (size / 10.24).round();
    return '${size / 100}k';
  } else if (size >= pow(1024, 2) && size < pow(1024, 3)) {
    size = (size / (pow(1024, 2) * 0.01)).round();
    return '${size / 100}MB';
  } else if (size >= pow(1024, 3) && size < pow(1024, 4)) {
    size = (size / (pow(1024, 3) * 0.01)).round();
    return '${size / 100}GB';
  }
  return size.toString();
}

/// Tools
class Ts {
  static Future<void> exitApp() async => await SystemNavigator.pop();

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

  static void setStatusBarLight(bool isLight) {
    const Color color = ConstColors.transparent;
    if (isLight is bool) {
      SystemChrome.setSystemUIOverlayStyle(isLight
          ? const SystemUiOverlayStyle(
              systemNavigationBarColor: ConstColors.black70,
              systemNavigationBarDividerColor: ConstColors.transparent,
              statusBarColor: color,
              systemNavigationBarIconBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark)
          : const SystemUiOverlayStyle(
              systemNavigationBarColor: ConstColors.black70,
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
