class GetAllmedicationsModel {
  List<Result>? result;

  GetAllmedicationsModel.fromJson(Map<String, dynamic> json) {
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
