class GetAllDoctorsModel {
  List<Result>? result;

  GetAllDoctorsModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }
}

class Result {
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

  Result.fromJson(Map<String, dynamic> json) {
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
