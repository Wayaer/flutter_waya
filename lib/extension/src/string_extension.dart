import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

import '../extension.dart';

/// String 扩展
extension ExtensionString on String {
  int get parseInt => int.parse(this);

  String insert(int index, String element) =>
      '${substring(0, index)}$element${substring(index, length)}';

  double get parseDouble => double.parse(this);

  ///  md5 加密
  String get toMd5 => md5.convert(utf8.encode(this)).toString();

  ///  Base64加密
  String get toEncodeBase64 => base64Encode(utf8.encode(this));

  ///  Base64解密
  String get toDecodeBase64 => String.fromCharCodes(base64Decode(this));

  /// 复制到粘贴板
  Future<void> get toClipboard async =>
      await Clipboard.setData(ClipboardData(text: this));

  /// 验证邮箱
  bool get isEmail =>
      RegExp(r'^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$').hasMatch(this);

  /// 手机号验证
  bool get isChinaPhone =>
      RegExp(r'^1([38][0-9]|4[579]|5[0-3,5-9]|6[6]|7[0135678]|9[89])\d{8}$')
          .hasMatch(this);

  ///  utf8ToList
  List<int> get utf8ToList {
    final List<int> words = length.generate((_) => 0);
    for (int i = 0; i < length; i++) {
      words[i >> 2] |= (codeUnitAt(i) & 0xff).toSigned(32) <<
          (24 - (i % 4) * 8).toSigned(32);
    }
    return words;
  }

  /// 进行utf8编码
  List<int> get utf8Encode => utf8.encode(this);

  /// 每隔 x位 加 pattern
  String formatDigitPattern({int digit = 4, String pattern = ' '}) {
    String text = this;
    text = text.replaceAllMapped(
        RegExp('(.{$digit})'), (Match match) => '${match.group(0)}$pattern');
    if (text.endsWith(pattern)) text = text.substring(0, text.length - 1);
    return text;
  }

  /// 每隔 x位 加 pattern, 从末尾开始
  String formatDigitPatternEnd(String text,
      {int digit = 4, String pattern = ' '}) {
    String temp = reverse;
    temp = formatDigitPattern(digit: digit, pattern: pattern);
    temp = reverse;
    return temp;
  }

  /// reverse
  String get reverse {
    final String text = this;
    if (isEmpty) return '';
    final StringBuffer sb = StringBuffer();
    for (int i = text.length - 1; i >= 0; i--) {
      sb.writeCharCode(text.codeUnitAt(i));
    }
    return sb.toString();
  }

  /// 移出头部指定 [prefix] 不包含不移出
  String removePrefix(String prefix) {
    if (!startsWith(prefix)) return this;
    return substring(prefix.length);
  }

  /// 移出尾部指定 [suffix] 不包含不移出
  String removeSuffix(String suffix) {
    if (!endsWith(suffix)) return this;
    return substring(0, length - suffix.length);
  }

  /// 移出头部指定长度
  String removePrefixLength(int l) => substring(l, length);

  /// 移出尾部指定长度
  String removeSuffixLength(int l) => substring(0, l);
}
