import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_waya/src/constant/WayConstant.dart';
import 'package:flutter_waya/src/model/ResponseModel.dart';
import 'package:flutter_waya/src/utils/LogUtils.dart';

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

class DioBaseUtils {
  static Dio dio;
  static DioError error;
  static CancelToken cancelToken = CancelToken();
  static BaseOptions _options;
  static int errorCode = 911;
  static bool cookie = false;
  static var cookieJar = CookieJar();

  //单例模式
  factory DioBaseUtils() => getHttp();

  static DioBaseUtils getHttp({BaseOptions options, bool addCookie: false}) {
    cookie = addCookie;
    return DioBaseUtils.internal(options: options);
  }

  DioBaseUtils.internal({BaseOptions options}) {
    dio = Dio();
    if (options != null) {
      Map<String, dynamic> _headers = {};
      _options = dio.options;
      _options.connectTimeout = options?.connectTimeout ?? HTTP_TIMEOUT_CONNECT;
      _options.receiveTimeout = options?.receiveTimeout ?? HTTP_TIMEOUT_RECEIVE;
      _options.contentType = options?.contentType ?? HTTP_CONTENT_TYPE[2];
      _options.responseType = options?.responseType ?? ResponseType.json;
      _options.headers = options?.headers ?? _headers;
    }
    addInterceptors();
  }

  saveCookies(Response response, ResponseModel responseModel) {
    if (response != null && response.headers != null) {
      List<String> cookies = response.headers[HttpHeaders.setCookieHeader];
      log(cookies);
      responseModel.cookie = cookies;
      if (cookies != null) {
        cookieJar.saveFromResponse(
          response.request.uri,
          cookies.map((str) => Cookie.fromSetCookieValue(str)).toList(),
        );
      }
    }
  }

  addInterceptors() {
    ResponseModel responseModel = ResponseModel();
    dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      if (cookie) {
        log(options.uri);
        var cookies = cookieJar.loadForRequest(options.uri);
        cookies.removeWhere((cookie) {
          if (cookie.expires != null) {
            return cookie.expires.isBefore(DateTime.now());
          }
          return false;
        });
        String cookie = getCookies(cookies);
        if (cookie.isNotEmpty) options.headers[HttpHeaders.cookieHeader] = cookie;
      }
      // 在请求被发送之前做一些事情
      return options; //continue
      // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
      // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
      //
      // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
      // 这样请求将被中止并触发异常，上层catchError会被调用。
    }, onResponse: (Response response) async {
      saveCookies(response, responseModel);
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
        log(responseModel.toMap());
        return responseModel;
      }
    }, onError: (DioError e) async {
      saveCookies(e.response, responseModel);
//      log(e.type.runtimeType);
      // 当请求失败时做一些预处理
      responseModel.type = e.type.toString();
      if (e.type == DioErrorType.DEFAULT) {
        responseModel.statusCode = WayConstant.errorCode404;
        responseModel.statusMessage = WayConstant.errorMessage404;
        responseModel.statusMessageT = WayConstant.errorMessageT404;
      } else if (e.type == DioErrorType.CANCEL) {
        responseModel.statusCode = WayConstant.errorCode420;
        responseModel.statusMessage = WayConstant.errorMessage420;
        responseModel.statusMessageT = WayConstant.errorMessageT420;
      } else if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        responseModel.statusCode = WayConstant.errorCode408;
        responseModel.statusMessage = WayConstant.errorMessage408;
        responseModel.statusMessageT = WayConstant.errorMessageT408;
      } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
        responseModel.statusCode = WayConstant.errorCode502;
        responseModel.statusMessage = WayConstant.errorMessage502;
        responseModel.statusMessageT = WayConstant.errorMessageT502;
      } else if (e.type == DioErrorType.SEND_TIMEOUT) {
        responseModel.statusCode = WayConstant.errorCode450;
        responseModel.statusMessage = WayConstant.errorMessage450;
        responseModel.statusMessageT = WayConstant.errorMessageT450;
      } else if (e.type == DioErrorType.RESPONSE) {
        responseModel.statusCode = e.response.statusCode;
        responseModel.statusMessage = WayConstant.errorMessage500 + e.response.statusCode.toString();
        responseModel.statusMessageT = WayConstant.errorMessageT500;
      }
      log(responseModel.toMap());
      return jsonEncode(responseModel.toMap());
    }));
  }

  Future<Map<String, dynamic>> get(String url, {Map<String, dynamic> params}) async {
    try {
      log("GET url:" + url + "  params:" + params.toString());
      Response response = await dio.get(url, queryParameters: params, cancelToken: cancelToken);
      log("GET url:" + url + '  responseData==  ' + response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      error = e;
      log(error);
      return jsonDecode(error.message);
    }
  }

  Future<Map<String, dynamic>> post(String url, {Map<String, dynamic> params, data}) async {
    try {
      log("POST url:" + url + "  params:" + params.toString() + "  data:" + data.toString());
      Response response = await dio.post(url, queryParameters: params, data: data, cancelToken: cancelToken);
      log("POST url:" + url + '  responseData==  ' + response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      error = e;
      return jsonDecode(error.message);
    }
  }

  Future<Map<String, dynamic>> put(String url, Map<String, dynamic> param) async {
    try {
      log("PUT url:" + url + "  params:" + param.toString());
      Response response = await dio.put(url, queryParameters: param, cancelToken: cancelToken);
      log("PUT url:" + url + '  responseData==  ' + response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      error = e;
      return jsonDecode(error.message);
    }
  }

  Future<Map<String, dynamic>> delete(String url, Map<String, dynamic> param) async {
    try {
      log("DELETE url:" + url + "  params:" + param.toString());
      Response response = await dio.delete(url, queryParameters: param, cancelToken: cancelToken);
      log("DELETE url:" + url + '  responseData==  ' + response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      error = e;
      return jsonDecode(error.message);
    }
  }

  //下载文件需要申请文件储存权限
  Future download(String url, String savePath, [ProgressCallback onReceiveProgress]) async {
    try {
      log("url:" + url + "  savePath:" + savePath.toString());
      return await Dio().download(url, savePath, cancelToken: cancelToken,
          onReceiveProgress: (int received, int total) {
            onReceiveProgress(received, total);
          });
    } catch (e) {
      error = e;
      return jsonDecode(error.message);
    }
  }

  cancel() {
    cancelToken.cancelError;
  }

  static String getCookies(List<Cookie> cookies) {
    return cookies.map((cookie) => "${cookie.name}=${cookie.value}").join('; ');
  }
}
