class GetPatientWithHisDiagnosisModel {
  Result? result;

  GetPatientWithHisDiagnosisModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }
}

class Result {
  String? sId;
  Patient? patient;
  Doctor? doctor;
  String? date;
  String? diagnosis;
  String? prescription;
  int? iV;

  Result.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    patient =
        json['patient'] != null ? Patient.fromJson(json['patient']) : null;
    doctor = json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null;
    date = json['date'];
    diagnosis = json['diagnosis'];
    prescription = json['prescription'];
    iV = json['__v'];
  }
}

class Patient {
  String? name;
  String? id;
  String? dateOfBirth;
  String? phone;

  Patient.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['Id'];
    dateOfBirth = json['dateOfBirth'];
    phone = json['phone'];
  }
}

class Doctor {
  String? name;
  String? specialty;
  String? id;

  Doctor.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    specialty = json['specialty'];
    id = json['Id'];
  }
}
