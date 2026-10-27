import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 透明背景 + 白色图标的状态栏/导航栏风格，适合深色页面。
class FlSystemUiOverlayStyleLight extends SystemUiOverlayStyle {
  const FlSystemUiOverlayStyleLight({
    super.systemNavigationBarColor = Colors.transparent,
    super.systemNavigationBarDividerColor = Colors.transparent,
    super.statusBarColor = Colors.transparent,
    super.systemNavigationBarIconBrightness = Brightness.light,
    super.statusBarIconBrightness = Brightness.light,
    super.statusBarBrightness = Brightness.dark,
  });
}

/// 透明背景 + 深色图标的状态栏/导航栏风格，适合浅色页面。
class FlSystemUiOverlayStyleDark extends SystemUiOverlayStyle {
  const FlSystemUiOverlayStyleDark({
    super.systemNavigationBarColor = Colors.transparent,
    super.systemNavigationBarDividerColor = Colors.transparent,
    super.statusBarColor = Colors.transparent,
    super.systemNavigationBarIconBrightness = Brightness.dark,
    super.statusBarIconBrightness = Brightness.dark,
    super.statusBarBrightness = Brightness.light,
  });
}
