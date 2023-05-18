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
  int? baseID;
  String? iDBaseCode;
  int? activityID;
  String? iDActivityCode;
  String? comment;
  int? offline;
  int? resultValue;
  int? resultValue2;
  int? resultValue3;
  int? resultValue4;
  int? resultValue5;
  String? result;
  String? iDOpponent;
  int? iDFaction;

  ScanData(
      {this.gameTag,
      this.scanTime,
      this.gameID,
      this.baseID,
      this.iDBaseCode,
      this.activityID,
      this.iDActivityCode,
      this.comment,
      this.offline,
      this.resultValue = 0,
      this.resultValue2 = 0,
      this.resultValue3 = 0,
      this.resultValue4 = 0,
      this.resultValue5 = 0,
      this.result,
      this.iDOpponent,
      this.iDFaction});

  ScanData.fromJson(Map<String, dynamic> json) {
    gameTag = json['GameTag'];
    scanTime = json['ScanTime'];
    gameID = json['GameID'];
    baseID = json['BaseID'];
    iDBaseCode = json['IDBaseCode'];
    activityID = json['ActivityID'];
    iDActivityCode = json['IDActivityCode'];
    comment = json['Comment'];
    offline = json['Offline'];
    resultValue = json['ResultValue'];
    resultValue2 = json['ResultValue2'];
    resultValue3 = json['ResultValue3'];
    resultValue4 = json['ResultValue4'];
    resultValue5 = json['ResultValue5'];
    result = json['Result'];
    iDOpponent = json['IDOpponent'];
    iDFaction = json['IDFaction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['GameTag'] = gameTag;
    data['ScanTime'] = scanTime;
    data['GameID'] = gameID;
    data['BaseID'] = baseID;
    data['IDBaseCode'] = iDBaseCode;
    data['ActivityID'] = activityID;
    data['IDActivityCode'] = iDActivityCode;
    data['Comment'] = comment;
    data['Offline'] = offline;
    data['ResultValue'] = resultValue;
    data['ResultValue2'] = resultValue2;
    data['ResultValue3'] = resultValue3;
    data['ResultValue4'] = resultValue4;
    data['ResultValue5'] = resultValue5;
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
        'BaseID: $baseID, '
        'IDBaseCode: $iDBaseCode, '
        'ActivityID: $activityID, '
        'IDActivityCode: $iDActivityCode, '
        'ScanTime: $scanTime, '
        'ResultValue: $resultValue, '
        'ResultValue2: $resultValue2, '
        'ResultValue3: $resultValue3, '
        'ResultValue4: $resultValue4, '
        'ResultValue5: $resultValue5, '
        'Comment: $comment, '
        'Result: $result, ';
  }
}
