import 'dart:ui' as ui show Shadow, FontFeature, TextHeightBehavior;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RichTextSpan extends RichText {
  RichTextSpan({
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
            text: texts == null || texts.isEmpty
                ? textSpan(
                    text: text ?? '',
                    style: style,
                    recognizer: recognizer,
                    semanticsLabel: semanticsLabel ?? text)
                : textSpans(
                    text: text ?? '',
                    texts: texts ?? <String>[],
                    style: style,
                    styles: styles ?? <TextStyle>[],
                    recognizer: recognizer,
                    recognizers: recognizers ?? <GestureRecognizer>[],
                    semanticsLabel: semanticsLabel ?? text,
                    semanticsLabels: semanticsLabels ?? <String>[]),
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

  static TextSpan textSpan(
          {String text,
          TextStyle style,
          GestureRecognizer recognizer,
          String semanticsLabel}) =>
      TextSpan(
          text: text,
          style: style,
          semanticsLabel: semanticsLabel,
          recognizer: recognizer);

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
    if (texts.length > styles.length && styles.isNotEmpty && style != null) {
      styles.addAll(List<TextStyle>.generate(
          texts.length - styles.length, (int index) => styles.last));
    }
    if (texts.length > semanticsLabels.length &&
        semanticsLabels.isNotEmpty &&
        semanticsLabel != null) {
      semanticsLabels.addAll(List<String>.generate(
          texts.length - semanticsLabels.length,
          (int index) => semanticsLabel));
    }
    if (texts.length > recognizers.length &&
        recognizers.isNotEmpty &&
        recognizers != null) {
      recognizers.addAll(List<GestureRecognizer>.generate(
          texts.length - recognizers.length, (int index) => recognizer));
    }
    return TextSpan(
        text: text,
        style: const BasisTextStyle().merge(style),
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
                style: const BasisTextStyle()
                    .merge(styles.isEmpty ? null : styles[entry.key])))
            ?.toList());
  }
}

class BasisText extends RichTextSpan {
  BasisText(
    String text, {
    Key key,

    /// [text]手势
    GestureRecognizer recognizer,

    /// [text]语义 - 语义描述标签，相当于此text的别名
    String semanticsLabel,

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

    /// 使劲此参数 以下单独字体样式无效
    TextStyle style,

    ///  TextStyle 以下是字体样式
    /// 默认样式会继承层级最为接近的 DefaultTextStyle，为true 表示继承，false 表示完全重写
    bool inherit,

    /// 字体颜色，注意： 如果有特殊的foreground，此值必须是null
    Color color,
    Color backgroundColor,
    String fontFamily,
    List<String> fontFamilyFallback,
    String package,

    /// 字体大小 默认的是 14
    double fontSize,

    /// 字体的粗细程度 FontWeight.w100 -- FontWeight.w900 . 默认是FontWeight.w400，
    FontWeight fontWeight,

    /// [FontStyle.normal]正常 [FontStyle.italic]斜体
    FontStyle fontStyle,

    /// 单个字母或者汉字的距离，默认是1.0，负数可以拉近距离
    double letterSpacing,

    /// 单词之间添加的空间间隔，负数可以拉近距离
    double wordSpacing,

    /// [TextBaseline.ideographic]用来对齐表意文字的水平线
    /// [TextBaseline.alphabetic ]以标准的字母顺序为基线
    TextBaseline textBaseline,

    /// 文本的高度 主要用于[TextSpan] 来设置不同的高度
    double height,

    ///  text的前景色，与 [color] 不能同时设置
    Paint foreground,

    /// [text]的背景色
    Paint background,

    /// [text]的划线
    /// [TextDecoration.none] 没有 默认
    /// [TextDecoration.underline] 下划线
    /// [TextDecoration.overline] 上划线
    /// [TextDecoration.lineThrough] 中间的线（删除线）
    TextDecoration decoration,

    /// [decoration]划线的颜色
    Color decorationColor,

    /// [decoration]划线的样式
    /// [TextDecorationStyle.solid]实线
    /// [TextDecorationStyle.double] 画两条线
    /// [TextDecorationStyle.dotted] 点线（一个点一个点的）
    /// [TextDecorationStyle.dashed] 虚线（一个长方形一个长方形的线）
    /// [TextDecorationStyle.wavy] 正玄曲线
    TextDecorationStyle decorationStyle,
    double decorationThickness,

    /// 只在调试的使用
    String debugLabel,

    /// 将在[text]下方绘制的阴影列表
    List<ui.Shadow> shadows,
    List<ui.FontFeature> fontFeatures,
  })  : assert(color == null || foreground == null, _kColorForegroundWarning),
        assert(backgroundColor == null || background == null,
            _kColorBackgroundWarning),
        super(
            key: key,
            text: text,
            style: BasisTextStyle(
                    inherit: inherit,
                    color: color,
                    backgroundColor: backgroundColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    fontStyle: fontStyle,
                    letterSpacing: letterSpacing,
                    wordSpacing: wordSpacing,
                    textBaseline: textBaseline,
                    height: height,
                    locale: locale,
                    foreground: foreground,
                    background: background,
                    shadows: shadows,
                    fontFeatures: fontFeatures,
                    decoration: decoration,
                    decorationColor: decorationColor,
                    decorationStyle: decorationStyle,
                    decorationThickness: decorationThickness,
                    debugLabel: debugLabel,
                    fontFamily: fontFamily,
                    fontFamilyFallback: fontFamilyFallback,
                    package: package)
                .merge(style),
            semanticsLabel: semanticsLabel,
            recognizer: recognizer,
            textAlign: textAlign ?? TextAlign.start,
            softWrap: softWrap ?? true,
            overflow: overflow ??
                (maxLines == null ? TextOverflow.clip : TextOverflow.ellipsis),
            textWidthBasis: textWidthBasis ?? TextWidthBasis.parent,
            textScaleFactor: textScaleFactor ?? 1.0,
            textDirection: textDirection,
            maxLines: maxLines ?? 1,
            locale: locale,
            strutStyle: strutStyle,
            textHeightBehavior: textHeightBehavior);
}

