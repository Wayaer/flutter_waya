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
///     设置键盘上enter键的显示内容
///     textInputAction: TextInputAction.search, /// 搜索
///     textInputAction: TextInputAction.none,/// 默认回车符号
///     textInputAction: TextInputAction.done,/// 安卓显示 回车符号
///     textInputAction: TextInputAction.go,/// 开始
///     textInputAction: TextInputAction.next,/// 下一步
///     textInputAction: TextInputAction.send,/// 发送
///     textInputAction: TextInputAction.continueAction,/// android  不支持
///     textInputAction: TextInputAction.emergencyCall,/// android  不支持
///     textInputAction: TextInputAction.newline,/// 安卓显示 回车符号
///     textInputAction: TextInputAction.route,/// android  不支持
///     textInputAction: TextInputAction.join,/// android  不支持
///     textInputAction: TextInputAction.previous,/// 安卓显示 回车符号
///     textInputAction: TextInputAction.unspecified,/// 安卓显示 回车符号
/// final TextInputAction? textInputAction,
///
///   输入时键盘的英文都是大写
///   textCapitalization: TextCapitalization.characters,
///   键盘英文默认显示小写
///   textCapitalization:  TextCapitalization.none,
///   在输入每个句子的第一个字母时，键盘大写形式，输入后续字母时键盘小写形式
///   textCapitalization:  TextCapitalization.sentences,
///   在输入每个单词的第一个字母时，键盘大写形式，输入其他字母时键盘小写形式
///   textCapitalization: TextCapitalization.words,
/// final TextCapitalization textCapitalization;
///
/// 自定义数字显示 指定maxLength后 右下角会出现字数，flutter有默认实现  可以通过这个自定义
/// final InputCounterWidgetBuilder? buildCounter;

enum BorderType { outline, underline, none }

enum TextInputLimitFormatter {
  /// 字母和数字
  lettersNumbers,

  /// 密码 字母和数字和.
  password,

  /// 整数
  number,

  /// 文本
  text,

  /// 小数
  decimal,

  /// 字母
  letter,

  /// 中文
  chinese,

  /// 邮箱
  email,

  /// 电话号码
  phone,

  /// 身份证
  idCard,

  /// 正数
  positive,

  /// 负数
  negative,
}

enum AccessoryMode {
  /// 编辑时显示
  editing,

  /// [TextField] 内部的 [InputDecoration]
  /// 在 [TextField] 内部
  inner,

  /// 在 [WidgetDecorator] 内部
  /// 在 [TextField] 外部
  outer,

  /// 在 [WidgetDecorator] 外部  最外面
  outermost,
}

class AccessoryEntry {
  const AccessoryEntry({required this.mode, required this.widget});

  /// 显示的位置
  final AccessoryMode mode;

  /// 要显示的 组件
  final Widget widget;
}

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
}

