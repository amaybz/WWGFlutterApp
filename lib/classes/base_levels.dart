class BaseLevels {
  String? message;
  List<BaseLevelData>? data;

  BaseLevels({this.message, this.data});

  BaseLevels.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <BaseLevelData>[];
      json['data'].forEach((v) {
        data!.add(BaseLevelData.fromJson(v));
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

class BaseLevelData {
  int? idlevel;
  String? levelDisplayValue;
  int? levelRequirement;

  BaseLevelData({this.idlevel, this.levelDisplayValue, this.levelRequirement});

  BaseLevelData.fromJson(Map<String, dynamic> json) {
    idlevel = json['idlevel'];
    levelDisplayValue = json['LevelDisplayValue'];
    levelRequirement = json['LevelRequirement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idlevel'] = idlevel;
    data['LevelDisplayValue'] = levelDisplayValue;
    data['LevelRequirement'] = levelRequirement;
    return data;
  }
}
