import 'package:dio/dio.dart';

class ResponseModel extends Response<dynamic> {
  ResponseModel({
    this.type,
    this.statusMessageT,
    dynamic? data,
    this.response,
    int? statusCode,
    String? statusMessage,
    Headers? headers,
    required RequestOptions request,
    List<RedirectRecord>? redirects,
    Map<String, dynamic>? extra,
  }) : super(
            data: data,
            headers: headers,
            request: request,
            statusCode: statusCode,
            statusMessage: statusMessage,
            redirects: redirects,
            extra: extra);

  ///  语言翻译版 状态消息
  String? statusMessageT;

  ///  请求返回类型 [DioErrorType].toString
  String? type;

  /// dio response
  Response<dynamic>? response;

  ///  保存的cookie
  List<String> cookie = <String>[];

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
  AppConfig(
      {this.androidVersionCode = 0,
      this.iosVersionCode = 0,
      this.open = false});

  AppConfig.fromJson(Map<dynamic, dynamic> json) {
    json['open'] == null ? open = false : open = json['open'] as bool;
    json['iosVersionCode'] == null
        ? iosVersionCode = 0
        : iosVersionCode = json['iosVersionCode'] as int;
    json['androidVersionCode'] == null
        ? androidVersionCode = 0
        : androidVersionCode = json['androidVersionCode'] as int;
  }

  late int androidVersionCode;
  late int iosVersionCode;
  late bool open;
}

class DateTimePickerUnit {
  DateTimePickerUnit(
      {this.year, this.month, this.day, this.hour, this.minute, this.second});

  final String? year;
  final String? month;
  final String? day;
  final String? hour;
  final String? minute;
  final String? second;

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
