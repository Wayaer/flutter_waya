import 'dart:ui' as ui;

import 'package:flutter/material.dart';

MediaQueryData get mediaQuery => MediaQueryData.fromWindow(ui.window);

///  获取状态栏高度
double get getStatusBarHeight => mediaQuery.padding.top;

///  获取导航栏高度
double get getBottomNavigationBarHeight => mediaQuery.padding.bottom;

///  orientation → Orientation 屏幕方向（横向/纵向）
Orientation get getOrientation => mediaQuery.orientation;

///  accessibleNavigation → bool 用户是否使用TalkBack或VoiceOver等辅助功能服务与应用程序进行交互。
bool get getAccessibleNavigation => mediaQuery.accessibleNavigation;

///  alwaysUse24HourFormat → bool 格式化时间时是否使用24小时格式。
bool get getBoldText => mediaQuery.boldText;

///  devicePixelRatio → double 单位逻辑像素的设备像素数量，即设备像素比。这个数字可能不是2的幂，实际上它甚至也可能不是整数。例如，Nexus 6的设备像素比为3.5。
double get getDevicePixelRatio => mediaQuery.devicePixelRatio;

///  disableAnimations → bool 平台是否要求尽可能禁用或减少使用动画。
bool get getDisableAnimations => mediaQuery.disableAnimations;

///  hashCode → int 此对象的哈希码
int get getHashCode => mediaQuery.hashCode;

///  invertColors → bool 设备是否反转平台的颜色
bool get getInvertColors => mediaQuery.invertColors;

///  padding → EdgeInsets 显示器的部分被系统UI部分遮挡，通常由硬件显示“凹槽”或系统状态栏
EdgeInsets get getPadding => mediaQuery.padding;

///  platformBrightness → Brightness 当前的亮度模式
Brightness get getPlatformBrightness => mediaQuery.platformBrightness;

///  size → Size 设备尺寸信息，如屏幕的大小，单位 pixels
Size get getDeviceSize => mediaQuery.size;

///  textScaleFactor → double 每个逻辑像素的字体像素数
double get getTextScaleFactor => mediaQuery.textScaleFactor;

///  viewInsets → EdgeInsets 显示器的各个部分完全被系统UI遮挡，通常是设备的键盘
EdgeInsets get getViewInsets => mediaQuery.viewInsets;

///  viewPadding → EdgeInsets 显示器的部分被系统UI部分遮挡，通常由硬件显示“凹槽”或系统状态栏
EdgeInsets get getViewPadding => mediaQuery.viewPadding;

///  手机屏幕的宽分辨率
double get getWidthPixel => mediaQuery.size.width * getDevicePixelRatio;

///  手机屏幕高分辨率
double get getHeightPixel => mediaQuery.size.height * getDevicePixelRatio;

///  手机屏幕的宽
double get deviceWidth => mediaQuery.size.width;

///  手机屏幕高
double get deviceHeight => mediaQuery.size.height;

double _designWidth = 375;
double _designHeight = 667;
bool _ratioFit = true;

///  相对iphone 6s 尺寸设计稿 高
double getHeight([double height, bool ratioFit]) {
  ratioFit ??= _ratioFit;
  double h;
  if (height == null || height == 0) {
    h = getDeviceSize.height;
  } else {
    h = ratioFit ? (height / _designHeight) * deviceHeight : height;
  }
  return h;
}

///  相对iphone 6s 尺寸设计稿 宽
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

///  初始化设置 设计稿宽高
///  默认为 667*375
bool setRatioFit(bool fit) => _ratioFit = fit;

///  初始化设置 设计稿宽高
///  默认为 667*375
void setDesignSize(Size size) {
  _designHeight = size.height;
  _designWidth = size.width;
}
