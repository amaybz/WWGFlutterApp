import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'api_login.dart';
import 'games.dart';

class WebAPI {
  static final WebAPI _wwgApi = WebAPI._internal();

  String? _apiKey = "";
  String? _apiLink;
  bool _loggedIn = false;

  get getApiKey => _apiKey;

  get getApiLink => _apiLink;
  get getLoggedIn => _loggedIn;

  void setApiKey(newValue) {
    _apiKey = newValue;
  }

  Future<Games> getGames() async {
    Games games = Games();
    var headers = {'Authorization': _apiKey!};
    var request = http.Request('POST', Uri.parse(_apiLink! + 'games/'));
    request.body = '';
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String jsonData = await response.stream.bytesToString();
      if (kDebugMode) {
        print("json data: " + jsonData);
      }
      games = Games.fromJson(json.decode(jsonData));
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
    if (kDebugMode) {
      print(games.message);
    }
    return games;
  }

  Future<Bases> getBasesByGameID(String gameID) async {
    Bases bases = Bases();
    var headers = {'Authorization': _apiKey!};
    var request = http.Request(
        'POST', Uri.parse(_apiLink! + 'bases/GetAllBasesByGameID.php'));
    request.body = '{"GameID" : "' + gameID + '"}';
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String jsonData = await response.stream.bytesToString();
      if (kDebugMode) {
        print("json data: " + jsonData);
      }
      bases = Bases.fromJson(json.decode(jsonData));
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
    if (kDebugMode) {
      print(bases.message);
    }
    return bases;
  }

  Future<APIValidateToken> validateToken(String token) async {
    APIValidateToken apiValidateToken = APIValidateToken();
    var headers = {'Authorization': token};
    var request =
        http.Request('POST', Uri.parse(_apiLink! + 'validate_token.php'));
    request.body = '';
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String jsonData = await response.stream.bytesToString();
      if (kDebugMode) {
        print(jsonData);
      }

      apiValidateToken = APIValidateToken.fromJson(json.decode(jsonData));
      _apiKey = token;
      _loggedIn = true;
    } else {
      _apiKey = "";
      apiValidateToken.message = "Unauthorized";
      _loggedIn = false;
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
    if (kDebugMode) {
      print(apiValidateToken.message);
    }
    return apiValidateToken;
  }

  Future<APILogin> login(String user, String pass) async {
    APILogin wwgAPILogin = APILogin();
    var request = http.Request('POST', Uri.parse(_apiLink! + 'login.php'));
    request.body = '{"username" : "' + user + '","password" : "' + pass + '"}';
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String loginJson = await response.stream.bytesToString();
      if (kDebugMode) {
        print(loginJson);
      }

      wwgAPILogin = APILogin.fromJson(json.decode(loginJson));
      _apiKey = wwgAPILogin.jwt;
      _loggedIn = true;
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
        _loggedIn = false;
      }
    }
    if (kDebugMode) {
      print(wwgAPILogin.message);
    }
    return wwgAPILogin;
  }

  factory WebAPI() {
    _wwgApi._apiLink = "https://app.widegame.com.au/api/";
    _wwgApi._loggedIn = false;
    return _wwgApi;
  }

  WebAPI._internal();
}

class APIValidateToken {
  String? message;
  ValidateData? data;

  APIValidateToken({this.message, this.data});

  APIValidateToken.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? ValidateData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ValidateData {
  int? id;
  String? username;
  String? name;
  int? access;
  int? gameID;
  int? baseID;

  ValidateData(
      {this.id,
      this.username,
      this.name,
      this.access,
      this.gameID,
      this.baseID});

  ValidateData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    access = json['access'];
    gameID = json['GameID'];
    baseID = json['BaseID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['name'] = name;
    data['access'] = access;
    data['GameID'] = gameID;
    data['BaseID'] = baseID;
    return data;
  }
}

class Bases {
  String? message;
  List<BaseData>? data;

  Bases({this.message, this.data});

  Bases.fromJson(Map<String, dynamic> json) {
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

  BaseData(
      {this.baseID,
      this.gameID,
      this.baseName,
      this.baseCode,
      this.randomEvents,
      this.randomChance,
      this.randomListID,
      this.level,
      this.iDFaction});

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
    return data;
  }
}
