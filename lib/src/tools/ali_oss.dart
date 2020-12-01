import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:http_parser/http_parser.dart';

class AliOSS {
  factory AliOSS() => getInstance();

  AliOSS._internal(
      {String aliOSSAccessKeyId, String aliOSSKeySecret, String policyText}) {
    final String text = policyText ??
        '{"expiration": "2050-01-01T12:00:00.000Z","conditions": [["content-length-range", 0, 1048576000]]}';

    /// 进行utf8编码
    final List<int> policyTextUtf8 = utf8.encode(text);

    /// 进行base64编码
    policyBase64 = base64.encode(policyTextUtf8);

    /// 再次进行utf8编码
    final List<int> policy = utf8.encode(policyBase64);

    /// 进行utf8 编码
    final List<int> key = utf8.encode(aliOSSKeySecret);

    /// 通过hmac,使用sha1进行加密
    final List<int> signatureHmac = Hmac(sha1, key).convert(policy).bytes;

    /// 最后一步，将上述所得进行base64 编码
    signature = base64.encode(signatureHmac);
    _aliOSSAccessKeyId = aliOSSAccessKeyId;
  }

  String _aliOSSAccessKeyId = '';

  static AliOSS getInstance(
      [String aliOSSAccessKeyId, String aliOSSKeySecret, String policyText]) {
    assert(aliOSSAccessKeyId != null && aliOSSKeySecret != null);
    return _instance ??= AliOSS._internal(
        aliOSSAccessKeyId: aliOSSAccessKeyId,
        aliOSSKeySecret: aliOSSKeySecret,
        policyText: policyText);
  }

  static AliOSS _instance;

  static AliOSS get instance => getInstance();

  static String signature = '';
  static String policyBase64 = '';

  Future<FormData> initUploadFile(String filePath, String ossPath,
      {MediaType contentType,
      String customFileName,
      ProgressCallback onSendProgress,
      ProgressCallback onReceiveProgress}) async {
    String fileName = customFileName;
    fileName ??=
        filePath.substring(filePath.lastIndexOf('/') + 1, filePath.length);
    return FormData.fromMap(<String, dynamic>{
      'file': await MultipartFile.fromFile(filePath, contentType: contentType),
      'key': ossPath,
      'policy': policyBase64,
      'OSSAccessKeyId': _aliOSSAccessKeyId,
      'success_action_status': 200,
      'Signature': signature,
      'Filename': fileName
    });
  }

  static Future<AppConfig> getAppConfig(String name,
      {String configName}) async {
    final String fileName = configName ?? 'appConfig';
    final String url = '${ConstConstant.oss}/$name/$fileName';
    final ResponseModel res = await DioTools.instance.getHttp(url);
    AppConfig appConfig =
        AppConfig(open: true, androidVersionCode: 1, iosVersionCode: 1);
    if (res != null &&
        res.statusCode == 200 &&
        res.data != null &&
        res.data is String) {
      final Map<dynamic, dynamic> map =
          jsonDecode(res.data.toString()) as Map<dynamic, dynamic>;
      if (res.data != null) appConfig = AppConfig.fromJson(map);
    }
    return appConfig;
  }
}
