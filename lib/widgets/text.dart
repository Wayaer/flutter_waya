import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

//
// class RichSpan extends StatelessWidget {
//   const RichSpan({
//     Key key,
//     this.text,
//     TextAlign textAlign,
//     bool softWrap,
//     TextOverflow overflow,
//     double textScaleFactor,
//     TextWidthBasis textWidthBasis,
//     this.textStyle,
//     this.textDirection,
//     this.maxLines,
//     this.locale,
//     this.strutStyle,
//     this.textHeightBehavior,
//   })  : textAlign = textAlign ?? TextAlign.center,
//         softWrap = softWrap ?? true,
//         overflow = overflow ?? TextOverflow.clip,
//         textWidthBasis = textWidthBasis ?? TextWidthBasis.parent,
//         textScaleFactor = textScaleFactor ?? 1.0,
//         super(key: key);
//
//   final TextAlign textAlign;
//   final List<String> text;
//   final List<TextStyle> textStyle;
//   final TextDirection textDirection;
//   final bool softWrap;
//   final TextOverflow overflow;
//   final int maxLines;
//   final Locale locale;
//   final StrutStyle strutStyle;
//   final TextWidthBasis textWidthBasis;
//   final ui.TextHeightBehavior textHeightBehavior;
//   final double textScaleFactor;
//
//   @override
//   Widget build(BuildContext context) {
//     final List<TextStyle> styles =
//         textStyle ?? <TextStyle>[const TextStyle(fontSize: 14)];
//     if (text.length > styles.length) {
//       styles.addAll(List<TextStyle>.generate(
//           text.length - styles.length, (int index) => styles.last));
//     }
//
//     return RichText(
//         textDirection: textDirection,
//         softWrap: softWrap,
//         overflow: overflow,
//         textScaleFactor: textScaleFactor,
//         maxLines: maxLines,
//         locale: locale,
//         strutStyle: strutStyle,
//         textWidthBasis: textWidthBasis,
//         textHeightBehavior: textHeightBehavior,
//         text: TextSpan(
//             text: '',
//             children: text
//                 .asMap()
//                 .entries
//                 .map((MapEntry<int, String> entry) =>
//                     TextSpan(text: entry.value, style: styles[entry.key]))
//                 .toList()),
//         textAlign: textAlign);
//   }
// }

class RichSpan extends RichText {
  RichSpan({
    Key key,

    /// 第一个[text]
    String text,

    /// 排在第一个[text]后面
    List<String> texts,

    /// 所有[text]、[texts]默认样式
    TextStyle style,

    /// [texts]内样式
    List<TextStyle> styles,

    /// 所有[text]、[texts]手势
    GestureRecognizer recognizer,

    /// [texts]内手势
    List<GestureRecognizer> recognizers,

    /// 所有[text]、[texts]语义 - 语义描述标签，相当于此text的别名
    String semanticsLabel,

    /// [texts]内语义 - 语义描述标签，相当于此text的别名
    List<String> semanticsLabels,

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

    ///  TextWidthBasis 测量一行或多行文本宽度
    TextWidthBasis textWidthBasis,
    ui.TextHeightBehavior textHeightBehavior,
  }) : super(
            text: textSpans(
              text: text ?? '',
              style: style ?? const TextStyle(fontSize: 14),
              texts: texts ?? <String>[],
              styles: styles ?? <TextStyle>[],
              recognizer: recognizer,
              recognizers: recognizers ?? <GestureRecognizer>[],
              semanticsLabel: semanticsLabel ?? text,
              semanticsLabels: semanticsLabels ?? <String>[],
            ),
            key: key,
            textAlign: textAlign ?? TextAlign.center,
            softWrap: softWrap ?? true,
            overflow: overflow ?? TextOverflow.clip,
            textWidthBasis: textWidthBasis ?? TextWidthBasis.parent,
            textScaleFactor: textScaleFactor ?? 1.0,
            textDirection: textDirection,
            maxLines: maxLines,
            locale: locale,
            strutStyle: strutStyle,
            textHeightBehavior: textHeightBehavior);

  static TextSpan textSpans({
    List<String> texts,
    List<TextStyle> styles,
    String text,
    TextStyle style,
    GestureRecognizer recognizer,
    List<GestureRecognizer> recognizers,
    String semanticsLabel,
    List<String> semanticsLabels,
  }) {
    if (texts.length > styles.length && styles.isNotEmpty) {
      styles.addAll(List<TextStyle>.generate(
          texts.length - styles.length, (int index) => styles.last));
    }
    if (texts.length > semanticsLabels.length && semanticsLabels.isNotEmpty) {
      semanticsLabels.addAll(List<String>.generate(
          texts.length - semanticsLabels.length,
          (int index) => semanticsLabel));
    }
    if (texts.length > recognizers.length && recognizers.isNotEmpty) {
      recognizers.addAll(List<GestureRecognizer>.generate(
          texts.length - recognizers.length, (int index) => recognizer));
    }
    return TextSpan(
        text: text,
        style: style,
        semanticsLabel: semanticsLabel,
        recognizer: recognizer,
        children: texts
            ?.asMap()
            ?.entries
            ?.map((MapEntry<int, String> entry) => TextSpan(
                text: entry.value,
                semanticsLabel:
                    semanticsLabels.isEmpty ? null : semanticsLabels[entry.key],
                recognizer: recognizers.isEmpty ? null : recognizers[entry.key],
                style: styles.isEmpty ? null : styles[entry.key]))
            ?.toList());
  }
}

class SimpleText extends RichSpan {}
