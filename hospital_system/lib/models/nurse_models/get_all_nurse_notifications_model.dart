class GetAllNurseNotificationsModel {
  List<Notifications>? notifications;

  GetAllNurseNotificationsModel.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(Notifications.fromJson(v));
      });
    }
  }
}

class Notifications {
  String? sId;
  String? nurse;
  String? title;
  String? description;
  String? date;
  int? iV;

  Notifications.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    nurse = json['nurse'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    iV = json['__v'];
  }
}
