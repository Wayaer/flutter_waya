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
      this.httpClientAdapter,
      this.transformer,
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

  HttpClientAdapter? httpClientAdapter;

  Transformer? transformer;
}

/// 全局只会存在2个Dio实例 一个常规网络请求  一个下载dio
class ExtendedDio {
  factory ExtendedDio() => _singleton ??= ExtendedDio._();

  ExtendedDio._();

  static ExtendedDio? _singleton;

  Dio? _dio;

  Dio? get dio => _dio;

  Dio? _dioDownload;

  Dio? get dioDownload => _dioDownload;

  ExtendedDioOptions? options;

  BaseOptions? downloadOptions;

  /// initialize
  ExtendedDio initialize(
      {ExtendedDioOptions? options, BaseOptions? downloadOptions}) {
    this.options = options;
    this.downloadOptions = downloadOptions;
    return this;
  }

  CancelToken _cancelToken = CancelToken();

  CancelToken get cancelToken => _cancelToken;

  Dio _createDio(BaseOptions? options) {
    final dio = Dio(options);
    if (this.options?.transformer != null) {
      dio.transformer = this.options!.transformer!;
    }
    if (this.options?.httpClientAdapter != null) {
      dio.httpClientAdapter = this.options!.httpClientAdapter!;
    }
    dio.interceptors.addAll(this.options?.interceptors ?? []);
    return dio;
  }

  /// get
  Future<ResponseModel> get(
    String url, {
    Map<String, dynamic>? params,
    dynamic data,
    Options? options,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    _dio ??= _createDio(this.options);
    if (options != null) _mergeOptions(_dio!, options: options);
    return await _handle(
        () => _dio!.get<dynamic>(url,
            options: options,
            onReceiveProgress: onReceiveProgress,
            queryParameters: params,
            cancelToken: cancelToken ?? _cancelToken),
        baseOptions: dio!.options);
  }

  /// post
  Future<ResponseModel> post(
    String url, {
    Map<String, dynamic>? params,
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    _dio ??= _createDio(this.options);
    if (options != null) _mergeOptions(_dio!, options: options);
    return await _handle(
        () => _dio!.post<dynamic>(url,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            queryParameters: params,
            options: options,
            data: data,
            cancelToken: cancelToken ?? _cancelToken),
        baseOptions: dio!.options);
  }

  /// put
  Future<ResponseModel> put(
    String url, {
    Map<String, dynamic>? params,
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    _dio ??= _createDio(this.options);
    if (options != null) _mergeOptions(_dio!, options: options);
    return await _handle(
        () => _dio!.put<dynamic>(url,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            queryParameters: params,
            options: options,
            data: data,
            cancelToken: cancelToken ?? _cancelToken),
        baseOptions: dio!.options);
  }

  /// delete
  Future<ResponseModel> delete(
    String url, {
    Map<String, dynamic>? params,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    _dio ??= _createDio(this.options);
    if (options != null) _mergeOptions(_dio!, options: options);
    return await _handle(
        () => _dio!.delete<dynamic>(url,
            data: data,
            queryParameters: params,
            options: options,
            cancelToken: cancelToken ?? _cancelToken),
        baseOptions: dio!.options);
  }

  /// patch
  Future<ResponseModel> patch(
    String url, {
    Map<String, dynamic>? params,
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    _dio ??= _createDio(this.options);
    if (options != null) _mergeOptions(_dio!, options: options);
    return await _handle(
        () => _dio!.patch<dynamic>(url,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            queryParameters: params,
            options: options,
            data: data,
            cancelToken: cancelToken ?? _cancelToken),
        baseOptions: dio!.options);
  }

  /// download
  Future<ResponseModel> download(
    String url,
    String savePath, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    ProgressCallback? onReceiveProgress,
    bool deleteOnError = true,
    CancelToken? cancelToken,
    String lengthHeader = Headers.contentLengthHeader,
  }) async {
    _dioDownload ??= _createDio(downloadOptions);
    return await _handle(
        () => _dioDownload!.download(url, savePath,
            data: data,
            queryParameters: params,
            options: options,
            deleteOnError: deleteOnError,
            lengthHeader: lengthHeader,
            cancelToken: cancelToken ?? _cancelToken,
            onReceiveProgress: onReceiveProgress),
        baseOptions: _dioDownload!.options);
  }

  void cancel([dynamic reason]) {
    assert(_singleton != null, 'Please call initialize');
    _cancelToken.cancel(reason);
    _cancelToken = CancelToken();
  }

  Future<ResponseModel> _handle(Future<Response<dynamic>> Function() func,
      {BaseOptions? baseOptions}) async {
    assert(_singleton != null, 'Please call initialize');
    ResponseModel? responseModel;
    try {
      responseModel = ResponseModel.formResponse(await func.call());
    } on DioError catch (e) {
      final DioError error = e;
      responseModel = ResponseModel.mergeError(error);
    } catch (e) {
      log('Dio catch error : $e', hasDottedLine: false);
      responseModel = ResponseModel.constResponseModel(error: e);
    }
    responseModel.baseOptions = baseOptions;
    if (options!.logTs) setHttpData(responseModel);
    return responseModel;
  }

  void _mergeOptions(Dio dio, {Options? options}) {
    dio.options = dio.options.copyWith(
        method: options?.method,
        receiveTimeout: options?.receiveTimeout,
        sendTimeout: options?.sendTimeout,
        extra: options?.extra,
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
