import 'package:flutter_waya/flutter_waya.dart';

/// 请求数据类型 (4种): application/x-www-form-urlencoded 、multipart/form-data、application/json、text/xml
const List<String> httpContentType = <String>[
  'application/x-www-form-urlencoded',
  'multipart/form-data',
  'application/json',
  'text/xml'
];

class ExtendedDioOptions extends BaseOptions {
  ExtendedDioOptions(
      {this.interceptors = const [],
      this.logTs = false,
      String? method,
      int? connectTimeout = 5000,
      int? receiveTimeout = 5000,
      int? sendTimeout = 5000,
      String baseUrl = '',
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? extra,
      Map<String, dynamic>? headers,
      ResponseType responseType = ResponseType.json,
      String? contentType,
      ValidateStatus? validateStatus,
      bool? receiveDataWhenStatusError,
      bool? followRedirects,
      int? maxRedirects,
      RequestEncoder? requestEncoder,
      ResponseDecoder? responseDecoder,
      ListFormat? listFormat,
      bool setRequestContentTypeWhenNoPayload = false})
      : super(
            method: method,
            receiveTimeout: receiveTimeout,
            sendTimeout: sendTimeout,
            connectTimeout: connectTimeout,
            extra: extra,
            baseUrl: baseUrl,
            setRequestContentTypeWhenNoPayload:
                setRequestContentTypeWhenNoPayload,
            queryParameters: queryParameters,
            headers: headers,
            responseType: responseType,
            contentType: contentType,
            validateStatus: validateStatus,
            receiveDataWhenStatusError: receiveDataWhenStatusError,
            followRedirects: followRedirects,
            maxRedirects: maxRedirects,
            requestEncoder: requestEncoder,
            responseDecoder: responseDecoder,
            listFormat: listFormat);

  /// 抓包工具
  bool logTs;

  /// 添加自定义拦截器
  /// [LoggerInterceptor] 日志打印
  /// [CookieInterceptor] cookie 请求和获取
  List<InterceptorsWrapper> interceptors;
}

class ExtendedDio {
  factory ExtendedDio() => _singleton ??= ExtendedDio._();

  ExtendedDio._();

  static ExtendedDio? _singleton;

  Dio? _dio;

  Dio? get dio => _dio;

  Dio? _dioUpload;

  Dio? get dioUpload => _dioUpload;

  Dio? _dioDownload;

  Dio? get dioDownload => _dioDownload;

  ExtendedDioOptions? options;

  /// initialize
  ExtendedDio initialize({ExtendedDioOptions? options}) {
    this.options =
        options ?? ExtendedDioOptions(contentType: httpContentType[2]);
    return this;
  }

  CancelToken _cancelToken = CancelToken();

  CancelToken get cancelToken => _cancelToken;

  /// get
  Future<ResponseModel> get(String url,
      {Map<String, dynamic>? params,
      dynamic data,
      BaseOptions? options}) async {
    _dio ??= Dio(this.options);
    if (options != null) _mergeOptions(_dio!, options: options);
    return await _handle(
        () => _dio!.get<dynamic>(url,
            queryParameters: params, cancelToken: _cancelToken),
        baseOptions: dio!.options);
  }

  /// post
  Future<ResponseModel> post(String url,
      {Map<String, dynamic>? params,
      dynamic data,
      BaseOptions? options}) async {
    _dio ??= Dio(this.options);
    if (options != null) _mergeOptions(_dio!, options: options);
    return await _handle(
        () => _dio!.post<dynamic>(url,
            queryParameters: params, cancelToken: _cancelToken),
        baseOptions: dio!.options);
  }

  /// put
  Future<ResponseModel> put(String url,
      {Map<String, dynamic>? params,
      dynamic data,
      BaseOptions? options}) async {
    _dio ??= Dio(this.options);
    if (options != null) _mergeOptions(_dio!, options: options);
    return await _handle(
        () => _dio!.put<dynamic>(url,
            queryParameters: params, cancelToken: _cancelToken),
        baseOptions: dio!.options);
  }

  /// delete
  Future<ResponseModel> delete(String url,
      {Map<String, dynamic>? params,
      dynamic data,
      BaseOptions? options}) async {
    _dio ??= Dio(this.options);
    if (options != null) _mergeOptions(_dio!, options: options);
    return await _handle(
        () => _dio!.delete<dynamic>(url,
            queryParameters: params, cancelToken: _cancelToken),
        baseOptions: dio!.options);
  }

  /// patch
  Future<ResponseModel> patch(String url,
      {Map<String, dynamic>? params,
      dynamic data,
      BaseOptions? options}) async {
    _dio ??= Dio(this.options);
    if (options != null) _mergeOptions(_dio!, options: options);
    return await _handle(
        () => _dio!.patch<dynamic>(url,
            queryParameters: params, cancelToken: _cancelToken),
        baseOptions: dio!.options);
  }

