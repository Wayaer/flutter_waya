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

enum TextInputLimitFormatter {
  /// 字母和数字
  lettersNumbers('[a-zA-Z0-9]'),

  /// 密码 字母和数字和.
  password('[a-zA-Z0-9.]'),

  /// 整数
  number('[0-9]'),

  /// 文本
  text(''),

  /// 小数
  decimal('[0-9.]'),

  /// 字母
  letter('[a-zA-Z]'),

  /// 中文
  chinese('[\u4e00-\u9fa5]'),

  /// 邮箱
  email('[a-zA-Z0-9.@]'),

  /// 电话号码
  phone('[0-9-+]'),

  /// 身份证
  idCard('[0-9Xx]'),

  /// 正数
  positive('[+0-9.]'),

  /// 负数
  negative('[-0-9.]'),
  ;

  const TextInputLimitFormatter(this.regExp);

  final String regExp;

  /// TextInputLimitFormatter 转换为  List<TextInputFormatter>
  List<TextInputFormatter> toTextInputFormatter() {
    if (this == TextInputLimitFormatter.text) return [];
    final RegExp regExp = RegExp(this.regExp);
    return [FilteringTextInputFormatter.allow(regExp)];
  }

  /// TextInputLimitFormatter 转换为 TextInputType
  TextInputType toKeyboardType() {
    switch (this) {
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
}

typedef TextFieldWithDecoratedBuilder = Widget Function(FocusNode? focusNode);

/// [TextField] 带 [DecoratorBox]
class TextFieldWithDecoratorBox extends StatelessWidget {
  const TextFieldWithDecoratorBox({
    super.key,
    this.decoration = const FlBoxDecoration(
        // borderType: BorderType.outline,
        // borderSide: BorderSide(color: Colors.black),
        ),
    this.suffixes = const [],
    this.prefixes = const [],
    required this.builder,
    this.focusNode,
    this.focusBorderSide,
    this.header,
    this.footer,
    this.disposeFocusNode = false,
  });

  /// ***** [TextField] Builder *****
  final TextFieldWithDecoratedBuilder builder;

  /// ***** [FlBoxDecoration] *****
  final FlBoxDecoration decoration;

  /// 前缀
  final List<DecoratedPendant> suffixes;

  /// 后缀
  final List<DecoratedPendant> prefixes;

  /// 焦点管理
  final FocusNode? focusNode;

  /// 组件销毁自动调用 [dispose]
  final bool disposeFocusNode;

  /// 获得焦点时的边框样式
  final BorderSide? focusBorderSide;

  /// [TextField] 头部和尾部挂件
  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    Widget current = builder.call(focusNode);
    return buildDecoratorBox(current);
  }

  /// TextField 外部装饰器
  Widget buildDecoratorBox(Widget current) {
    if (focusNode != null) {
      return DecoratorBoxState(
          decoration: decoration,
          focusBorderSide: focusBorderSide,
          header: header,
          footer: footer,
          suffixes: suffixes,
          prefixes: prefixes,
          focusNode: focusNode!,
          disposeFocusNode: disposeFocusNode,
          child: current);
    }

    final suffix =
        buildDecoratedPendant(suffixes, DecoratedPendantPosition.inner);
    final prefix =
        buildDecoratedPendant(prefixes, DecoratedPendantPosition.inner);
    final extraSuffix =
        buildDecoratedPendant(suffixes, DecoratedPendantPosition.outer);
    final extraPrefix =
        buildDecoratedPendant(prefixes, DecoratedPendantPosition.outer);
    return DecoratorBox(
        decoration: decoration,
        // header: header,
        // footer: footer,
        suffix: suffix,
        prefix: prefix,
        extraSuffix: extraSuffix,
        extraPrefix: extraPrefix,
        child: current);
  }

  Widget? buildDecoratedPendant(
      List<DecoratedPendant> list, DecoratedPendantPosition positioned) {
    final children =
        list.where((element) => element.positioned == positioned).toList();
    if (children.isEmpty) return null;
    if (children.length == 1) return children.first.widget;
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: children.map((entry) => entry.widget).toList());
  }
}

/// 数字输入的精确控制
class NumberLimitFormatter extends TextInputFormatter {
  NumberLimitFormatter(this.numberLength, this.decimalLength);

  final int decimalLength;
  final int numberLength;

  RegExp exp = RegExp(TextInputLimitFormatter.decimal.regExp);

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
