import 'package:flutter/foundation.dart';
import 'package:flutter_waya/flutter_waya.dart';

export 'src/ali_oss.dart';
export 'src/des/des.dart';
export 'src/des/des_engine.dart';
export 'src/des/permuted.dart';
export 'src/dio.dart';
export 'src/event.dart';
export 'src/screen_fit.dart';

void logDebug(dynamic msg) => debugPrint(msg.toString());

void log(dynamic msg, {bool? hasDottedLine}) {
  var _hasDottedLine = hasDottedLine ?? GlobalOptions().logHasDottedLine;
  if (!(kDebugMode || kProfileMode)) return;
  final String message = msg.toString();
  if (_hasDottedLine) {
    debugPrint(
        '┌------------------------------------------------------------------------------');
  }
  const int _limitLength = 800;
  if (message.length < _limitLength) {
    debugPrint('$msg');
  } else {
    final StringBuffer outStr = StringBuffer();
    for (int index = 0; index < message.length; index++) {
      outStr.write(message[index]);
      if (index % _limitLength == 0 && index != 0) {
        debugPrint(outStr.toString());
        outStr.clear();
        final int lastIndex = index + 1;
        if (message.length - lastIndex < _limitLength) {
          final String remainderStr =
              message.substring(lastIndex, message.length);
          debugPrint(remainderStr);
          break;
        }
      }
    }
  }
  if (_hasDottedLine) {
    debugPrint(
        '└------------------------------------------------------------------------------');
  }
}
