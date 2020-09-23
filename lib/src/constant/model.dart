class ResponseModel {
  ResponseModel({
    this.data,
    this.type,
    this.statusCode,
    this.statusMessage,
    this.statusMessageT,
  });

  ResponseModel.fromJson(Map<String, dynamic> json) {
    type = json['type'] as String;
    statusCode = json['statusCode'] as int;
    cookie = json['cookie'] as List<String>;
    statusMessage = json['statusMessage'].toString();
    statusMessageT = json['statusMessageT'].toString();
    data = json['data'];
  }

  /// 状态
  int statusCode;

  /// 状态消息
  String statusMessage;

  /// 语言翻译版 消息
  String statusMessageT;

  String type;
  Object data;
  List<String> cookie;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['data'] = data;
    data['cookie'] = cookie;
    data['statusCode'] = statusCode;
    data['statusMessage'] = statusMessage;
    data['statusMessageT'] = statusMessageT;
    return data;
  }
}

class DateTimePickerUnit {
  DateTimePickerUnit({this.year, this.month, this.day, this.hour, this.minute, this.second});

  final String year;
  final String month;
  final String day;
  final String hour;
  final String minute;
  final String second;

  int getLength() {
    int i = 0;
    if (year != null) i += 1;
    if (month != null) i += 1;
    if (day != null) i += 1;
    if (hour != null) i += 1;
    if (minute != null) i += 1;
    if (second != null) i += 1;
    return i;
  }

  DateTimePickerUnit getDefaultUnit() =>
      DateTimePickerUnit(year: 'Y', month: 'M', day: 'D', hour: 'H', minute: 'M', second: 'S');
}
