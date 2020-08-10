import 'package:flutter/material.dart';
import 'dart:ui' as ui show TextHeightBehavior;

class GText extends StatelessWidget {
  ///要展示的数据内容，必须填写的参数
  final String data;

  ///text类型，一般使用TextStyle
  final TextStyle style;

  ///StrutStyle,影响Text在垂直方向上的布局
  final StrutStyle strutStyle;

  ///TextAlign,内容对齐方式
  final TextAlign textAlign;

  ///TextDirection,内容的走向方式
  final TextDirection textDirection;

  ///Locale，当相同的Unicode字符可以根据不同的地区以不同的方式呈现时，用于选择字体
  final Locale locale;

  ///bool 文本是否应在软换行时断行
  final bool softWrap;

  ///TextOverflow，内容溢出时的处理方式
  final TextOverflow overflow;

  ///double 设置文字的放大缩小，例如，fontSize=10，this.textScaleFactor=2.0，最终得到的文字大小为10*2.0
  final double textScaleFactor;

  ///int 设置文字的最大展示行数
  final int maxLines;

  ///string,语义描述标签，相当于此text的别名
  final String semanticsLabel;

  ///TextWidthBasis 测量一行或多行文本宽度
  final TextWidthBasis textWidthBasis;

  final ui.TextHeightBehavior textHeightBehavior;

  const GText(
    this.data, {
    Key key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data ?? "",
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
      textHeightBehavior: textHeightBehavior,
    );
  }
}
