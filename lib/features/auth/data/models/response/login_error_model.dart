class LoginErrorModel {
  String? message;
  int? statusCode;

  LoginErrorModel({this.message, this.statusCode});

  LoginErrorModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
  }

}