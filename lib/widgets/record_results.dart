import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wwgnfcscoringsystem/classes/activities.dart';
import 'package:wwgnfcscoringsystem/classes/database/datamanager.dart';
import 'package:wwgnfcscoringsystem/classes/patrol_sign_in.dart';
import 'package:wwgnfcscoringsystem/classes/scan_results.dart';
import 'package:wwgnfcscoringsystem/widgets/widget_success_fail.dart';
import 'package:wwgnfcscoringsystem/widgets/widget_value_result.dart';

import '../classes/utils.dart';

class RecordResults extends StatefulWidget {
  const RecordResults({
    Key? key,
    required this.listActivitiesDropdown,
    required this.onSubmit(ScanData scanData, ActivityData selectedActivity),
    required this.scanData,
    required this.activitiesData,
    required this.patrolsSignedIn,
    required this.onChange,
    required this.txtValueResult,
  }) : super(key: key);

  final List<DropdownMenuItem<String>> listActivitiesDropdown;

  final ScanData scanData;
  final List<ActivityData> activitiesData;
  final Function(ScanData scanData, ActivityData selectedActivity) onSubmit;
  final List<PatrolSignIn> patrolsSignedIn;
  final ValueChanged<ScanData> onChange;
  final TextEditingController txtValueResult;

  @override
  State<RecordResults> createState() => _RecordResultsState();
}

class _RecordResultsState extends State<RecordResults> {
  String? selectedActivityId;
  ActivityData selectedActivity = ActivityData();
  Utils utils = Utils();
  List<DropdownMenuItem<String>> listPatrolsDropdown = [
    const DropdownMenuItem(value: "0", child: Text("Please Sign in a Patrol"))
  ];
  DataManager dataManager = DataManager();

  @override
  void initState() {
    super.initState();
    updatePatrolsDropDown();
    dataManager.uploadOfflineScans();
    widget.scanData.comment = null;
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

  void submitClicked() {
    DateTime now = DateTime.now();
    widget.scanData.scanTime = Utils().getCurrentDateSQL();
    if (kDebugMode) {
      print(widget.scanData.scanTime);
    }
    //widget.scanData.result = "Success";
    widget.onSubmit(widget.scanData, getSelectedActivity());
  }

  void setActivityCode(int activityID) {
    List<ActivityData> filteredList =
        widget.activitiesData.where((i) => i.activityID == activityID).toList();
    if (filteredList.isNotEmpty) {
      for (ActivityData activities in filteredList) {
        setState(() {
          widget.scanData.iDActivityCode = activities.activityCode;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FractionallySizedBox(
          widthFactor: 0.95,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    width: 150,
                    child: const Text("Activity:"),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: DropdownButton(
                        isExpanded: true,
                        value: selectedActivityId,
                        items: widget.listActivitiesDropdown,
                        onChanged: (item) {
                          setState(() {
                            selectedActivityId = item.toString();
                            widget.scanData.result = null;
                            widget.scanData.resultValue = null;
                            widget.txtValueResult.text = "";
                            try {
                              setActivityCode(int.parse(selectedActivityId!));
                            } catch (e) {
                              if (kDebugMode) {
                                print("Error Converting selectedActivity: " +
                                    e.toString());
                              }
                            }
                          });
                        }),
                  )
                ],
              ),
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
              const Text("Results: "),
              SuccessFailField(
                activityData: getSelectedActivity(),
                onChange: (updatedScanData) {
                  setState(() {
                    widget.scanData.result = updatedScanData.result;
                    widget.onChange(updatedScanData);
                  });
                },
                scanData: widget.scanData,
              ),
              ValueResult(
                txtValueResult: widget.txtValueResult,
                activityData: getSelectedActivity(),
                label: getSelectedActivity().valueResultName.toString(),
                scanData: widget.scanData,
                onChange: (updatedScanData) {
                  setState(() {
                    widget.scanData.resultValue = updatedScanData.resultValue;
                    widget.onChange(updatedScanData);
                  });
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    submitClicked();
                  },
                  child: const Text("Submit"))
            ],
          ),
        )
      ],
    );
  }

  ActivityData getSelectedActivity() {
    return widget.activitiesData.firstWhere(
        (element) => element.activityID.toString() == selectedActivityId,
        orElse: () => ActivityData());
  }
}
