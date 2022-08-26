class Fractions {
  String? message;
  List<FractionData>? data;

  Fractions({this.message, this.data});

  Fractions.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <FractionData>[];
      json['data'].forEach((v) {
        data!.add(FractionData.fromJson(v));
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

class FractionData {
  int? iDFaction;
  String? factionName;
  int? gameID;

  FractionData({this.iDFaction, this.factionName, this.gameID});

  FractionData.fromJson(Map<String, dynamic> json) {
    iDFaction = json['IDFaction'];
    factionName = json['FactionName'];
    gameID = json['GameID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['IDFaction'] = iDFaction;
    data['FactionName'] = factionName;
    data['GameID'] = gameID;
    return data;
  }
}
