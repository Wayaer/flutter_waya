import 'dart:ui' as ui show Shadow, FontFeature, TextHeightBehavior;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class RText extends RichText {
  RText({
    Key? key,

    /// 第一个[text]
    String? text,

    /// 排在第一个[text]后面
    List<String>? texts,

    /// 所有[text]、[texts]默认样式
    TextStyle? style,

    /// [texts]内样式
    List<TextStyle> styles = const <TextStyle>[],

    /// 所有[text]、[texts]手势
    GestureRecognizer? recognizer,

    /// [texts]内手势
    List<GestureRecognizer?> recognizers = const <GestureRecognizer?>[],

    /// 所有[text]、[texts]语义 - 语义描述标签，相当于此text的别名
    String? semanticsLabel,

    /// [texts]内语义 - 语义描述标签，相当于此text的别名
    List<String> semanticsLabels = const <String>[],

    /// StrutStyle,影响Text在垂直方向上的布局
    StrutStyle? strutStyle,

    /// TextAlign,内容对齐方式
    TextAlign textAlign = TextAlign.center,

    /// TextDirection,内容的走向方式
    TextDirection? textDirection,

    /// Locale，当相同的Unicode字符可以根据不同的地区以不同的方式呈现时，用于选择字体
    Locale? locale,

    /// bool 文本是否应在软换行时断行
    bool softWrap = true,

    /// TextOverflow，内容溢出时的处理方式
    TextOverflow overflow = TextOverflow.clip,

    /// double 设置文字的放大缩小，例如，fontSize=10，this.textScaleFactor=2.0，最终得到的文字大小为10*2.0
    double textScaleFactor = 1.0,

    /// int 设置文字的最大展示行数
    int? maxLines,

    /// TextWidthBasis 测量一行或多行文本宽度
    TextWidthBasis textWidthBasis = TextWidthBasis.parent,
    ui.TextHeightBehavior? textHeightBehavior,
  }) : super(
            text: texts == null || texts.isEmpty
                ? textSpan(
                    text: text ?? '',
                    style: style,
                    recognizer: recognizer,
                    semanticsLabel: semanticsLabel ?? text)
                : textSpans(
                    text: text ?? '',
                    texts: texts,
                    style: style,
                    styles: styles,
                    recognizer: recognizer,
                    recognizers: recognizers,
                    semanticsLabel: semanticsLabel,
                    semanticsLabels: semanticsLabels),
            key: key,
            textAlign: textAlign,
            softWrap: softWrap,
            overflow: overflow,
            textWidthBasis: textWidthBasis,
            textScaleFactor: textScaleFactor,
            textDirection: textDirection,
            maxLines: maxLines,
            locale: locale,
            strutStyle: strutStyle,
            textHeightBehavior: textHeightBehavior);

  static TextSpan textSpan(
          {required String text,
          TextStyle? style,
          GestureRecognizer? recognizer,
          String? semanticsLabel}) =>
      TextSpan(
          text: text,
          style: style,
          semanticsLabel: semanticsLabel,
          recognizer: recognizer);

  static TextSpan textSpans({
    required List<String> texts,
    required List<TextStyle> styles,
    String? text,
    TextStyle? style,
    GestureRecognizer? recognizer,
    required List<GestureRecognizer?> recognizers,
    String? semanticsLabel,
    required List<String> semanticsLabels,
  }) {
    if (texts.length > styles.length && styles.isNotEmpty) {
      styles.addAll(
          (texts.length - styles.length).generate((int index) => styles.last));
    }
    if (texts.length > semanticsLabels.length &&
        semanticsLabels.isNotEmpty &&
        semanticsLabel != null) {
      semanticsLabels.addAll((texts.length - semanticsLabels.length)
          .generate((int index) => semanticsLabel));
    }
    if (texts.length > recognizers.length &&
        recognizers.isNotEmpty &&
        recognizer != null) {
      recognizers.addAll((texts.length - recognizers.length)
          .generate((int index) => recognizer));
    }
    return TextSpan(
        text: text,
        style: const BTextStyle().merge(style),
        semanticsLabel: semanticsLabel,
        recognizer: recognizer,
        children: texts.builderEntry((MapEntry<int, String> entry) => TextSpan(
            text: entry.value,
            semanticsLabel:
                semanticsLabels.isEmpty ? null : semanticsLabels[entry.key],
            recognizer: recognizers.isEmpty ? null : recognizers[entry.key],
            style: const BTextStyle()
                .merge(styles.isEmpty ? null : styles[entry.key]))));
  }
}

