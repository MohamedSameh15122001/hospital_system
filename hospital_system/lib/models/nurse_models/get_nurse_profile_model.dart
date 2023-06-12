class GetNurseProfileModel {
  Data? data;

  GetNurseProfileModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  String? sId;
  String? name;
  String? address;
  String? department;
  String? phone;
  String? email;
  String? id;
  String? password;
  String? profileImage;
  String? fcmToken;
  String? role;
  int? iV;

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    address = json['address'];
    department = json['department'];
    phone = json['phone'];
    email = json['email'];
    id = json['Id'];
    password = json['password'];
    profileImage = json['profileImage'];
    fcmToken = json['fcmToken'];
    role = json['role'];
    iV = json['__v'];
  }
}
