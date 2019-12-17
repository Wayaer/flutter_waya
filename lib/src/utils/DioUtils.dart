import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_waya/src/model/ResponseModel.dart';

import 'Utils.dart';

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

class DioUtils {
  static Dio dio;
  static DioError error;

  static BaseOptions _options;

  //单例模式
  factory DioUtils() => getHttp();

  static DioUtils getHttp({BaseOptions options}) {
    return DioUtils.internal(options: options);
  }

  DioUtils.internal({BaseOptions options}) {
    dio = Dio();
    if (options = null) {
      _options.connectTimeout = HTTP_TIMEOUT_CONNECT;
      _options.receiveTimeout = HTTP_TIMEOUT_RECEIVE;
      _options.contentType = HTTP_CONTENT_TYPE[2];
      _options.responseType = ResponseType.json;
    } else {
      _options = options;
    }
    addInterceptors();
  }

  addInterceptors() {
    ResponseModel responseModel =
    new ResponseModel({'code': "9999999", 'data': null, 'message': ''});
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
        responseModel.statusCode = response.statusCode.toString();
        responseModel.statusMessage = response.statusMessage;
        Utils.log(jsonEncode(responseModel).toString());
        return jsonEncode(responseModel).toString();
      }
    }, onError: (DioError e) async {
      // 当请求失败时做一些预处理
      if (e.type == DioErrorType.DEFAULT) {
        responseModel.statusCode = 'failed';
        responseModel.statusMessage = '网络请求失败';
        responseModel.statusMessageT = 'network_failed';
      } else if (e.type == DioErrorType.CANCEL) {
        responseModel.statusCode = 'cancel';
        responseModel.statusMessage = '网络请求已取消';
        responseModel.statusMessageT = 'network_cancel';
      } else if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        responseModel.statusCode = 'connect_timeout';
        responseModel.statusMessage = '网络请求链接超时';
        responseModel.statusMessageT = 'network_connect_timeout';
      } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
        responseModel.statusCode = 'receive_timeout';
        responseModel.statusMessage = '网络请求接收超时';
        responseModel.statusMessageT = 'network_receive_timeout';
      } else if (e.type == DioErrorType.RESPONSE) {
        responseModel.statusCode = e.response.statusCode.toString();
        responseModel.statusMessage =
        'HTTP请求错误,${e.response.statusCode.toString()}';
        responseModel.statusMessageT = 'network_response';
      } else if (e.type == DioErrorType.SEND_TIMEOUT) {
        responseModel.statusCode = 'send_timeout';
        responseModel.statusMessage = '网络发送超时';
        responseModel.statusMessageT = 'network_send_timeout';
      }
      Utils.log(jsonEncode(responseModel).toString());
      return jsonEncode(responseModel).toString();
    }));
  }

  Future get(String url, {Map<String, dynamic> param}) async {
    try {
      Utils.log("GET url:" + url + "  param:" + param.toString());
      Response response = await dio.get(url, queryParameters: param);
      Utils.log(
          "GET url:" + url + '  respronseData==  ' + response.toString());
      return response.toString();
    } catch (e) {
      error = e;
      return error.message;
    }
  }

  Future post(String url, {Map<String, dynamic> params, data}) async {
    try {
      Utils.log("POST url:" +
          url +
          "  param:" +
          params.toString() +
          "  data:" +
          data.toString());
      Response response =
      await dio.post(url, queryParameters: params, data: data);
      Utils.log(
          "POST url:" + url + '  respronseData==  ' + response.toString());
      return response.toString();
    } catch (e) {
      error = e;
      return error.message;
    }
  }

  Future put(String url, Map<String, dynamic> param) async {
    try {
      Utils.log("PUT url:" + url + "  param:" + param.toString());
      Response response = await dio.put(url, queryParameters: param);
      Utils.log(
          "PUT url:" + url + '  respronseData==  ' + response.toString());
      return response.toString();
    } catch (e) {
      error = e;
      return error.message;
    }
  }

  Future delete(String url, Map<String, dynamic> param) async {
    try {
      Utils.log("DELETE url:" + url + "  param:" + param.toString());
      Response response = await dio.delete(url, queryParameters: param);
      Utils.log(
          "DELETE url:" + url + '  respronseData==  ' + response.toString());
      return response.toString();
    } catch (e) {
      error = e;
      return error.message;
    }
  }

  Future download(String url, String savePath,
      [ProgressCallback onReceiveProgress]) async {
    try {
      Utils.log("url:" + url + "  savePath:" + savePath.toString());
      dio.download(url, savePath, onReceiveProgress: (received, total) {
        onReceiveProgress(received, total);
      });
    } catch (e) {
      error = e;
      return error;
    }
  }
}
