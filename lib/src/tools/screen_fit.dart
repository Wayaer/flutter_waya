import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

class MediaQueryTools {
  static var mediaQuery = MediaQueryData.fromWindow(window);

  ///获取状态栏高度
  static double getStatusBarHeight() => mediaQuery.padding.top;

  ///获取导航栏高度
  static double getBottomNavigationBarHeight() => mediaQuery.padding.bottom;

  ///orientation → Orientation 屏幕方向（横向/纵向）
  static Orientation getOrientation() => mediaQuery.orientation;

  ///accessibleNavigation → bool 用户是否使用TalkBack或VoiceOver等辅助功能服务与应用程序进行交互。
  static bool getAccessibleNavigation() => mediaQuery.accessibleNavigation;

  ///alwaysUse24HourFormat → bool 格式化时间时是否使用24小时格式。
  static bool getBoldText() => mediaQuery.boldText;

  ///devicePixelRatio → double 单位逻辑像素的设备像素数量，即设备像素比。这个数字可能不是2的幂，实际上它甚至也可能不是整数。例如，Nexus 6的设备像素比为3.5。
  static double getDevicePixelRatio() => mediaQuery.devicePixelRatio;

  ///disableAnimations → bool 平台是否要求尽可能禁用或减少使用动画。
  static bool getDisableAnimations() => mediaQuery.disableAnimations;

  ///  hashCode → int 此对象的哈希码
  static int getHashCode() => mediaQuery.hashCode;

  /// invertColors → bool 设备是否反转平台的颜色
  static bool getInvertColors() => mediaQuery.invertColors;

  ///padding → EdgeInsets 显示器的部分被系统UI部分遮挡，通常由硬件显示“凹槽”或系统状态栏
  static EdgeInsets getPadding() => mediaQuery.padding;

  ///platformBrightness → Brightness 当前的亮度模式
  static Brightness getPlatformBrightness() => mediaQuery.platformBrightness;

  ///size → Size 设备尺寸信息，如屏幕的大小，单位 pixels
  static Size getSize() => mediaQuery.size;

  ///textScaleFactor → double 每个逻辑像素的字体像素数
  static double getTextScaleFactor() => mediaQuery.textScaleFactor;

  /// viewInsets → EdgeInsets 显示器的各个部分完全被系统UI遮挡，通常是设备的键盘
  static EdgeInsets getViewInsets() => mediaQuery.viewInsets;

  /// viewPadding → EdgeInsets 显示器的部分被系统UI部分遮挡，通常由硬件显示“凹槽”或系统状态栏
  static EdgeInsets getViewPadding() => mediaQuery.viewPadding;

  ///手机屏幕的宽分辨率
  static double getWidthPixel() => mediaQuery.size.width * MediaQueryTools.getDevicePixelRatio();

  ///手机屏幕高分辨率
  static double getHeightPixel() => mediaQuery.size.height * MediaQueryTools.getDevicePixelRatio();

  ///手机屏幕的宽
  static double getWidth() => mediaQuery.size.width;

  ///手机屏幕高
  static double getHeight() => mediaQuery.size.height;
}

class ScreenFit {
  static double _designWidth = 375;
  static double _designHeight = 667;
  static bool _ratioFit = true;

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
  static getHeight(double height, {bool intType, bool ratioFit}) {
    if (ratioFit == null) ratioFit = _ratioFit;
    double h;
    if (height == null || height == 0) {
      h = MediaQueryTools.getSize().height;
    } else {
      ///  h = (height / designHeight) * phoneFitHeight(context);
      h = ratioFit ? (height / _designHeight) * MediaQueryTools.getHeight() : height;
    }
    return intType == true ? h.toInt() : h;
  }

  ///相对iphone 6s 尺寸设计稿 宽
  static getWidth(double width, {bool intType, bool ratioFit}) {
    if (ratioFit == null) ratioFit = _ratioFit;
    double w;
    if (width == null || width == 0) {
      w = MediaQueryTools.getSize().width;
    } else {
      w = ratioFit ? (width / _designWidth) * MediaQueryTools.getWidth() : width;
    }
    return intType == true ? w.toInt() : w;
  }

  ///初始化设置 设计稿宽高
  ///默认为 667*375
  static setRatioFit(bool fit) => _ratioFit = fit;

  ///初始化设置 设计稿宽高
  ///默认为 667*375
  static setDesignSize(Size size) {
    _designHeight = size.height;
    _designWidth = size.width;
  }
}
