import 'package:dio/dio.dart';

class ResponseModel {
  ResponseModel({
    this.data,
    this.type,
    this.statusCode,
    this.statusMessage,
    this.statusMessageT,
    this.headers,
    this.request,
    this.isRedirect,
    this.redirects,
    this.extra,
  });

  ResponseModel.fromJson(Map<String, dynamic> json) {
    type = json['type'] as String;
    statusCode = json['statusCode'] as int;
    cookie = json['cookie'] as List<String>;
    statusMessage = json['statusMessage'].toString();
    statusMessageT = json['statusMessageT'].toString();
    data = json['data'];
    headers = json['headers'] as Headers;
    request = json['request'] as RequestOptions;
    isRedirect = json['isRedirect'] as bool;
    redirects = json['redirects'] as List<RedirectRecord>;
    extra = json['extra'] as Map<String, dynamic>;
  }

  /// Response headers.
  Headers headers;

  /// The corresponding request info.
  RequestOptions request;

  /// Custom field that you can retrieve it later in `then`.
  Map<String, dynamic> extra;

  /// Returns the series of redirects this connection has been through. The
  /// list will be empty if no redirects were followed. [redirects] will be
  /// updated both in the case of an automatic and a manual redirect.
  ///
  /// ** Attention **: Whether this field is available depends on whether the
  /// implementation of the adapter supports it or not.
  List<RedirectRecord> redirects;

  /// Whether this response is a redirect.
  /// ** Attention **: Whether this field is available depends on whether the
  /// implementation of the adapter supports it or not.
  bool isRedirect;

  /// 状态
  int statusCode;

  /// 状态消息
  String statusMessage;

  /// 语言翻译版 状态消息
  String statusMessageT;

  String type;

  ///后台返回的数据
  Object data;

  ///保存的cookie
  List<String> cookie;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['type'] = type;
    map['data'] = data;
    map['cookie'] = cookie;
    map['statusCode'] = statusCode;
    map['statusMessage'] = statusMessage;
    map['statusMessageT'] = statusMessageT;
    // map['headers'] = headers;
    // map['request'] = request;
    // map['isRedirect'] = isRedirect;
    // map['redirects'] = redirects;
    // map['extra'] = extra;
    return map;
  }

  String toJson() =>
      '{"type":"${type.toString()}","data":$data,"cookie":$cookie,"statusCode":$statusCode,"statusMessage":"$statusMessage","statusMessageT":"$statusMessageT"}';
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
