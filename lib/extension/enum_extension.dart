import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

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

extension ExtensionTextInputLimitFormatter on TextInputLimitFormatter {
  String get value => allRegExp[this]!;

  Map<TextInputLimitFormatter, String> get allRegExp => {
        /// 字母和数字
        TextInputLimitFormatter.lettersNumbers: '[a-zA-Z0-9]',

        /// 密码 字母和数字和.
        TextInputLimitFormatter.password: '[a-zA-Z0-9.]',

        /// 整数
        TextInputLimitFormatter.number: '[0-9]',

        /// 文本
        TextInputLimitFormatter.text: '',

        /// 小数
        TextInputLimitFormatter.decimal: '[0-9.]',

        /// 字母
        TextInputLimitFormatter.letter: '[a-zA-Z]',

        /// 中文
        TextInputLimitFormatter.chinese: '[\u4e00-\u9fa5]',

        /// 邮箱
        TextInputLimitFormatter.email: '[a-zA-Z0-9.@]',

        /// 电话号码
        TextInputLimitFormatter.phone: '[0-9-+]',

        /// 身份证
        TextInputLimitFormatter.idCard: '[0-9Xx]',

        /// 正数
        TextInputLimitFormatter.positive: '[+0-9.]',

        /// 负数
        TextInputLimitFormatter.negative: '[-0-9.]',
      };

  /// TextInputLimitFormatter 转换为  List<TextInputFormatter>
  List<TextInputFormatter> toTextInputFormatter() {
    if (this == TextInputLimitFormatter.text) return [];
    final RegExp regExp = RegExp(allRegExp[this]!);
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

enum BorderType { outline, underline, none }

extension ExtensionBorderType on BorderType {
  /// BorderType to Border
  Border? value([BorderSide borderSide = const BorderSide()]) {
    switch (this) {
      case BorderType.outline:
        return Border.fromBorderSide(borderSide);
      case BorderType.underline:
        return Border(bottom: borderSide);
      case BorderType.none:
        return null;
    }
  }
}

extension ExtensionRoutePushStyle on RoutePushStyle {
  /// Builds the primary contents of the route.
  PageRoute<T> pageRoute<T>(
      {WidgetBuilder? builder,
      Widget? widget,
      bool maintainState = true,
      bool fullscreenDialog = false,
      String? title,
      RouteSettings? settings}) {
    assert(widget != null || builder != null);
    switch (this) {
      case RoutePushStyle.cupertino:
        return CupertinoPageRoute<T>(
            title: title,
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog,
            builder: builder ?? widget!.toWidgetBuilder);
      case RoutePushStyle.material:
        return MaterialPageRoute<T>(
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog,
            builder: builder ?? widget!.toWidgetBuilder);
    }
  }
}
