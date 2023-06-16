import 'package:flutter_waya/flutter_waya.dart';

part 'extension.dart';

/// 全局只会存在2个Dio实例 一个常规网络请求  一个下载dio
/// 统一了返回结果 [正常返回 、 DioException catch 、 catch] 均返回 ExtendedResponse
/// 全局统一设置 BaseOptions 分 [常规网络请求的 options 和 downloadOptions]
class ExtendedDio {
  factory ExtendedDio() => _singleton ??= ExtendedDio._();

  ExtendedDio._();

  static ExtendedDio? _singleton;

  final Dio dio = Dio();
  final Dio dioDownload = Dio();

  /// initialize
  ExtendedDio initialize(
      {List<InterceptorsWrapper> interceptors = const [],
      HttpClientAdapter? httpClientAdapter,
      Transformer? transformer,
      BaseOptions? options,
      BaseOptions? downloadOptions}) {
    if (options != null) dio.options = options;
    if (downloadOptions != null) dioDownload.options = downloadOptions;
    if (transformer != null) {
      dio.transformer = transformer;
      dioDownload.transformer = transformer;
    }
    if (httpClientAdapter != null) {
      dio.httpClientAdapter = httpClientAdapter;
      dioDownload.httpClientAdapter = httpClientAdapter;
    }
    dio.interceptors.addAll(interceptors);
    dioDownload.interceptors.addAll(interceptors);
    return this;
  }

  CancelToken _cancelToken = CancelToken();

  CancelToken get cancelToken => _cancelToken;

