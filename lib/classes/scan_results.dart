class ScanResults {
  String? message;
  List<ScanData>? data;

  ScanResults({this.message, this.data});

  ScanResults.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <ScanData>[];
      json['data'].forEach((v) {
        data!.add(ScanData.fromJson(v));
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

class ScanData {
  String? gameTag;
  String? scanTime;
  int? gameID;
  String? iDBaseCode;
  String? iDActivityCode;
  String? comment;
  int? offline;
  int? resultValue;
  String? result;
  String? iDOpponent;
  String? iDFaction;

  ScanData(
      {this.gameTag,
      this.scanTime,
      this.gameID,
      this.iDBaseCode,
      this.iDActivityCode,
      this.comment,
      this.offline,
      this.resultValue,
      this.result,
      this.iDOpponent,
      this.iDFaction});

  ScanData.fromJson(Map<String, dynamic> json) {
    gameTag = json['GameTag'];
    scanTime = json['ScanTime'];
    gameID = json['GameID'];
    iDBaseCode = json['IDBaseCode'];
    iDActivityCode = json['IDActivityCode'];
    comment = json['Comment'];
    offline = json['Offline'];
    resultValue = json['ResultValue'];
    result = json['Result'];
    iDOpponent = json['IDOpponent'];
    iDFaction = json['IDFaction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['GameTag'] = gameTag;
    data['ScanTime'] = scanTime;
    data['GameID'] = gameID;
    data['IDBaseCode'] = iDBaseCode;
    data['IDActivityCode'] = iDActivityCode;
    data['Comment'] = comment;
    data['Offline'] = offline;
    data['ResultValue'] = resultValue;
    data['Result'] = result;
    data['IDOpponent'] = iDOpponent;
    data['IDFaction'] = iDFaction;
    return data;
  }

  @override
  String toString() {
    return 'ScanData{'
        'GameID: $gameID, '
        'gameTag: $gameTag, '
        'IDActivityCode: $iDActivityCode, '
        'ScanTime: $scanTime, '
        'ResultValue: $resultValue, '
        'Result: $result, ';
  }
}
