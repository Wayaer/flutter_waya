import 'package:flutter_waya/flutter_waya.dart';

export 'interceptor/cookies_interceptor.dart';
export 'interceptor/debugger_interceptor.dart';
export 'interceptor/logger_interceptor.dart';

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
      this.httpClientAdapter,
      this.transformer,
      super.method,
      super.connectTimeout = 5000,
      super.receiveTimeout = 5000,
      super.sendTimeout = 5000,
      super.baseUrl = '',
      super.queryParameters,
      super.extra,
      super.headers,
      super.responseType = ResponseType.json,
      super.contentType,
      super.validateStatus,
      super.receiveDataWhenStatusError,
      super.followRedirects,
      super.maxRedirects,
      super.requestEncoder,
      super.responseDecoder,
      super.listFormat,
      super.setRequestContentTypeWhenNoPayload = false});

  /// 添加自定义拦截器
  /// [LoggerInterceptor] 日志打印
  /// [CookieInterceptor] cookie 请求和获取
  /// [DebuggerInterceptor] debug 工具
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

class ResponseModel extends Response<dynamic> {
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

  static ResponseModel formResponse(Response<dynamic> response,
          {DioErrorType? type, BaseOptions? baseOptions}) =>
      ResponseModel(
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

  static ResponseModel mergeError(DioError err,
      [ResponseModel? responseModel]) {
    responseModel ??= ResponseModel(requestOptions: err.requestOptions);
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

  static ResponseModel constResponseModel({dynamic error}) => ResponseModel(
      error: error,
      requestOptions: RequestOptions(path: ''),
      statusCode: 0,
      statusMessage: 'unknown exception',
      type: DioErrorType.other.toString());

  String toJson() =>
      '{"type":"${type.toString()}","data":$data,"cookie":$cookie,"statusCode'
      '":$statusCode,"statusMessage":"$statusMessage","extra":$extra"}';

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
