class SuccessModel {
  String? message;

  SuccessModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }
}
