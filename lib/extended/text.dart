import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// [RichText] 魔改版
/// 建议使用 [BText.rich],动态配置字体颜色
class RText extends RichText {
  RText({
    super.key,

    /// 文本
    required List<String> texts,

    /// 所有[texts]默认样式
    TextStyle? style,

    /// [texts]内样式
    List<TextStyle?> styles = const [],

    /// [texts]内手势
    List<GestureRecognizer?> recognizers = const [],

    /// [texts]内语义 - 语义描述标签，相当于此text的别名
    List<String?> semanticsLabels = const [],

    /// 新增属性
    List<MouseCursor?> mouseCursors = const [],
    List<PointerEnterEventListener?> onEnters = const [],
    List<PointerExitEventListener?> onExits = const [],
    List<Locale?> locales = const [],
    List<bool?> spellOuts = const [],

    /// StrutStyle,影响Text在垂直方向上的布局
    super.strutStyle,

    /// TextAlign,内容对齐方式
    super.textAlign = TextAlign.center,

    /// TextDirection,内容的走向方式
    super.textDirection,

    /// Locale，当相同的Unicode字符可以根据不同的地区以不同的方式呈现时，用于选择字体
    super.locale,

    /// bool 文本是否应在软换行时断行
    super.softWrap = true,

    /// TextOverflow，内容溢出时的处理方式
    super.overflow = TextOverflow.clip,

    /// double 设置文字的放大缩小，例如，fontSize=10，this.textScaleFactor=2.0，最终得到的文字大小为10*2.0
    super.textScaler = TextScaler.noScaling,

    /// int 设置文字的最大展示行数
    super.maxLines,

    /// TextWidthBasis 测量一行或多行文本宽度
    super.textWidthBasis = TextWidthBasis.parent,
    super.textHeightBehavior,
    super.selectionRegistrar,
    super.selectionColor,
  })  : assert(texts.isNotEmpty),
        super(
            text: buildTextSpan(buildTextSpans(
                texts: texts,
                style: style,
                styles: styles,
                semanticsLabels: semanticsLabels,
                recognizers: recognizers,
                mouseCursors: mouseCursors,
                onEnters: onEnters,
                onExits: onExits,
                locales: locales,
                spellOuts: spellOuts)));

  static TextSpan buildTextSpan(List<TextSpan> textSpans) => TextSpan(
      text: textSpans.first.text,
      style: textSpans.first.style,
      semanticsLabel: textSpans.first.semanticsLabel,
      recognizer: textSpans.first.recognizer,
      children:
          textSpans.length > 1 ? textSpans.sublist(1, textSpans.length) : null);

  static List<TextSpan> buildTextSpans({
    TextStyle? style,
    required List<String> texts,
    required List<TextStyle?> styles,
    required List<GestureRecognizer?> recognizers,
    required List<String?> semanticsLabels,
    required List<MouseCursor?> mouseCursors,
    required List<PointerEnterEventListener?> onEnters,
    required List<PointerExitEventListener?> onExits,
    required List<Locale?> locales,
    required List<bool?> spellOuts,
  }) =>
      texts.builderEntry((MapEntry<int, String> entry) => TextSpan(
          text: entry.value,
          semanticsLabel: semanticsLabels.isEmpty ||
                  (semanticsLabels.length - 1) < entry.key
              ? null
              : semanticsLabels[entry.key],
          mouseCursor:
              mouseCursors.isEmpty || (mouseCursors.length - 1) < entry.key
                  ? null
                  : mouseCursors[entry.key],
          onEnter: onEnters.isEmpty || (onEnters.length - 1) < entry.key
              ? null
              : onEnters[entry.key],
          onExit: onExits.isEmpty || (onExits.length - 1) < entry.key
              ? null
              : onExits[entry.key],
          spellOut: spellOuts.isEmpty || (spellOuts.length - 1) < entry.key
              ? null
              : spellOuts[entry.key],
          locale: locales.isEmpty || (locales.length - 1) < entry.key
              ? null
              : locales[entry.key],
          recognizer:
              recognizers.isEmpty || (recognizers.length - 1) < entry.key
                  ? null
                  : recognizers[entry.key],
          style: styles.isEmpty || (styles.length - 1) < entry.key
              ? const BTextStyle().merge(style)
              : const BTextStyle().merge(style).merge(styles[entry.key])));

