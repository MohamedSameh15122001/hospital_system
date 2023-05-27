class GetAllMedicationsModel {
  List<Result>? result;

  GetAllMedicationsModel.fromJson(Map<String, dynamic> json) {
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
