import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

void log(dynamic msg) {
  final String message = msg.toString();
  if (!kDebugMode) return;
  const int _limitLength = 800;
  if (message.length < _limitLength) {
    print(msg);
  } else {
    print(
        ' — — — — — — — — — — — — — — — — st — — — — — — — — — — — — — — — —');
    final StringBuffer outStr = StringBuffer();
    for (int index = 0; index < message.length; index++) {
      outStr.write(message[index]);
      if (index % _limitLength == 0 && index != 0) {
        print(outStr);
        outStr.clear();
        final int lastIndex = index + 1;
        if (message.length - lastIndex < _limitLength) {
          final String remainderStr =
              message.substring(lastIndex, message.length);
          print(remainderStr);
          break;
        }
      }
    }
    print('— — — — — — — — — — — — — — — — ed — — — — — — — — — — — — — — — —');
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

WidgetsBinding? widgetsBinding = WidgetsBinding.instance;
SchedulerBinding? schedulerBinding = SchedulerBinding.instance;

void addPostFrameCallback(FrameCallback duration) =>
    widgetsBinding?.addPostFrameCallback(duration);

void addObserver(WidgetsBindingObserver observer) =>
    widgetsBinding?.addObserver(observer);

void removeObserver(WidgetsBindingObserver observer) =>
    widgetsBinding?.removeObserver(observer);

void addPersistentFrameCallback(FrameCallback duration) =>
    widgetsBinding?.addPersistentFrameCallback(duration);

void addTimingsCallback(TimingsCallback callback) =>
    widgetsBinding?.addTimingsCallback(callback);

void setStatusBarLight(bool isLight) {
  const Color color = ConstColors.transparent;
  SystemChrome.setSystemUIOverlayStyle(isLight
      ? const SystemUiOverlayStyle(
          systemNavigationBarColor: ConstColors.black70,
          systemNavigationBarDividerColor: color,
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
