import 'package:flutter_waya/flutter_waya.dart';

/// 请求数据类型 (4种): application/x-www-form-urlencoded 、multipart/form-data、application/json、text/xml
const List<String> httpContentType = <String>[
  'application/x-www-form-urlencoded',
  'multipart/form-data',
  'application/json',
  'text/xml'
];

enum HttpType { get, post, put, delete, patch }

class ExtendedDioOptions {
  ExtendedDioOptions(
      {this.options,
      this.interceptors,
      this.requestCookie,
      this.saveCookies,
      this.logTs = false});

  BaseOptions? options;

  /// 抓包工具
  late bool logTs;

  /// 添加自定义拦截器
  List<InterceptorsWrapper>? interceptors;

  /// 拦截器中 请求回调添加 cookie 方法
  RequestCookie? requestCookie;

  /// 拦截器中 返回回调添加 获取cookie 方法
  ResponseSaveCookies? saveCookies;
}

class ExtendedDio {
  factory ExtendedDio() => getInstance();

  ExtendedDio._internal({ExtendedDioOptions? options}) {
    options ??= ExtendedDioOptions();
    _dio = Dio();
    logTools = options.logTs;
    _initOptions(_dio,
        options: options.options ??
            BaseOptions(
                connectTimeout: 5000,
                receiveTimeout: 10000,
                contentType: httpContentType[2],
                responseType: ResponseType.json,
                headers: <String, dynamic>{}));
    _dio.interceptors.add(ResponseModelInterceptorWrapper<dynamic>(
        requestCookie: options.requestCookie,
        saveCookies: options.saveCookies));
    if (options.interceptors != null && options.interceptors!.isNotEmpty) {
      _dio.interceptors.addAll(options.interceptors!);
    }
  }

  static ExtendedDio? _instance;

  static ExtendedDio get instance => getInstance();

  static ExtendedDio getInstance({ExtendedDioOptions? options}) =>
      _instance ??= ExtendedDio._internal(options: options);

  void _initOptions(Dio dio, {BaseOptions? options}) {
    final BaseOptions _options = dio.options;
    if (options?.connectTimeout != null) {
      _options.connectTimeout = options!.connectTimeout;
    }
    if (options?.receiveTimeout != null) {
      _options.receiveTimeout = options!.receiveTimeout;
    }
    if (options?.contentType != null) {
      _options.contentType = options?.contentType ??
          (dio == _dio ? httpContentType[2] : httpContentType[1]);
    }
    if (options?.responseType != null) {
      _options.responseType = options!.responseType;
    }
    if (options?.headers != null) _options.headers = options!.headers;
  }

  late Dio _dio;
  late bool logTools;
  CancelToken _cancelToken = CancelToken();

  Future<ResponseModel> getHttp(
    String url, {
    Map<String, dynamic>? params,
    dynamic data,
    HttpType httpType = HttpType.get,
    BaseOptions? options,
  }) async {
    try {
      _initOptions(_dio, options: options);
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
      responseModel.baseOptions = _dio.options;
      if (logTools) setHttpData(responseModel);
      return responseModel;
    } on DioError catch (e) {
      final DioError error = e;
      final ResponseModel responseModel = ResponseModel.mergeError(error);
      responseModel.baseOptions = _dio.options;
      if (logTools) setHttpData(responseModel);
      return responseModel;
    } catch (e) {
      final ResponseModel responseModel = ResponseModel.constResponseModel();
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
      final Dio dio = Dio();
      _initOptions(dio, options: options);
      final Response<dynamic> response = await dio.download(url, savePath,
          cancelToken: _cancelToken, onReceiveProgress: onReceiveProgress);
      return ResponseModel.formResponse(response, baseOptions: dio.options);
    } on DioError catch (e) {
      final DioError error = e;
      final ResponseModel responseModel = ResponseModel.mergeError(error);
      return responseModel;
    } catch (e) {
      return ResponseModel.constResponseModel();
    }
  }

  /// 文件上传
  Future<ResponseModel> upload<T>(
    String url, {
    Map<String, dynamic>? params,
    dynamic data,
    BaseOptions? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Dio dio = Dio();
      _initOptions(dio, options: options);
      final Response<dynamic> response = await dio.post<dynamic>(url,
          queryParameters: params,
          data: data,
          cancelToken: cancelToken ?? _cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
      return ResponseModel.formResponse(response, baseOptions: dio.options);
    } on DioError catch (e) {
      final DioError error = e;
      final ResponseModel responseModel = ResponseModel.mergeError(error);
      return responseModel;
    } catch (e) {
      return ResponseModel.constResponseModel();
    }
  }

  void cancel([dynamic reason]) {
    _cancelToken.cancel(reason);
    _cancelToken = CancelToken();
  }
}

/// 添加cookie
typedef RequestCookie = Future<void> Function(RequestOptions options);

/// 从http请求中获取cookie
typedef ResponseSaveCookies = List<String> Function(Response<dynamic> response);

class ResponseModelInterceptorWrapper<T> extends InterceptorsWrapper {
  ResponseModelInterceptorWrapper({this.requestCookie, this.saveCookies});

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
    super.onError(
        DioError(
            response: ResponseModel.mergeError(err, responseModel),
            requestOptions: err.requestOptions),
        handler);
  }
}

class LoggerInterceptor<T> extends InterceptorsWrapper {
  LoggerInterceptor({this.forbidPrintUrl = const []});

  final List<String> forbidPrintUrl;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String headers = '';
    options.headers.forEach((String key, dynamic value) {
      headers += ' | $key: $value';
    });
    log('┌------------------------------------------------------------------------------',
        hasDottedLine: false);
    log('''| [DIO] Request: ${options.method} ${options.uri}\n| QueryParameters:${options.queryParameters}\n| Data:${options.data}\n| Headers:$headers''',
        hasDottedLine: false);
    log('├------------------------------------------------------------------------------',
        hasDottedLine: false);
    handler.next(options);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    bool _forbidPrint = false;
    String requestUri = response.requestOptions.uri.toString();
    for (var element in forbidPrintUrl) {
      if (requestUri.toString().contains(element)) {
        _forbidPrint = true;
        break;
      }
    }
    log('| [DIO] Response [code ${response.statusCode}]: ${response.statusMessage}',
        hasDottedLine: false);
    log('| [DIO] Request uri ($requestUri)', hasDottedLine: false);
    log('| [DIO] Response data: ${_forbidPrint ? 'This data is not printed' : '\n${response.data}'}',
        hasDottedLine: false);
    log('└------------------------------------------------------------------------------',
        hasDottedLine: false);
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    log('| [DIO] Error: ${err.error}: ${err.response?.toString()}',
        hasDottedLine: false);
    log('|            : ${err.type}: ${err.message.toString()}',
        hasDottedLine: false);
    log('└------------------------------------------------------------------------------',
        hasDottedLine: false);
    handler.next(err); //continue
  }
}
