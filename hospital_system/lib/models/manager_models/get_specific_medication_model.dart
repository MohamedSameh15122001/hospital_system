class GetSpecificMedicationModel {
  Result? result;

  GetSpecificMedicationModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }
}

class Result {
  String? sId;
  String? name;
  String? activeIngredients;
  String? doses;
  String? warnings;
  String? sideEffects;
  int? iV;

  Result.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    activeIngredients = json['activeIngredients'];
    doses = json['doses'];
    warnings = json['warnings'];
    sideEffects = json['sideEffects'];
    iV = json['__v'];
  }
}