  static convertTextStyle(BuildContext context, TextStyle style) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle effectiveTextStyle = style;
    if (style.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(style);
    }
    return effectiveTextStyle;
  }
}

class BText extends StatelessWidget {
  const BText(
    this.text, {
    super.key,
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
    this.inherit = true,
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
    this.decoration = TextDecoration.none,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.debugLabel,
    this.shadows,
    this.fontFeatures,
    this.textHeightBehavior,
    this.selectionColor,
    this.textScaler = TextScaler.noScaling,
  })  : assert(color == null || foreground == null, _kColorForegroundWarning),
        assert(backgroundColor == null || background == null,
            _kColorBackgroundWarning),
        isRich = false,
        texts = const [],
        styles = const [],
        recognizers = const [],
        semanticsLabels = const [];

  /// 与 [RText] 一致，仅增加 主题适配
  const BText.rich({
    super.key,
    required this.texts,
    this.style,
    this.styles = const [],
    this.recognizers = const [],
    this.semanticsLabels = const [],
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.inherit = true,
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
    this.decoration = TextDecoration.none,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.debugLabel,
    this.shadows,
    this.fontFeatures,
    this.selectionColor,
    this.textScaler = TextScaler.noScaling,
  })  : isRich = true,
        text = '',
        recognizer = null,
        semanticsLabel = null;

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
  final TextHeightBehavior? textHeightBehavior;

  /// 使劲此参数 以下单独字体样式无效
  final TextStyle? style;

  /// TextStyle 以下是字体样式
  /// 默认样式会继承层级最为接近的 DefaultTextStyle，为true 表示继承，false 表示完全重写
  final bool inherit;

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
  final TextDecoration decoration;

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
  final List<Shadow>? shadows;
  final List<FontFeature>? fontFeatures;

  /// The color to use when painting the selection.
  final Color? selectionColor;

  /// 排在第一个[text]后面
  final List<String> texts;

  /// [texts]内样式
  final List<TextStyle> styles;

  /// [texts]内手势
  final List<GestureRecognizer?> recognizers;

  /// [texts]内语义 - 语义描述标签，相当于此text的别名
  final List<String> semanticsLabels;

  final bool isRich;

  final TextScaler textScaler;

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle effectiveTextStyle = BTextStyle(
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
        .merge(style);
    if (inherit && (style?.inherit ?? true)) {
      effectiveTextStyle = defaultTextStyle.style.merge(effectiveTextStyle);
    }
    if (MediaQuery.boldTextOf(context)) {
      effectiveTextStyle = effectiveTextStyle
          .merge(const TextStyle(fontWeight: FontWeight.bold));
    }
    final SelectionRegistrar? registrar = SelectionContainer.maybeOf(context);
    Widget result = RText(
        texts: isRich ? texts : [text],
        style: effectiveTextStyle,
        styles: isRich ? styles : [effectiveTextStyle],
        recognizers: isRich ? recognizers : [recognizer],
        semanticsLabels: isRich ? semanticsLabels : [semanticsLabel],
        textAlign: textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap ?? defaultTextStyle.softWrap,
        overflow: overflow ??
            effectiveTextStyle.overflow ??
            defaultTextStyle.overflow,
        textScaler: textScaler,
        maxLines: maxLines ?? defaultTextStyle.maxLines,
        strutStyle: strutStyle,
        textWidthBasis: textWidthBasis ?? defaultTextStyle.textWidthBasis,
        textHeightBehavior: textHeightBehavior ??
            defaultTextStyle.textHeightBehavior ??
            DefaultTextHeightBehavior.maybeOf(context),
        selectionRegistrar: registrar,
        selectionColor: selectionColor ??
            DefaultSelectionStyle.of(context).selectionColor ??
            DefaultSelectionStyle.defaultColor);
    if (registrar != null) {
      result = MouseRegion(cursor: SystemMouseCursors.text, child: result);
    }
    if (semanticsLabel != null) {
      result = Semantics(
          textDirection: textDirection,
          label: semanticsLabel,
          child: ExcludeSemantics(child: result));
    }
    return result;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('data', text, showName: false));

