class GetDoctorProfileModel {
  Data? data;

  GetDoctorProfileModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  String? sId;
  String? name;
  String? specialty;
  String? phone;
  String? email;
  String? id;
  String? password;
  String? profileImage;
  String? cloudinaryId;
  String? role;
  int? iV;

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    specialty = json['specialty'];
    phone = json['phone'];
    email = json['email'];
    id = json['Id'];
    password = json['password'];
    profileImage = json['profileImage'];
    cloudinaryId = json['cloudinary_id'];
    role = json['role'];
    iV = json['__v'];
  }
}