  /// download
  Future<ResponseModel> download(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    BaseOptions? options,
  }) async {
    _dioDownload ??= Dio(this.options);
    if (options != null) _mergeOptions(_dioDownload!, options: options);
    log('_dioDownload.options');
    log(_dioDownload!.options.contentType);
    log(_dioDownload!.options.responseType);
    return await _handle(
        () => _dioDownload!.download(url, savePath,
            cancelToken: _cancelToken, onReceiveProgress: onReceiveProgress),
        baseOptions: _dioDownload!.options);
  }

  /// upload
  Future<ResponseModel> upload<T>(
    String url, {
    Map<String, dynamic>? params,
    dynamic data,
    BaseOptions? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    _dioUpload ??= Dio(this.options);
    if (options != null) _mergeOptions(_dioUpload!, options: options);
    return await _handle(
        () => _dioUpload!.post<dynamic>(url,
            queryParameters: params,
            data: data,
            cancelToken: _cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress),
        baseOptions: _dioUpload!.options);
  }

  void cancel([dynamic reason]) {
    assert(_singleton != null, 'Please call initialize');
    _cancelToken.cancel(reason);
    _cancelToken = CancelToken();
  }

  Future<ResponseModel> _handle(Future<Response<dynamic>> Function() func,
      {BaseOptions? baseOptions}) async {
    assert(_singleton != null, 'Please call initialize');
    try {
      final ResponseModel responseModel =
          ResponseModel.formResponse(await func.call());
      responseModel.baseOptions = baseOptions;
      if (options!.logTs) setHttpData(responseModel);
      return responseModel;
    } on DioError catch (e) {
      final DioError error = e;
      final ResponseModel responseModel = ResponseModel.mergeError(error);
      responseModel.baseOptions = baseOptions;
      if (options!.logTs) setHttpData(responseModel);
      return responseModel;
    } catch (e) {
      final ResponseModel responseModel = ResponseModel.constResponseModel();
      responseModel.baseOptions = baseOptions;
      if (options!.logTs) setHttpData(responseModel);
      return responseModel;
    }
  }

  void _mergeOptions(Dio dio, {BaseOptions? options}) {
    dio.options = dio.options.copyWith(
        method: options?.method,
        receiveTimeout: options?.receiveTimeout,
        sendTimeout: options?.sendTimeout,
        connectTimeout: options?.connectTimeout,
        extra: options?.extra,
        baseUrl: options?.baseUrl,
        setRequestContentTypeWhenNoPayload:
            options?.setRequestContentTypeWhenNoPayload,
        queryParameters: options?.queryParameters,
        headers: options?.headers,
        responseType: options?.responseType,
        contentType: options?.contentType,
        validateStatus: options?.validateStatus,
        receiveDataWhenStatusError: options?.receiveDataWhenStatusError,
        followRedirects: options?.followRedirects,
        maxRedirects: options?.maxRedirects,
        requestEncoder: options?.requestEncoder,
        responseDecoder: options?.responseDecoder,
        listFormat: options?.listFormat);
    log('options');
    log(options?.contentType);
    log(options?.responseType);
    log('dio.options');
    log(dio.options.contentType);
    log(dio.options.responseType);
  }
}

/// 请求cookie
typedef RequestCookie = Future<void> Function(RequestOptions options);

/// 获取cookie
typedef ResponseGetCookies = List<String> Function(Response<dynamic> response);

class CookieInterceptor<T> extends InterceptorsWrapper {
  CookieInterceptor({this.requestCookie, this.getCookies});

  /// 拦截器中 请求回调添加 cookie 方法
  final RequestCookie? requestCookie;

  /// 拦截器中 返回回调添加 获取cookie 方法
  final ResponseGetCookies? getCookies;

  late ResponseModel responseModel;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    responseModel = ResponseModel(requestOptions: options);
    requestCookie?.call(options);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    responseModel.response = response;
    responseModel.cookie = getCookies?.call(response) ?? [];
    responseModel = ResponseModel.formResponse(response);
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
    bool forbidPrint = false;
    String requestUri = response.requestOptions.uri.toString();
    for (var element in forbidPrintUrl) {
      if (requestUri.toString().contains(element)) {
        forbidPrint = true;
        break;
      }
    }
    log('| [DIO] Response [statusCode : ${response.statusCode}] [statusMessage : ${response.statusMessage}]',
        hasDottedLine: false);
    log('| [DIO] Request uri ($requestUri)', hasDottedLine: false);
    log('| [DIO] Response data: ${forbidPrint ? 'This data is not printed' : '\n${response.data}'}',
        hasDottedLine: false);
    log('└------------------------------------------------------------------------------',
        hasDottedLine: false);
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    log('| [DIO] Response [statusCode : ${err.response?.statusCode}] [statusMessage : ${err.response?.statusMessage}]',
        hasDottedLine: false);
    log('| [DIO] Error: ${err.error}: ${err.response?.toString()}',
        hasDottedLine: false);
    log('|            : ${err.type}: ${err.message.toString()}',
        hasDottedLine: false);
    log('└------------------------------------------------------------------------------',
        hasDottedLine: false);
    handler.next(err);
  }
}
