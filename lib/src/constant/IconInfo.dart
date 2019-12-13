import 'package:flutter/material.dart';

class IconInfo{
  static const IconData iconsChecked = getIcon(0xe71d);
  static const IconData iconsUnChecked = getIcon(0xe71c);
  static const IconData iconsEyeOpen = getIcon(0xe6de);
  static const IconData iconsEyeClose = getIcon(0xe6e3);
  static const IconData iconsRight = getIcon(0xe6fc);
  static const IconData iconsLeft = getIcon(0xe6e7);
  static const IconData iconsSearch = getIcon(0xe759);
}
class getIcon extends IconData {
  const getIcon(int codePoint) : super(codePoint, fontFamily: 'Icons', matchTextDirection: true);
}