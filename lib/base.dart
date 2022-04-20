import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wwgnfcscoringsystem/classes/activities.dart';
import 'package:wwgnfcscoringsystem/classes/base_results.dart';
import 'package:wwgnfcscoringsystem/classes/dialog_builder.dart';
import 'package:wwgnfcscoringsystem/classes/patrol_results.dart';
import 'package:wwgnfcscoringsystem/widgets/record_results.dart';
import 'package:wwgnfcscoringsystem/widgets/scan_patrol.dart';
import 'classes/patrol_sign_in.dart';
import 'classes/scan_results.dart';
import 'classes/wwgapi.dart';
import 'login.dart';

class Base extends StatefulWidget {
  const Base(
      {Key? key,
      required this.gameID,
      required this.base,
      required this.activityData,
      required this.patrols})
      : super(key: key);

  final int gameID;
  final BaseData base;
  final List<ActivityData> activityData;
  final List<PatrolData> patrols;
  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  int _selectedTab = 0;
  List<DropdownMenuItem<String>> listActivitiesDropdown = [
    const DropdownMenuItem(value: "0", child: Text("None Loaded")),
  ];
  ScanData scanData = ScanData();
  List<PatrolSignIn> patrolsSignedIn = [];
  WebAPI webAPI = WebAPI();
  final TextEditingController txtValueResult = TextEditingController();
  String error = "Please fill in all Fields";

  @override
  void initState() {
    super.initState();
    updateActivitiesDropDown();
    getSignedInPatrols();
    scanData.gameID = widget.base.gameID;
    scanData.iDBaseCode = widget.base.baseCode;
  }

  Future<void> getSignedInPatrols() async {
    List<PatrolSignIn> patrolSignIn = await webAPI.getSignedInPatrols(
        widget.base.gameID.toString(), widget.base.baseCode!);
    setState(() {
      patrolsSignedIn = patrolSignIn;
    });
  }

  void updateActivitiesDropDown() {
    List<ActivityData> filteredList = widget.activityData
        .where((i) => i.baseID == widget.base.baseID)
        .toList();
    if (filteredList.isNotEmpty) {
      listActivitiesDropdown.clear();
      for (ActivityData activities in filteredList) {
        setState(() {
          listActivitiesDropdown.add(DropdownMenuItem(
              value: activities.activityID.toString(),
              child: Text(activities.activityName!)));
        });
      }
    } else {
      setState(() {
        listActivitiesDropdown.clear();
        listActivitiesDropdown.add(
            const DropdownMenuItem(value: "0", child: Text("None Loaded")));
      });
    }

    if (kDebugMode) {
      print(widget.activityData);
      print("#Filtered");
      print(filteredList.length);
    }
  }

  _navigateToLogin(BuildContext context) async {
    await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  void handleMenuClick(String value) async {
    switch (value) {
      case 'Work Offline':
        if (kDebugMode) {
          print("Work Offline Selected");
        }
        //showAlertDialogClearMatch(context);
        break;
      case 'Settings':
        if (kDebugMode) {
          print("Settings Selected");
        }
        //_navigateToSettings(context);
        break;
      case 'Login':
        if (kDebugMode) {
          print("Login Selected");
        }
        _navigateToLogin(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.base.baseName!),
        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: handleMenuClick,
              itemBuilder: (BuildContext context) {
                return {'Work Offline', 'Settings', 'Login'}
                    .map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              }),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedTab, // th
        onTap: (value) {
          setState(() => _selectedTab = value);
          getSignedInPatrols();
        }, // is will be set when a new tab is tapped
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_overscan),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Results',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.all(2.0),
              padding: const EdgeInsets.all(2.0),
              child: _showTab(_selectedTab)),
        ],
      ),
    );
  }

  _showTab(int index) {
    if (index == 0) {
      return ScanPatrol(
        patrolData: widget.patrols,
        onSignIn: signInPatrol,
      );
    }
    if (index == 1) {
      return RecordResults(
        txtValueResult: txtValueResult,
        scanData: scanData,
        listActivitiesDropdown: listActivitiesDropdown,
        activitiesData: widget.activityData,
        patrolsSignedIn: patrolsSignedIn,
        onChange: (updatedScanData) {
          setState(() {
            scanData = updatedScanData;
          });
          if (kDebugMode) {
            print(scanData);
          }
        },
        onSubmit: submitResult,
      );
    }
  }

  Future<void> submitResult(
      updatedScanData, ActivityData selectedActivity) async {
    bool resultSubmitted = false;
    bool validData = true;

    scanData = updatedScanData;
    validData = validateData(selectedActivity);

    if (scanData.iDBaseCode != null &&
        scanData.iDActivityCode != null &&
        scanData.gameTag != null &&
        scanData.result != null &&
        scanData.scanTime != null &&
        scanData.gameID != null &&
        validData) {
      scanData.iDOpponent ??= "";
      scanData.comment ??= "";
      scanData.offline ??= 0;
      scanData.resultValue ??= 0;
      resultSubmitted = await webAPI.insertScan(scanData);
    }
    if (resultSubmitted) {
      DialogBuilder(context).showAlertOKDialog("Result", "Submitted");
      setState(() {
        scanData.result = null;
        scanData.gameTag = null;
        scanData.resultValue = 0;
        txtValueResult.text = "";
      });
    } else {
      DialogBuilder(context).showAlertOKDialog("Result", "error: " + error);
    }
    //getSignedInPatrols();
    //verify data and submit to API

    if (kDebugMode) {
      print(scanData);
    }
  }

  Future<void> signInPatrol(gameTag) async {
    DialogBuilder(context).showLoadingIndicator("Signing in Patrol");
    PatrolData patrol = PatrolData();
    PatrolSignIn patrolSignIn = PatrolSignIn();
    patrol = widget.patrols.firstWhere((element) => element.gameTag == gameTag,
        orElse: () => PatrolData());
    patrolSignIn.iDPatrol = patrol.gameTag;
    patrolSignIn.iDBaseCode = widget.base.baseCode;
    patrolSignIn.gameID = widget.base.gameID;
    patrolSignIn.offline = 0;

    //get current time
    DateTime now = DateTime.now();
    patrolSignIn.scanIn = now.year.toString() +
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
    bool signedIn = await webAPI.setPatrolSignIn(patrolSignIn);
    await getSignedInPatrols();
    DialogBuilder(context).hideOpenDialog();
    if (signedIn) {
      DialogBuilder(context).showAlertOKDialog(
          "Signed in Patrol", patrol.gameTag! + " " + patrol.patrolName!);
    } else {
      DialogBuilder(context).showAlertOKDialog("FAILED to Sign in Patrol",
          patrol.gameTag! + " " + patrol.patrolName!);
    }

    if (kDebugMode) {
      //print(patrolSignIn);
    }
  }

  bool validateData(ActivityData activityData) {
    if (activityData.valueResultField == 1) {
      if (activityData.successFailResultField == 0) {
        scanData.result = "Success";
      }
      if (scanData.resultValue == null) {
        error = "Please enter a value for " +
            activityData.valueResultName.toString();
        return false;
      }
      if (activityData.valueResultMax! < scanData.resultValue!) {
        error = "Max value is " + activityData.valueResultMax.toString();
        return false;
      }
      if (activityData.passBasedonValueResult == 1) {
        if (activityData.passValue! <= scanData.resultValue!) {
          scanData.result = "Success";
        } else {
          scanData.result = "Fail";
        }
      }
    }
    return true;
  }
}
