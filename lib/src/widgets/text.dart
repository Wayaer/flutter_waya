import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/material.dart';

class RichSpan extends StatelessWidget {
  const RichSpan({
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
  })  : textAlign = textAlign ?? TextAlign.center,
        softWrap = softWrap ?? true,
        overflow = overflow ?? TextOverflow.clip,
        textWidthBasis = textWidthBasis ?? TextWidthBasis.parent,
        textScaleFactor = textScaleFactor ?? 1.0,
        super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final List<TextStyle> styles =
        textStyle ?? <TextStyle>[const TextStyle(fontSize: 14)];
    if (text.length > styles.length) {
      styles.addAll(List<TextStyle>.generate(
          text.length - styles.length, (int index) => styles.last));
    }
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
        text: TextSpan(
            text: '',
            children: text
                .asMap()
                .entries
                .map((MapEntry<int, String> entry) =>
                    TextSpan(text: entry.value, style: styles[entry.key]))
                .toList()),
        textAlign: textAlign);
  }
}

class GText extends Text {
  const GText(
    ///  要展示的数据内容，必须填写的参数
    String data, {
    Key key,

    ///  text类型，一般使用TextStyle
    TextStyle style,

    ///  StrutStyle,影响Text在垂直方向上的布局
    StrutStyle strutStyle,

    ///  TextAlign,内容对齐方式
    TextAlign textAlign,

    ///  TextDirection,内容的走向方式
    TextDirection textDirection,

    ///  Locale，当相同的Unicode字符可以根据不同的地区以不同的方式呈现时，用于选择字体
    Locale locale,

    ///  bool 文本是否应在软换行时断行
    bool softWrap,

    ///  TextOverflow，内容溢出时的处理方式
    TextOverflow overflow,

    ///  double 设置文字的放大缩小，例如，fontSize=10，this.textScaleFactor=2.0，最终得到的文字大小为10*2.0
    double textScaleFactor,

    ///  int 设置文字的最大展示行数
    int maxLines,

    ///  string,语义描述标签，相当于此text的别名
    String semanticsLabel,

    ///  TextWidthBasis 测量一行或多行文本宽度
    TextWidthBasis textWidthBasis,
    ui.TextHeightBehavior textHeightBehavior,
  }) : super(data ?? '',
            key: key,
            style: style,
            strutStyle: strutStyle,
            textAlign: textAlign,
            textDirection: textDirection,
            locale: locale,
            softWrap: softWrap,
            overflow: overflow,
            textScaleFactor: textScaleFactor,
            maxLines: maxLines,
            semanticsLabel: semanticsLabel,
            textWidthBasis: textWidthBasis,
            textHeightBehavior: textHeightBehavior);
}
