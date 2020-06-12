import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final TextAlign textAlign;
  final List<String> text;
  final List<TextStyle> textStyle;
  final TextDirection textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final int maxLines;
  final Locale locale;
  final StrutStyle strutStyle;
  final TextWidthBasis textWidthBasis;
  final ui.TextHeightBehavior textHeightBehavior;
  final double textScaleFactor;

  CustomRichText({
    Key key,
    this.text,
    TextAlign textAlign,
    bool softWrap,
    TextOverflow overflow,
    double textScaleFactor,
    TextWidthBasis textWidthBasis,
    this.textStyle,
    this.textDirection,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textHeightBehavior,
  })  : this.textAlign = textAlign ?? TextAlign.center,
        this.softWrap = softWrap ?? true,
        this.overflow = overflow ?? TextOverflow.clip,
        this.textWidthBasis = textWidthBasis ?? TextWidthBasis.parent,
        this.textScaleFactor = textScaleFactor ?? 1.0,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return richText();
  }

  Widget richText() {
    List<TextSpan> children = List();
    List<TextStyle> styles = List();
    if (textStyle == null) {
      styles.add(TextStyle(fontSize: 14));
    } else {
      styles.addAll(textStyle);
    }
    if (text.length > styles.length) {
      int poor = text.length - styles.length;
      print(poor);
      for (int i = 0; i <= poor; i++) {
        styles.add(styles.last);
      }
    }
    text.map((value) {
      children.add(TextSpan(text: value, style: styles[text.indexOf(value)]));
    }).toList();
    return RichText(
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      text: TextSpan(text: '', children: children),
      textAlign: textAlign,
    );
  }
}
