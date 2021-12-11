import 'package:flutter_waya/flutter_waya.dart';

class DES {
  DES(this.engine, this.key);

  final Engine engine;
  final String key;

  String? encode(String message) {
    engine.init(true, key.utf8ToList);
    final List<int> result = engine.process(message.utf8ToList);
    engine.reset();
    return result.toUtf8;
  }

  String? decode(String text) {
    final Engine b = engine..init(false, key.utf8ToList);
    final List<int> result = b.process(text.utf8ToList);
    engine.reset();
    return result.toUtf8;
  }

  String? encodeBase64(String message) =>
      encode(message)!.codeUnits.base64Encode;

  String? decodeBase64(String text) {
    final Engine b = engine..init(false, key.utf8ToList);
    final List<int> result = b.process(_desParseBase64(text));
    engine.reset();
    return result.toUtf8!.codeUnits.utf8Decode;
  }

  /// des解码
  List<int> _desParseBase64(String base64Str) {
    const String map =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
    List<int>? reverseMap;

    /// Shortcuts
    int base64StrLength = base64Str.length;
    if (reverseMap == null) {
      reverseMap = List<int>.filled(123, 0);
      for (int j = 0; j < map.length; j++) {
        reverseMap[map.codeUnits[j]] = j;
      }
    }

    /// Ignore padding
    final int paddingChar = map.codeUnits[64];
    final int paddingIndex = base64Str.codeUnits.indexOf(paddingChar);
    if (paddingIndex != -1) base64StrLength = paddingIndex;
    return _parseLoop(base64Str, base64StrLength, reverseMap);
  }

  List<int> _parseLoop(
      String base64Str, int base64StrLength, List<int> reverseMap) {
    final List<int> words = <int>[];
    int nBytes = 0;
    for (int i = 0; i < base64StrLength; i++) {
      if (i % 4 != 0) {
        final int bits1 = reverseMap[base64Str.codeUnits[i - 1]] <<
            ((i % 4) * 2).toSigned(32);
        final int bits2 = reverseMap[base64Str.codeUnits[i]]
            .rightShift32((6 - (i % 4) * 2).toInt())
            .toSigned(32);
        final int idx = nBytes.rightShift32(2);
        if (words.length <= idx) {
          words.addAll((idx + 1).generate((int index) => 0));
        }

        words[idx] |= ((bits1 | bits2) << (24 - (nBytes % 4) * 8)).toSigned(32);
        nBytes++;
      }
    }
    return List<int>.generate(
        nBytes, (int i) => i < words.length ? words[i] : 0);
  }
}
