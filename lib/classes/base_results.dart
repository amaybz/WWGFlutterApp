class BasesResults {
  String? message;
  List<BaseData>? data;

  BasesResults({this.message, this.data});

  BasesResults.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <BaseData>[];
      json['data'].forEach((v) {
        data!.add(BaseData.fromJson(v));
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

class BaseData {
  int? baseID;
  int? gameID;
  String? baseName;
  String? baseCode;
  int? randomEvents;
  int? randomChance;
  int? randomListID;
  int? level;
  int? iDFaction;
  int? bank;

  BaseData(
      {this.baseID,
      this.gameID,
      this.baseName,
      this.baseCode,
      this.randomEvents,
      this.randomChance,
      this.randomListID,
      this.level,
      this.iDFaction,
      this.bank});

  BaseData.fromJson(Map<String, dynamic> json) {
    baseID = json['BaseID'];
    gameID = json['GameID'];
    baseName = json['BaseName'];
    baseCode = json['BaseCode'];
    randomEvents = json['RandomEvents'];
    randomChance = json['RandomChance'];
    randomListID = json['RandomListID'];
    level = json['level'];
    iDFaction = json['IDFaction'];
    bank = json['Bank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['BaseID'] = baseID;
    data['GameID'] = gameID;
    data['BaseName'] = baseName;
    data['BaseCode'] = baseCode;
    data['RandomEvents'] = randomEvents;
    data['RandomChance'] = randomChance;
    data['RandomListID'] = randomListID;
    data['level'] = level;
    data['IDFaction'] = iDFaction;
    data['Bank'] = bank;
    return data;
  }

  @override
  String toString() {
    return 'BaseData{'
        'GameID: $gameID, '
        'BaseID: $baseID, '
        'BaseName: $baseName, '
        'BaseCode: $baseCode, '
        'level: $level, '
        'IDFaction: $iDFaction, '
        'bank: $bank,';
  }
}
