import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wwgnfcscoringsystem/classes/activities.dart';
import 'package:wwgnfcscoringsystem/classes/bank_class.dart';
import 'package:wwgnfcscoringsystem/classes/patrol_results.dart';
import 'package:wwgnfcscoringsystem/classes/patrol_sign_in.dart';
import 'package:wwgnfcscoringsystem/classes/scan_results.dart';

class Alerts {
  AlertData checkAlerts(ActivityData activityData, ScanData scanData) {
    AlertData alertData = AlertData(alert: false, alertMessage: "");
    //Visit Count
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
    //Bank above Level
    if (activityData.alertRule == 3) {
      alertData.alert = true;
      alertData.alertMessage = "Bank Value ALERT WIP";
      return alertData;
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
    return alertData;
  }
}

class AlertData {
  bool? alert;
  String? alertMessage;

  AlertData({this.alert, this.alertMessage});
}
