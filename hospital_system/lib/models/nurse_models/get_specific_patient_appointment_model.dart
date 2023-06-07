class GetSpecificPatientAppointmentModel {
  Result? result;

  GetSpecificPatientAppointmentModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }
}

class Result {
  String? sId;
  PatientOrNurse? patient;
  List<Medications>? medications;
  int? schedule;
  String? createdAt;
  PatientOrNurse? nurse;
  String? doctorNotes;
  bool? completed;
  int? iV;

  Result.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    patient = json['patient'] != null
        ? PatientOrNurse.fromJson(json['patient'])
        : null;
    if (json['medications'] != null) {
      medications = <Medications>[];
      json['medications'].forEach((v) {
        medications!.add(Medications.fromJson(v));
      });
    }
    schedule = json['schedule'];
    createdAt = json['createdAt'];
    nurse =
        json['nurse'] != null ? PatientOrNurse.fromJson(json['nurse']) : null;
    doctorNotes = json['doctorNotes'];
    completed = json['completed'];
    iV = json['__v'];
  }
}

class PatientOrNurse {
  String? name;
  String? id;

  PatientOrNurse.fromJson(Map<String, dynamic> json) {
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
