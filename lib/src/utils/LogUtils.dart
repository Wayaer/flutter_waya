log(message) {
  LogUtils.d(message);
}

class LogUtils {
  static var separator = "=";
  static var split =
      "$separator$separator$separator$separator$separator$separator$separator$separator$separator";
  static var title = "Yl-Log";
  static var isDebug = true;
  static int limitLength = 800;
  static String startLine = "$split$title$split";
  static String endLine = "$split$separator$separator$separator$split";

  static void init({String title, bool isDebug, int limitLength}) {
    title = title;
    isDebug = isDebug;
    limitLength = limitLength ??= limitLength;
    startLine = "$split$title$split";
    var endLineStr = StringBuffer();
    var cnCharReg = RegExp("[\u4e00-\u9fa5]");
    for (int i = 0; i < startLine.length; i++) {
      if (cnCharReg.stringMatch(startLine[i]) != null) {
        endLineStr.write(separator);
      }
      endLineStr.write(separator);
    }
    endLine = endLineStr.toString();
  }

  //仅Debug模式可见
  static void d(dynamic obj) {
    if (isDebug) {
      log(obj.toString());
    }
  }

  static void v(dynamic obj) {
    log(obj.toString());
  }

  static void log(String msg) {
    if (msg.length < limitLength) {
      print(msg);
    } else {
      segmentationLog(msg);
    }
  }

  static void segmentationLog(String msg) {
    var outStr = StringBuffer();
    for (var index = 0; index < msg.length; index++) {
      outStr.write(msg[index]);
      if (index % limitLength == 0 && index != 0) {
        print(outStr);
        outStr.clear();
        var lastIndex = index + 1;
        if (msg.length - lastIndex < limitLength) {
          var remainderStr = msg.substring(lastIndex, msg.length);
          print(remainderStr);
          break;
        }
      }
    }
  }
}
