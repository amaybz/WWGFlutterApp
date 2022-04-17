class APILogin {
  String? message;
  String? jwt;
  String? username;
  String? name;
  int? access;
  int? gameID;
  int? baseID;

  APILogin(
      {this.message,
      this.jwt,
      this.username,
      this.name,
      this.access,
      this.gameID,
      this.baseID});

  APILogin.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    jwt = json['jwt'];
    username = json['username'];
    name = json['name'];
    access = json['access'];
    gameID = json['GameID'];
    baseID = json['BaseID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['jwt'] = jwt;
    data['username'] = username;
    data['name'] = name;
    data['access'] = access;
    data['GameID'] = gameID;
    data['BaseID'] = baseID;
    return data;
  }
}
