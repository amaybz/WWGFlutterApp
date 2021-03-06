import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:wwgnfcscoringsystem/classes/activities.dart';
import 'package:wwgnfcscoringsystem/classes/bank_class.dart';
import 'package:wwgnfcscoringsystem/classes/patrol_results.dart';
import 'package:wwgnfcscoringsystem/classes/patrol_sign_in.dart';
import 'package:wwgnfcscoringsystem/classes/scan_results.dart';
import 'dart:convert';

import '../api_login.dart';
import '../base_results.dart';
import '../games_results.dart';

class WebAPI {
  static final WebAPI _wwgApi = WebAPI._internal();

  String? _apiKey = "";
  String? _apiLink;
  bool _loggedIn = false;
  bool _offLine = false;
  int _accessLevel = 10;

  get getApiKey => _apiKey;
  get getAccessLevel => _accessLevel;
  get getApiLink => _apiLink;
  get getLoggedIn => _loggedIn;
  get getOffLine => _offLine;

  void setApiKey(newValue) {
    _apiKey = newValue;
  }

  void setAccessLevel(int newValue) {
    _accessLevel = newValue;
  }

  void setOffline(bool newValue) {
    _offLine = newValue;
  }

  Future<bool> checkConnection(apiToken) async {
    try {
      await validateToken(apiToken);
      _wwgApi.setOffline(false);
      return false;
    } on SocketException {
      _wwgApi.setOffline(true);
      return true;
    } catch (e) {
      _wwgApi.setOffline(true);
      if (kDebugMode) {
        print(e);
      }
      return true;
    }
  }

  Future<GamesResults> getGames() async {
    GamesResults games = GamesResults();
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
      games = GamesResults.fromJson(json.decode(jsonData));
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

  Future<List<BankData>?> getBankConfig() async {
    BankResults bankConfig = BankResults();
    var headers = {'Authorization': _apiKey!};
    var request = http.Request('POST', Uri.parse(_apiLink! + 'bank/'));
    request.body = '';
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String jsonData = await response.stream.bytesToString();
      if (kDebugMode) {
        print("json data: " + jsonData);
      }
      bankConfig = BankResults.fromJson(json.decode(jsonData));
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
    if (kDebugMode) {
      print(bankConfig.message);
    }
    return bankConfig.data;
  }

  Future<BasesResults> getBasesByGameID(String gameID) async {
    BasesResults bases = BasesResults();
    var headers = {'Authorization': _apiKey!};
    var request = http.Request(
        'POST', Uri.parse(_apiLink! + 'bases/GetAllBasesByGameID.php'));
    request.body = '{"GameID" : "' + gameID + '"}';
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String jsonData = await response.stream.bytesToString();
      if (kDebugMode) {
        //print("json data: " + jsonData);
      }
      bases = BasesResults.fromJson(json.decode(jsonData));
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
    if (kDebugMode) {
      print("Bases results: " + bases.message!);
    }
    return bases;
  }

  Future<Activities> getActivitiesByGameID(String gameID) async {
    Activities activities = Activities();
    var headers = {'Authorization': _apiKey!};
    var request = http.Request('POST',
        Uri.parse(_apiLink! + 'activities/GetAllActivitiesByGameID.php'));
    request.body = '{"GameID" : ' + gameID + '}';
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String jsonData = await response.stream.bytesToString();
      if (kDebugMode) {
        //print("json data: " + jsonData);
      }
      activities = Activities.fromJson(json.decode(jsonData));
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
    if (kDebugMode) {
      print("Activity Results: " + activities.message!);
    }
    return activities;
  }

  Future<PatrolResults> getPatrolsByGameID(String gameID) async {
    PatrolResults patrolResults = PatrolResults();
    var headers = {'Authorization': _apiKey!};
    var request = http.Request(
        'POST', Uri.parse(_apiLink! + 'patrols/GetAllPatrolsByGameID.php'));
    request.body = '{"GameID" : ' + gameID + '}';
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String jsonData = await response.stream.bytesToString();
      if (kDebugMode) {
        //print("json data: " + jsonData);
      }
      patrolResults = PatrolResults.fromJson(json.decode(jsonData));
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
    if (kDebugMode) {
      print("Patrol Results: " + patrolResults.message!);
    }
    return patrolResults;
  }

  Future<List<PatrolSignIn>> getSignedInPatrols(
      String gameID, String baseCode) async {
    List<PatrolSignIn> patrolSignIn = [];
    var headers = {'Authorization': _apiKey!};
    var request = http.Request(
        'POST', Uri.parse(_apiLink! + 'basesignin/all_patrols_signed_in.php'));
    request.body =
        '{"IDBaseCode" : "' + baseCode + '","GameID" : ' + gameID + '}';
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String strjsonData = await response.stream.bytesToString();
      if (kDebugMode) {
        //print("json data: " + strjsonData);
      }
      List<dynamic> jsonData = json.decode(strjsonData);
      if (jsonData[0] != "None") {
        for (var i = 0; i < jsonData.length; i++) {
          patrolSignIn.add(PatrolSignIn.fromJson(jsonData[i]));
        }
      } else {
        if (kDebugMode) {
          print(response.reasonPhrase);
        }
      }
    }
    return patrolSignIn;
  }

