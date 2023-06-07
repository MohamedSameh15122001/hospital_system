class GetComplatedAppointmentsModel {
  List<Result>? result;

  GetComplatedAppointmentsModel.fromJson(Map<String, dynamic> json) {
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
  Patient? patient;
  List<Medications>? medications;
  dynamic schedule;
  String? createdAt;
  Nurse? nurse;
  void doctorNotes;
  bool? completed;
  int? iV;

  Result.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    patient =
        json['patient'] != null ? Patient.fromJson(json['patient']) : null;
    if (json['medications'] != null) {
      medications = <Medications>[];
      json['medications'].forEach((v) {
        medications!.add(Medications.fromJson(v));
      });
    }
    schedule = json['schedule'];
    createdAt = json['createdAt'];
    nurse = json['nurse'] != null ? Nurse.fromJson(json['nurse']) : null;
    // ignore: void_checks
    doctorNotes = json['doctorNotes'];
    completed = json['completed'];
    iV = json['__v'];
  }
}

class Patient {
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

  Patient.fromJson(Map<String, dynamic> json) {
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

class Medications {
  Medication? medication;
  String? dose;
  String? sId;

  Medications.fromJson(Map<String, dynamic> json) {
    medication = json['medication'] != null
        ? Medication.fromJson(json['medication'])
        : null;
    dose = json['dose'];
    sId = json['_id'];
  }
}

class Medication {
  String? sId;
  String? name;
  String? activeIngredients;
  String? doses;
  String? warnings;
  String? sideEffects;
  int? iV;

  Medication.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    activeIngredients = json['activeIngredients'];
    doses = json['doses'];
    warnings = json['warnings'];
    sideEffects = json['sideEffects'];
    iV = json['__v'];
  }
}

class Nurse {
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

  Nurse.fromJson(Map<String, dynamic> json) {
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