    style?.debugFillProperties(properties);
    properties.add(
        EnumProperty<TextAlign>('textAlign', textAlign, defaultValue: null));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty<Locale>('locale', locale, defaultValue: null));
    properties.add(FlagProperty('softWrap',
        value: softWrap,
        ifTrue: 'wrapping at box width',
        ifFalse: 'no wrapping except at line break characters',
        showName: true));
    properties.add(
        EnumProperty<TextOverflow>('overflow', overflow, defaultValue: null));
    properties.add(
        DoubleProperty('textScaleFactor', textScaleFactor, defaultValue: null));
    properties.add(IntProperty('maxLines', maxLines, defaultValue: null));
    properties.add(EnumProperty<TextWidthBasis>(
        'textWidthBasis', textWidthBasis,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextHeightBehavior>(
        'textHeightBehavior', textHeightBehavior,
        defaultValue: null));
    if (semanticsLabel != null) {
      properties.add(StringProperty('semanticsLabel', semanticsLabel));
    }
  }
}

class BTextStyle extends TextStyle {
  const BTextStyle(
      {
      /// 默认样式会继承层级最为接近的 DefaultTextStyle，为true 表示继承，false 表示完全重写
      super.inherit = true,

      /// 字体颜色，注意： 如果有特殊的foreground，此值必须是null
      super.color,
      super.backgroundColor,
      super.fontFamily,
      super.fontFamilyFallback,
      super.package,

      /// Locale，当相同的Unicode字符可以根据不同的地区以不同的方式呈现时，用于选择字体
      super.locale,

      /// 字体大小 默认的是 14
      super.fontSize,

      /// 字体的粗细程度 FontWeight.w100 -- FontWeight.w900 . 默认是FontWeight.w400，
      super.fontWeight,

      /// [FontStyle.normal]正常 [FontStyle.italic]斜体
      super.fontStyle,

      /// 单个字母或者汉字的距离，默认是1.0，负数可以拉近距离
      super.letterSpacing,

      /// 单词之间添加的空间间隔，负数可以拉近距离
      super.wordSpacing,

      /// [TextBaseline.ideographic]用来对齐表意文字的水平线
      /// [TextBaseline.alphabetic ]以标准的字母顺序为基线
      super.textBaseline,

      /// 文本的高度 主要用于[TextSpan] 来设置不同的高度
      super.height,

      /// text的前景色，与 [color] 不能同时设置
      super.foreground,

      /// [text]的背景色
      super.background,

      /// [text]的划线
      /// [TextDecoration.none] 没有 默认
      /// [TextDecoration.underline] 下划线
      /// [TextDecoration.overline] 上划线
      /// [TextDecoration.lineThrough] 中间的线（删除线）
      super.decoration = TextDecoration.none,

      /// [decoration]划线的颜色
      super.decorationColor,

      /// [decoration]划线的样式
      /// [TextDecorationStyle.solid]实线
      /// [TextDecorationStyle.double] 画两条线
      /// [TextDecorationStyle.dotted] 点线（一个点一个点的）
      /// [TextDecorationStyle.dashed] 虚线（一个长方形一个长方形的线）
      /// [TextDecorationStyle.wavy] 正玄曲线
      super.decorationStyle,
      super.decorationThickness,

      /// 只在调试的使用
      super.debugLabel,

      /// 将在[text]下方绘制的阴影列表
      super.shadows,
      super.fontFeatures,
      super.fontVariations,
      super.leadingDistribution,
      super.overflow});
}

const String _kColorForegroundWarning =
    'Cannot provide both a color and a foreground\n'
    'The color argument is just a shorthand for "foreground: new Paint()..color = color".';

const String _kColorBackgroundWarning =
    'Cannot provide both a backgroundColor and a background\n'
    'The backgroundColor argument is just a shorthand for "background: new Paint()..color = color".';
