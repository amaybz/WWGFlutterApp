import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:wwgnfcscoringsystem/classes/patrol_results.dart';

class Utils {
  String getCurrentDateSQL() {
    //get current time
    DateTime now = DateTime.now();
    return now.year.toString() +
        "-" +
        now.month.toString() +
        "-" +
        now.day.toString() +
        " " +
        now.hour.toString() +
        ":" +
        now.minute.toString() +
        ":" +
        now.second.toString();
  }

  PatrolData getPatrolDataByGameTag(
      String gameTag, List<PatrolData> listPatrols) {
    PatrolData patrol = PatrolData();
    patrol = listPatrols.firstWhere((element) => element.gameTag == gameTag,
        orElse: () => PatrolData());
    return patrol;
  }
}
