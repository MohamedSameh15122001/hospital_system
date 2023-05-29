class GetPatientWithHisDiagnosisModel {
  Result? result;

  GetPatientWithHisDiagnosisModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }
}

class Result {
  String? sId;
  Details? patient;
  Details? doctor;
  String? date;
  String? diagnosis;
  String? prescription;
  int? iV;

  Result.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    patient =
        json['patient'] != null ? Details.fromJson(json['patient']) : null;
    doctor = json['doctor'] != null ? Details.fromJson(json['doctor']) : null;
    date = json['date'];
    diagnosis = json['diagnosis'];
    prescription = json['prescription'];
    iV = json['__v'];
  }
}

class Details {
  String? name;
  String? id;

  Details.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['Id'];
  }
}
