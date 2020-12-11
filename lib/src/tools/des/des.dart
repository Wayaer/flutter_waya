import 'dart:convert';
import 'dart:math';

import 'dart:typed_data';
import 'permuted.dart';

part 'des_engine.dart';

class DES {
  DES(this.engine, this.key);

  final Engine engine;
  final String key;

  String encode(String message) {
    engine.init(true, _utf8ToWords(key));
    final List<int> result = engine.process(_utf8ToWords(message));
    engine.reset();
    return _wordsToUtf8(result);
  }

  String decode(String text) {
    final Engine b = engine..init(false, _utf8ToWords(key));
    final List<int> r = b.process(_utf8ToWords(text));
    engine.reset();
    return _wordsToUtf8(r);
  }

  String encodeB64(String message) {
    return base64.encode(encode(message).codeUnits);
  }

  String decodeB64(String text) {
    final Engine b = engine..init(false, _utf8ToWords(key));
    final List<int> result = b.process(_parseBase64(text));
    engine.reset();
    return utf8.decode(_wordsToUtf8(result).codeUnits);
  }
}
