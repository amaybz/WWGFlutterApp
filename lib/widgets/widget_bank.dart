import 'package:flutter/material.dart';

import '../classes/activities.dart';
import '../classes/database/datamanager.dart';
import '../classes/patrol_sign_in.dart';
import '../classes/scan_results.dart';
import '../classes/utils.dart';

class Banking extends StatefulWidget {
  const Banking({
    Key? key,
    required this.activitiesData,
    required this.scanData,
    required this.onChange,
    required this.patrolsSignedIn,
  }) : super(key: key);

  final List<ActivityData> activitiesData;
  final ScanData scanData;
  final ValueChanged<ScanData> onChange;
  final List<PatrolSignIn> patrolsSignedIn;

  @override
  State<Banking> createState() => _BankingState();
}

class _BankingState extends State<Banking> {
  DataManager dataManager = DataManager();
  Utils utils = Utils();
  List<DropdownMenuItem<String>> listPatrolsDropdown = [
    const DropdownMenuItem(value: "0", child: Text("Please Sign in a Patrol"))
  ];

  @override
  void initState() {
    super.initState();
    updatePatrolsDropDown();
    dataManager.uploadOfflineScans();
  }

  void updatePatrolsDropDown() {
    bool stillSignedIn = false;
    for (int i = 0; i < widget.patrolsSignedIn.length; i++) {
      if (widget.patrolsSignedIn[i].iDPatrol == widget.scanData.gameTag) {
        stillSignedIn = true;
      }
    }
    if (!stillSignedIn) {
      widget.scanData.gameTag = null;
    }
    listPatrolsDropdown.clear();
    listPatrolsDropdown
        .addAll(utils.convertPatrolsListToDropDownList(widget.patrolsSignedIn));
  }

  @override
  Widget build(BuildContext context) {
    //Patrol
    //
    return FractionallySizedBox(
      widthFactor: 0.95,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                width: 150,
                child: const Text("Patrol:"),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: DropdownButton(
                  isExpanded: true,
                  value: widget.scanData.gameTag,
                  items: listPatrolsDropdown,
                  onChanged: (item) {
                    setState(() {
                      widget.scanData.gameTag = item.toString();
                      updatePatrolsDropDown();
                    });
                  },
                ),
              )
            ],
          ),
          Text("Account: IDActivityCode"),
          Text("Transaction Type: Comment"),
          Text("Amount: ResultValue"),
          Text("Patrol Accounts"),
          Text("Base Accounts"),
        ],
      ),
    );
  }
}