class WidgetDecoratorStyle {
  const WidgetDecoratorStyle({
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
    List<TextInputFormatter> inputFormatters, InputDecoration? decoration);

class ExtendedTextField extends StatelessWidget {
  const ExtendedTextField({
    Key? key,
    this.decorator,
    this.inputLimitFormatter = TextInputLimitFormatter.text,
    this.decoration,
    this.hideCounter = true,
    this.suffixes = const [],
    this.suffixInnerConstraints,
    this.prefixes = const [],
    this.prefixInnerConstraints,
    this.contentPadding = EdgeInsets.zero,
    required this.builder,
  }) : super(key: key);

  /// 文本限制输入类型
  final TextInputLimitFormatter inputLimitFormatter;

  /// ***** [TextField] Builder *****
  final ExtendedTextFieldBuilder builder;

  /// ***** [WidgetDecorator] *****
  final WidgetDecoratorStyle? decorator;

  /// ***** [InputDecoration] *****
  final InputDecoration? decoration;
  final EdgeInsetsGeometry? contentPadding;
  final bool hideCounter;

  /// 前缀
  final List<AccessoryEntry> suffixes;
  final BoxConstraints? suffixInnerConstraints;

  /// 后缀
  final List<AccessoryEntry> prefixes;
  final BoxConstraints? prefixInnerConstraints;

  /// InputBorderStyle to InputBorder
  static InputBorder toInputBorder(InputBorderStyle style) {
    final borderSide = BorderSide(
        color: style.color,
        width: style.width,
        style: style.style,
        strokeAlign: style.strokeAlign);
    switch (style.borderType) {
      case BorderType.outline:
        return OutlineInputBorder(
            gapPadding: style.gapPadding,
            borderRadius: style.radius,
            borderSide: borderSide);
      case BorderType.underline:
        return UnderlineInputBorder(
            borderRadius: style.radius, borderSide: borderSide);
      case BorderType.none:
        return InputBorder.none;
    }
  }

  /// TextInputLimitFormatter 转换为  List<TextInputFormatter>
  static List<TextInputFormatter> limitFormatterToTextInputFormatter(
      TextInputLimitFormatter textInputLimitFormatter) {
    if (textInputLimitFormatter == TextInputLimitFormatter.text) return [];
    const Map<TextInputLimitFormatter, String> regExpMap = ConstConstant.regExp;
    final RegExp regExp = RegExp(regExpMap[textInputLimitFormatter]!);
    return [FilteringTextInputFormatter.allow(regExp)];
  }

  /// TextInputLimitFormatter 转换为 TextInputType
  static TextInputType limitFormatterToKeyboardType(
      TextInputLimitFormatter inputLimitFormatter) {
    switch (inputLimitFormatter) {
      case TextInputLimitFormatter.lettersNumbers:
        return TextInputType.name;
      case TextInputLimitFormatter.password:
        return TextInputType.visiblePassword;
      case TextInputLimitFormatter.number:
        return TextInputType.number;
      case TextInputLimitFormatter.text:
        return TextInputType.text;
      case TextInputLimitFormatter.decimal:
        return const TextInputType.numberWithOptions(decimal: true);
      case TextInputLimitFormatter.letter:
        return TextInputType.name;
      case TextInputLimitFormatter.chinese:
        return TextInputType.text;
      case TextInputLimitFormatter.email:
        return TextInputType.emailAddress;
      case TextInputLimitFormatter.phone:
        return TextInputType.phone;
      case TextInputLimitFormatter.idCard:
        return TextInputType.name;
      case TextInputLimitFormatter.positive:
        return const TextInputType.numberWithOptions(
            decimal: true, signed: true);
      case TextInputLimitFormatter.negative:
        return const TextInputType.numberWithOptions(
            decimal: true, signed: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget current = builder.call(
        limitFormatterToKeyboardType(inputLimitFormatter),
        limitFormatterToTextInputFormatter(inputLimitFormatter),
        buildDecoration);
    return buildWidgetDecorator(current);
  }

  /// TextField 自带装饰器
  InputDecoration? get buildDecoration {
    InputDecoration? decoration = this.decoration;
    final suffix =
        buildSuffix(AccessoryMode.editing, extra: decoration?.suffix);
    final innerSuffix =
        buildSuffix(AccessoryMode.inner, extra: decoration?.suffixIcon);
    final prefix =
        buildPrefix(AccessoryMode.editing, extra: decoration?.prefix);
    final innerPrefix =
        buildPrefix(AccessoryMode.inner, extra: decoration?.prefixIcon);
    if (hideCounter ||
        suffix != null ||
        innerSuffix != null ||
        prefix != null ||
        innerPrefix != null) {
      decoration = decoration?.copyWith(
          contentPadding: contentPadding,
          counterText: hideCounter ? '' : decoration.counterText,
          suffix: suffix,
          suffixIcon: innerSuffix,
          suffixIconConstraints:
              suffixInnerConstraints ?? decoration.suffixIconConstraints,
          prefix: prefix,
          prefixIcon: innerPrefix,
          prefixIconConstraints:
              prefixInnerConstraints ?? decoration.prefixIconConstraints);
    }
    return decoration;
  }

  /// TextField 外部装饰器
  Widget buildWidgetDecorator(Widget current) {
    final decorator = this.decorator;
    final suffix = buildSuffix(AccessoryMode.outer);
    final prefix = buildPrefix(AccessoryMode.outer);
    final extraSuffix = buildSuffix(AccessoryMode.outermost);
    final extraPrefix = buildPrefix(AccessoryMode.outermost);
    if (decorator != null ||
        suffix != null ||
        prefix != null ||
        extraSuffix != null ||
        extraPrefix != null) {
      return WidgetDecorator(
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
  Widget? buildSuffix(AccessoryMode mode, {Widget? extra}) {
    final children = suffixes.where((element) => element.mode == mode).toList();
    if (extra != null) children.add(AccessoryEntry(widget: extra, mode: mode));
    if (children.isEmpty) return null;
    if (children.length == 1) return children.first.widget;
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: children.builder((entry) => entry.widget));
  }

  /// 前缀
  Widget? buildPrefix(AccessoryMode mode, {Widget? extra}) {
    final children = prefixes.where((element) => element.mode == mode).toList();
    if (extra != null) {
      children.insert(0, AccessoryEntry(widget: extra, mode: mode));
    }
    if (children.isEmpty) return null;
    if (children.length == 1) return children.first.widget;
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: children.builder((entry) => entry.widget));
  }
}

/// [Widget] 装饰器
class WidgetDecorator extends StatelessWidget {
  const WidgetDecorator({
    super.key,
    required this.child,
    this.header,
    this.footer,
    this.extraPrefix,
    this.extraSuffix,
    this.prefix,
    this.suffix,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.borderType = BorderType.none,
    this.fillColor,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
    this.margin,
    this.padding,
    this.borderSide = const BorderSide(),
  });

  final Widget child;

  /// [child] 头部和尾部挂件
  final Widget? header;
  final Widget? footer;

  /// [child] 左右两遍的挂件 在[Border] 外部
  final Widget? extraPrefix;
  final Widget? extraSuffix;

  /// [child] 左右两遍的挂件 在[Border] 外部
  final Widget? prefix;
  final Widget? suffix;

  /// 仅作用于 [child]
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  /// [child] 与 [extraPrefix]、[extraSuffix] 对齐方式
  final CrossAxisAlignment crossAxisAlignment;

  /// [child] 边框类型
  final BorderType borderType;

  /// [child] 边框样式
  final BorderSide borderSide;

  /// [child] 填充色
  final Color? fillColor;

  /// [child] 圆角
  final BorderRadius? borderRadius;

  /// [child] 阴影
  final List<BoxShadow>? boxShadow;

  /// [child] 渐变色
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    Widget current = buildCurrent;
    if (extraPrefix != null || extraSuffix != null) {
      final List<Widget> row = <Widget>[];
      if (extraPrefix != null) row.add(extraPrefix!);
      row.add(Expanded(child: current));
      if (extraSuffix != null) row.add(extraSuffix!);
      current = Row(crossAxisAlignment: crossAxisAlignment, children: row);
    }

    if (header != null || footer != null) {
      final List<Widget> children = <Widget>[];
      if (header != null) children.add(header!);
      children.add(current);
      if (footer != null) children.add(footer!);
      current = Column(mainAxisSize: MainAxisSize.min, children: children);
    }
    return current;
  }

  Widget get buildCurrent {
    Widget current = child;
    Border? border;
    switch (borderType) {
      case BorderType.outline:
        border = Border.fromBorderSide(borderSide);
        break;
      case BorderType.underline:
        assert(borderRadius == null,
            'The current borderType, borderRadius must be null');
        border = Border(bottom: borderSide);
        break;
      case BorderType.none:
        break;
    }

    Decoration? decoration;
    if (border != null ||
        fillColor != null ||
        borderRadius != null ||
        boxShadow != null ||
        gradient != null) {
      decoration = BoxDecoration(
          border: border,
          color: fillColor,
          borderRadius: borderRadius,
          gradient: gradient,
          boxShadow: boxShadow);
    }
    final List<Widget> children = [current.expandedNull];
    if (prefix != null) children.insert(0, prefix!);
    if (suffix != null) children.add(suffix!);
    current = Universal(
        decoration: decoration,
        margin: margin,
        padding: padding,
        direction: Axis.horizontal,
        child: children.length > 1 ? null : current,
        children: children.length > 1 ? children : null);
    return current;
  }
}

/// 数字输入的精确控制
class NumberLimitFormatter extends TextInputFormatter {
  NumberLimitFormatter(this.numberLength, this.decimalLength);

  final int decimalLength;
  final int numberLength;

  RegExp exp = RegExp(ConstConstant.regExp[TextInputLimitFormatter.decimal]!);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    const String pointer = '.';

    /// 输入完全删除
    if (newValue.text.isEmpty) return const TextEditingValue();

    /// 只允许输入数字和小数点
    if (!exp.hasMatch(newValue.text)) return oldValue;

    /// 包含小数点的情况
    if (newValue.text.contains(pointer)) {
      /// 精度为0，即不含小数
      if (decimalLength == 0) return oldValue;

      /// 包含多个小数
      if (newValue.text.indexOf(pointer) !=
          newValue.text.lastIndexOf(pointer)) {
        return oldValue;
      }

      final String input = newValue.text;
      final int index = input.indexOf(pointer);

      /// 小数点前位数
      final int lengthBeforePointer = input.substring(0, index).length;

      /// 整数部分大于约定长度
      if (lengthBeforePointer > numberLength) return oldValue;

      /// 小数点后位数
      final int lengthAfterPointer =
          input.substring(index, input.length).length - 1;

      /// 小数位大于精度
      if (lengthAfterPointer > decimalLength) return oldValue;
    } else if (

        /// 以点开头
        newValue.text.startsWith(pointer) ||

            /// 如果第1位为0，并且长度大于1，排除00,01-09所有非法输入
            (newValue.text.startsWith('0') && newValue.text.length > 1) ||

            /// 如果整数长度超过约定长度
            newValue.text.length > numberLength) {
      return oldValue;
    }
    return newValue;
  }
}
