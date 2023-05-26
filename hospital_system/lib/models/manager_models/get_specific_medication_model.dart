class GetSpecificmedicationModel {
  Result? result;

  GetSpecificmedicationModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }
}

class Result {
  String? sId;
  String? name;
  List<String>? activeIngredients;
  List<String>? doses;
  String? warnings;
  String? sideEffects;
  int? iV;

  Result.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    activeIngredients = json['activeIngredients'].cast<String>();
    doses = json['doses'].cast<String>();
    warnings = json['warnings'];
    sideEffects = json['sideEffects'];
    iV = json['__v'];
  }
}
