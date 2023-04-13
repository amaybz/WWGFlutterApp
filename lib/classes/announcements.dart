class AnnouncementsResults {
  String? message;
  List<AnnouncementsData>? data;

  AnnouncementsResults({this.message, this.data});

  AnnouncementsResults.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <AnnouncementsData>[];
      json['data'].forEach((v) {
        data!.add(AnnouncementsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnnouncementsData {
  int? alertID;
  String? time;
  int? alertType;
  String? tabletID;
  String? gameTag;
  String? alertMsg;
  int? offline;
  int? gameID;
  String? sendToUsername;
  int? status;

  AnnouncementsData(
      {this.alertID,
      this.time,
      this.alertType,
      this.tabletID,
      this.gameTag,
      this.alertMsg,
      this.offline,
      this.gameID,
      this.sendToUsername,
      this.status});

  AnnouncementsData.fromJson(Map<String, dynamic> json) {
    alertID = json['AlertID'];
    time = json['Time'];
    alertType = json['AlertType'];
    tabletID = json['TabletID'];
    gameTag = json['GameTag'];
    alertMsg = json['AlertMsg'];
    offline = json['offline'];
    gameID = json['GameID'];
    sendToUsername = json['SendToUsername'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AlertID'] = this.alertID;
    data['Time'] = this.time;
    data['AlertType'] = this.alertType;
    data['TabletID'] = this.tabletID;
    data['GameTag'] = this.gameTag;
    data['AlertMsg'] = this.alertMsg;
    data['offline'] = this.offline;
    data['GameID'] = this.gameID;
    data['SendToUsername'] = this.sendToUsername;
    data['Status'] = this.status;
    return data;
  }
}
