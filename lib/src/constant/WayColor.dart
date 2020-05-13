import 'package:flutter/material.dart' show Color, Colors;

const String transparent = 'transparent';
const String white50 = 'white50';
const String white = 'white';
const String background = 'background';
const String blue = 'blue';
const String black = 'black';
const String black30 = 'black30';
const String boxShadowColor = 'boxShadowColor';
const String black70 = 'black70';
const String black90 = 'black90';
const String greenAccent = 'greenAccent';

Color getColors(String color) {
  return ColorInfo[color];
}

const ColorInfo = {
  '$transparent': Colors.transparent,
  '$white': Colors.white,
  '$white50': Color(0x50FFFFFF),
  '$black': Color(0xFF000000),
  '$black70': Color(0x70000000),
  '$black90': Color(0x90000000),
  '$black30': Color(0x309B9B9B),
  '$greenAccent': Colors.greenAccent,

  '$blue': Color(0xFF349DFF),
  //
  '$boxShadowColor': Color(0xFFE0E0E0),
  '$background': Color.fromRGBO(246, 246, 246, 1),
};
