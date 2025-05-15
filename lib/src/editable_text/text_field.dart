import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension ExtensionInputDecoration on InputDecoration {
  InputDecoration get copyWithNoneBorder => copyWith(
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none);
}

enum BorderType {
  /// outline
  outline,

  /// underline
  underline,

  /// none
  none,
  ;

  /// BorderType to Border
  Border? toBorder([BorderSide? borderSide]) {
    if (borderSide == null) return null;
    switch (this) {
      case BorderType.outline:
        return Border.fromBorderSide(borderSide);
      case BorderType.underline:
        return Border(bottom: borderSide);
      case BorderType.none:
        return null;
    }
  }

  /// BorderType to InputBorder
  InputBorder toInputBorder({
    BorderSide borderSide = const BorderSide(),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    double gapPadding = 4.0,
  }) {
    switch (this) {
      case BorderType.outline:
        return OutlineInputBorder(
            gapPadding: gapPadding,
            borderRadius: borderRadius,
            borderSide: borderSide);
      case BorderType.underline:
        borderRadius = const BorderRadius.only(
            topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0));
        return UnderlineInputBorder(
            borderRadius: borderRadius, borderSide: borderSide);
      case BorderType.none:
        return InputBorder.none;
    }
  }
}

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

  /// TextInputLimitFormatter 转换为  `List<TextInputFormatter>`
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
