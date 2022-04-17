class Games {
  String? message;
  List<GamesData>? data;

  Games({this.message, this.data});

  Games.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <GamesData>[];
      json['data'].forEach((v) {
        data!.add(GamesData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GamesData {
  int? gameID;
  String? gameName;
  int? remote;
  String? deviceName;
  int? defaultGame;

  GamesData(
      {this.gameID,
      this.gameName,
      this.remote,
      this.deviceName,
      this.defaultGame});

  GamesData.fromJson(Map<String, dynamic> json) {
    gameID = json['GameID'];
    gameName = json['GameName'];
    remote = json['Remote'];
    deviceName = json['DeviceName'];
    defaultGame = json['DefaultGame'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['GameID'] = gameID;
    data['GameName'] = gameName;
    data['Remote'] = remote;
    data['DeviceName'] = deviceName;
    data['DefaultGame'] = defaultGame;
    return data;
  }
}
