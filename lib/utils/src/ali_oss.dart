import 'package:flutter_waya/flutter_waya.dart';

class AliOSS {
  factory AliOSS() => _singleton ??= AliOSS._();

  AliOSS._();

  static AliOSS? _singleton;

  /// 必须先初始化
  void initialize(String aliOSSAccessKeyId, String aliOSSKeySecret,
      {String? policyText}) {
    final String text = policyText ??
        '{"expiration": "2050-01-01T12:00:00.000Z","conditions": [["content-length-range", 0, 1048576000]]}';

    /// 进行base64编码
    _policyBase64 = text.utf8Encode.base64Encode;

    /// 再次进行utf8编码
    final List<int> policy = _policyBase64!.utf8Encode;

    /// 进行utf8 编码
    final List<int> key = aliOSSKeySecret.utf8Encode;

    /// 通过 HMAC ,使用sha1进行加密
    final List<int> signatureHMAC = Hmac(sha1, key).convert(policy).bytes;

    /// 最后一步，将上述所得进行base64 编码
    _signature = signatureHMAC.base64Encode;
    _aliOSSAccessKeyId = aliOSSAccessKeyId;
  }

  String _aliOSSAccessKeyId = '';

  String? _signature;

  String? _policyBase64;

  Future<FormData> setFormData(String filePath, String ossPath,
      {MediaType? contentType, String? fileName}) async {
    assert(_singleton != null, '请先调用 initialize');
    fileName ??=
        '${DateTime.now().millisecondsSinceEpoch}-${filePath.substring(filePath.lastIndexOf('/') + 1, filePath.length)}';
    return FormData.fromMap(<String, dynamic>{
      'file': await MultipartFile.fromFile(filePath, contentType: contentType),
      'key': ossPath,
      'policy': _policyBase64,
      'OSSAccessKeyId': _aliOSSAccessKeyId,
      'success_action_status': 200,
      'Signature': _signature,
      'Filename': fileName
    });
  }
}
