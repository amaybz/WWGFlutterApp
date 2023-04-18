import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:wwgnfcscoringsystem/classes/activities.dart';
import 'package:wwgnfcscoringsystem/classes/bank_class.dart';
import 'package:wwgnfcscoringsystem/classes/base_results.dart';
import 'package:wwgnfcscoringsystem/classes/database/sharedprefs.dart';
import 'package:wwgnfcscoringsystem/classes/database/wwgapi.dart';
import 'package:wwgnfcscoringsystem/classes/factions.dart';
import 'package:wwgnfcscoringsystem/classes/groups.dart';
import 'package:wwgnfcscoringsystem/classes/patrol_results.dart';
import 'package:wwgnfcscoringsystem/classes/patrol_sign_in.dart';
import 'package:wwgnfcscoringsystem/classes/scan_results.dart';

import '../games_results.dart';
import 'localdb.dart';

class DataManager {
  final LocalDB localDB = LocalDB.instance;
  final WebAPI webAPI = WebAPI();
  MySharedPrefs mySharedPrefs = MySharedPrefs();

  Future<bool> isAPIOnline() async {
    webAPI.setOffline(false);
    try {
      await validateAPIToken();
    } on SocketException {
      webAPI.setOffline(true);
      if (kDebugMode) {
        print("DataManager: Unable to connect to API");
      }
    } catch (e) {
      webAPI.setOffline(true);
      if (kDebugMode) {
        print(e);
      }
    }
    return webAPI.getOffLine;
  }

  bool getManSignIn() {
    if (webAPI.getManSignIn == 1) {
      return true;
    } else {
      return false;
    }
  }

  int getUserBaseID() {
    return webAPI.getGameID;
  }

  Future<bool> signOutPatrol(PatrolSignIn patrolSignIn) async {
    bool? signedOut;
    int? insertID = 0;
    try {
      signedOut = await webAPI.setPatrolSignOut(patrolSignIn);
    } on SocketException {
      webAPI.setOffline(true);
      patrolSignIn.offline = 1;
      int? updateCount = await localDB.signOutPatrol(patrolSignIn);
      if (updateCount != null) {
        if (kDebugMode) {
          print("DataManager: Unable to upload Sign out to API");
          print("DataManager: Offline Record inserted: " + insertID.toString());
        }
        signedOut = true;
      } else {
        signedOut = false;
        if (kDebugMode) {
          print("DataManager: Unable to upload Sign in to API or LocalDB");
        }
      }
    } catch (e) {
      webAPI.setOffline(true);
      signedOut = false;
      if (kDebugMode) {
        print(e);
      }
    }

    return signedOut;
  }

  Future<bool> insertScan(ScanData scanData) async {
    bool resultSubmitted = false;
    int? insertID = 0;
    try {
      resultSubmitted = await webAPI
          .insertScan(scanData)
          .timeout(const Duration(seconds: 10));
      if (kDebugMode) {
        print("DataManager: API Scan Data Submitted: " +
            resultSubmitted.toString());
      }
    } on SocketException {
      webAPI.setOffline(true);
      scanData.offline = 1;
      insertID = await localDB.insertScan(scanData);
      if (insertID != null) {
        if (kDebugMode) {
          print("DataManager: Unable to upload scanData to API");
          print("DataManager: Offline Record inserted: " + insertID.toString());
        }
        resultSubmitted = true;
      } else {
        if (kDebugMode) {
          print("DataManager: Unable to upload Sign in to API or LocalDB");
        }
      }
    } on TimeoutException {
      webAPI.setOffline(true);
      scanData.offline = 1;
      insertID = await localDB.insertScan(scanData);
      if (insertID != null) {
        if (kDebugMode) {
          print("DataManager: Unable to upload scanData to API - TIMEOUT");
          print("DataManager: Offline Record inserted: " + insertID.toString());
        }
        resultSubmitted = true;
      } else {
        if (kDebugMode) {
          print("DataManager: Unable to upload Sign in to API or LocalDB");
        }
      }
    } catch (e) {
      webAPI.setOffline(true);
      if (kDebugMode) {
        print(e);
      }
    }
    return resultSubmitted;
  }

