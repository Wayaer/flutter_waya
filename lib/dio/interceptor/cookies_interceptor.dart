import 'package:flutter_waya/flutter_waya.dart';

/// 请求cookie
typedef SetCookieOnRequest = Map<String, dynamic> Function(
    RequestOptions options);

/// 获取cookie
typedef GetCookiesOnResponse = void Function(Response<dynamic> response);

class CookiesInterceptor<T> extends InterceptorsWrapper {
  CookiesInterceptor({this.setCookie, this.getCookies});

  /// 拦截器中 请求回调添加 cookie 方法
  final SetCookieOnRequest? setCookie;

  /// 拦截器中 返回回调添加 获取cookie 方法
  final GetCookiesOnResponse? getCookies;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final cookie = setCookie?.call(options);
    if (cookie != null) {
      cookie.builderEntry((entry) {
        options.headers[entry.key] = entry.value;
      });
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    getCookies?.call(response);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response != null) getCookies?.call(err.response!);
    super.onError(err, handler);
  }
}
