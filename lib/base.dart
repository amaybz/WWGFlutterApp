import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wwgnfcscoringsystem/classes/activities.dart';
import 'package:wwgnfcscoringsystem/classes/alerts.dart';
import 'package:wwgnfcscoringsystem/classes/bank_class.dart';
import 'package:wwgnfcscoringsystem/classes/base_results.dart';
import 'package:wwgnfcscoringsystem/classes/database/datamanager.dart';
import 'package:wwgnfcscoringsystem/classes/dialog_builder.dart';
import 'package:wwgnfcscoringsystem/classes/groups.dart';
import 'package:wwgnfcscoringsystem/classes/patrol_results.dart';
import 'package:wwgnfcscoringsystem/widgets/record_results.dart';
import 'package:wwgnfcscoringsystem/widgets/scan_patrol.dart';
import 'package:wwgnfcscoringsystem/widgets/widget_bank.dart';
import 'package:wwgnfcscoringsystem/widgets/widget_info.dart';
import 'classes/fractions.dart';
import 'classes/patrol_sign_in.dart';
import 'classes/scan_results.dart';
import 'classes/utils.dart';
import 'classes/database/wwgapi.dart';
import 'login.dart';

class Base extends StatefulWidget {
  const Base({
    Key? key,
    required this.gameID,
    required this.base,
    required this.activityData,
    required this.patrols,
    required this.groups,
    required this.fractions,
  }) : super(key: key);

  final int gameID;
  final BaseData base;
  final List<ActivityData> activityData;
  final List<PatrolData> patrols;
  final List<GroupData> groups;
  final List<FractionData> fractions;
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
  List<BankData> listBankData = [];
  WebAPI webAPI = WebAPI();
  Alerts alerts = Alerts();
  DataManager dataManager = DataManager();
  final TextEditingController txtValueResult = TextEditingController();
  final TextEditingController txtValueAmount = TextEditingController();
  String error = "Please fill in all Fields";
  bool offline = false;

  @override
  void initState() {
    super.initState();
    updateActivitiesDropDown();
    getSignedInPatrols();
    scanData.gameID = widget.base.gameID;
    scanData.iDBaseCode = widget.base.baseCode;
    dataManager.uploadOfflineScans();
    if (widget.base.bank == 1) {
      print("getting bank data.");
      getBankConfig();
    }
  }

  Future<void> getSignedInPatrols() async {
    List<PatrolSignIn>? patrolSignIn = await dataManager.getSignedInPatrols(
        widget.base.gameID.toString(), widget.base.baseCode!);
    setState(() {
      patrolsSignedIn = patrolSignIn!;
    });
  }

