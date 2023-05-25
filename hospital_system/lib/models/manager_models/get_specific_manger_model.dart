class GetSpecificMangerModel {
  Result? result;

  GetSpecificMangerModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }
}

class Result {
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

  Result.fromJson(Map<String, dynamic> json) {
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
