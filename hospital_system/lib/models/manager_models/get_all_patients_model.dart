class GetAllPatientsModel {
  List<Result>? result;

  GetAllPatientsModel.fromJson(Map<String, dynamic> json) {
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
  String? id;
  String? password;
  String? dateOfBirth;
  String? address;
  String? phone;
  String? email;
  String? medicalHistory;
  String? lastVisited;
  String? profileImage;
  String? cloudinaryId;
  String? role;
  int? iV;

  Result.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    id = json['Id'];
    password = json['password'];
    dateOfBirth = json['dateOfBirth'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    medicalHistory = json['medicalHistory'];
    lastVisited = json['lastVisited'];
    profileImage = json['profileImage'];
    cloudinaryId = json['cloudinary_id'];
    role = json['role'];
    iV = json['__v'];
  }
}
