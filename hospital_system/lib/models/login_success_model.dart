class LoginSuccessModel {
  String? message;
  String? token;

  LoginSuccessModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
  }
}
