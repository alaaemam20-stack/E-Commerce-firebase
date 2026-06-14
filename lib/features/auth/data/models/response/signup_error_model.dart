class SignupErrorModel {
  List<String>? message;
  String? error;
  int? statusCode;

  SignupErrorModel({this.message, this.error, this.statusCode});

  SignupErrorModel.fromJson(Map<String, dynamic> json) {
    message = json['message'].cast<String>();
    error = json['error'];
    statusCode = json['statusCode'];
  }

}