import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/colors.dart';
import 'package:flutter_waya/src/constant/enums.dart';

isDebug() {
  return !kReleaseMode;
}

class Tools {
  static Timer _timerInfo;
  static double _designWidth = 375;
  static double _designHeight = 667;

  /// 截屏
  static Future<ByteData> screenshots(GlobalKey globalKey,
      {ImageByteFormat format}) async {
    RenderRepaintBoundary boundary =
    globalKey.currentContext.findRenderObject();
    var image = await boundary.toImage(pixelRatio: window.devicePixelRatio);
    ByteData byteData =
    await image.toByteData(format: format ?? ImageByteFormat.rawRgba);

    ///    Uint8List uint8list = byteData.buffer.asUint8List();
    return byteData;
  }

  /// 复制到粘贴板
  static void copy(text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  ///分页 计算总页数
  static int totalPageCount(int recordCount, int pageSize) {
    int totalPage = recordCount ~/ pageSize;
    if (recordCount % pageSize != 0) {
      totalPage += 1;
    }
    return totalPage;
  }

  ///时间戳转换
  static String stampToDate(int s, {DateType dateType, bool micro}) {
    if (micro == null) {
      micro = false;
    }
    if (micro) {
      ///微秒
      return formatDate(DateTime.fromMicrosecondsSinceEpoch(s), dateType);
    } else {
      ///毫秒
      return formatDate(DateTime.fromMillisecondsSinceEpoch(s), dateType);
    }
  }

  static String formatDate(DateTime date, [DateType dateType]) {
    if (dateType == null) dateType = DateType.yearSecond;
    String year = date.year.toString();
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    String hour = date.hour.toString().padLeft(2, '0');
    String minute = date.minute.toString().padLeft(2, '0');
    String second = date.second.toString().padLeft(2, '0');
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

  ///  * 全面屏适配
  ///  * @returns {number} 返回全面屏对应的16：9 屏幕高度

  static double phoneFitHeight(BuildContext context) {
    double h = MediaQueryTools.getHeight();
    double s = MediaQueryTools.getDevicePixelRatio();
    double y = s * h;
    if (Platform.isAndroid) {
      if (y < 1000) {
        ///720p以下手机
        return h;
      } else if (y > 1000 && y < 1300) {
        ///720p 16:9
        return h;
      } else if (y > 1300 && y < 1650) {
        ///720p 18:9
        return 1280 / s;
      } else if (y > 1700 && y < 1930) {
        ///1080p 16:9
        return h;
      } else if (y > 1930 && y < 2400) {
        ///1080p 18:9 19.5:9
        return 1920 / s;
      } else if (y > 2400 && y < 2560) {
        ///2k 16:9
        return h;
      } else if (y > 2560 && y < 3300) {
        ///2k 18:9  19.5:9
        return 2560 / s;
      }
    } else if (Platform.isIOS) {
      if (y < 1400) {
        ///4.7寸 16:9
        return h;
      } else if (y > 1400 && y < 1850) {
        ///iphone xr 18:9
        return 1334 / s;
      } else if (y > 1700 && y < 1800) {
        ///iphone 11 18:9
        return 1334 / s;
      } else if (y > 1850 && y < 2300) {
        ///iphone plus 16:9
        return h;
      } else if (y > 2300) {
        ///iphone x  18:9
        return 2208 / s;
      }
    }
    return h;
  }

  ///相对iphone 6s 尺寸设计稿 高
  static getHeight([double height, bool intType]) {
    double h;
    if (height == null || height == 0) {
      h = MediaQueryTools
          .getSize()
          .height;
    } else {
      ///  h = (height / designHeight) * phoneFitHeight(context);
      h = (height / _designHeight) * MediaQueryTools.getHeight();
    }
    return intType == true ? h.toInt() : h;
  }

  ///相对iphone 6s 尺寸设计稿 宽
  static getWidth([double width, bool intType]) {
    double w;
    if (width == null || width == 0) {
      w = MediaQueryTools
          .getSize()
          .width;
    } else {
      w = (width / _designWidth) * MediaQueryTools.getWidth();
    }
    return intType == true ? w.toInt() : w;
  }

  ///初始化设置 设计稿宽高
  ///默认为 667*375
  static setDesignSize(Size size) {
    _designHeight = size.height;
    _designWidth = size.width;
  }

  ///关闭键盘
  static closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  ///
  static addPostFrameCallback(FrameCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback(callback);
  }

  static Timer timerTools(Duration duration, [Function function]) {
    _timerInfo = Timer(duration, () {
      if (function != null) function();
      _timerInfo.cancel();
    });
    return _timerInfo;
  }

  static Timer timerPeriodic(Duration duration, [void callback(Timer timer)]) {
    ///需要手动释放timer
    _timerInfo = Timer.periodic(duration, (time) {
      callback(time);
    });
    return _timerInfo;
  }

  static timerCancel() {
    if (_timerInfo != null) _timerInfo.cancel();
  }

  /// md5 加密
  static String setMd5(String data) {
    return md5.convert(utf8.encode(data)).toString();
  }

  /// Base64加密
  static String encodeBase64(String data) {
    return base64Encode(utf8.encode(data));
  }

  ///Base64解密
  static String decodeBase64(String data) {
    return String.fromCharCodes(base64Decode(data));
  }

  static setStatusBarLight(bool isLight) {
    Color color = getColors(transparent);
    SystemUiOverlayStyle systemUiOverlayStyle;
    if (isLight is bool) {
      if (isLight) {
        systemUiOverlayStyle = SystemUiOverlayStyle(
          systemNavigationBarColor: getColors(black70),
          systemNavigationBarDividerColor: getColors(transparent),
          statusBarColor: color,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        );
      } else {
        systemUiOverlayStyle = SystemUiOverlayStyle(
          systemNavigationBarColor: getColors(black70),
          systemNavigationBarDividerColor: color,
          statusBarColor: color,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        );
      }
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }

  static popBack(navigator, {bool nullBack: true}) {
    Future future = navigator;
    future.then((value) {
      if (value == null) {
        if (nullBack) NavigatorTools.getInstance().pop();
      } else {
        NavigatorTools.getInstance().pop(value);
      }
    });
  }

  static bool isAndroid() {
    return Platform.isAndroid;
  }

  static bool isIOS() {
    return Platform.isIOS;
  }

  static bool isMacOS() {
    return Platform.isMacOS;
  }

  static bool isWindows() {
    return Platform.isWindows;
  }

  static isLinux() {
    return Platform.isLinux;
  }

  static bool isFuchsia() {
    return Platform.isFuchsia;
  }
}
