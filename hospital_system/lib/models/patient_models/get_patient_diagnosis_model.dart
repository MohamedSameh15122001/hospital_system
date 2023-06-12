class GetPatientDiagnosisModel {
  List<Result>? result;

  GetPatientDiagnosisModel.fromJson(Map<String, dynamic> json) {
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
  Patient? doctor;
  String? date;
  String? diagnosis;
  String? prescription;
  int? iV;

  Result.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    patient =
        json['patient'] != null ? Patient.fromJson(json['patient']) : null;
    doctor = json['doctor'] != null ? Patient.fromJson(json['doctor']) : null;
    date = json['date'];
    diagnosis = json['diagnosis'];
    prescription = json['prescription'];
    iV = json['__v'];
  }
}

class Patient {
  String? name;
  String? id;

  Patient.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['Id'];
  }
}
