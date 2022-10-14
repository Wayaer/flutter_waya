import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 按回车时调用 先调用此方法  然后调用onSubmitted方法
/// final VoidCallback? onEditingComplete;
/// final ValueCallback<String>? onSubmitted;
///
/// 键盘颜色  Brightness.dark 深色模式
/// final Brightness keyboardAppearance;
///
/// 长按输入的文字时，true显示系统的粘贴板  false不显示
/// final bool enableInteractiveSelection;
/// 设置键盘上enter键的显示内容
/// textInputAction: TextInputAction.search, /// 搜索
/// textInputAction: TextInputAction.none,/// 默认回车符号
/// textInputAction: TextInputAction.done,/// 安卓显示 回车符号
/// textInputAction: TextInputAction.go,/// 开始
/// textInputAction: TextInputAction.next,/// 下一步
/// textInputAction: TextInputAction.send,/// 发送
/// textInputAction: TextInputAction.continueAction,/// android  不支持
/// textInputAction: TextInputAction.emergencyCall,/// android  不支持
/// textInputAction: TextInputAction.newline,/// 安卓显示 回车符号
/// textInputAction: TextInputAction.route,/// android  不支持
/// textInputAction: TextInputAction.join,/// android  不支持
/// textInputAction: TextInputAction.previous,/// 安卓显示 回车符号
/// textInputAction: TextInputAction.unspecified,/// 安卓显示 回车符号
/// final TextInputAction? textInputAction,
///
/// 输入时键盘的英文都是大写
/// textCapitalization: TextCapitalization.characters,
/// 键盘英文默认显示小写
/// textCapitalization:  TextCapitalization.none,
/// 在输入每个句子的第一个字母时，键盘大写形式，输入后续字母时键盘小写形式
/// textCapitalization:  TextCapitalization.sentences,
/// 在输入每个单词的第一个字母时，键盘大写形式，输入其他字母时键盘小写形式
/// textCapitalization: TextCapitalization.words,
/// final TextCapitalization textCapitalization;
///
/// 自定义数字显示 指定maxLength后 右下角会出现字数，flutter有默认实现  可以通过这个自定义
/// final InputCounterWidgetBuilder? buildCounter;

class InputBorderStyle {
  InputBorderStyle({
    this.borderType = BorderType.none,
    this.radius = BorderRadius.zero,
    this.color = const Color(0xFF000000),
    this.width = 1,
    this.gapPadding = 4,
    this.style = BorderStyle.solid,
    this.strokeAlign = StrokeAlign.inside,
  });

  /// 边框类型
  final BorderType borderType;

  /// 边框圆角
  final BorderRadius radius;

  /// 颜色
  final Color color;

  /// 边框宽度
  final double width;

  /// [borderType] = [BorderType.outline]有效
  final double gapPadding;

  /// 样式
  final BorderStyle style;

  /// strokeAlign
  final StrokeAlign strokeAlign;

  InputBorderStyle copyWith({
    BorderType? borderType,
    BorderRadius? radius,
    Color? color,
    double? width,
    double? gapPadding,
    BorderStyle? style,
    StrokeAlign? strokeAlign,
  }) =>
      InputBorderStyle(
          borderType: borderType ?? this.borderType,
          radius: radius ?? this.radius,
          color: color ?? this.color,
          width: width ?? this.width,
          gapPadding: gapPadding ?? this.gapPadding,
          style: style ?? this.style,
          strokeAlign: strokeAlign ?? this.strokeAlign);

  /// InputBorderStyle to InputBorder
  InputBorder toInputBorder() {
    final borderSide = BorderSide(
        color: color, width: width, style: style, strokeAlign: strokeAlign);
    switch (borderType) {
      case BorderType.outline:
        return OutlineInputBorder(
            gapPadding: gapPadding,
            borderRadius: radius,
            borderSide: borderSide);
      case BorderType.underline:
        return UnderlineInputBorder(
            borderRadius: radius, borderSide: borderSide);
      case BorderType.none:
        return InputBorder.none;
    }
  }
}

