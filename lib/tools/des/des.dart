import 'package:flutter_waya/flutter_waya.dart';

class DES {
  DES(this.engine, this.key);

  final Engine engine;
  final String key;

  String encode(String message) {
    engine.init(true, key.utf8ToList);
    final List<int> result = engine.process(message.utf8ToList);
    engine.reset();
    return result.toUtf8;
  }

  String decode(String text) {
    final Engine b = engine..init(false, key.utf8ToList);
    final List<int> r = b.process(text.utf8ToList);
    engine.reset();
    return r.toUtf8;
  }

  String encodeBase64(String message) => encode(message).codeUnits.base64Encode;

  String decodeBase64(String text) {
    final Engine b = engine..init(false, key.utf8ToList);
    final List<int> result = b.process(text.desParseBase64);
    engine.reset();
    return result.toUtf8.codeUnits.utf8Decode;
  }
}
