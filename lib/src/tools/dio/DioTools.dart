import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_waya/src/tools/LogTools.dart';
import 'package:flutter_waya/src/tools/dio/InterceptorWrap.dart';

//网络链接超时时间
const int HTTP_TIMEOUT_CONNECT = 5000;
//接收超时时间
const int HTTP_TIMEOUT_RECEIVE = 10000;
//请求数据类型 (4种): application/x-www-form-urlencoded 、multipart/form-data、application/json、text/xml
const List<String> HTTP_CONTENT_TYPE = [
  "application/x-www-form-urlencoded",
  "multipart/form-data",
  "application/json",
  "text/xml"
];

class DioTools {
  static Dio _dio;
  static DioError _error;
  static CancelToken _cancelToken = CancelToken();
  static BaseOptions _options;
  static InterceptorWrap _interceptorWrap;

  //单例模式
  factory DioTools() => getHttp();

  ///安装  cookie_jar  cookieJar:CookieJar()
  static DioTools getHttp({BaseOptions options, CookieJar cookieJar}) {
    return DioTools.internal(options: options, cookieJar: cookieJar);
  }

  DioTools.internal({BaseOptions options, CookieJar cookieJar}) {
    _dio = Dio();
    if (options != null) {
      Map<String, dynamic> _headers = {};
      _options = _dio.options;
      _options.connectTimeout = options?.connectTimeout ?? HTTP_TIMEOUT_CONNECT;
      _options.receiveTimeout = options?.receiveTimeout ?? HTTP_TIMEOUT_RECEIVE;
      _options.contentType = options?.contentType ?? HTTP_CONTENT_TYPE[2];
      _options.responseType = options?.responseType ?? ResponseType.json;
      _options.headers = options?.headers ?? _headers;
    }
    _interceptorWrap = InterceptorWrap(cookieJar);
    _dio.interceptors.add(_interceptorWrap);
  }

  Future<Map<String, dynamic>> get(String url,
      {Map<String, dynamic> params}) async {
    try {
      log("GET url:" + url + "  params:" + params.toString());
      Response response = await _dio.get(url,
          queryParameters: params, cancelToken: _cancelToken);
      log("GET url:" + url + '  responseData==  ' + response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      _error = e;
      return jsonDecode(_error.message);
    }
  }

  Future<Map<String, dynamic>> post(String url,
      {Map<String, dynamic> params, data}) async {
    try {
      log("POST url:" +
          url +
          "  params:" +
          params.toString() +
          "  data:" +
          data.toString());
      Response response = await _dio.post(url,
          queryParameters: params, data: data, cancelToken: _cancelToken);
      log("POST url:" + url + '  responseData==  ' + response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      _error = e;
      return jsonDecode(_error.message);
    }
  }

  Future<Map<String, dynamic>> put(String url,
      {Map<String, dynamic> params, data}) async {
    try {
      log("PUT url:" +
          url +
          "  params:" +
          params.toString() +
          "  data:" +
          data.toString());
      Response response = await _dio.put(url,
          data: data, queryParameters: params, cancelToken: _cancelToken);
      log("PUT url:" + url + '  responseData==  ' + response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      _error = e;
      return jsonDecode(_error.message);
    }
  }

  Future<Map<String, dynamic>> delete(String url,
      {Map<String, dynamic> params, data}) async {
    try {
      log("DELETE url:" +
          url +
          "  params:" +
          params.toString() +
          "  data:" +
          data.toString());
      Response response = await _dio.delete(url,
          queryParameters: params, data: data, cancelToken: _cancelToken);
      log("DELETE url:" + url + '  responseData==  ' + response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      _error = e;
      return jsonDecode(_error.message);
    }
  }

  //下载文件需要申请文件储存权限
  Future download(String url, String savePath,
      [ProgressCallback onReceiveProgress]) async {
    try {
      log("Download url:" + url + "  savePath:" + savePath.toString());
      _dio.interceptors.remove(_interceptorWrap);
      return await _dio.download(url, savePath, cancelToken: _cancelToken,
          onReceiveProgress: (int received, int total) {
        onReceiveProgress(received, total);
      });
    } catch (e) {
      return e;
    }
  }

  Future upload(String url,
      {Map<String, dynamic> params,
      data,
      ProgressCallback onSendProgress,
      ProgressCallback onReceiveProgress}) async {
    try {
      _dio.interceptors.remove(_interceptorWrap);
      log("Upload url:" +
          url +
          "  params:" +
          params.toString() +
          "  data:" +
          data.toString());
      return await _dio.post(url,
          queryParameters: params,
          data: data,
          cancelToken: _cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
    } catch (e) {
      return e;
    }
  }

  cancel() {
    _cancelToken.cancelError;
  }
}
