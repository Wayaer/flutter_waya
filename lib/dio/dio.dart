import 'package:flutter_waya/flutter_waya.dart';

export 'interceptor/cookies_interceptor.dart';
export 'interceptor/debugger_interceptor.dart';
export 'interceptor/logger_interceptor.dart';

class ExtendedDioOptions extends BaseOptions {
  ExtendedDioOptions({
    String? contentType,
    this.interceptors = const [],
    this.httpClientAdapter,
    this.transformer,
    super.method,
    super.connectTimeout = const Duration(seconds: 5),
    super.receiveTimeout = const Duration(seconds: 5),
    super.sendTimeout = const Duration(seconds: 5),
    super.baseUrl = '',
    super.queryParameters,
    super.extra,
    super.headers,
    super.responseType = ResponseType.json,
    super.validateStatus,
    super.receiveDataWhenStatusError,
    super.followRedirects,
    super.maxRedirects,
    super.requestEncoder,
    super.responseDecoder,
    super.listFormat,
    super.persistentConnection,
  }) : super(contentType: contentType ?? Headers.jsonContentType);

  /// 添加自定义拦截器
  /// [LoggerInterceptor] 日志打印
  /// [CookieInterceptor] cookie 请求和获取
  /// [DebuggerInterceptor] debug 工具
  List<InterceptorsWrapper> interceptors;

  HttpClientAdapter? httpClientAdapter;

  Transformer? transformer;

  Map<String, dynamic> toMap() => {
        'interceptors': interceptors,
        'httpClientAdapter': httpClientAdapter,
        'transformer': transformer,
        'method': method,
        'connectTimeout': connectTimeout,
        'receiveTimeout': receiveTimeout,
        'sendTimeout': sendTimeout,
        'baseUrl': baseUrl,
        'queryParameters': queryParameters,
        'extra': extra,
        'headers': headers,
        'responseType': responseType,
        'contentType': contentType,
        'validateStatus': validateStatus,
        'receiveDataWhenStatusError': receiveDataWhenStatusError,
        'followRedirects': followRedirects,
        'maxRedirects': maxRedirects,
        'requestEncoder': requestEncoder,
        'responseDecoder': responseDecoder,
        'listFormat': listFormat,
        'persistentConnection': persistentConnection,
      };
}

