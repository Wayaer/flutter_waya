import 'package:flutter/material.dart';

class FixedSizeText extends Text {
  const FixedSizeText(
    String data, {
    Key key,
    TextStyle style,
    StrutStyle strutStyle,
    TextAlign textAlign,
    TextDirection textDirection,
    Locale locale,
    bool softWrap,
    TextOverflow overflow,
    double textScaleFactor = 1,
    int maxLines,
    TextWidthBasis textWidthBasis,
    String semanticsLabel,
  }) : super(data,
            key: key,
            style: style,
            strutStyle: strutStyle,
            textAlign: textAlign,
            textDirection: textDirection,
            locale: locale,
            softWrap: softWrap,
            overflow: overflow,
            textWidthBasis: textWidthBasis,
            textScaleFactor: textScaleFactor,
            maxLines: maxLines,
            semanticsLabel: semanticsLabel);
}
