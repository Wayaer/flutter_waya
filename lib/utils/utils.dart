import 'package:flutter/foundation.dart';
import 'package:flutter_waya/flutter_waya.dart';

export 'src/ali_oss.dart';
export 'src/des/des.dart';
export 'src/des/des_engine.dart';
export 'src/des/permuted.dart';
export 'src/event.dart';
export 'src/media_query.dart';

void logDebug(dynamic msg) => debugPrint(msg.toString());

void log(dynamic msg, {bool? crossLine}) {
  crossLine ??= GlobalOptions().logCrossLine;
  if (!(kDebugMode || kProfileMode)) return;
  final String message = msg.toString();
  if (crossLine) {
    debugPrint(
        '┌------------------------------------------------------------------------------');
  }
  const int limitLength = 800;
  if (message.length < limitLength) {
    debugPrint('$msg');
  } else {
    final StringBuffer outStr = StringBuffer();
    for (int index = 0; index < message.length; index++) {
      outStr.write(message[index]);
      if (index % limitLength == 0 && index != 0) {
        debugPrint(outStr.toString());
        outStr.clear();
        final int lastIndex = index + 1;
        if (message.length - lastIndex < limitLength) {
          final String remainderStr =
              message.substring(lastIndex, message.length);
          debugPrint(remainderStr);
          break;
        }
      }
    }
  }
  if (crossLine) {
    debugPrint(
        '└------------------------------------------------------------------------------');
  }
}
