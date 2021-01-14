import 'package:dio/dio.dart';

class ResponseModel extends Response<dynamic> {
  ResponseModel({
    this.type,
    this.statusMessageT,
    dynamic data,
    int statusCode,
    String statusMessage,
    Headers headers,
    RequestOptions request,
    List<RedirectRecord> redirects,
    Map<String, dynamic> extra,
  }) : super(
            data: data,
            headers: headers,
            request: request,
            statusCode: statusCode,
            statusMessage: statusMessage,
            redirects: redirects,
            extra: extra);

  ///  语言翻译版 状态消息
  String statusMessageT;

  ///  请求返回类型 [DioErrorType].toString
  String type;

  ///  保存的cookie
  List<String> cookie;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['type'] = type;
    map['data'] = data;
    map['cookie'] = cookie;
    map['statusCode'] = statusCode;
    map['statusMessage'] = statusMessage;
    map['statusMessageT'] = statusMessageT;
    return map;
  }

  String toJson() =>
      '{"type":"${type.toString()}","data":$data,"cookie":$cookie,"statusCode":$statusCode,"statusMessage":"$statusMessage","statusMessageT":"$statusMessageT"}';
}

class HttpStatus {
  const HttpStatus(this.code, this.message, this.messageT);

  final int code;
  final String message;
  final String messageT;
}

class AppConfig {
  AppConfig({this.androidVersionCode, this.iosVersionCode, this.open});

  AppConfig.fromJson(Map<dynamic, dynamic> json) {
    json['open'] == null ? open = false : open = json['open'] as bool;
    iosVersionCode = json['iosVersionCode'] as int;
    androidVersionCode = json['androidVersionCode'] as int;
  }

  int androidVersionCode;
  int iosVersionCode;
  bool open;
}

class DateTimePickerUnit {
  DateTimePickerUnit(
      {this.year, this.month, this.day, this.hour, this.minute, this.second});

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

  DateTimePickerUnit get getDefaultUnit => DateTimePickerUnit(
      year: 'Y', month: 'M', day: 'D', hour: 'H', minute: 'M', second: 'S');
}