  Future<bool> signInPatrol(PatrolSignIn patrolSignIn) async {
    bool signedIn = false;
    int? insertID = 0;
    try {
      signedIn = await webAPI
          .setPatrolSignIn(patrolSignIn)
          .timeout(const Duration(seconds: 10));
    } on SocketException {
      if (!kIsWeb) {
        webAPI.setOffline(true);
        patrolSignIn.offline = 1;
        insertID = await localDB.insertPatrolSignIn(patrolSignIn);
        if (insertID != null) {
          if (kDebugMode) {
            print(
                "DataManager: Unable to upload Sign in to API: SocketException");
            print(
                "DataManager: Offline Record inserted: " + insertID.toString());
          }
          signedIn = true;
        } else {
          signedIn = false;
          if (kDebugMode) {
            print("DataManager: Unable to upload Sign in to API or LocalDB");
          }
        }
      }
    } on TimeoutException {
      if (!kIsWeb) {
        webAPI.setOffline(true);
        patrolSignIn.offline = 1;
        insertID = await localDB.insertPatrolSignIn(patrolSignIn);
        if (insertID != null) {
          if (kDebugMode) {
            print(
                "DataManager: Unable to upload Sign in to API: TimeoutException");
            print(
                "DataManager: Offline Record inserted: " + insertID.toString());
          }
          signedIn = true;
        } else {
          signedIn = false;
          if (kDebugMode) {
            print("DataManager: Unable to upload Sign in to API or LocalDB");
          }
        }
      }
    } catch (e) {
      webAPI.setOffline(true);
      signedIn = false;
      if (kDebugMode) {
        print(e);
      }
    }

    return signedIn;
  }

  Future<bool> validateAPIToken() async {
    webAPI.setApiKey(await mySharedPrefs.readStr('apikey'));
    APIValidateToken apiValidateToken =
    await webAPI.validateToken(webAPI.getApiKey);
    if (apiValidateToken.message == "Unauthorized") {
      return false;
    }
    if (apiValidateToken.message == "Access granted.") {
      return true;
    }
    return false;
  }

  Future<bool> uploadOfflineScans() async {
    if (!kIsWeb && !webAPI.getOffLine) {
      List<ScanData> offlineData = await localDB.listScanDataOfflineRecords();
      print("DataManager: offline Scan Data Records: " +
          offlineData.length.toString());
      if (offlineData.isNotEmpty) {
        List<dynamic> response =
        await webAPI.uploadOfflineScanData(offlineData);
        if (kDebugMode) {
          print(response);
        }
        for (var i = 0; i < response.length; i++) {
          if (response[i]["Uploaded"] == true) {
            int? updateCount = await localDB.updateOfflineScanData(
                response[i]["GameTag"], response[i]["ScanTime"], 0);
            if (updateCount == 0) {
              print("DataManager: Update to offline record FAILED!");
            }
          }
          if (response[i]["Uploaded"] == false) {
            int? updateCount = await localDB.updateOfflineScanData(
                response[i]["GameTag"], response[i]["ScanTime"], 3);
            print(
                "DataManager: Offline Record error: Record marked as conflicted!");
            if (updateCount == 0) {
              print("DataManager: Update to offline record FAILED!");
            }
          }
        }
        print("DataManager: Offline Records Submitted: " +
            response.length.toString());
        return true;
      }
    }
    return false;
  }

