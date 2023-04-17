class Factions {
  String? message;
  List<FactionData>? data;

  Factions({this.message, this.data});

  Factions.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <FactionData>[];
      json['data'].forEach((v) {
        data!.add(FactionData.fromJson(v));
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

class FactionData {
  int? iDFaction;
  String? factionName;
  int? gameID;

  FactionData({this.iDFaction, this.factionName, this.gameID});

  FactionData.fromJson(Map<String, dynamic> json) {
    iDFaction = json['IDFaction'];
    factionName = json['FactionName'];
    gameID = json['GameID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IDFaction'] = iDFaction;
    data['FactionName'] = factionName;
    data['GameID'] = gameID;
    return data;
  }
}
