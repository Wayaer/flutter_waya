import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 网络链接超时时间
const int HTTP_TIMEOUT_CONNECT = 5000;

/// 接收超时时间
const int HTTP_TIMEOUT_RECEIVE = 10000;

/// 请求数据类型 (4种): application/x-www-form-urlencoded 、multipart/form-data、application/json、text/xml
const List<String> HTTP_CONTENT_TYPE = <String>[
  'application/x-www-form-urlencoded',
  'multipart/form-data',
  'application/json',
  'text/xml'
];

enum HttpType { get, post, put, delete }

class DioTools {
  factory DioTools() => getInstance();

  DioTools._internal(
      {BaseOptions? options,
      bool logTs = false,
      RequestCookie? requestCookie,
      ResponseSaveCookies? saveCookies}) {
    _dio = Dio();
    logTools = logTs;
    _initOptions(_dio, options: options);
    _dio.interceptors.add(InterceptorWrap<dynamic>(
        requestCookie: requestCookie, saveCookies: saveCookies));
  }

  void _initOptions(Dio dio, {BaseOptions? options}) {
    final BaseOptions _options = dio.options;
    _options.connectTimeout = options?.connectTimeout ?? HTTP_TIMEOUT_CONNECT;
    _options.receiveTimeout = options?.receiveTimeout ?? HTTP_TIMEOUT_RECEIVE;
    _options.contentType = options?.contentType ??
        (dio == _dio ? HTTP_CONTENT_TYPE[2] : HTTP_CONTENT_TYPE[1]);
    _options.responseType = options?.responseType ?? ResponseType.json;
    _options.headers = options?.headers ?? <String, dynamic>{};
  }

  late Dio _dio;
  late bool logTools;
  final CancelToken _cancelToken = CancelToken();

  static DioTools? _instance;

  static DioTools get instance => getInstance();

  static DioTools getInstance({BaseOptions? options, bool logTs = false}) =>
      _instance ??= DioTools._internal(options: options, logTs: logTs);

  Future<ResponseModel> getHttp(String url,
      {Map<String, dynamic>? params,
      dynamic? data,
      HttpType httpType = HttpType.get,
      BaseOptions? options}) async {
    log('\n==================== 开始一个请求 ====================\n');
    try {
      _initOptions(_dio, options: options);
      log('${httpType.toString()} url:$url  params:${params.toString()}  data:${data.toString()}');
      Response<dynamic> response;
      switch (httpType) {
        case HttpType.get:
          response = await _dio.get<dynamic>(url,
              queryParameters: params, cancelToken: _cancelToken);
          break;
        case HttpType.post:
          response = await _dio.post<dynamic>(url,
              queryParameters: params, data: data, cancelToken: _cancelToken);
          break;
        case HttpType.put:
          response = await _dio.put<dynamic>(url,
              queryParameters: params, data: data, cancelToken: _cancelToken);
          break;
        case HttpType.delete:
          response = await _dio.delete<dynamic>(url,
              queryParameters: params, data: data, cancelToken: _cancelToken);
          break;
        default:
          response = await _dio.get<dynamic>(url,
              queryParameters: params, cancelToken: _cancelToken);
          break;
      }
      final ResponseModel responseModel = response as ResponseModel;
      if (responseModel.request.responseType != ResponseType.bytes &&
          responseModel.request.responseType != ResponseType.stream) {
        log('$httpType url:$url  responseData==  ${responseModel.toMap()}');
      }
      if (logTools) setHttpData(responseModel);
      log('\n==================== 结束一个请求 ====================\n');
      return responseModel;
    } on DioError catch (e) {
      final DioError error = e;
      ResponseModel errResponse = constResponseModel(
          httpStatus: ConstConstant.httpStatus[404], error: error);
      errResponse = _dioErrorToResponse(error, errResponse);
      log('error:$url  errorData==  ${errResponse.toMap()}');
      log('\n==================== 结束一个请求 ====================\n');
      if (logTools) setHttpData(errResponse);
      return errResponse;
    } catch (e) {
      final ResponseModel responseModel = constResponseModel();
      log('\n==================== 结束一个请求 ====================\n');
      if (logTools) setHttpData(responseModel);
      return responseModel;
    }
  }

