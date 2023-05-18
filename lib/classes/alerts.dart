import 'package:flutter/foundation.dart';
import 'package:wwgnfcscoringsystem/classes/activities.dart';
import 'package:wwgnfcscoringsystem/classes/base_levels.dart';
import 'package:wwgnfcscoringsystem/classes/base_results.dart';
import 'package:wwgnfcscoringsystem/classes/database/datamanager.dart';
import 'package:wwgnfcscoringsystem/classes/factions.dart';
import 'package:wwgnfcscoringsystem/classes/scan_results.dart';
import 'package:wwgnfcscoringsystem/classes/utils.dart';

class Alerts {
  Future<AlertData> checkAlerts(
      ActivityData activityData, ScanData scanData) async {
    AlertData alertData = AlertData(alert: false, alertMessage: "");

    DataManager dataManager = DataManager();
    Utils utils = Utils();
    ScanResults scanResults = ScanResults();
    BasesResults basesResults = BasesResults();
    BaseLevels baseLevels = BaseLevels();
    Factions factions = Factions();

    int baseBalance = 0;

    scanResults = await dataManager
        .getScanData(scanData.gameID!)
        .timeout(const Duration(seconds: 5));
    basesResults.data = await dataManager
        .getBasesByGameID(scanData.gameID!)
        .timeout(const Duration(seconds: 5));
    baseLevels.data =
        await dataManager.getBaseLevels().timeout(const Duration(seconds: 5));
    factions.data = await dataManager
        .getFractionsByGameID(scanData.gameID!)
        .timeout(const Duration(seconds: 5));

    print("Alert: Activity Alert Type: ${activityData.alert}");

    //Visit Count
    if (activityData.alert == 1) {
      if (activityData.alertRule == 1) {
        alertData.alert = true;
        alertData.alertMessage = "VisitCount ALERT WIP";
        return alertData;
      }

      //success result only
      if (activityData.alertRule == 2) {
        if (scanData.result == "Success") {
          alertData.alert = true;
          alertData.alertMessage = activityData.alertMessage;
          return alertData;
        }
      }

      //Success and Fail
      if (activityData.alertRule == 4) {
        if (scanData.result == "Success") {
          alertData.alert = true;
          alertData.alertMessage = activityData.alertMessage;
          return alertData;
        }
        if (scanData.result == "Fail") {
          alertData.alert = true;
          alertData.alertMessage = activityData.alertMessageFail;
          return alertData;
        }
      }
      //Success, Partial and Fail
      if (activityData.alertRule == 5) {
        if (scanData.result == "Success") {
          alertData.alert = true;
          alertData.alertMessage = activityData.alertMessage;
          return alertData;
        }
        if (scanData.result == "Partial") {
          alertData.alert = true;
          alertData.alertMessage = activityData.alertMessagePartial;
          return alertData;
        }
        if (scanData.result == "Fail") {
          alertData.alert = true;
          alertData.alertMessage = activityData.alertMessageFail;
          return alertData;
        }
      }
    }
    //Bank above Level
    BaseData baseData =
        utils.getBaseDataByID(activityData.baseID!, basesResults);
    if (kDebugMode) {
      print("Alerts: Bank Levels: ${baseData.bankLevels} ");
    }
    if (baseData.bankLevels == 1) {
      int currentBaseLevel = baseData.level!;
      int nextBaseLevel = currentBaseLevel + 1;
      int currentBaseBalance = utils.getBankBalanceBase(
          scanResults,
          baseData.baseID!,
          utils
              .getFractionDataByID(baseData.iDFaction!, factions.data!)
              .factionName!,
          baseData.gameID!);
      BaseLevelData nextBaseLevelData = baseLevels.data!.firstWhere(
          (element) => element.idlevel == nextBaseLevel,
          orElse: () => BaseLevelData());
      print("Alerts: Next Level ${nextBaseLevelData.idlevel}");
      if (nextBaseLevelData.levelRequirement! < currentBaseBalance) {
        alertData.alert = true;
        alertData.alertMessage = nextBaseLevelData.levelDisplayValue;
        baseData.level = nextBaseLevel;
        dataManager.setBaseLevel(baseData);
      }

      //get bank value
      return alertData;
    }
    return alertData;
  }
}

class AlertData {
  bool? alert;
  String? alertMessage;

  AlertData({this.alert, this.alertMessage});
}