  Future<List<dynamic>> uploadOfflineScanData(
      List<ScanData> offlineData) async {
    var headers = {'Authorization': _apiKey!};
    var request = http.Request(
        'POST', Uri.parse(_apiLink! + 'scan/UploadOfflineResults.php'));
    request.body = jsonEncode(offlineData);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String strJsonData = await response.stream.bytesToString();
      if (kDebugMode) {
        print("json data: " + strJsonData);
        //print(response.reasonPhrase);
      }
      List<dynamic> jsonData = json.decode(strJsonData);
      if (jsonData.isNotEmpty) {
        return jsonData;
      } else {
        if (kDebugMode) {
          print(response.reasonPhrase);
        }
        return jsonData;
      }
    }
    return jsonDecode('[{"Uploaded": false,"GameTag": "None"}]"');
  }

  Future<List<dynamic>> signedInPatrolsUploadOffline(
      List<PatrolSignIn> offlinePatrols) async {
    var headers = {'Authorization': _apiKey!};
    var request = http.Request(
        'POST', Uri.parse(_apiLink! + 'basesignin/UploadOfflineResults.php'));
    request.body = jsonEncode(offlinePatrols);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String strJsonData = await response.stream.bytesToString();
      if (kDebugMode) {
        print("json data: " + strJsonData);
        //print(response.reasonPhrase);
      }
      List<dynamic> jsonData = json.decode(strJsonData);
      if (jsonData.isNotEmpty) {
        return jsonData;
      } else {
        if (kDebugMode) {
          print(response.reasonPhrase);
        }
        return jsonData;
      }
    }
    return jsonDecode('[{"Uploaded": false,"GameTag": "na"}]"');
  }

  Future<bool> setPatrolSignIn(PatrolSignIn patrolSignIn) async {
    var headers = {'Authorization': _apiKey!};
    var request =
        http.Request('POST', Uri.parse(_apiLink! + 'basesignin/sign_in.php'));
    request.body = '{"IDPatrol" : "' +
        patrolSignIn.iDPatrol! +
        '", "IDBaseCode" : "' +
        patrolSignIn.iDBaseCode! +
        '", "GameID" : "' +
        patrolSignIn.gameID.toString() +
        '", "ScanIn" : "' +
        patrolSignIn.scanIn.toString() +
        '","offline" : "' +
        patrolSignIn.offline.toString() +
        '"}';
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String strJsonData = await response.stream.bytesToString();
      if (kDebugMode) {
        print("json data: " + strJsonData);
      }
      Map<String, dynamic> jsonData = json.decode(strJsonData);
      if (jsonData['data']['SignedIn'] == "true") {
        return true;
      } else {
        if (kDebugMode) {
          print(response.reasonPhrase);
        }
      }
    }
    if (kDebugMode) {
      print(patrolSignIn);
    }
    return false;
  }

  Future<bool> setPatrolSignOut(PatrolSignIn patrolSignIn) async {
    var headers = {'Authorization': _apiKey!};
    var request =
        http.Request('POST', Uri.parse(_apiLink! + 'basesignin/sign_out.php'));
    request.body = '{"IDPatrol" : "' +
        patrolSignIn.iDPatrol! +
        '", "IDBaseCode" : "' +
        patrolSignIn.iDBaseCode! +
        '", "GameID" : "' +
        patrolSignIn.gameID.toString() +
        '", "ScanOut" : "' +
        patrolSignIn.scanOut.toString() +
        '","offline" : "' +
        patrolSignIn.offline.toString() +
        '"}';
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String strJsonData = await response.stream.bytesToString();
      if (kDebugMode) {
        print("json data: " + strJsonData);
      }
      Map<String, dynamic> jsonData = json.decode(strJsonData);
      if (jsonData['data']['SignedOut'] == "true") {
        return true;
      } else {
        if (kDebugMode) {
          print(response.reasonPhrase);
        }
      }
    }
    if (kDebugMode) {
      print(patrolSignIn);
    }
    return false;
  }

  Future<bool> insertScan(ScanData scanData) async {
    var headers = {'Authorization': _apiKey!};
    var request =
        http.Request('POST', Uri.parse(_apiLink! + 'scan/insertScan.php'));
    request.body = '{"GameTag" : "' +
        scanData.gameTag! +
        '", "ScanTime" : "' +
        scanData.scanTime! +
        '", "GameID" : "' +
        scanData.gameID.toString() +
        '", "IDBaseCode" : "' +
        scanData.iDBaseCode! +
        '","IDActivityCode" : "' +
        scanData.iDActivityCode! +
        '","Comment" : "' +
        scanData.comment.toString() +
        '","Offline" : "' +
        scanData.offline.toString() +
        '","ResultValue" : "' +
        scanData.resultValue.toString() +
        '","Result" : "' +
        scanData.result! +
        '","IDOpponent" : "' +
        scanData.iDOpponent.toString() +
        '"}';
    //print(request.body);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String strJsonData = await response.stream.bytesToString();
      if (kDebugMode) {
        //print("json data: " + strJsonData);
      }
      Map<String, dynamic> jsonData = json.decode(strJsonData);
      if (jsonData['code'] == "1") {
        return true;
      } else {
        if (kDebugMode) {
          print(response.reasonPhrase);
        }
      }
    }
    if (kDebugMode) {
      print(scanData);
    }
    return false;
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
        //print(jsonData);
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
      _accessLevel = wwgAPILogin.access!;
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
