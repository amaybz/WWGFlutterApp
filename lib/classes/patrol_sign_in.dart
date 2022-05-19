class PatrolSignIn {
  int? iDSignIn;
  String? iDPatrol;
  String? iDBaseCode;
  String? scanIn;
  String? scanOut;
  int? status;
  int? gameID;
  int? offline;

  PatrolSignIn(
      {this.iDSignIn,
      this.iDPatrol,
      this.iDBaseCode,
      this.scanIn,
      this.scanOut,
      this.status,
      this.gameID,
      this.offline});

  PatrolSignIn.fromJson(Map<String, dynamic> json) {
    iDSignIn = json['IDSignIn'];
    iDPatrol = json['IDPatrol'];
    iDBaseCode = json['IDBaseCode'];
    scanIn = json['ScanIn'];
    scanOut = json['ScanOut'];
    status = json['Status'];
    gameID = json['GameID'];
    offline = json['offline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IDSignIn'] = iDSignIn;
    data['IDPatrol'] = iDPatrol;
    data['IDBaseCode'] = iDBaseCode;
    data['ScanIn'] = scanIn;
    data['ScanOut'] = scanOut;
    data['Status'] = status;
    data['GameID'] = gameID;
    data['offline'] = offline;
    return data;
  }

  @override
  String toString() {
    return 'PatrolSignIn{'
        'GameID: $gameID, '
        'IDPatrol: $iDPatrol, '
        'IDBaseCode: $iDBaseCode, '
        'ScanIn: $scanIn, '
        'ScanOut: $scanOut, '
        'offline: $offline, '
        'Status: $status} ';
  }
}