  ResponseModel constResponseModel({HttpStatus? httpStatus, DioError? error}) {
    const Map<int, HttpStatus> status = ConstConstant.httpStatus;
    httpStatus ??= status[error?.response?.statusCode ?? 100] ?? status[100];
    return ResponseModel(
        request: error?.request ?? RequestOptions(path: ''),
        statusCode: error?.response?.statusCode ?? httpStatus!.code,
        statusMessage: error?.response?.statusMessage ?? httpStatus!.message,
        statusMessageT: httpStatus!.messageT,
        type: (error?.type ?? DioErrorType.other).toString());
  }

  /// 下载文件需要申请文件储存权限
  Future<ResponseModel> download(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    BaseOptions? options,
  }) async {
    try {
      log('Download url:$url  savePath:${savePath.toString()}');
      log('\n==================== 开始下载 ====================\n');
      final Dio dio = Dio();
      _initOptions(dio, options: options);
      final Response<dynamic> response = await dio.download(url, savePath,
          cancelToken: _cancelToken, onReceiveProgress: onReceiveProgress);
      log('\n==================== 下载结束 ====================\n');
      return response as ResponseModel;
    } on DioError catch (e) {
      final DioError error = e;
      ResponseModel errResponse = constResponseModel(
          httpStatus: ConstConstant.httpStatus[404], error: error);
      errResponse = _dioErrorToResponse(error, errResponse);
      log('error:$url  errorData==  ${errResponse.toMap()}');
      log('\n==================== 下载结束 ====================\n');
      return errResponse;
    } catch (e) {
      log('\n==================== 下载结束 ====================\n');
      return constResponseModel();
    }
  }

  ///  文件上传
  Future<ResponseModel> upload<T>(String url,
      {Map<String, dynamic>? params,
      dynamic? data,
      BaseOptions? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    try {
      log('Upload url:$url  params:${params.toString()}  data:${data.toString()}');
      log('\n==================== 开始上传 ====================\n');
      final Dio dio = Dio();
      _initOptions(dio, options: options);
      final Response<dynamic> response = await dio.post<dynamic>(url,
          queryParameters: params,
          data: data,
          cancelToken: cancelToken ?? _cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
      log('\n==================== 结束上传 ====================\n');
      return response as ResponseModel;
    } on DioError catch (e) {
      final DioError error = e;
      ResponseModel errResponse = constResponseModel(
          httpStatus: ConstConstant.httpStatus[404], error: error);
      errResponse = _dioErrorToResponse(error, errResponse);
      log('error:$url  errorData==  ${errResponse.toMap()}');
      log('\n==================== 结束上传 ====================\n');
      return errResponse;
    } catch (e) {
      log('\n==================== 结束上传 ====================\n');
      return constResponseModel();
    }
  }

  void get cancel => _cancelToken.cancelError;
}

/// 添加cookie
typedef RequestCookie = Future<void> Function(RequestOptions options);

/// 从http请求中获取cookie
typedef ResponseSaveCookies = List<String> Function(Response<dynamic> response);

class InterceptorWrap<T> extends InterceptorsWrapper {
  InterceptorWrap({this.requestCookie, this.saveCookies});

  final RequestCookie? requestCookie;
  final ResponseSaveCookies? saveCookies;
  late ResponseModel responseModel;

  @override
  Future<void> onRequest(RequestOptions options) async {
    responseModel = ResponseModel(request: options);
    if (requestCookie != null) requestCookie!(options);
  }

  @override
  Future<ResponseModel> onResponse(Response<dynamic> response) async {
    responseModel.response = response;
    if (saveCookies != null) responseModel.cookie = saveCookies!(response);
    if (response.statusCode == 200) {
      responseModel.statusMessage = ConstConstant.success;
      responseModel.statusMessageT = ConstConstant.success;
    } else {
      responseModel.statusMessage = response.statusMessage;
      responseModel.statusMessageT = response.statusMessage;
    }
    responseModel.data = response.data;
    responseModel.statusCode = response.statusCode;
    responseModel.request = response.request;
    responseModel.headers = response.headers;
    responseModel.redirects = response.redirects;
    responseModel.extra = response.extra;
    return responseModel;
  }

  @override
  Future<ResponseModel> onError(DioError err) async =>
      _dioErrorToResponse(err, responseModel);
}

ResponseModel _dioErrorToResponse(DioError err, ResponseModel responseModel) {
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