  Future<void> getBankConfig() async {
    listBankData = (await dataManager.getBankData())!;
    setState(() {
      listBankData = listBankData;
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
        items: bottomNavItems(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _showTab(_selectedTab),
          ),
        ],
      ),
    );
  }

  List<BottomNavigationBarItem> bottomNavItems() {
    if (widget.base.bank == 1) {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_overscan),
          label: 'Scan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Results',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'Info',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on),
          label: 'Bank',
        ),
      ];
    } else {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_overscan),
          label: 'Scan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Results',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'Info',
        ),
      ];
    }
  }

  _showTab(int index) {
    if (index == 0) {
      return ScanPatrol(
        patrolData: widget.patrols,
        patrolsSignedIn: patrolsSignedIn,
        onSignIn: signInPatrol,
        onSignOut: signOutPatrol,
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
    if (index == 2) {
      return Info(
        baseData: widget.base,
        scanData: scanData,
        patrols: widget.patrols,
        activitiesData: widget.activityData,
        patrolsSignedIn: patrolsSignedIn,
        groups: widget.groups,
        onChange: (updatedScanData) {
          setState(() {
            scanData = updatedScanData;
          });
          if (kDebugMode) {
            print(scanData);
          }
        },
      );
    }
    if (index == 3) {
      return Banking(
        txtValueAmount: txtValueAmount,
        patrolsSignedIn: patrolsSignedIn,
        activitiesData: widget.activityData,
        listBankData: listBankData,
        scanData: scanData,
        onSubmit: submitBankResult,
        onChange: (updatedScanData) {
          setState(() {
            scanData = updatedScanData;
          });
          if (kDebugMode) {
            print(scanData);
          }
        },
      );
    }
  }

  submitBankResult(submittedScanData) async {
    bool resultSubmitted = false;
    scanData = submittedScanData;
    if (scanData.iDBaseCode != null &&
        scanData.iDActivityCode != null &&
        scanData.gameTag != null &&
        scanData.scanTime != null &&
        scanData.gameID != null) {
      scanData.iDOpponent ??= "";
      scanData.comment ??= "";
      scanData.offline ??= 0;
      scanData.resultValue ??= 0;
      scanData.result = "Success";
      resultSubmitted = await dataManager.insertScan(scanData);
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
      DialogBuilder(context).showAlertOKDialog("Result", "Error: " + error);
    }
  }

  Future<void> submitResult(
    updatedScanData,
    ActivityData selectedActivity,
  ) async {
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
      resultSubmitted = await dataManager.insertScan(scanData);
    }
    if (resultSubmitted) {
      AlertData alertData = AlertData(alert: false, alertMessage: "Submitted");
      alertData = alerts.checkAlerts(selectedActivity, scanData);
      if (!alertData.alert!) {
        alertData.alertMessage = "Submitted";
      }

      DialogBuilder(context)
          .showAlertOKDialog("Result", alertData.alertMessage!);
      setState(() {
        scanData.result = null;
        scanData.gameTag = null;
        scanData.resultValue = 0;
        txtValueResult.text = "";
      });
    } else {
      DialogBuilder(context).showAlertOKDialog("Result", "Error: " + error);
    }
    //getSignedInPatrols();
    //verify data and submit to API
    dataManager.uploadOfflineScans();
    if (kDebugMode) {
      print(scanData);
    }
  }

  Future<void> signInPatrol(gameTag) async {
    DialogBuilder(context).showLoadingIndicator("Signing in Patrol");
    bool inDB = false;
    bool signedIn = false;
    PatrolData patrol = PatrolData();
    PatrolSignIn patrolSignIn = PatrolSignIn();
    patrol = Utils().getPatrolDataByGameTag(gameTag, widget.patrols);
    if (patrol.gameTag != null) {
      patrolSignIn.iDPatrol = patrol.gameTag;
      inDB = true;
    } else {
      patrolSignIn.iDPatrol = gameTag;
      inDB = false;
    }
    patrolSignIn.iDBaseCode = widget.base.baseCode;
    patrolSignIn.gameID = widget.base.gameID;
    patrolSignIn.offline = 0;
    patrolSignIn.status = 1;

    //get current time
    patrolSignIn.scanIn = Utils().getCurrentDateSQL();
    signedIn = await dataManager.signInPatrol(patrolSignIn);
    await getSignedInPatrols();
    DialogBuilder(context).hideOpenDialog();
    if (signedIn) {
      DialogBuilder(context).showAlertOKDialog(
          "Signed in Patrol", patrolSignIn.iDPatrol.toString());
      if (!inDB) {
        DialogBuilder(context).showAlertOKDialog(
            "Patrol not in database, CONTACT WWG ADMIN! ", gameTag);
      }
    } else {
      DialogBuilder(context).showAlertOKDialog("FAILED to Sign in Patrol",
          patrol.gameTag! + " " + patrol.patrolName!);
    }

    if (kDebugMode) {
      //print(patrolSignIn);
    }
  }

  Future<void> signOutPatrol(gameTag) async {
    PatrolSignIn patrol = PatrolSignIn();
    patrol = patrolsSignedIn.firstWhere(
        (element) => element.iDPatrol == gameTag,
        orElse: () => PatrolSignIn());
    if (patrol.iDPatrol != null) {
      DialogBuilder(context).showLoadingIndicator("Signing Out Patrol");
      //sign out patrol
      patrol.scanOut = Utils().getCurrentDateSQL();
      bool signedOut = await dataManager.signOutPatrol(patrol);
      DialogBuilder(context).hideOpenDialog();
      if (signedOut) {
        DialogBuilder(context)
            .showAlertOKDialog("Signed out Patrol", patrol.iDPatrol.toString());
      } else {
        DialogBuilder(context)
            .showAlertOKDialog("FAILED to Sign Out Patrol", patrol.iDPatrol!);
      }
    } else {
      //patrol already signed out
    }

    await getSignedInPatrols();

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
