import 'package:flutter_waya/flutter_waya.dart';

class LoggerInterceptor<T> extends InterceptorsWrapper {
  LoggerInterceptor({this.filteredApi = const []});

  final List<String> filteredApi;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String headers = '';
    options.headers.forEach((String key, dynamic value) {
      headers += ' | $key: $value';
    });
    log('┌------------------------------------------------------------------------------',
        crossLine: false);
    log('''| [DIO] Request: ${options.method} ${options.uri}\n| QueryParameters:${options.queryParameters}\n| Data:${options.data}\n| Headers:$headers''',
        crossLine: false);
    log('├------------------------------------------------------------------------------',
        crossLine: false);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    bool forbidPrint = false;
    String requestUri = response.requestOptions.uri.toString();
    for (var element in filteredApi) {
      if (requestUri.toString().contains(element)) {
        forbidPrint = true;
        break;
      }
    }
    log('| [DIO] Response [statusCode : ${response.statusCode}] [statusMessage : ${response.statusMessage}]',
        crossLine: false);
    log('| [DIO] Request uri ($requestUri)', crossLine: false);
    log('| [DIO] Response data: ${forbidPrint ? 'This data is not printed' : '\n${response.data}'}',
        crossLine: false);
    log('└------------------------------------------------------------------------------',
        crossLine: false);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    log('| [DIO] Response [statusCode : ${err.response?.statusCode}] [statusMessage : ${err.response?.statusMessage}]',
        crossLine: false);
    log('| [DIO] Error: ${err.error}: ${err.response?.toString()}',
        crossLine: false);
    log('|            : ${err.type}: ${err.message.toString()}',
        crossLine: false);
    log('└------------------------------------------------------------------------------',
        crossLine: false);
    super.onError(err, handler);
  }
}