class DecoratorBoxStyle {
  const DecoratorBoxStyle({
    this.borderType = BorderType.none,
    this.borderRadius = BorderRadius.zero,
    this.borderSide = const BorderSide(),
    this.header,
    this.footer,
    this.margin,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.fillColor,
    this.boxShadow,
    this.gradient,
  });

  /// 边框类型
  final BorderType borderType;

  /// 边框圆角
  final BorderRadius borderRadius;

  /// 边框样式
  final BorderSide borderSide;

  /// [TextField] 头部和尾部挂件
  final Widget? header;
  final Widget? footer;

  /// 仅作用于 [TextField]
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  /// [TextField] 与 [outer]、[outermost] 对齐方式
  final CrossAxisAlignment crossAxisAlignment;

  /// [TextField] 填充色
  final Color? fillColor;

  /// [TextField] 阴影
  final List<BoxShadow>? boxShadow;

  /// [TextField] 渐变色
  final Gradient? gradient;
}

typedef ExtendedTextFieldBuilder = Widget Function(TextInputType keyboardType,
    List<TextInputFormatter> inputFormatters, Widget? suffix, Widget? prefix);

class ExtendedTextField extends StatelessWidget {
  const ExtendedTextField({
    Key? key,
    this.decorator,
    this.inputLimitFormatter = TextInputLimitFormatter.text,
    this.suffixes = const [],
    this.prefixes = const [],
    required this.builder,
  }) : super(key: key);

  /// 文本限制输入类型
  final TextInputLimitFormatter inputLimitFormatter;

  /// ***** [TextField] Builder *****
  final ExtendedTextFieldBuilder builder;

  /// ***** [DecoratorBox] *****
  final DecoratorBoxStyle? decorator;

  /// 前缀
  final List<DecoratorEntry> suffixes;

  /// 后缀
  final List<DecoratorEntry> prefixes;

  @override
  Widget build(BuildContext context) {
    Widget current = builder.call(
        inputLimitFormatter.toKeyboardType(),
        inputLimitFormatter.toTextInputFormatter(),
        buildSuffix(DecoratorPositioned.inner),
        buildPrefix(DecoratorPositioned.inner));
    return buildDecoratorBox(current);
  }

  /// TextField 外部装饰器
  Widget buildDecoratorBox(Widget current) {
    final decorator = this.decorator;
    final suffix = buildSuffix(DecoratorPositioned.outer);
    final prefix = buildPrefix(DecoratorPositioned.outer);
    final extraSuffix = buildSuffix(DecoratorPositioned.outermost);
    final extraPrefix = buildPrefix(DecoratorPositioned.outermost);
    if (decorator != null ||
        suffix != null ||
        prefix != null ||
        extraSuffix != null ||
        extraPrefix != null) {
      return DecoratorBox(
          borderType: decorator?.borderType ?? BorderType.none,
          borderRadius: decorator?.borderRadius,
          borderSide: decorator?.borderSide ?? BorderSide.none,
          header: decorator?.header,
          footer: decorator?.footer,
          crossAxisAlignment:
              decorator?.crossAxisAlignment ?? CrossAxisAlignment.center,
          fillColor: decorator?.fillColor,
          boxShadow: decorator?.boxShadow,
          gradient: decorator?.gradient,
          margin: decorator?.margin,
          padding: decorator?.padding,
          suffix: suffix,
          prefix: prefix,
          extraSuffix: extraSuffix,
          extraPrefix: extraPrefix,
          child: current);
    }
    return current;
  }

  /// 后缀
  Widget? buildSuffix(DecoratorPositioned positioned) {
    final children =
        suffixes.where((element) => element.positioned == positioned).toList();
    if (children.isEmpty) return null;
    if (children.length == 1) return children.first.widget;
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: children.builder((entry) => entry.widget));
  }

  /// 前缀
  Widget? buildPrefix(DecoratorPositioned positioned) {
    final children =
        prefixes.where((element) => element.positioned == positioned).toList();
    if (children.isEmpty) return null;
    if (children.length == 1) return children.first.widget;
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: children.builder((entry) => entry.widget));
  }
}