  Future<List<PatrolSignIn>?> getSignedInPatrols(String gameID,
      String baseCode) async {
    List<PatrolSignIn> patrolsSignIn = [];
    await isAPIOnline();
    try {
      print("DataManager: Getting Patrols Signed in");
      print("DataManager: API Offline: " + webAPI.getOffLine.toString());
      print("DataManager: Web App: " + kIsWeb.toString());
      // check for offline patrols and sync data to local DB
      if (!kIsWeb && !webAPI.getOffLine) {
        List<PatrolSignIn> offlineData =
        await localDB.listPatrolSignInOfflineRecords();
        print("DataManager: offline Base Sign in Data: " +
            offlineData.length.toString());
        //print(offlineData);

        if (offlineData.isNotEmpty) {
          List<dynamic> response =
          await webAPI.signedInPatrolsUploadOffline(offlineData);
          print(response);
          if (response[0]["Uploaded"] == true) {
            await localDB.clearPatrolSignIn();
          }
        }

        //connect to API and get latest data
        patrolsSignIn = await webAPI.getSignedInPatrols(gameID, baseCode);

        if (offlineData.isEmpty && !kIsWeb) {
          await localDB.clearPatrolSignIn();
          for (PatrolSignIn patrolSignIn in patrolsSignIn) {
            int? insertId = await localDB.insertPatrolSignIn(patrolSignIn);
            if (kDebugMode) {
              //print(insertId);
            }
          }
        }
      } else {
        //connect to API and get latest data
        patrolsSignIn = await webAPI.getSignedInPatrols(gameID, baseCode);
      }
    } on SocketException {
      webAPI.setOffline(true);

      if (kDebugMode) {
        print("DataManager: Unable to get signed in Patrols from API.");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (webAPI.getOffLine) {
      patrolsSignIn = await localDB.listPatrolSignIn();
    }

    return patrolsSignIn;
  }

  Future<List<BankData>?> getBankData() async {
    List<BankData>? listBankData = [];

    if (!webAPI.getOffLine) {
      try {
        listBankData = await webAPI.getBankConfig();
      } on SocketException {
        if (kDebugMode) {
          print("DataManager: Unable to get Bank Config from API.");
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    //update local DB with latest data
    if (listBankData != null) {
      if (!kIsWeb && !webAPI.getOffLine) {
        if (kDebugMode) {
          print("DataManager: Saving Bank data to local DB");
        }
        await localDB.clearBankData();
        for (BankData bankData in listBankData) {
          int? insertId = await localDB.insertBankData(bankData);
          if (kDebugMode) {
            //print(insertId);
          }
        }
      }
      //print(games.data);
      return listBankData;
    } else {
      if (kDebugMode) {
        print("DataManager: Loading games from local DB");
      }
      listBankData = await localDB.listBankData();
      //print(games.data);
      return listBankData;
    }
  }

  Future<List<GamesData>?> getGames() async {
    GamesResults games = GamesResults();

    if (!webAPI.getOffLine) {
      try {
        games = await webAPI.getGames();
      } on SocketException {
        if (kDebugMode) {
          print("DataManager: Unable to get games from API.");
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    //update local DB with latest data
    if (games.data != null) {
      if (!kIsWeb && !webAPI.getOffLine) {
        if (kDebugMode) {
          print("DataManager: Saving Games data to local DB");
        }
        await localDB.clearGamesData();
        for (GamesData gamesData in games.data!) {
          int? insertId = await localDB.insertGamesData(gamesData);
          if (kDebugMode) {
            //print(insertId);
          }
        }
      }
      //print(games.data);
      return games.data;
    } else {
      if (kDebugMode) {
        print("DataManager: Loading games from local DB");
      }
      games.data = await localDB.listGamesData();
      //print(games.data);
      return games.data;
    }
  }

  Future<List<GroupData>?> getGroups() async {
    Groups groups = Groups();

    if (!webAPI.getOffLine) {
      try {
        groups = await webAPI.getGroups();
      } on SocketException {
        if (kDebugMode) {
          print("DataManager: Unable to get groups from API.");
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    //update local DB with latest data
    if (groups.data != null) {
      if (!kIsWeb && !webAPI.getOffLine) {
        if (kDebugMode) {
          print("DataManager: Saving Groups data to local DB");
        }
        await localDB.clearGroupData();
        for (GroupData groupData in groups.data!) {
          int? insertId = await localDB.insertGroupData(groupData);
          if (kDebugMode) {
            //print(insertId);
          }
        }
      }
      //print(groups.data);
      return groups.data;
    } else {
      if (kDebugMode) {
        print("DataManager: Loading groups from local DB");
      }
      groups.data = await localDB.listGroupData();
      //print(groups.data);
      return groups.data;
    }
  }

  Future<List<BaseData>?> getBasesByGameID(String gameID) async {
    BasesResults bases = BasesResults();
    if (!webAPI.getOffLine) {
      try {
        bases = await webAPI.getBasesByGameID(gameID);
      } on SocketException {
        webAPI.setOffline(true);
        if (kDebugMode) {
          print("DataManager: Unable to get Bases from API.");
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    //update local DB with latest data
    if (bases.data != null) {
      if (!kIsWeb && !webAPI.getOffLine) {
        if (kDebugMode) {
          print("DataManager: Saving Base data to local DB");
        }
        await localDB.clearBaseData();
        for (BaseData baseData in bases.data!) {
          int? insertId = await localDB.insertBaseData(baseData);
          if (kDebugMode) {
            //print(insertId);
          }
        }
      }
      //print(bases.data);
      return bases.data;
    } else {
      if (kDebugMode) {
        print("DataManager: Loading bases from local DB");
      }
      bases.data = await localDB.listBaseData();
      //print(bases.data);
      return bases.data;
    }
  }

  Future<List<FactionData>?> getFractionsByGameID(String gameID) async {
    Factions fractions = Factions();
    if (!webAPI.getOffLine) {
      try {
        fractions = await webAPI.getFractionsByGameID(gameID);
      } on SocketException {
        webAPI.setOffline(true);
        if (kDebugMode) {
          print("DataManager: Unable to get fractions from API.");
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    //update local DB with latest data
    if (fractions.data != null) {
      if (!kIsWeb && !webAPI.getOffLine) {
        if (kDebugMode) {
          print("DataManager: Saving fractions data to local DB");
        }
        await localDB.clearBaseData();
        for (FactionData fractionData in fractions.data!) {
          int? insertId = await localDB.insertFractionData(fractionData);
          if (kDebugMode) {
            //print(insertId);
          }
        }
      }
      //print(bases.data);
      return fractions.data;
    } else {
      if (kIsWeb) {
        fractions.data = [
          FactionData(iDFaction: 0, factionName: "None", gameID: 0)
        ];
      }
      else {
        if (kDebugMode) {
          print("DataManager: Loading factions from local DB");
        }
        fractions.data = await localDB.listFractionData();
        //print(fractions.data);
      }
      return fractions.data;
    }
  }

  Future<List<ActivityData>?> getActivitiesByGameID(String gameID,
      bool offline) async {
    Activities activities = Activities();
    if (!offline) {
      try {
        activities = await webAPI.getActivitiesByGameID(gameID);
      } on SocketException {
        if (kDebugMode) {
          print("Unable to get Activities from API.");
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    //update local DB with latest data
    if (activities.data != null) {
      if (!kIsWeb && !offline) {
        if (kDebugMode) {
          print("Saving activities data to local DB");
        }
        await localDB.clearActivitiesData();
        for (ActivityData activityData in activities.data!) {
          int? insertId = await localDB.insertActivityData(activityData);
          if (kDebugMode) {
            //print(insertId);
          }
        }
      }
      //print(bases.data);
      return activities.data;
    } else {
      if (kDebugMode) {
        print("Loading activities from local DB");
      }
      offline = true;
      activities.data = await localDB.listActivityData();
      //print(bases.data);
      return activities.data;
    }
  }

  Future<List<PatrolData>?> getPatrolsByGameID(String gameID,
      bool offline) async {
    PatrolResults patrolResults = PatrolResults();
    if (!offline) {
      try {
        patrolResults = await webAPI.getPatrolsByGameID(gameID);
      } on SocketException {
        if (kDebugMode) {
          print("Unable to get Patrols from API.");
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    //update local DB with latest data
    if (patrolResults.data != null) {
      if (!kIsWeb && !offline) {
        if (kDebugMode) {
          print("Saving Patrols data to local DB");
        }
        await localDB.clearPatrolsData();
        for (PatrolData patrolData in patrolResults.data!) {
          int? insertId = await localDB.insertPatrolData(patrolData);
          if (kDebugMode) {
            //print(insertId);
          }
        }
      }
      //print(bases.data);
      return patrolResults.data;
    } else {
      if (kDebugMode) {
        print("Loading Patrols from local DB");
      }
      offline = true;
      patrolResults.data = await localDB.listPatrolData();
      //print(bases.data);
      return patrolResults.data;
    }
  }
}
