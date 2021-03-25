import 'package:dio/dio.dart';

import 'constant.dart';

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

  static ResponseModel formResponse(Response<dynamic> response) =>
      ResponseModel(
          request: response.request,
          type: null,
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          statusMessageT: response.statusMessage,
          data: response.data,
          extra: response.extra,
          headers: response.headers,
          redirects: response.redirects,
          response: response);

  static ResponseModel mergeError(DioError err, ResponseModel responseModel) {
    responseModel.type = err.type.toString();
    final Response<dynamic>? errResponse = err.response;
    if (err.type == DioErrorType.other) {
      final HttpStatus status = ConstConstant.httpStatus[404]!;
      responseModel.statusCode = status.code;
      responseModel.statusMessage = status.message;
      responseModel.statusMessageT = status.messageT;
    } else if (err.type == DioErrorType.cancel) {
      final HttpStatus status = ConstConstant.httpStatus[420]!;
      responseModel.statusCode = status.code;
      responseModel.statusMessage = status.message;
      responseModel.statusMessageT = status.messageT;
    } else if (err.type == DioErrorType.connectTimeout) {
      final HttpStatus status = ConstConstant.httpStatus[408]!;
      responseModel.statusCode = status.code;
      responseModel.statusMessage = status.message;
      responseModel.statusMessageT = status.messageT;
    } else if (err.type == DioErrorType.receiveTimeout) {
      final HttpStatus status = ConstConstant.httpStatus[502]!;
      responseModel.statusCode = status.code;
      responseModel.statusMessage = status.message;
      responseModel.statusMessageT = status.messageT;
    } else if (err.type == DioErrorType.sendTimeout) {
      final HttpStatus status = ConstConstant.httpStatus[450]!;
      responseModel.statusCode = status.code;
      responseModel.statusMessage = status.message;
      responseModel.statusMessageT = status.messageT;
    } else if (err.type == DioErrorType.response) {
      final HttpStatus status = ConstConstant.httpStatus[500]!;
      responseModel.statusCode = errResponse?.statusCode;
      responseModel.statusMessage =
          errResponse!.statusCode.toString() + ':' + status.message;
      responseModel.statusMessageT = status.messageT;
    }
    if (err.request != null) responseModel.request = err.request!;
    if (errResponse != null) {
      responseModel.headers = errResponse.headers;
      responseModel.redirects = errResponse.redirects;
      responseModel.extra = errResponse.extra;
      if (errResponse.statusCode != null)
        responseModel.statusCode = errResponse.statusCode;
      if (errResponse.statusMessage != null &&
          errResponse.statusMessage!.isNotEmpty) {
        responseModel.statusMessage = errResponse.statusMessage;
        responseModel.statusMessageT = errResponse.statusMessage;
      }
      if (errResponse.data != null && errResponse.data.toString().isNotEmpty)
        responseModel.data = errResponse.data;
    }
    responseModel.cookie = <String>[];
    return responseModel;
  }

  static ResponseModel constResponseModel(
      {HttpStatus? httpStatus, DioError? error}) {
    const Map<int, HttpStatus> status = ConstConstant.httpStatus;
    httpStatus ??= status[error?.response?.statusCode ?? 100] ?? status[100];
    return ResponseModel(
        request: error?.request ?? RequestOptions(path: ''),
        statusCode: error?.response?.statusCode ?? httpStatus!.code,
        statusMessage: error?.response?.statusMessage ?? httpStatus!.message,
        statusMessageT: httpStatus!.messageT,
        type: (error?.type ?? DioErrorType.other).toString());
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
