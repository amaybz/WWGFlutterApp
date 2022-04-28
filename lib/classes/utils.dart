import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wwgnfcscoringsystem/classes/patrol_results.dart';
import 'package:wwgnfcscoringsystem/classes/patrol_sign_in.dart';

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

  List<DropdownMenuItem<String>> convertPatrolsListToDropDownList(
      List<PatrolSignIn> patrolsSignedIn) {
    bool inList = false;
    List<DropdownMenuItem<String>> listPatrolsDropdown = [
      const DropdownMenuItem(value: "0", child: Text("Please Sign in a Patrol"))
    ];

    if (kDebugMode) {
      print("#Signed in Patrols");
      print(patrolsSignedIn.length);
    }

    if (patrolsSignedIn.isNotEmpty) {
      listPatrolsDropdown.clear();
      for (PatrolSignIn patrol in patrolsSignedIn) {
        for (int i = 0; i < listPatrolsDropdown.length; i++) {
          if (listPatrolsDropdown[i].value == patrol.iDPatrol) {
            inList = true;
          }
        }
        if (!inList) {
          listPatrolsDropdown.add(DropdownMenuItem(
              value: patrol.iDPatrol, child: Text(patrol.iDPatrol!)));
        }
      }
      return listPatrolsDropdown;
    } else {
      listPatrolsDropdown.clear();
      listPatrolsDropdown.add(const DropdownMenuItem(
          value: "0", child: Text("Please sign in a Patrol")));
      return listPatrolsDropdown;
    }
  }
}
