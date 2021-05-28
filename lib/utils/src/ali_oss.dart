import 'package:flutter_waya/flutter_waya.dart';

class AliOSS {
  factory AliOSS() => getInstance();

  AliOSS._internal(
      {required String aliOSSAccessKeyId,
      required String aliOSSKeySecret,
      String? policyText}) {
    final String text = policyText ??
        '{"expiration": "2050-01-01T12:00:00.000Z","conditions": [["content-length-range", 0, 1048576000]]}';

    /// 进行base64编码
    policyBase64 = text.utf8Encode.base64Encode;

    /// 再次进行utf8编码
    final List<int> policy = policyBase64!.utf8Encode;

    /// 进行utf8 编码
    final List<int> key = aliOSSKeySecret.utf8Encode;

    /// 通过hmac,使用sha1进行加密
    final List<int> signatureHmac = Hmac(sha1, key).convert(policy).bytes;

    /// 最后一步，将上述所得进行base64 编码
    signature = signatureHmac.base64Encode;
    _aliOSSAccessKeyId = aliOSSAccessKeyId;
  }

  String _aliOSSAccessKeyId = '';

  static AliOSS getInstance(
      {String? aliOSSAccessKeyId,
      String? aliOSSKeySecret,
      String? policyText}) {
    assert(aliOSSAccessKeyId != null && aliOSSKeySecret != null);
    return _instance ??= AliOSS._internal(
        aliOSSAccessKeyId: aliOSSAccessKeyId!,
        aliOSSKeySecret: aliOSSKeySecret!,
        policyText: policyText);
  }

  static AliOSS? _instance;

  static AliOSS get instance => getInstance();

  static String? signature = '';
  static String? policyBase64 = '';

  Future<FormData> initUploadFile(String filePath, String ossPath,
      {MediaType? contentType,
      String? fileName,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
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
}