class BText extends StatelessWidget {
  const BText(this.text,
      {Key? key,
      this.recognizer,
      this.semanticsLabel,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.locale,
      this.softWrap,
      this.overflow,
      this.textScaleFactor,
      this.maxLines,
      this.textWidthBasis,
      this.style,
      this.inherit,
      this.color,
      this.backgroundColor,
      this.fontFamily,
      this.fontFamilyFallback,
      this.package,
      this.fontSize,
      this.fontWeight,
      this.fontStyle,
      this.letterSpacing,
      this.wordSpacing,
      this.textBaseline,
      this.height,
      this.foreground,
      this.background,
      this.decoration,
      this.decorationColor,
      this.decorationStyle,
      this.decorationThickness,
      this.debugLabel,
      this.shadows,
      this.fontFeatures,
      this.textHeightBehavior})
      : assert(color == null || foreground == null, _kColorForegroundWarning),
        assert(backgroundColor == null || background == null,
            _kColorBackgroundWarning),
        super(key: key);

  final String text;

  /// [text]手势
  final GestureRecognizer? recognizer;

  /// [text]语义 - 语义描述标签，相当于此text的别名
  final String? semanticsLabel;

  /// StrutStyle,影响Text在垂直方向上的布局
  final StrutStyle? strutStyle;

  /// TextAlign,内容对齐方式
  final TextAlign? textAlign;

  /// TextDirection,内容的走向方式
  final TextDirection? textDirection;

  /// Locale，当相同的Unicode字符可以根据不同的地区以不同的方式呈现时，用于选择字体
  final Locale? locale;

  /// bool 文本是否应在软换行时断行
  final bool? softWrap;

  /// TextOverflow，内容溢出时的处理方式
  final TextOverflow? overflow;

  /// double 设置文字的放大缩小，例如，fontSize=10，this.textScaleFactor=2.0，最终得到的文字大小为10*2.0
  final double? textScaleFactor;

  /// int 设置文字的最大展示行数
  final int? maxLines;

  /// TextWidthBasis 测量一行或多行文本宽度
  final TextWidthBasis? textWidthBasis;
  final ui.TextHeightBehavior? textHeightBehavior;

  /// 使劲此参数 以下单独字体样式无效
  final TextStyle? style;

  /// TextStyle 以下是字体样式
  /// 默认样式会继承层级最为接近的 DefaultTextStyle，为true 表示继承，false 表示完全重写
  final bool? inherit;

  /// 字体颜色，注意： 如果有特殊的foreground，此值必须是null
  final Color? color;
  final Color? backgroundColor;
  final String? fontFamily;
  final List<String>? fontFamilyFallback;
  final String? package;

  /// 字体大小 默认的是 14
  final double? fontSize;

  /// 字体的粗细程度 FontWeight.w100 -- FontWeight.w900 . 默认是FontWeight.w400，
  final FontWeight? fontWeight;

  /// [FontStyle.normal]正常 [FontStyle.italic]斜体
  final FontStyle? fontStyle;

  /// 单个字母或者汉字的距离，默认是1.0，负数可以拉近距离
  final double? letterSpacing;

  /// 单词之间添加的空间间隔，负数可以拉近距离
  final double? wordSpacing;

  /// [TextBaseline.ideographic]用来对齐表意文字的水平线
  /// [TextBaseline.alphabetic ]以标准的字母顺序为基线
  final TextBaseline? textBaseline;

  /// 文本的高度 主要用于[TextSpan] 来设置不同的高度
  final double? height;

  /// text的前景色，与 [color] 不能同时设置
  final Paint? foreground;

  /// [text]的背景色
  final Paint? background;

  /// [text]的划线
  /// [TextDecoration.none] 没有 默认
  /// [TextDecoration.underline] 下划线
  /// [TextDecoration.overline] 上划线
  /// [TextDecoration.lineThrough] 中间的线（删除线）
  final TextDecoration? decoration;

