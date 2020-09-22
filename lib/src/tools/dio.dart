import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_waya/flutter_waya.dart';

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

  Future<Map<String, dynamic>> get(String url, {Map<String, dynamic> params}) async {
    try {
      log("GET url:" + url + "  params:" + params.toString());
      Response response = await _dio.get(url, queryParameters: params, cancelToken: _cancelToken);
      log("GET url:" + url + '  responseData==  ' + response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      _error = e;
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
      log("Download url:" + url + "  savePath:" + savePath.toString());
      return await Dio().download(url, savePath, cancelToken: _cancelToken,
          onReceiveProgress: (int received, int total) {
        onReceiveProgress(received, total);
      });
    } catch (e) {
      return e;
    }
  }

  Future upload(String url,
      {Map<String, dynamic> params, data, ProgressCallback onSendProgress, ProgressCallback onReceiveProgress}) async {
    try {
      log("Upload url:" + url + "  params:" + params.toString() + "  data:" + data.toString());
      return await Dio().post(url,
          queryParameters: params,
          data: data,
          cancelToken: _cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
    } catch (e) {
      return e;
    }
  }

  void cancel() => _cancelToken.cancelError;
}

class InterceptorWrap extends InterceptorsWrapper {
  final CookieJar cookieJar;
  final ResponseModel responseModel = ResponseModel();

  InterceptorWrap(this.cookieJar);

  @override
  Future onRequest(RequestOptions options) async {
    /// 在请求被发送之前做一些事情
    /// 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
    /// 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
    /// 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
    /// 这样请求将被中止并触发异常，上层catchError会被调用。 return options;
    if (cookieJar != null) {
      var cookies = cookieJar?.loadForRequest(options.uri);
      cookies.removeWhere((cookie) {
        if (cookie.expires != null) {
          return cookie.expires.isBefore(DateTime.now());
        }
        return false;
      });
      String cookie = getCookies(cookies);
      if (cookie.isNotEmpty) options.headers[HttpHeaders.cookieHeader] = cookie;
    }
  }

  @override
  Future onResponse(Response response) async {
    if (cookieJar != null) saveCookies(response, responseModel);
    responseModel.statusCode = response.statusCode;
    if (response.statusCode == 200) {
      responseModel.statusMessage = 'success';
      responseModel.statusMessageT = 'success';
      if (response.data is Map || jsonDecode(response.data) is Map) {
        responseModel.data = response.data;
        return responseModel.toMap();
      } else {
        responseModel.data = response.data;
        return responseModel.toMap();
      }
    } else {
      responseModel.statusCode = response.statusCode;
      responseModel.statusMessage = response.statusMessage;
      responseModel.statusMessageT = response.statusMessage;
      return responseModel;
    }
  }

  @override
  Future onError(DioError e) async {
    responseModel.type = e.type.toString();
    if (e.type == DioErrorType.DEFAULT) {
      responseModel.statusCode = ConstConstant.errorCode404;
      responseModel.statusMessage = ConstConstant.errorMessage404;
      responseModel.statusMessageT = ConstConstant.errorMessageT404;
    } else if (e.type == DioErrorType.CANCEL) {
      responseModel.statusCode = ConstConstant.errorCode420;
      responseModel.statusMessage = ConstConstant.errorMessage420;
      responseModel.statusMessageT = ConstConstant.errorMessageT420;
    } else if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      responseModel.statusCode = ConstConstant.errorCode408;
      responseModel.statusMessage = ConstConstant.errorMessage408;
      responseModel.statusMessageT = ConstConstant.errorMessageT408;
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      responseModel.statusCode = ConstConstant.errorCode502;
      responseModel.statusMessage = ConstConstant.errorMessage502;
      responseModel.statusMessageT = ConstConstant.errorMessageT502;
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      responseModel.statusCode = ConstConstant.errorCode450;
      responseModel.statusMessage = ConstConstant.errorMessage450;
      responseModel.statusMessageT = ConstConstant.errorMessageT450;
    } else if (e.type == DioErrorType.RESPONSE) {
      responseModel.statusCode = e.response.statusCode;
      responseModel.statusMessage = ConstConstant.errorMessage500 + e.response.statusCode.toString();
      responseModel.statusMessageT = ConstConstant.errorMessageT500;
    }
    return jsonEncode(responseModel.toMap());
  }

  saveCookies(Response response, ResponseModel responseModel) {
    if (response != null && response.headers != null) {
      List<String> cookies = response.headers[HttpHeaders.setCookieHeader];
      responseModel.cookie = cookies;
      if (cookies != null) {
        cookieJar.saveFromResponse(
          response.request.uri,
          cookies.map((str) => Cookie.fromSetCookieValue(str)).toList(),
        );
      }
    }
  }

  static String getCookies(List<Cookie> cookies) =>
      cookies.map((cookie) => "${cookie.name}=${cookie.value}").join('; ');
}
