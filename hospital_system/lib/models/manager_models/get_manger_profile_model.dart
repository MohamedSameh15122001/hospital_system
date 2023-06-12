class GetMangerProfileModel {
  Data? data;

  GetMangerProfileModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  String? sId;
  String? name;
  String? phone;
  String? email;
  String? id;
  String? password;
  String? role;
  String? profileImage;
  String? cloudinaryId;
  int? iV;

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    id = json['Id'];
    password = json['password'];
    role = json['role'];
    profileImage = json['profileImage'];
    cloudinaryId = json['cloudinary_id'];
    iV = json['__v'];
  }
}
