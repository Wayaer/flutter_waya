import 'dart:ui';

import 'package:flutter/material.dart';

class WayMediaQueryUtils {
  //获取状态栏高度
  static getStatusBarHeight() {
    return MediaQueryData
        .fromWindow(window)
        .padding
        .top;
  }

  //获取导航栏高度
  static getBottomNavigationBarHeight() {
    return MediaQueryData
        .fromWindow(window)
        .padding
        .bottom;
  }

  //orientation → Orientation 屏幕方向（横向/纵向）
  static getOrientation() {
    return MediaQueryData
        .fromWindow(window)
        .orientation;
  }

  //accessibleNavigation → bool 用户是否使用TalkBack或VoiceOver等辅助功能服务与应用程序进行交互。
  static getAccessibleNavigation() {
    return MediaQueryData
        .fromWindow(window)
        .accessibleNavigation;
  }

  //alwaysUse24HourFormat → bool 格式化时间时是否使用24小时格式。
  static getBoldText() {
    return MediaQueryData
        .fromWindow(window)
        .boldText;
  }

  //devicePixelRatio → double 单位逻辑像素的设备像素数量，即设备像素比。这个数字可能不是2的幂，实际上它甚至也可能不是整数。例如，Nexus 6的设备像素比为3.5。
  static getDevicePixelRatio() {
    return MediaQueryData
        .fromWindow(window)
        .devicePixelRatio;
  }

  //disableAnimations → bool 平台是否要求尽可能禁用或减少使用动画。
  static getDisableAnimations() {
    return MediaQueryData
        .fromWindow(window)
        .disableAnimations;
  }

  //  hashCode → int 此对象的哈希码
  static getHashCode() {
    return MediaQueryData
        .fromWindow(window)
        .hashCode;
  }

  // invertColors → bool 设备是否反转平台的颜色
  static getInvertColors() {
    return MediaQueryData
        .fromWindow(window)
        .invertColors;
  }

  //padding → EdgeInsets 显示器的部分被系统UI部分遮挡，通常由硬件显示“凹槽”或系统状态栏
  static getPadding() {
    return MediaQueryData
        .fromWindow(window)
        .padding;
  }

  //platformBrightness → Brightness 当前的亮度模式
  static getPlatformBrightness() {
    return MediaQueryData
        .fromWindow(window)
        .platformBrightness;
  }

  //size → Size 设备尺寸信息，如屏幕的大小，单位 pixels
  static getSize() {
    return MediaQueryData
        .fromWindow(window)
        .size;
  }

  //textScaleFactor → double 每个逻辑像素的字体像素数
  static getTextScaleFactor() {
    return MediaQueryData
        .fromWindow(window)
        .textScaleFactor;
  }

  // viewInsets → EdgeInsets 显示器的各个部分完全被系统UI遮挡，通常是设备的键盘
  static getViewInsets() {
    return MediaQueryData
        .fromWindow(window)
        .viewInsets;
  }

  // viewPadding → EdgeInsets 显示器的部分被系统UI部分遮挡，通常由硬件显示“凹槽”或系统状态栏
  static getViewPadding() {
    return MediaQueryData
        .fromWindow(window)
        .viewPadding;
  }
}
