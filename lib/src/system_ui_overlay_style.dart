import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemUiOverlayStyleLight extends SystemUiOverlayStyle {
  const SystemUiOverlayStyleLight(
      {super.systemNavigationBarColor = Colors.transparent,
      super.systemNavigationBarDividerColor = Colors.transparent,
      super.statusBarColor = Colors.transparent,
      super.systemNavigationBarIconBrightness = Brightness.light,
      super.statusBarIconBrightness = Brightness.light,
      super.statusBarBrightness = Brightness.dark});
}

class SystemUiOverlayStyleDark extends SystemUiOverlayStyle {
  const SystemUiOverlayStyleDark(
      {super.systemNavigationBarColor = Colors.transparent,
      super.systemNavigationBarDividerColor = Colors.transparent,
      super.statusBarColor = Colors.transparent,
      super.systemNavigationBarIconBrightness = Brightness.dark,
      super.statusBarIconBrightness = Brightness.dark,
      super.statusBarBrightness = Brightness.light});
}