class BasisTextStyle extends TextStyle {
  const BasisTextStyle({
    /// 默认样式会继承层级最为接近的 DefaultTextStyle，为true 表示继承，false 表示完全重写
    bool inherit,

    /// 字体颜色，注意： 如果有特殊的foreground，此值必须是null
    Color color,
    Color backgroundColor,
    String fontFamily,
    List<String> fontFamilyFallback,
    String package,

    ///  Locale，当相同的Unicode字符可以根据不同的地区以不同的方式呈现时，用于选择字体
    Locale locale,

    /// 字体大小 默认的是 14
    double fontSize,

    /// 字体的粗细程度 FontWeight.w100 -- FontWeight.w900 . 默认是FontWeight.w400，
    FontWeight fontWeight,

    /// [FontStyle.normal]正常 [FontStyle.italic]斜体
    FontStyle fontStyle,

    /// 单个字母或者汉字的距离，默认是1.0，负数可以拉近距离
    double letterSpacing,

    /// 单词之间添加的空间间隔，负数可以拉近距离
    double wordSpacing,

    /// [TextBaseline.ideographic]用来对齐表意文字的水平线
    /// [TextBaseline.alphabetic ]以标准的字母顺序为基线
    TextBaseline textBaseline,

    /// 文本的高度 主要用于[TextSpan] 来设置不同的高度
    double height,

    ///  text的前景色，与 [color] 不能同时设置
    Paint foreground,

    /// [text]的背景色
    Paint background,

    /// [text]的划线
    /// [TextDecoration.none] 没有 默认
    /// [TextDecoration.underline] 下划线
    /// [TextDecoration.overline] 上划线
    /// [TextDecoration.lineThrough] 中间的线（删除线）
    TextDecoration decoration,

    /// [decoration]划线的颜色
    Color decorationColor,

    /// [decoration]划线的样式
    /// [TextDecorationStyle.solid]实线
    /// [TextDecorationStyle.double] 画两条线
    /// [TextDecorationStyle.dotted] 点线（一个点一个点的）
    /// [TextDecorationStyle.dashed] 虚线（一个长方形一个长方形的线）
    /// [TextDecorationStyle.wavy] 正玄曲线
    TextDecorationStyle decorationStyle,
    double decorationThickness,

    /// 只在调试的使用
    String debugLabel,

    /// 将在[text]下方绘制的阴影列表
    List<ui.Shadow> shadows,
    List<ui.FontFeature> fontFeatures,
  }) : super(
            inherit: inherit ?? true,
            color: color ?? Colors.black87,
            backgroundColor: backgroundColor,
            fontSize: fontSize ?? 14,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            letterSpacing: letterSpacing,
            wordSpacing: wordSpacing,
            textBaseline: textBaseline,
            height: height,
            locale: locale,
            foreground: foreground,
            background: background,
            shadows: shadows,
            fontFeatures: fontFeatures,
            decoration: decoration ?? TextDecoration.none,
            decorationColor: decorationColor,
            decorationStyle: decorationStyle,
            decorationThickness: decorationThickness,
            debugLabel: debugLabel,
            fontFamily: fontFamily,
            fontFamilyFallback: fontFamilyFallback,
            package: package);
}

const String _kColorForegroundWarning =
    'Cannot provide both a color and a foreground\n'
    'The color argument is just a shorthand for "foreground: new Paint()..color = color".';

const String _kColorBackgroundWarning =
    'Cannot provide both a backgroundColor and a background\n'
    'The backgroundColor argument is just a shorthand for "background: new Paint()..color = color".';
