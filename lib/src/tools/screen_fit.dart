import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

///获取状态栏高度
double get getStatusBarHeight => MediaQueryData.fromWindow(window).padding.top;

///获取导航栏高度
double get getBottomNavigationBarHeight =>
    MediaQueryData.fromWindow(window).padding.bottom;

///orientation → Orientation 屏幕方向（横向/纵向）
Orientation get getOrientation => MediaQueryData.fromWindow(window).orientation;

///accessibleNavigation → bool 用户是否使用TalkBack或VoiceOver等辅助功能服务与应用程序进行交互。
bool get getAccessibleNavigation =>
    MediaQueryData.fromWindow(window).accessibleNavigation;

///alwaysUse24HourFormat → bool 格式化时间时是否使用24小时格式。
bool get getBoldText => MediaQueryData.fromWindow(window).boldText;

///devicePixelRatio → double 单位逻辑像素的设备像素数量，即设备像素比。这个数字可能不是2的幂，实际上它甚至也可能不是整数。例如，Nexus 6的设备像素比为3.5。
double get getDevicePixelRatio =>
    MediaQueryData.fromWindow(window).devicePixelRatio;

///disableAnimations → bool 平台是否要求尽可能禁用或减少使用动画。
bool get getDisableAnimations =>
    MediaQueryData.fromWindow(window).disableAnimations;

///  hashCode → int 此对象的哈希码
int get getHashCode => MediaQueryData.fromWindow(window).hashCode;

/// invertColors → bool 设备是否反转平台的颜色
bool get getInvertColors => MediaQueryData.fromWindow(window).invertColors;

///padding → EdgeInsets 显示器的部分被系统UI部分遮挡，通常由硬件显示“凹槽”或系统状态栏
EdgeInsets get getPadding => MediaQueryData.fromWindow(window).padding;

///platformBrightness → Brightness 当前的亮度模式
Brightness get getPlatformBrightness =>
    MediaQueryData.fromWindow(window).platformBrightness;

///size → Size 设备尺寸信息，如屏幕的大小，单位 pixels
Size get getDeviceSize => MediaQueryData.fromWindow(window).size;

///textScaleFactor → double 每个逻辑像素的字体像素数
double get getTextScaleFactor =>
    MediaQueryData.fromWindow(window).textScaleFactor;

/// viewInsets → EdgeInsets 显示器的各个部分完全被系统UI遮挡，通常是设备的键盘
EdgeInsets get getViewInsets => MediaQueryData.fromWindow(window).viewInsets;

/// viewPadding → EdgeInsets 显示器的部分被系统UI部分遮挡，通常由硬件显示“凹槽”或系统状态栏
EdgeInsets get getViewPadding => MediaQueryData.fromWindow(window).viewPadding;

///手机屏幕的宽分辨率
double get getWidthPixel =>
    MediaQueryData.fromWindow(window).size.width * getDevicePixelRatio;

///手机屏幕高分辨率
double get getHeightPixel =>
    MediaQueryData.fromWindow(window).size.height * getDevicePixelRatio;

///手机屏幕的宽
double get deviceWidth => MediaQueryData.fromWindow(window).size.width;

///手机屏幕高
double get deviceHeight => MediaQueryData.fromWindow(window).size.height;

double _designWidth = 375;
double _designHeight = 667;
bool _ratioFit = true;

///  * 全面屏适配
///  * @returns {number} 返回全面屏对应的16：9 屏幕高度

double phoneFitHeight(BuildContext context) {
  final double h = deviceHeight;
  final double s = getDevicePixelRatio;
  final double y = s * h;
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
double getHeight([double height, bool ratioFit]) {
  ratioFit ??= _ratioFit;
  double h;
  if (height == null || height == 0) {
    h = getDeviceSize.height;
  } else {
    ///  h = (height / designHeight) * phoneFitHeight(context);
    h = ratioFit ? (height / _designHeight) * deviceHeight : height;
  }
  return h;
}

///相对iphone 6s 尺寸设计稿 宽
double getWidth([double width, bool ratioFit]) {
  ratioFit ??= _ratioFit;
  double w;
  if (width == null || width == 0) {
    w = getDeviceSize.width;
  } else {
    w = ratioFit ? (width / _designWidth) * deviceWidth : width;
  }
  return w;
}

///初始化设置 设计稿宽高
///默认为 667*375
bool setRatioFit(bool fit) => _ratioFit = fit;

///初始化设置 设计稿宽高
///默认为 667*375
void setDesignSize(Size size) {
  _designHeight = size.height;
  _designWidth = size.width;
}
