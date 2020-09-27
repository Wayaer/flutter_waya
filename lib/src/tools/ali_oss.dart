import 'dart:convert';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:http_parser/http_parser.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

class AliOSS {
  factory AliOSS() => getInstance();

  AliOSS._internal({BaseOptions options, String aliOSSAccessKeyId, String url, String aliOSSKeySecret}) {
    BaseOptions baseOptions = BaseOptions();
    if (options != null) {
      baseOptions = options;
    } else {
      baseOptions.responseType = ResponseType.plain;
      baseOptions.contentType = HTTP_CONTENT_TYPE[1];
    }
    _dioTools = DioTools.getInstance(options: options);
    const String policyText =
        '{"expiration": "2050-01-01T12:00:00.000Z","conditions": [["content-length-range", 0, 1048576000]]}';
    //进行utf8编码
    final List<int> policyTextUtf8 = utf8.encode(policyText);
    //进行base64编码
    policyBase64 = base64.encode(policyTextUtf8);
    //再次进行utf8编码
    final List<int> policy = utf8.encode(policyBase64);
    //进行utf8 编码
    final List<int> key = utf8.encode(aliOSSKeySecret);
    //通过hmac,使用sha1进行加密
    final List<int> signatureHmac = Hmac(sha1, key).convert(policy).bytes;
    //最后一步，将上述所得进行base64 编码
    signature = base64.encode(signatureHmac);
    _aliOSSAccessKeyId = aliOSSAccessKeyId;
    _url = url;
  }

  DioTools _dioTools;
  String _aliOSSAccessKeyId = '';
  String _url = '';

  static AliOSS getInstance({BaseOptions options, String aliOSSAccessKeyId, String aliOSSKeySecret, String url}) =>
      _instance ??= AliOSS._internal(
          options: options, aliOSSAccessKeyId: aliOSSAccessKeyId, aliOSSKeySecret: aliOSSKeySecret, url: url);

  static AliOSS _instance;

  static AliOSS get instance => getInstance();

  static String signature = '';
  static String policyBase64 = '';

  Future<void> uploadFile(String filePath, String ossPath,
      {MediaType contentType,
      String customFileName,
      ProgressCallback onSendProgress,
      ProgressCallback onReceiveProgress}) async {
    String fileName = customFileName;
    if (fileName == null) {
      final String name = filePath.substring(filePath.lastIndexOf('/') + 1, filePath.length);
      final String suffix = name.substring(name.lastIndexOf('.') + 1, name.length);
      fileName = name + '.' + suffix;
    }
    final FormData formData = FormData.fromMap(<String, dynamic>{
      'file': await MultipartFile.fromFile(filePath, contentType: contentType),
      'key': ossPath + fileName,
      'policy': policyBase64,
      'OSSAccessKeyId': _aliOSSAccessKeyId,
      'success_action_status': 200,
      'Signature': signature,
      'Filename': fileName,
    });
    _dioTools.upload<dynamic>(_url,
        data: formData, onSendProgress: onSendProgress, onReceiveProgress: onReceiveProgress);
  }
}
