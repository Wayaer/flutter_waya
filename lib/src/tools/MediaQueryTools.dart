import 'dart:ui';

import 'package:flutter/material.dart';

class MediaQueryTools {
  //获取状态栏高度
  static double getStatusBarHeight() {
    return MediaQueryData
        .fromWindow(window)
        .padding
        .top;
  }

  //获取导航栏高度
  static double getBottomNavigationBarHeight() {
    return MediaQueryData
        .fromWindow(window)
        .padding
        .bottom;
  }

  //orientation → Orientation 屏幕方向（横向/纵向）
  static Orientation getOrientation() {
    return MediaQueryData
        .fromWindow(window)
        .orientation;
  }

  //accessibleNavigation → bool 用户是否使用TalkBack或VoiceOver等辅助功能服务与应用程序进行交互。
  static bool getAccessibleNavigation() {
    return MediaQueryData
        .fromWindow(window)
        .accessibleNavigation;
  }

  //alwaysUse24HourFormat → bool 格式化时间时是否使用24小时格式。
  static bool getBoldText() {
    return MediaQueryData
        .fromWindow(window)
        .boldText;
  }

  //devicePixelRatio → double 单位逻辑像素的设备像素数量，即设备像素比。这个数字可能不是2的幂，实际上它甚至也可能不是整数。例如，Nexus 6的设备像素比为3.5。
  static double getDevicePixelRatio() {
    return MediaQueryData
        .fromWindow(window)
        .devicePixelRatio;
  }

  //disableAnimations → bool 平台是否要求尽可能禁用或减少使用动画。
  static bool getDisableAnimations() {
    return MediaQueryData
        .fromWindow(window)
        .disableAnimations;
  }

  //  hashCode → int 此对象的哈希码
  static int getHashCode() {
    return MediaQueryData
        .fromWindow(window)
        .hashCode;
  }

  // invertColors → bool 设备是否反转平台的颜色
  static bool getInvertColors() {
    return MediaQueryData
        .fromWindow(window)
        .invertColors;
  }

  //padding → EdgeInsets 显示器的部分被系统UI部分遮挡，通常由硬件显示“凹槽”或系统状态栏
  static EdgeInsets getPadding() {
    return MediaQueryData
        .fromWindow(window)
        .padding;
  }

  //platformBrightness → Brightness 当前的亮度模式
  static Brightness getPlatformBrightness() {
    return MediaQueryData
        .fromWindow(window)
        .platformBrightness;
  }

  //size → Size 设备尺寸信息，如屏幕的大小，单位 pixels
  static Size getSize() {
    return MediaQueryData
        .fromWindow(window)
        .size;
  }

  //textScaleFactor → double 每个逻辑像素的字体像素数
  static double getTextScaleFactor() {
    return MediaQueryData
        .fromWindow(window)
        .textScaleFactor;
  }

  // viewInsets → EdgeInsets 显示器的各个部分完全被系统UI遮挡，通常是设备的键盘
  static EdgeInsets getViewInsets() {
    return MediaQueryData
        .fromWindow(window)
        .viewInsets;
  }

  // viewPadding → EdgeInsets 显示器的部分被系统UI部分遮挡，通常由硬件显示“凹槽”或系统状态栏
  static EdgeInsets getViewPadding() {
    return MediaQueryData
        .fromWindow(window)
        .viewPadding;
  }

  //手机屏幕的宽分辨率
  static double getWidthPixel() {
    return MediaQueryData
        .fromWindow(window)
        .size
        .width * MediaQueryTools.getDevicePixelRatio();
  }

  //手机屏幕高分辨率
  static double getHeightPixel() {
    return MediaQueryData
        .fromWindow(window)
        .size
        .height * MediaQueryTools.getDevicePixelRatio();
  }

  //手机屏幕的宽
  static double getWidth() {
    return MediaQueryData
        .fromWindow(window)
        .size
        .width;
  }

  //手机屏幕高
  static double getHeight() {
    return MediaQueryData
        .fromWindow(window)
        .size
        .height;
  }
}
