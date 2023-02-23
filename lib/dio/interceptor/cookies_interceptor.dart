import 'package:flutter_waya/flutter_waya.dart';

/// 请求cookie
typedef SetCookieOnRequest = Map<String, dynamic> Function(
    RequestOptions options);

/// 获取cookie
typedef GetCookiesOnResponse = void Function(Response<dynamic> response);

class CookiesInterceptor extends InterceptorsWrapper {
  CookiesInterceptor({this.setCookies, this.getCookies});

  /// 拦截器中 请求回调添加 cookie 方法
  final SetCookieOnRequest? setCookies;

  /// 拦截器中 返回回调添加 获取cookie 方法
  final GetCookiesOnResponse? getCookies;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final cookies = setCookies?.call(options);
    if (cookies != null) options.headers.addAll(cookies);
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
