import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// InputDecoration 扩展，提供一键移除所有边框的 [noneBorder]。
extension FlInputDecorationExtension on InputDecoration {
  /// 返回各状态下边框均为 InputBorder.none 的装饰。
  InputDecoration get noneBorder => copyWith(
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
  );
}

/// 边框类型：四周外框、仅下划线、无边框。
enum FlBorderType {
  /// 四周外框
  outline,

  /// 仅下划线
  underline,

  /// 无边框
  none;

  /// 转换为 [Border]，[borderSide] 为空或类型为 none 时返回 null。
  Border? toBorder([BorderSide? borderSide]) {
    if (borderSide == null) return null;
    switch (this) {
      case FlBorderType.outline:
        return Border.fromBorderSide(borderSide);
      case FlBorderType.underline:
        return Border(bottom: borderSide);
      case FlBorderType.none:
        return null;
    }
  }

  /// 转换为 [InputBorder]，默认 4.0 圆角与 4.0 间距。
  InputBorder toInputBorder({
    BorderSide borderSide = const BorderSide(),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    double gapPadding = 4.0,
  }) {
    switch (this) {
      case FlBorderType.outline:
        return OutlineInputBorder(gapPadding: gapPadding, borderRadius: borderRadius, borderSide: borderSide);
      case FlBorderType.underline:
        borderRadius = const BorderRadius.only(topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0));
        return UnderlineInputBorder(borderRadius: borderRadius, borderSide: borderSide);
      case FlBorderType.none:
        return InputBorder.none;
    }
  }
}

/// 文本输入限制类型，内置常用的字符白名单正则与对应键盘类型。
enum FlTextInputLimitFormatter {
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
  negative('[-0-9.]');

  const FlTextInputLimitFormatter(this.regExp);

  /// 允许输入的字符白名单正则，空字符串表示不限制。
  final String regExp;

  /// FlTextInputLimitFormatter 转换为  `List<TextInputFormatter>`
  List<TextInputFormatter> toTextInputFormatter() {
    if (this == FlTextInputLimitFormatter.text) return [];
    final RegExp regExp = RegExp(this.regExp);
    return [FilteringTextInputFormatter.allow(regExp)];
  }

  /// FlTextInputLimitFormatter 转换为 TextInputType
  TextInputType toKeyboardType() {
    switch (this) {
      case FlTextInputLimitFormatter.lettersNumbers:
        return TextInputType.name;
      case FlTextInputLimitFormatter.password:
        return TextInputType.visiblePassword;
      case FlTextInputLimitFormatter.number:
        return TextInputType.number;
      case FlTextInputLimitFormatter.text:
        return TextInputType.text;
      case FlTextInputLimitFormatter.decimal:
        return const TextInputType.numberWithOptions(decimal: true);
      case FlTextInputLimitFormatter.letter:
        return TextInputType.name;
      case FlTextInputLimitFormatter.chinese:
        return TextInputType.text;
      case FlTextInputLimitFormatter.email:
        return TextInputType.emailAddress;
      case FlTextInputLimitFormatter.phone:
        return TextInputType.phone;
      case FlTextInputLimitFormatter.idCard:
        return TextInputType.name;
      case FlTextInputLimitFormatter.positive:
        return const TextInputType.numberWithOptions(decimal: true, signed: true);
      case FlTextInputLimitFormatter.negative:
        return const TextInputType.numberWithOptions(decimal: true, signed: true);
    }
  }
}

/// 数字输入的精确控制。
class FlNumberLimitFormatter extends TextInputFormatter {
  FlNumberLimitFormatter(this.numberLength, this.decimalLength);

  /// 允许的最大小数位数，0 表示不允许输入小数。
  final int decimalLength;

  /// 允许的最大整数位数。
  final int numberLength;

  /// 校验只允许数字和小数点的正则。
  RegExp exp = RegExp('^${FlTextInputLimitFormatter.decimal.regExp}+\$');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
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
      if (newValue.text.indexOf(pointer) != newValue.text.lastIndexOf(pointer)) {
        return oldValue;
      }

      final String input = newValue.text;
      final int index = input.indexOf(pointer);

      /// 以点开头
      if (index == 0) return oldValue;

      /// 小数点前位数
      final int lengthBeforePointer = input.substring(0, index).length;

      /// 整数部分大于约定长度
      if (lengthBeforePointer > numberLength) return oldValue;

      /// 小数点后位数
      final int lengthAfterPointer = input.substring(index, input.length).length - 1;

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
