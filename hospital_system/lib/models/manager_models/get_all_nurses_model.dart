class GetAllNursesModel {
  List<Result>? result;

  GetAllNursesModel.fromJson(Map<String, dynamic> json) {
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
  String? address;
  String? department;
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
    address = json['address'];
    department = json['department'];
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
