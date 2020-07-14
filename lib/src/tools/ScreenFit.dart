import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

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
      h = ratioFit
          ? (height / _designHeight) * MediaQueryTools.getHeight()
          : height;
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
      w = ratioFit
          ? (width / _designWidth) * MediaQueryTools.getWidth()
          : width;
    }
    return intType == true ? w.toInt() : w;
  }

  ///初始化设置 设计稿宽高
  ///默认为 667*375
  static setRatioFit(bool fit) {
    _ratioFit = fit;
  }

  ///初始化设置 设计稿宽高
  ///默认为 667*375
  static setDesignSize(Size size) {
    _designHeight = size.height;
    _designWidth = size.width;
  }
}
