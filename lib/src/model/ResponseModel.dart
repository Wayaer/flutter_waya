import 'dart:convert';

class ResponseModel {
  String code;
  String statusCode;
  String statusMessage;
  String statusMessageT;
  String message;
  Object data;

//  ResponseModel({this.code, this.data, this.message});
  factory ResponseModel(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new ResponseModel.fromJson(json.decode(jsonStr))
          : new ResponseModel.fromJson(jsonStr);

  ResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'].toString();
    statusMessage = json['statusMessage'].toString();
    statusMessageT = json['statusMessageT'].toString();
    code = json['code'].toString();
    data = json['data'];
    message = json['message'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['data'] = this.data;
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    data['statusMessage'] = this.statusMessage;
    data['statusMessageT'] = this.statusMessageT;
    return data;
  }
}

