import 'package:flutter_waya/flutter_waya.dart';

class LoggerInterceptor<T> extends InterceptorsWrapper {
  LoggerInterceptor({this.filteredUrls = const []});

  final List<String> filteredUrls;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String headers = '';
    options.headers.forEach((String key, dynamic value) {
      headers += ' | $key: $value';
    });
    log('┌------------------------------------------------------------------------------',
        hasDottedLine: false);
    log('''| [DIO] Request: ${options.method} ${options.uri}\n| QueryParameters:${options.queryParameters}\n| Data:${options.data}\n| Headers:$headers''',
        hasDottedLine: false);
    log('├------------------------------------------------------------------------------',
        hasDottedLine: false);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    bool forbidPrint = false;
    String requestUri = response.requestOptions.uri.toString();
    for (var element in filteredUrls) {
      if (requestUri.toString().contains(element)) {
        forbidPrint = true;
        break;
      }
    }
    log('| [DIO] Response [statusCode : ${response.statusCode}] [statusMessage : ${response.statusMessage}]',
        hasDottedLine: false);
    log('| [DIO] Request uri ($requestUri)', hasDottedLine: false);
    log('| [DIO] Response data: ${forbidPrint ? 'This data is not printed' : '\n${response.data}'}',
        hasDottedLine: false);
    log('└------------------------------------------------------------------------------',
        hasDottedLine: false);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    log('| [DIO] Response [statusCode : ${err.response?.statusCode}] [statusMessage : ${err.response?.statusMessage}]',
        hasDottedLine: false);
    log('| [DIO] Error: ${err.error}: ${err.response?.toString()}',
        hasDottedLine: false);
    log('|            : ${err.type}: ${err.message.toString()}',
        hasDottedLine: false);
    log('└------------------------------------------------------------------------------',
        hasDottedLine: false);
    super.onError(err, handler);
  }
}
