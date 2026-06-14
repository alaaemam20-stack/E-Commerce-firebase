class SignupRequestModel {
  String? name;
  String? email;
  String? password;
  String? avatar= "https://products_api.lorem.space/image/face?w=640&h=480";

  SignupRequestModel({this.name, this.email, this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['avatar'] = avatar;
    return data;
  }
}