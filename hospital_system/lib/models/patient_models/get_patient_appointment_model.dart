class GetPatientAppointmentsModel {
  List<Result>? result;

  GetPatientAppointmentsModel.fromJson(Map<String, dynamic> json) {
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
  double? schedule;
  String? createdAt;
  Patient? nurse;
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
    nurse = json['nurse'] != null ? Patient.fromJson(json['nurse']) : null;
    doctorNotes = json['doctorNotes'];
    completed = json['completed'];
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
  String? name;

  Medication.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }
}