  /// [decoration]划线的颜色
  final Color? decorationColor;

  /// [decoration]划线的样式
  /// [TextDecorationStyle.solid]实线
  /// [TextDecorationStyle.double] 画两条线
  /// [TextDecorationStyle.dotted] 点线（一个点一个点的）
  /// [TextDecorationStyle.dashed] 虚线（一个长方形一个长方形的线）
  /// [TextDecorationStyle.wavy] 正玄曲线
  final TextDecorationStyle? decorationStyle;
  final double? decorationThickness;

  /// 只在调试的使用
  final String? debugLabel;

  /// 将在[text]下方绘制的阴影列表
  final List<ui.Shadow>? shadows;
  final List<ui.FontFeature>? fontFeatures;

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle? effectiveTextStyle = style;
    if (style == null || style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(style);
    }
    effectiveTextStyle = effectiveTextStyle!
        .merge(BTextStyle(
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
            package: package))
        .merge(style);
    return RText(
        text: text,
        style: effectiveTextStyle,
        textAlign: textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap ?? defaultTextStyle.softWrap,
        overflow: overflow ??
            effectiveTextStyle.overflow ??
            defaultTextStyle.overflow,
        textScaleFactor:
            textScaleFactor ?? MediaQuery.textScaleFactorOf(context),
        maxLines: maxLines ?? defaultTextStyle.maxLines,
        strutStyle: strutStyle,
        textWidthBasis: textWidthBasis ?? defaultTextStyle.textWidthBasis,
        textHeightBehavior: textHeightBehavior ??
            defaultTextStyle.textHeightBehavior ??
            DefaultTextHeightBehavior.of(context),
        semanticsLabel: semanticsLabel,
        recognizer: recognizer);
  }
}

class BTextStyle extends TextStyle {
  const BTextStyle({
    /// 默认样式会继承层级最为接近的 DefaultTextStyle，为true 表示继承，false 表示完全重写
    bool? inherit,

    /// 字体颜色，注意： 如果有特殊的foreground，此值必须是null
    Color? color,
    Color? backgroundColor,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,

    /// Locale，当相同的Unicode字符可以根据不同的地区以不同的方式呈现时，用于选择字体
    Locale? locale,

    /// 字体大小 默认的是 14
    double? fontSize,

    /// 字体的粗细程度 FontWeight.w100 -- FontWeight.w900 . 默认是FontWeight.w400，
    FontWeight? fontWeight,

    /// [FontStyle.normal]正常 [FontStyle.italic]斜体
    FontStyle? fontStyle,

    /// 单个字母或者汉字的距离，默认是1.0，负数可以拉近距离
    double? letterSpacing,

    /// 单词之间添加的空间间隔，负数可以拉近距离
    double? wordSpacing,

    /// [TextBaseline.ideographic]用来对齐表意文字的水平线
    /// [TextBaseline.alphabetic ]以标准的字母顺序为基线
    TextBaseline? textBaseline,

    /// 文本的高度 主要用于[TextSpan] 来设置不同的高度
    double? height,

    /// text的前景色，与 [color] 不能同时设置
    Paint? foreground,

    /// [text]的背景色
    Paint? background,

    /// [text]的划线
    /// [TextDecoration.none] 没有 默认
    /// [TextDecoration.underline] 下划线
    /// [TextDecoration.overline] 上划线
    /// [TextDecoration.lineThrough] 中间的线（删除线）
    TextDecoration? decoration,

    /// [decoration]划线的颜色
    Color? decorationColor,

    /// [decoration]划线的样式
    /// [TextDecorationStyle.solid]实线
    /// [TextDecorationStyle.double] 画两条线
    /// [TextDecorationStyle.dotted] 点线（一个点一个点的）
    /// [TextDecorationStyle.dashed] 虚线（一个长方形一个长方形的线）
    /// [TextDecorationStyle.wavy] 正玄曲线
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,

    /// 只在调试的使用
    String? debugLabel,

    /// 将在[text]下方绘制的阴影列表
    List<ui.Shadow>? shadows,
    List<ui.FontFeature>? fontFeatures,
  }) : super(
            inherit: inherit ?? true,
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
