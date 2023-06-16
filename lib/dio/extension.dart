part of 'dio.dart';

extension ExtensionExtendedResponse on ExtendedResponse {
  Map<String, dynamic> toMap() => {
        'headers': headers.map,
        'requestOptions': requestOptions.toMap(),
        'data': data,
        'statusCode': statusCode,
        'statusMessage': statusMessage,
        'extra': extra,
        'realUri': realUri.toMap(),
        'isRedirect': isRedirect,
        'type': type,
        'cookie': cookie,
        'error': error,
        'redirects': redirects.builder((item) => {
              'location': item.location,
              'statusCode': item.statusCode,
              'method': item.method,
            })
      };
}

extension ExtensionDioException on DioException {
  Map<String, dynamic> toMap() => {
        'error': error,
        'type': type.name,
        'message': message,
        'requestOptions': requestOptions.toMap(),
        'response': response?.toMap(),
        'stackTrace': stackTrace.toString(),
        // 'errorTime': responseTime?.format(DateTimeDist.yearMillisecond),
      };
}

extension ExtensionResponse on Response {
  Map<String, dynamic> toMap() => {
        'headers': headers.map,
        'requestOptions': requestOptions.toMap(),
        'data': data,
        'statusCode': statusCode,
        'statusMessage': statusMessage,
        'extra': extra,
        'realUri': realUri.toMap(),
        'isRedirect': isRedirect,
        'redirects': redirects.builder((item) => {
              'location': item.location,
              'statusCode': item.statusCode,
              'method': item.method,
            })
      };

  ExtendedResponse<T> toExtendedResponse<T>() => ExtendedResponse<T>(
      requestOptions: requestOptions,
      data: data,
      statusCode: statusCode,
      statusMessage: statusMessage,
      isRedirect: isRedirect,
      redirects: redirects,
      extra: extra,
      headers: headers);
}

extension ExtensionRequestOptions on RequestOptions {
  Map<String, dynamic> toMap() => {
        'baseUrl': baseUrl,
        'path': path,
        'uri': uri.toMap(),
        'method': method,
        'requestHeaders': headers,
        'data': data.toString(),
        'queryParameters': queryParameters,
        'contentType': contentType,
        'receiveTimeout': receiveTimeout?.toString(),
        'sendTimeout': sendTimeout?.toString(),
        'connectTimeout': connectTimeout?.toString(),
        'extra': extra,
        'responseType': responseType.toString(),
        'receiveDataWhenStatusError': receiveDataWhenStatusError,
        'followRedirects': followRedirects,
        'maxRedirects': maxRedirects,
      };
}
