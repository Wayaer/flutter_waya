class ResponseModel {
  /// 状态
  int statusCode;

  /// 状态消息
  String statusMessage;

  /// 语言翻译版 消息
  String statusMessageT;

  String type;
  Object data;
  List<String> cookie;

  ResponseModel({
    this.data,
    this.type,
    this.statusCode,
    this.statusMessage,
    this.statusMessageT,
  });

  ResponseModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    statusCode = json['statusCode'];
    cookie = json['cookie'];
    statusMessage = json['statusMessage'].toString();
    statusMessageT = json['statusMessageT'].toString();
    data = json['data'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = this.type;
    data['data'] = this.data;
    data['cookie'] = this.cookie;
    data['statusCode'] = this.statusCode;
    data['statusMessage'] = this.statusMessage;
    data['statusMessageT'] = this.statusMessageT;
    return data;
  }
}

class DateTimePickerUnit {
  final String year;
  final String month;
  final String day;
  final String hour;
  final String minute;
  final String second;

  DateTimePickerUnit({this.year, this.month, this.day, this.hour, this.minute, this.second});

  int getLength() {
    int i = 0;
    if (year != null) i = i + 1;
    if (month != null) i = i + 1;
    if (day != null) i = i + 1;
    if (hour != null) i = i + 1;
    if (minute != null) i = i + 1;
    if (second != null) i = i + 1;
    return i;
  }

  DateTimePickerUnit getDefaultUnit() =>
      DateTimePickerUnit(year: 'Y', month: 'M', day: 'D', hour: 'H', minute: 'M', second: 'S');
}
