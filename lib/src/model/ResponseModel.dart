class ResponseModel {
  int statusCode;

  ///error状态
  String statusMessage;

  ///error 状态消息
  String statusMessageT;

  ///error 语言翻译版 消息
  String type;
  Object data;
  List<String> cookie;

  ResponseModel({
    this.data,
    this.type,
    this.statusCode,
    this.statusMessage,
    this.statusMessageT,
  });

  ResponseModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    statusCode = json['statusCode'];
    cookie = json['cookie'];
    statusMessage = json['statusMessage'].toString();
    statusMessageT = json['statusMessageT'].toString();
    data = json['data'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = this.type;
    data['data'] = this.data;
    data['cookie'] = this.cookie;
    data['statusCode'] = this.statusCode;
    data['statusMessage'] = this.statusMessage;
    data['statusMessageT'] = this.statusMessageT;
    return data;
  }
}
