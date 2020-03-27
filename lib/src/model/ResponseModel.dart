class ResponseModel {
  int statusCode; //error状态
  String statusMessage; //error 状态消息
  String statusMessageT; //error 语言翻译版 消息
  String type;
  Object data;

  ResponseModel({
    this.data,
    this.type,
    this.statusCode,
    this.statusMessage,
    this.statusMessageT,
  });

  ResponseModel.fromJson(Map<String, dynamic> json) {
    type = json['type'].toString();
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'].toString();
    statusMessageT = json['statusMessageT'].toString();
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['data'] = this.data;
    data['statusCode'] = this.statusCode;
    data['statusMessage'] = this.statusMessage;
    data['statusMessageT'] = this.statusMessageT;
    return data;
  }
}
