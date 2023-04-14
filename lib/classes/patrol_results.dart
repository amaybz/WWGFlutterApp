class PatrolResults {
  String? message;
  List<PatrolData>? data;

  PatrolResults({this.message, this.data});

  PatrolResults.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <PatrolData>[];
      json['data'].forEach((v) {
        data!.add(PatrolData.fromJson(v));
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

class PatrolData {
  int? iDPatrol;
  int? iDGroup;
  int? gameID;
  String? patrolName;
  String? gameTag;
  double? ageScore;
  int? sizeScore;
  double? handicap;
  int? iDFaction;

  PatrolData(
      {this.iDPatrol,
      this.iDGroup,
      this.gameID,
      this.patrolName,
      this.gameTag,
      this.ageScore,
      this.sizeScore,
      this.handicap,
      this.iDFaction});

  PatrolData.fromJson(Map<String, dynamic> json) {
    iDPatrol = json['IDPatrol'];
    iDGroup = json['IDGroup'];
    gameID = json['GameID'];
    patrolName = json['PatrolName'];
    gameTag = json['GameTag'];
    ageScore = double.parse(json['AgeScore'].toString());
    sizeScore = json['SizeScore'];
    handicap = double.parse(json['Handicap'].toString());
    iDFaction = json['IDFaction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IDPatrol'] = iDPatrol;
    data['IDGroup'] = iDGroup;
    data['GameID'] = gameID;
    data['PatrolName'] = patrolName;
    data['GameTag'] = gameTag;
    data['AgeScore'] = ageScore;
    data['SizeScore'] = sizeScore;
    data['Handicap'] = handicap;
    data['IDFaction'] = iDFaction;
    return data;
  }
}
