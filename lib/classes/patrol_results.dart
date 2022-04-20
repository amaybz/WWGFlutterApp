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
    data['IDPatrol'] = this.iDPatrol;
    data['IDGroup'] = this.iDGroup;
    data['GameID'] = this.gameID;
    data['PatrolName'] = this.patrolName;
    data['GameTag'] = this.gameTag;
    data['AgeScore'] = this.ageScore;
    data['SizeScore'] = this.sizeScore;
    data['Handicap'] = this.handicap;
    data['IDFaction'] = this.iDFaction;
    return data;
  }
}
