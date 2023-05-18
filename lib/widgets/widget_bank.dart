import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wwgnfcscoringsystem/classes/bank_class.dart';

import '../classes/activities.dart';
import '../classes/database/datamanager.dart';
import '../classes/patrol_sign_in.dart';
import '../classes/scan_results.dart';
import '../classes/utils.dart';

class Banking extends StatefulWidget {
  const Banking({Key? key,
    required this.activitiesData,
    required this.scanData,
    required this.onChange,
    required this.patrolsSignedIn,
    required this.txtValueAmount,
    required this.listBankData,
    required this.onSubmit(ScanData scanData)})
      : super(key: key);

  final List<ActivityData> activitiesData;
  final ScanData scanData;
  final ValueChanged<ScanData> onChange;
  final List<PatrolSignIn> patrolsSignedIn;
  final TextEditingController txtValueAmount;
  final List<BankData> listBankData;
  final Function(ScanData scanData) onSubmit;

  @override
  State<Banking> createState() => _BankingState();
}

class _BankingState extends State<Banking> {
  DataManager dataManager = DataManager();
  Utils utils = Utils();
  List<DropdownMenuItem<String>> listPatrolsDropdown = [
    const DropdownMenuItem(value: "0", child: Text("Please Sign in a Patrol"))
  ];
  List<DropdownMenuItem<String>> listAccountsDropdown = [
    const DropdownMenuItem(value: "0", child: Text("No Accounts Configured"))
  ];

  List<DropdownMenuItem<String>> listTransactionTypes = [
    const DropdownMenuItem(value: "Deposit", child: Text("Deposit")),
    const DropdownMenuItem(value: "Withdrawal", child: Text("Withdrawal")),
  ];

  @override
  void initState() {
    super.initState();
    updatePatrolsDropDown();
    updateAccountsDropDown();
    clearTransactionTypeDropDown();
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

  void updateAccountsDropDown() {
    widget.scanData.iDActivityCode = null;
    listAccountsDropdown.clear();
    listAccountsDropdown.addAll(
        utils.convertListBankDataToAccountsDropDownList(widget.listBankData));
  }

  void clearTransactionTypeDropDown() {
    widget.scanData.comment = null;
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                width: 150,
                child: const Text("Account:"),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: DropdownButton(
                  isExpanded: true,
                  value: widget.scanData.iDActivityCode,
                  items: listAccountsDropdown,
                  onChanged: (item) {
                    setState(() {
                      widget.scanData.iDActivityCode = item.toString();
                    });
                  },
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                width: 150,
                child: const Text("Transaction Type:"),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: DropdownButton(
                  isExpanded: true,
                  value: widget.scanData.comment,
                  items: listTransactionTypes,
                  onChanged: (item) {
                    setState(() {
                      widget.scanData.comment = item.toString();
                      updatePatrolsDropDown();
                    });
                  },
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                width: 150,
                child: const Text("Amount:"),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: TextField(
                    controller: widget.txtValueAmount,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (string) {
                      widget.scanData.resultValue = int.tryParse(string);
                    }),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.scanData.scanTime = Utils().getCurrentDateSQL();
                  widget.onSubmit(widget.scanData);
                });
              },
              child: const Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }
}
