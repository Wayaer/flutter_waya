import 'dart:convert';

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
  static bool _cookie = false;

  //单例模式
  factory DioTools() => getHttp();

  static DioTools getHttp({BaseOptions options, bool addCookie: false}) {
    _cookie = addCookie;
    return DioTools.internal(options: options);
  }

  DioTools.internal({BaseOptions options}) {
    _dio = Dio();
    if (options != null) {
      Map<String, dynamic> _headers = {};
      _options = _dio.options;
      _options.connectTimeout = options?.connectTimeout ?? HTTP_TIMEOUT_CONNECT;
      _options.receiveTimeout = options?.receiveTimeout ?? HTTP_TIMEOUT_RECEIVE;
      _options.contentType = options?.contentType ?? HTTP_CONTENT_TYPE[2];
      _options.responseType = options?.responseType ?? ResponseType.json;
      _options.headers = options?.headers ?? _headers;
      log('header=> ' + options.headers.toString());
    }
    _dio.interceptors.add(InterceptorWrap(cookie: _cookie));
  }


  Future<Map<String, dynamic>> get(String url, {Map<String, dynamic> params}) async {
    try {
      log("GET url:" + url + "  params:" + params.toString());
      Response response = await _dio.get(url, queryParameters: params, cancelToken: _cancelToken);
      log("GET url:" + url + '  responseData==  ' + response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      _error = e;
      log(_error);
      return jsonDecode(_error.message);
    }
  }

  Future<Map<String, dynamic>> post(String url, {Map<String, dynamic> params, data}) async {
    try {
      log("POST url:" + url + "  params:" + params.toString() + "  data:" + data.toString());
      Response response = await _dio.post(url, queryParameters: params, data: data, cancelToken: _cancelToken);
      log("POST url:" + url + '  responseData==  ' + response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      _error = e;
      return jsonDecode(_error.message);
    }
  }

  Future<Map<String, dynamic>> put(String url, {Map<String, dynamic> params, data}) async {
    try {
      log("PUT url:" + url + "  params:" + params.toString() + "  data:" + data.toString());
      Response response = await _dio.put(url, data: data, queryParameters: params, cancelToken: _cancelToken);
      log("PUT url:" + url + '  responseData==  ' + response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      _error = e;
      return jsonDecode(_error.message);
    }
  }

  Future<Map<String, dynamic>> delete(String url, {Map<String, dynamic> params, data}) async {
    try {
      log("DELETE url:" + url + "  params:" + params.toString() + "  data:" + data.toString());
      Response response = await _dio.delete(url, queryParameters: params, data: data, cancelToken: _cancelToken);
      log("DELETE url:" + url + '  responseData==  ' + response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      _error = e;
      return jsonDecode(_error.message);
    }
  }

  //下载文件需要申请文件储存权限
  Future download(String url, String savePath, [ProgressCallback onReceiveProgress]) async {
    try {
      log("url:" + url + "  savePath:" + savePath.toString());
      return await Dio().download(url, savePath, cancelToken: _cancelToken,
          onReceiveProgress: (int received, int total) {
            onReceiveProgress(received, total);
          });
    } catch (e) {
      _error = e;
      return jsonDecode(_error.message);
    }
  }

  cancel() {
    _cancelToken.cancelError;
  }


}