/// 全局只会存在2个Dio实例 一个常规网络请求  一个下载dio
/// 统一了返回结果 [正常返回 、 DioError catch 、 catch] 均返回 ResponseModel
/// 全局统一设置 BaseOptions 分 [常规网络请求的 ExtendedDioOptions 和 downloadOptions]
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
  Future<ResponseModel<T>> get<T>(
    String url, {
    Map<String, dynamic>? params,
    dynamic data,
    Options? options,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    _dio ??= _createDio(this.options);
    if (options != null) _dio!.options = _dio!.options.mergeOptions(options);
    return await _handle<T>(
        _dio!.get<T>(url,
            options: options,
            onReceiveProgress: onReceiveProgress,
            queryParameters: params,
            cancelToken: cancelToken ?? _cancelToken),
        baseOptions: dio!.options);
  }

  /// getUri
  Future<ResponseModel<T>> getUri<T>(
    Uri uri, {
    dynamic data,
    Options? options,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    _dio ??= _createDio(this.options);
    if (options != null) _dio!.options = _dio!.options.mergeOptions(options);

    return await _handle<T>(
        _dio!.getUri<T>(uri,
            options: options,
            onReceiveProgress: onReceiveProgress,
            cancelToken: cancelToken ?? _cancelToken),
        baseOptions: dio!.options);
  }

  /// post
  Future<ResponseModel<T>> post<T>(
    String url, {
    Map<String, dynamic>? params,
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    _dio ??= _createDio(this.options);
    if (options != null) _dio!.options = _dio!.options.mergeOptions(options);
    return await _handle<T>(
        _dio!.post<T>(url,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            queryParameters: params,
            options: options,
            data: data,
            cancelToken: cancelToken ?? _cancelToken),
        baseOptions: dio!.options);
  }

  /// postUri
  Future<ResponseModel<T>> postUri<T>(
    Uri uri, {
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    _dio ??= _createDio(this.options);
    if (options != null) _dio!.options = _dio!.options.mergeOptions(options);
    return await _handle<T>(
        _dio!.postUri<T>(uri,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            options: options,
            data: data,
            cancelToken: cancelToken ?? _cancelToken),
        baseOptions: dio!.options);
  }

  /// put
  Future<ResponseModel<T>> put<T>(
    String url, {
    Map<String, dynamic>? params,
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    _dio ??= _createDio(this.options);
    if (options != null) _dio!.options = _dio!.options.mergeOptions(options);
    return await _handle<T>(
        _dio!.put<T>(url,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            queryParameters: params,
            options: options,
            data: data,
            cancelToken: cancelToken ?? _cancelToken),
        baseOptions: dio!.options);
  }

  /// putUri
  Future<ResponseModel<T>> putUri<T>(
    Uri uri, {
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    _dio ??= _createDio(this.options);
    if (options != null) _dio!.options = _dio!.options.mergeOptions(options);
    return await _handle<T>(
        _dio!.putUri<T>(uri,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            options: options,
            data: data,
            cancelToken: cancelToken ?? _cancelToken),
        baseOptions: dio!.options);
  }

  /// head
  Future<ResponseModel<T>> head<T>(
    String url, {
    Map<String, dynamic>? params,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    _dio ??= _createDio(this.options);
    if (options != null) _dio!.options = _dio!.options.mergeOptions(options);
    return await _handle<T>(
        _dio!.head<T>(url,
            queryParameters: params,
            options: options,
            data: data,
            cancelToken: cancelToken ?? _cancelToken),
        baseOptions: dio!.options);
  }

  /// headUri
  Future<ResponseModel<T>> headUri<T>(
    Uri uri, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    _dio ??= _createDio(this.options);
    if (options != null) _dio!.options = _dio!.options.mergeOptions(options);
    return await _handle<T>(
        _dio!.headUri<T>(uri,
            options: options,
            data: data,
            cancelToken: cancelToken ?? _cancelToken),
        baseOptions: dio!.options);
  }

  /// delete
  Future<ResponseModel<T>> delete<T>(
    String url, {
    Map<String, dynamic>? params,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    _dio ??= _createDio(this.options);
    if (options != null) _dio!.options = _dio!.options.mergeOptions(options);
    return await _handle<T>(
        _dio!.delete<T>(url,
            data: data,
            queryParameters: params,
            options: options,
            cancelToken: cancelToken ?? _cancelToken),
        baseOptions: dio!.options);
  }

  /// deleteUri
  Future<ResponseModel<T>> deleteUri<T>(
    Uri uri, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    _dio ??= _createDio(this.options);
    if (options != null) _dio!.options = _dio!.options.mergeOptions(options);
    return await _handle<T>(
        _dio!.deleteUri<T>(uri,
            data: data,
            options: options,
            cancelToken: cancelToken ?? _cancelToken),
        baseOptions: dio!.options);
  }

  /// patch
  Future<ResponseModel<T>> patch<T>(
    String url, {
    Map<String, dynamic>? params,
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    _dio ??= _createDio(this.options);
    if (options != null) _dio!.options = _dio!.options.mergeOptions(options);
    return await _handle<T>(
        _dio!.patch<T>(url,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            queryParameters: params,
            options: options,
            data: data,
            cancelToken: cancelToken ?? _cancelToken),
        baseOptions: dio!.options);
  }

  /// patchUri
  Future<ResponseModel<T>> patchUri<T>(
    Uri uri, {
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    _dio ??= _createDio(this.options);
    if (options != null) _dio!.options = _dio!.options.mergeOptions(options);
    return await _handle<T>(
        _dio!.patchUri<T>(uri,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            options: options,
            data: data,
            cancelToken: cancelToken ?? _cancelToken),
        baseOptions: dio!.options);
  }

  /// request
  Future<ResponseModel<T>> request<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    _dio ??= _createDio(this.options);
    if (options != null) _dio!.options = _dio!.options.mergeOptions(options);
    return await _handle<T>(
        _dio!.request<T>(url,
            data: data,
            queryParameters: params,
            options: options,
            cancelToken: cancelToken ?? _cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress),
        baseOptions: _dio!.options);
  }

  /// requestUri
  Future<ResponseModel<T>> requestUri<T>(
    Uri uri, {
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    _dio ??= _createDio(this.options);
    if (options != null) _dio!.options = _dio!.options.mergeOptions(options);
    return await _handle<T>(
        _dio!.requestUri<T>(uri,
            data: data,
            options: options,
            cancelToken: cancelToken ?? _cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress),
        baseOptions: _dio!.options);
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
    if (options != null) {
      _dioDownload!.options = _dioDownload!.options.mergeOptions(options);
    }
    return await _handle(
        _dioDownload!.download(url, savePath,
            data: data,
            queryParameters: params,
            options: options,
            deleteOnError: deleteOnError,
            lengthHeader: lengthHeader,
            cancelToken: cancelToken ?? _cancelToken,
            onReceiveProgress: onReceiveProgress),
        baseOptions: _dioDownload!.options);
  }

  /// downloadUri
  Future<ResponseModel> downloadUri(
    Uri uri,
    String savePath, {
    dynamic data,
    Options? options,
    ProgressCallback? onReceiveProgress,
    bool deleteOnError = true,
    CancelToken? cancelToken,
    String lengthHeader = Headers.contentLengthHeader,
  }) async {
    _dioDownload ??= _createDio(downloadOptions);
    if (options != null) {
      _dioDownload!.options = _dioDownload!.options.mergeOptions(options);
    }
    return await _handle(
        _dioDownload!.downloadUri(uri, savePath,
            data: data,
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

  Future<ResponseModel<T>> _handle<T>(Future<Response<T>> func,
      {BaseOptions? baseOptions}) async {
    assert(_singleton != null, 'Please call initialize');
    ResponseModel<T>? responseModel;
    try {
      responseModel = ResponseModel.formResponse<T>(await func);
    } on DioError catch (e) {
      final DioError error = e;
      responseModel = ResponseModel.mergeError<T>(error);
    } catch (e) {
      responseModel = ResponseModel.constResponseModel<T>(error: e);
    }
    responseModel.baseOptions = baseOptions;
    return responseModel;
  }
}

extension ExtensionBaseOptions on BaseOptions {
  BaseOptions merge([BaseOptions? options]) {
    options?.headers.remove(Headers.contentTypeHeader);
    return copyWith(
        method: options?.method,
        connectTimeout: options?.connectTimeout,
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
        listFormat: options?.listFormat,
        baseUrl: options?.baseUrl,
        queryParameters: options?.queryParameters,
        persistentConnection: options?.persistentConnection);
  }

  BaseOptions mergeOptions([Options? options]) {
    options?.headers?.remove(Headers.contentTypeHeader);
    return copyWith(
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

  Map<String, dynamic> toMap() => {
        'method': method,
        'connectTimeout': connectTimeout,
        'receiveTimeout': receiveTimeout,
        'sendTimeout': sendTimeout,
        'baseUrl': baseUrl,
        'queryParameters': queryParameters,
        'extra': extra,
        'headers': headers,
        'responseType': responseType,
        'contentType': contentType,
        'validateStatus': validateStatus,
        'receiveDataWhenStatusError': receiveDataWhenStatusError,
        'followRedirects': followRedirects,
        'maxRedirects': maxRedirects,
        'requestEncoder': requestEncoder,
        'responseDecoder': responseDecoder,
        'listFormat': listFormat,
        'persistentConnection': persistentConnection,
      };
}

extension ExtensionOptions on Options {
  Options mergeBaseOptions([BaseOptions? options]) => copyWith(
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

  Options merge([Options? options]) => copyWith(
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

  Map<String, dynamic> toMap() => {
        'method': method,
        'receiveTimeout': receiveTimeout,
        'sendTimeout': sendTimeout,
        'extra': extra,
        'headers': headers,
        'responseType': responseType,
        'contentType': contentType,
        'validateStatus': validateStatus,
        'receiveDataWhenStatusError': receiveDataWhenStatusError,
        'followRedirects': followRedirects,
        'maxRedirects': maxRedirects,
        'requestEncoder': requestEncoder,
        'responseDecoder': responseDecoder,
        'listFormat': listFormat,
        'persistentConnection': persistentConnection,
      };
}

class ResponseModel<T> extends Response<T> {
  ResponseModel({
    this.type,
    super.data,
    this.response,
    super.statusCode,
    super.statusMessage,
    super.headers,
    required super.requestOptions,
    super.redirects,
    super.extra,
    this.baseOptions,
    this.error,
  });

  BaseOptions? baseOptions;

  /// 请求返回类型 [DioErrorType].toString
  String? type;

  /// dio response
  Response<dynamic>? response;

  /// error 信息
  dynamic error;

  /// 保存的cookie
  List<String> cookie = <String>[];

  Map<String, dynamic> toMap() => {
        'headers': headers.map,
        'requestOptions': requestOptionsToMap(),
        'type': type,
        'data': data,
        'cookie': cookie,
        'statusCode': statusCode,
        'statusMessage': statusMessage,
        'extra': extra,
        'error': error,
      };

  static ResponseModel<T> formResponse<T>(Response<T> response,
          {DioErrorType? type, BaseOptions? baseOptions}) =>
      ResponseModel<T>(
          baseOptions: baseOptions,
          requestOptions: response.requestOptions,
          type: type.toString(),
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          data: response.data,
          extra: response.extra,
          headers: response.headers,
          redirects: response.redirects,
          response: response);

  static ResponseModel<T> mergeError<T>(DioError err,
      [ResponseModel<T>? responseModel]) {
    responseModel ??= ResponseModel<T>(requestOptions: err.requestOptions);
    responseModel.type = err.type.toString();
    final Response<dynamic>? errResponse = err.response;
    responseModel.requestOptions = err.requestOptions;
    responseModel.error = err.error;
    if (errResponse != null) {
      responseModel.headers = errResponse.headers;
      responseModel.redirects = errResponse.redirects;
      responseModel.extra = errResponse.extra;
      responseModel.statusCode = errResponse.statusCode;
      responseModel.statusMessage = errResponse.statusMessage;
      responseModel.data = errResponse.data;
    }
    responseModel.cookie = <String>[];
    return responseModel;
  }

  static ResponseModel<T> constResponseModel<T>({dynamic error}) =>
      ResponseModel<T>(
          error: error,
          requestOptions: RequestOptions(path: ''),
          statusCode: 0,
          statusMessage: 'unknown exception',
          type: DioErrorType.unknown.toString());

  Map<String, dynamic> requestOptionsToMap() => <String, dynamic>{
        'uri': requestOptions.uri.path,
        'method': requestOptions.method,
        'baseUrl': requestOptions.baseUrl,
        'path': requestOptions.path,
        'requestHeaders': baseOptions?.headers,
        'responseHeaders': response?.headers.map,
        'body': requestOptions.data,
        'params': requestOptions.queryParameters,
        'contentType': requestOptions.contentType,
        'receiveTimeout': requestOptions.receiveTimeout,
        'sendTimeout': requestOptions.sendTimeout,
        'connectTimeout': requestOptions.connectTimeout,
        'extra': requestOptions.extra,
        'responseType': requestOptions.responseType.toString(),
      };
}