  /// get
  Future<ExtendedResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? params,
    Object? data,
    Options? options,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) =>
      _handle<T>(
          path,
          dio.get<T>(path,
              options: options,
              data: data,
              onReceiveProgress: onReceiveProgress,
              queryParameters: params,
              cancelToken: cancelToken ?? _cancelToken));

  /// getUri
  Future<ExtendedResponse<T>> getUri<T>(
    Uri uri, {
    Object? data,
    Options? options,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) =>
      _handle<T>(
          uri.path,
          dio.getUri<T>(uri,
              options: options,
              data: data,
              onReceiveProgress: onReceiveProgress,
              cancelToken: cancelToken ?? _cancelToken));

  /// post
  Future<ExtendedResponse<T>> post<T>(
    String path, {
    Map<String, dynamic>? params,
    Object? data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) =>
      _handle<T>(
          path,
          dio.post<T>(path,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
              queryParameters: params,
              options: options,
              data: data,
              cancelToken: cancelToken ?? _cancelToken));

  /// postUri
  Future<ExtendedResponse<T>> postUri<T>(
    Uri uri, {
    Object? data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) =>
      _handle<T>(
          uri.path,
          dio.postUri<T>(uri,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
              options: options,
              data: data,
              cancelToken: cancelToken ?? _cancelToken));

  /// put
  Future<ExtendedResponse<T>> put<T>(
    String path, {
    Map<String, dynamic>? params,
    Object? data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) =>
      _handle<T>(
          path,
          dio.put<T>(path,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
              queryParameters: params,
              options: options,
              data: data,
              cancelToken: cancelToken ?? _cancelToken));

  /// putUri
  Future<ExtendedResponse<T>> putUri<T>(
    Uri uri, {
    Object? data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) =>
      _handle<T>(
          uri.path,
          dio.putUri<T>(uri,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
              options: options,
              data: data,
              cancelToken: cancelToken ?? _cancelToken));

  /// head
  Future<ExtendedResponse<T>> head<T>(
    String path, {
    Map<String, dynamic>? params,
    Object? data,
    Options? options,
    CancelToken? cancelToken,
  }) =>
      _handle<T>(
          path,
          dio.head<T>(path,
              queryParameters: params,
              options: options,
              data: data,
              cancelToken: cancelToken ?? _cancelToken));

  /// headUri
  Future<ExtendedResponse<T>> headUri<T>(
    Uri uri, {
    Object? data,
    Options? options,
    CancelToken? cancelToken,
  }) =>
      _handle<T>(
          uri.path,
          dio.headUri<T>(uri,
              options: options,
              data: data,
              cancelToken: cancelToken ?? _cancelToken));

  /// delete
  Future<ExtendedResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? params,
    Object? data,
    Options? options,
    CancelToken? cancelToken,
  }) =>
      _handle<T>(
          path,
          dio.delete<T>(path,
              data: data,
              queryParameters: params,
              options: options,
              cancelToken: cancelToken ?? _cancelToken));

  /// deleteUri
  Future<ExtendedResponse<T>> deleteUri<T>(
    Uri uri, {
    Object? data,
    Options? options,
    CancelToken? cancelToken,
  }) =>
      _handle<T>(
          uri.path,
          dio.deleteUri<T>(uri,
              data: data,
              options: options,
              cancelToken: cancelToken ?? _cancelToken));

  /// patch
  Future<ExtendedResponse<T>> patch<T>(
    String path, {
    Map<String, dynamic>? params,
    Object? data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) =>
      _handle<T>(
          path,
          dio.patch<T>(path,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
              queryParameters: params,
              options: options,
              data: data,
              cancelToken: cancelToken ?? _cancelToken));

  /// patchUri
  Future<ExtendedResponse<T>> patchUri<T>(
    Uri uri, {
    Object? data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) =>
      _handle<T>(
          uri.path,
          dio.patchUri<T>(uri,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
              options: options,
              data: data,
              cancelToken: cancelToken ?? _cancelToken));

  /// request
  Future<ExtendedResponse<T>> request<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? params,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) =>
      _handle<T>(
          path,
          dio.request<T>(path,
              data: data,
              queryParameters: params,
              options: options,
              cancelToken: cancelToken ?? _cancelToken,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress));

  /// requestUri
  Future<ExtendedResponse<T>> requestUri<T>(
    Uri uri, {
    Object? data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) =>
      _handle<T>(
          uri.path,
          dio.requestUri<T>(uri,
              data: data,
              options: options,
              cancelToken: cancelToken ?? _cancelToken,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress));

  /// download
  Future<ExtendedResponse> download(
    String path,
    String savePath, {
    Object? data,
    Map<String, dynamic>? params,
    Options? options,
    ProgressCallback? onReceiveProgress,
    bool deleteOnError = true,
    CancelToken? cancelToken,
    String lengthHeader = Headers.contentLengthHeader,
  }) =>
      _handle(
          path,
          dioDownload.download(path, savePath,
              data: data,
              queryParameters: params,
              options: options,
              deleteOnError: deleteOnError,
              lengthHeader: lengthHeader,
              cancelToken: cancelToken ?? _cancelToken,
              onReceiveProgress: onReceiveProgress));

  /// downloadUri
  Future<ExtendedResponse> downloadUri(
    Uri uri,
    String savePath, {
    Object? data,
    Options? options,
    ProgressCallback? onReceiveProgress,
    bool deleteOnError = true,
    CancelToken? cancelToken,
    String lengthHeader = Headers.contentLengthHeader,
  }) =>
      _handle(
          uri.path,
          dioDownload.downloadUri(uri, savePath,
              data: data,
              options: options,
              deleteOnError: deleteOnError,
              lengthHeader: lengthHeader,
              cancelToken: cancelToken ?? _cancelToken,
              onReceiveProgress: onReceiveProgress));

  void cancel([dynamic reason]) {
    _cancelToken.cancel(reason);
    _cancelToken = CancelToken();
  }

  Future<ExtendedResponse<T>> _handle<T>(
      String path, Future<Response<T>> call) async {
    late ExtendedResponse<T> extendedResponse;
    try {
      extendedResponse = (await call).toExtendedResponse<T>();
    } on DioException catch (error) {
      extendedResponse = ExtendedResponse.mergeError<T>(error);
    } catch (error) {
      extendedResponse =
          ExtendedResponse.generalExtendedResponse<T>(error: error);
    }
    return extendedResponse;
  }
}

class ExtendedResponse<T> extends Response<T> {
  ExtendedResponse({
    super.data,
    super.statusCode,
    super.statusMessage,
    super.headers,
    required super.requestOptions,
    super.redirects,
    super.extra,
    super.isRedirect,
    this.error,
    this.type,
  });

  /// 请求返回类型 [DioException].toString
  String? type;

  /// error 信息
  Object? error;

  /// 保存的cookie
  List<String> cookie = <String>[];

  static ExtendedResponse<T> mergeError<T>(DioException err) {
    late ExtendedResponse<T> response;
    response = (err.response?.toExtendedResponse()) ??
        ExtendedResponse<T>(requestOptions: err.requestOptions);
    response.type = err.type.toString();
    response.error = err.error;
    response.cookie = <String>[];
    return response;
  }

  static ExtendedResponse<T> generalExtendedResponse<T>({dynamic error}) =>
      ExtendedResponse<T>(
          error: error,
          requestOptions: RequestOptions(path: ''),
          statusCode: 0,
          statusMessage: 'unknown exception',
          type: DioExceptionType.unknown.toString());
}
