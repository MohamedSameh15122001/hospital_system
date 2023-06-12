class GetPatientProfileModel {
  Data? data;

  GetPatientProfileModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  String? sId;
  String? name;
  String? id;
  String? password;
  String? sex;
  String? dateOfBirth;
  String? address;
  String? phone;
  String? email;
  String? medicalHistory;
  String? lastVisited;
  String? profileImage;
  String? fcmToken;
  String? role;
  int? iV;

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    id = json['Id'];
    password = json['password'];
    sex = json['sex'];
    dateOfBirth = json['dateOfBirth'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    medicalHistory = json['medicalHistory'];
    lastVisited = json['lastVisited'];
    profileImage = json['profileImage'];
    fcmToken = json['fcmToken'];
    role = json['role'];
    iV = json['__v'];
  }
}
