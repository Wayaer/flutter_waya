import 'package:flutter/material.dart';

const String white = 'white';
const String white50 = 'white50';
const String background = 'background';
const String iconWhite = 'iconWhite';
const String iconBlue = 'iconBlue';
const String iconGray = 'iconGray';
const String iconBlack = 'iconBlack';
const String textBlue = 'textBlue';
const String textBlack100 = 'textBlack100';
const String textBlack70 = 'textBlack70';
const String textBlack30 = 'textBlack30';
const String textBlack20 = 'textBlack20';
const String textWhite = 'textWhite';
const String textWhite60 = 'textWhite60';
const String buttonBlue = 'buttonBlue';
const String buttonBlue50 = 'buttonBlue50';
const String buttonBlue20 = 'buttonBlue20';
const String boxShadowColor = 'boxShadowColor';
const String checkboxActiveColor = 'checkboxActiveColor';
const String checkboxCheckColor = 'checkboxCheckColor';
const String activeColor = 'activeColor';
const String tabBarLabelColor = 'tabBarLabelColor';
const String tabBarUnselectedLabelColor = 'tabBarUnselectedLabelColor';
const String appBarBackgroundColor = 'appBarBackgroundColor';
const String tabBarNavigationColor = 'tabBarNavigationColor';
const String tabBarNavigationSelectedItemColor =
    'tabBarNavigationSelectedItemColor';
const String tabBarNavigationUnSelectedItemColor =
    'tabBarNavigationUnSelectedItemColor';
const String containerColor = 'containerColor';
const String appBarTextColor = 'appBarTextColor';

getColors(String color) {
  return ColorInfo[color];
}

const ColorInfo = {
  '$appBarTextColor': Colors.white,
  '$textBlack100': Color(0xFF000000),
  '$textBlack70': Color(0xFF393939),
  '$textBlack30': Color(0xFF9B9B9B),
  '$textBlack20': Color(0xFFCACACA),
  '$textWhite': Color(0xFFFFFFFF),
  '$textWhite60': Color(0x66FFFFFF),
  '$textBlue': Color(0xFF349DFF),
  '$buttonBlue': Color(0xFF349DFF),
  '$buttonBlue50': Color(0xFF4EB3FA),
  '$buttonBlue20': Color(0xFF64C7F5),
  '$iconWhite': Color(0xFFFFFFFF),
  '$iconGray': Color(0xFFA7A7A7),
  '$iconBlue': Color(0xFF349DFF),
  '$iconBlack': Color(0xFF393939),
  '$checkboxActiveColor': Color.fromRGBO(52, 157, 255, 1),
  '$checkboxCheckColor': Colors.white,
  '$boxShadowColor': Color(0xFFE0E0E0),
  '$tabBarLabelColor': Color.fromRGBO(52, 157, 255, 1),
  '$tabBarUnselectedLabelColor': Color.fromRGBO(57, 57, 57, 1),
  '$background': Color.fromRGBO(246, 246, 246, 1),
  '$activeColor': Color.fromRGBO(52, 157, 255, 1),
  '$tabBarNavigationColor': Colors.white,
  '$tabBarNavigationSelectedItemColor': Color(0xFF349DFF),
  '$tabBarNavigationUnSelectedItemColor': Color(0xFFA7A7A7),
  '$white': Colors.white,
  '$white50': Color(0xFFFFFFFF),
  '$containerColor': Colors.white,
  '$appBarBackgroundColor': Colors.white,
};
