import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 网络链接超时时间
int httpConnectTimeout = 5000;

/// 接收超时时间
int httpReceiveTimeout = 10000;

/// 请求数据类型 (4种): application/x-www-form-urlencoded 、multipart/form-data、application/json、text/xml
const List<String> HTTP_CONTENT_TYPE = <String>[
  'application/x-www-form-urlencoded',
  'multipart/form-data',
  'application/json',
  'text/xml'
];

enum HttpType { get, post, put, delete, patch }

class DioTools {
  factory DioTools() => getInstance();

  DioTools._internal(
      {BaseOptions? options,
      bool logTs = false,
      RequestCookie? requestCookie,
      ResponseSaveCookies? saveCookies}) {
    _dio = Dio();
    logTools = logTs;
    _initOptions(_dio,
        options: options ??
            BaseOptions(
                connectTimeout: httpConnectTimeout,
                receiveTimeout: httpReceiveTimeout,
                contentType: HTTP_CONTENT_TYPE[2],
                responseType: ResponseType.json,
                headers: <String, dynamic>{}));
    _dio.interceptors.add(InterceptorWrap<dynamic>(
        requestCookie: requestCookie, saveCookies: saveCookies));
  }

  void _initOptions(Dio dio, {BaseOptions? options}) {
    final BaseOptions _options = dio.options;
    if (options?.connectTimeout != null)
      _options.connectTimeout = options!.connectTimeout;
    if (options?.receiveTimeout != null)
      _options.receiveTimeout = options!.receiveTimeout;
    if (options?.contentType != null)
      _options.contentType = options?.contentType ??
          (dio == _dio ? HTTP_CONTENT_TYPE[2] : HTTP_CONTENT_TYPE[1]);
    if (options?.responseType != null)
      _options.responseType = options!.responseType;
    if (options?.headers != null) _options.headers = options!.headers;
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
        case HttpType.patch:
          response = await _dio.patch<dynamic>(url,
              queryParameters: params, data: data, cancelToken: _cancelToken);
          break;
        default:
          response = await _dio.get<dynamic>(url,
              queryParameters: params, cancelToken: _cancelToken);
          break;
      }
      final ResponseModel responseModel = ResponseModel.formResponse(response);
      if (responseModel.requestOptions.responseType != ResponseType.bytes &&
          responseModel.requestOptions.responseType != ResponseType.stream) {
        log('$httpType url:$url  responseData==  ${responseModel.toMap()}');
      }
      responseModel.baseOptions = _dio.options;
      if (logTools) setHttpData(responseModel);
      log('\n==================== 结束一个请求 ====================\n');
      return responseModel;
    } on DioError catch (e) {
      final DioError error = e;
      ResponseModel responseModel = ResponseModel.constResponseModel(
          httpStatus: ConstConstant.httpStatus[404], error: error);
      responseModel = ResponseModel.mergeError(error, responseModel);
      log('error:$url  errorData==  ${responseModel.toMap()}');
      log('\n==================== 结束一个请求 DioError ====================\n');
      responseModel.baseOptions = _dio.options;
      if (logTools) setHttpData(responseModel);
      return responseModel;
    } catch (e) {
      final ResponseModel responseModel = ResponseModel.constResponseModel();
      log('\n==================== 结束一个请求 catch ====================\n');
      responseModel.baseOptions = _dio.options;
      if (logTools) setHttpData(responseModel);
      return responseModel;
    }
  }

  /// 下载文件需要申请文件储存权限
  Future<ResponseModel> download(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    BaseOptions? options,
  }) async {
    try {
      log('\n==================== 开始下载 ====================\n');
      log('Download url:$url  savePath:${savePath.toString()}');
      final Dio dio = Dio();
      _initOptions(dio, options: options);
      final Response<dynamic> response = await dio.download(url, savePath,
          cancelToken: _cancelToken, onReceiveProgress: onReceiveProgress);
      log('\n==================== 下载结束 ====================\n');
      return ResponseModel.formResponse(response, baseOptions: dio.options);
    } on DioError catch (e) {
      final DioError error = e;
      ResponseModel errResponse = ResponseModel.constResponseModel(
          httpStatus: ConstConstant.httpStatus[404], error: error);
      errResponse = ResponseModel.mergeError(error, errResponse);
      log('error:$url  errorData==  ${errResponse.toMap()}');
      log('\n==================== 下载结束 DioError ====================\n');
      return errResponse;
    } catch (e) {
      log('\n==================== 下载结束 catch ====================\n');
      return ResponseModel.constResponseModel();
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
      log('\n==================== 开始上传 ====================\n');
      log('Upload url:$url  params:${params.toString()}  data:${data.toString()}');
      final Dio dio = Dio();
      _initOptions(dio, options: options);
      final Response<dynamic> response = await dio.post<dynamic>(url,
          queryParameters: params,
          data: data,
          cancelToken: cancelToken ?? _cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
      log('\n==================== 结束上传 ====================\n');
      return ResponseModel.formResponse(response, baseOptions: dio.options);
    } on DioError catch (e) {
      final DioError error = e;
      ResponseModel errResponse = ResponseModel.constResponseModel(
          httpStatus: ConstConstant.httpStatus[404], error: error);
      errResponse = ResponseModel.mergeError(error, errResponse);
      log('\n==================== 结束上传 DioError ====================\n');
      return errResponse;
    } catch (e) {
      log('\n==================== 结束上传 catch ====================\n');
      return ResponseModel.constResponseModel();
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
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    responseModel = ResponseModel(requestOptions: options);
    if (requestCookie != null) requestCookie!(options);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    responseModel.response = response;
    if (saveCookies != null) responseModel.cookie = saveCookies!(response);
    responseModel = ResponseModel.formResponse(response);
    if (response.statusCode == 200) {
      responseModel.statusMessage = ConstConstant.success;
      responseModel.statusMessageT = ConstConstant.success;
    }
    super.onResponse(responseModel, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    log('onError===>' + err.type.toString());
    super.onError(
        DioError(
            response: ResponseModel.mergeError(err, responseModel),
            requestOptions: err.requestOptions),
        handler);
  }
}
