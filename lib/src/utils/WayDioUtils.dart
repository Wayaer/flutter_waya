import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_waya/src/constant/WayConstant.dart';
import 'package:flutter_waya/src/model/ResponseModel.dart';

import 'WayUtils.dart';

//网络链接超时时间
const int HTTP_TIMEOUT_CONNECT = 5000;
//接收超时时间
const int HTTP_TIMEOUT_RECEIVE = 10000;
//请求数据类型 (4种): application/x-www-form-urlencoded 、multipart/form-data、application/json、text/xml
const HTTP_CONTENT_TYPE = [
  "application/x-www-form-urlencoded",
  "multipart/form-data",
  "application/json",
  "text/xml"
];

class WayDioUtils {
  static Dio dio;
  static DioError error;
  static BaseOptions _options;
  static int errorCode = 911;

  //单例模式
  factory WayDioUtils() => getHttp();

  static WayDioUtils getHttp({BaseOptions options}) {
    return WayDioUtils.internal(options: options);
  }

  WayDioUtils.internal({BaseOptions options}) {
    dio = Dio();
    _options = dio.options;
    _options.connectTimeout = options.connectTimeout ?? HTTP_TIMEOUT_CONNECT;
    _options.receiveTimeout = options.receiveTimeout ?? HTTP_TIMEOUT_RECEIVE;
    _options.contentType =
        options.contentType ?? HTTP_CONTENT_TYPE[2].toString();
    _options.responseType = options.responseType ?? ResponseType.json;
    Map<String, dynamic> _headers = {};
    _options.headers = options.headers ?? _headers;
    addInterceptors();
  }

  addInterceptors() {
    ResponseModel responseModel = ResponseModel(statusCode: errorCode);
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      // 在请求被发送之前做一些事情
      return options; //continue
      // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
      // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
      //
      // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
      // 这样请求将被中止并触发异常，上层catchError会被调用。
    }, onResponse: (Response response) async {
      if (response.statusCode == 200) {
        return response.data;
      } else {
        responseModel.statusCode = response.statusCode;
        responseModel.statusMessage = response.statusMessage;
        log(responseModel.toJson());
        return responseModel;
      }
    }, onError: (DioError e) async {
      // 当请求失败时做一些预处理
      responseModel.type = e.type.toString();
      if (e.type == DioErrorType.DEFAULT) {
        responseModel.statusCode = WayConstant.errorCode911;
        responseModel.statusMessage = WayConstant.errorMessage911;
        responseModel.statusMessageT = WayConstant.errorMessageT911;
      } else if (e.type == DioErrorType.CANCEL) {
        responseModel.statusCode = WayConstant.errorCode920;
        responseModel.statusMessage = WayConstant.errorMessage920;
        responseModel.statusMessageT = WayConstant.errorMessageT920;
      } else if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        responseModel.statusCode = WayConstant.errorCode930;
        responseModel.statusMessage = WayConstant.errorMessage930;
        responseModel.statusMessageT = WayConstant.errorMessageT930;
        responseModel.statusMessage = WayConstant.errorMessage911;
      } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
        responseModel.statusCode = WayConstant.errorCode940;
        responseModel.statusMessage = WayConstant.errorMessage940;
        responseModel.statusMessageT = WayConstant.errorMessageT940;
      } else if (e.type == DioErrorType.SEND_TIMEOUT) {
        responseModel.statusCode = WayConstant.errorCode950;
        responseModel.statusMessage = WayConstant.errorMessage950;
        responseModel.statusMessageT = WayConstant.errorMessageT950;
      } else if (e.type == DioErrorType.RESPONSE) {
        responseModel.statusCode = e.response.statusCode;
        responseModel.statusMessage =
            WayConstant.errorMessage960 + e.response.statusCode.toString();
        responseModel.statusMessageT = WayConstant.errorMessageT960;
      }
      log(responseModel.toJson());
      return responseModel;
    }));
  }

  Future get(String url, {Map<String, dynamic> params}) async {
    try {
      log("GET url:" + url + "  params:" + params.toString());
      Response response = await dio.get(url, queryParameters: params);
      log("GET url:" + url + '  responseData==  ' + response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      error = e;
      return jsonDecode(jsonDecode(error.message.toString()).toString());
    }
  }

  Future post(String url, {Map<String, dynamic> params, data}) async {
    try {
      log("POST url:" +
          url +
          "  params:" +
          params.toString() +
          "  data:" +
          data.toString());
      Response response =
          await dio.post(url, queryParameters: params, data: data);
      log("POST url:" + url + '  responseData==  ' + response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      error = e;
      return jsonDecode(error.message.toString());
    }
  }

  Future put(String url, Map<String, dynamic> param) async {
    try {
      log("PUT url:" + url + "  params:" + param.toString());
      Response response = await dio.put(url, queryParameters: param);
      log("PUT url:" + url + '  responseData==  ' + response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      error = e;
      return jsonDecode(error.message.toString());
    }
  }

  Future delete(String url, Map<String, dynamic> param) async {
    try {
      log("DELETE url:" + url + "  params:" + param.toString());
      Response response = await dio.delete(url, queryParameters: param);
      log("DELETE url:" + url + '  responseData==  ' + response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      error = e;
      return jsonDecode(error.message.toString());
    }
  }

  Future download(String url, String savePath,
      [ProgressCallback onReceiveProgress]) async {
    try {
      log("url:" + url + "  savePath:" + savePath.toString());
      dio.download(url, savePath, onReceiveProgress: (received, total) {
        onReceiveProgress(received, total);
      });
    } catch (e) {
      error = e;
      return error;
    }
  }
}
