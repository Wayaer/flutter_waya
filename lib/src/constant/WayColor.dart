import 'package:flutter/material.dart' show Color, Colors;

const String transparent = 'transparent';
const String white50 = 'white50';
const String white = 'white';
const String background = 'background';
const String blue = 'blue';
const String boxShadowColor = 'boxShadowColor';
const String greenAccent = 'greenAccent';
const String red = 'red';
const String black = 'black';
const String black30 = 'black30';
const String black70 = 'black70';
const String black50 = 'black50';
const String black90 = 'black90';

Color getColors(String color) {
  return constColors[color];
}

const constColors = {
  '$transparent': Colors.transparent,
  '$white': Colors.white,
  '$red': Colors.red,
  '$white50': Color(0x50FFFFFF),
  '$black': Color(0xFF000000),
  '$black30': Color(0x30000000),
  '$black50': Color(0x50000000),
  '$black70': Color(0x70000000),
  '$black90': Color(0x90000000),
  '$greenAccent': Colors.greenAccent,

  '$blue': Color(0xFF349DFF),
  //
  '$boxShadowColor': Color(0xFFE0E0E0),
  '$background': Color.fromRGBO(246, 246, 246, 1),
};
