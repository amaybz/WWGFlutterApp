import 'package:flutter/material.dart';
import 'package:wwgnfcscoringsystem/classes/base_results.dart';
import 'package:wwgnfcscoringsystem/classes/patrol_results.dart';
import 'package:wwgnfcscoringsystem/classes/utils.dart';
import 'package:wwgnfcscoringsystem/widgets/widget_info_scout_details.dart';
import '../classes/activities.dart';
import '../classes/database/datamanager.dart';
import '../classes/factions.dart';
import '../classes/groups.dart';
import '../classes/patrol_sign_in.dart';
import '../classes/scan_results.dart';

class Info extends StatefulWidget {
  const Info({
    Key? key,
    required this.activitiesData,
    required this.scanData,
    required this.onChange,
    required this.patrolsSignedIn,
    required this.baseData,
    required this.patrols,
    required this.groups,
    required this.fractions,
  }) : super(key: key);

  final List<ActivityData> activitiesData;
  final ScanData scanData;
  final BaseData baseData;
  final List<PatrolData> patrols;
  final ValueChanged<ScanData> onChange;
  final List<PatrolSignIn> patrolsSignedIn;
  final List<GroupData> groups;
  final List<FactionData> fractions;

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  DataManager dataManager = DataManager();
  Utils utils = Utils();
  int patrolBalance = 0;
  int baseBalance = 0;
  List<DropdownMenuItem<String>> listPatrolsDropdown = [
    const DropdownMenuItem(value: "0", child: Text("Please Sign in a Patrol"))
  ];

  @override
  void initState() {
    super.initState();
    updatePatrolsDropDown();
    dataManager.uploadOfflineScans();
    getBaseBalance(Utils()
        .getFractionDataByID(widget.baseData.iDFaction!, widget.fractions)
        .factionName!);
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

  Future<int> getPatrolBalance(String gameTag, account) async {
    DataManager dataManager = DataManager();
    ScanResults scanResults = ScanResults();
    setState(() {
      patrolBalance = 0;
    });
    int balance = 0;
    Utils utils = Utils();
    if (widget.scanData.gameTag != null) {
      scanResults = await dataManager.getScanData(widget.scanData.gameID!);
      balance = utils.getBankBalancePatrol(
          scanResults, gameTag, account, widget.scanData.gameID!);
      setState(() {
        patrolBalance = balance;
      });
    }

    return balance;
  }

  Future<int> getBaseBalance(String account) async {
    DataManager dataManager = DataManager();
    ScanResults scanResults = ScanResults();
    int balance = 0;
    Utils utils = Utils();

    scanResults = await dataManager.getScanData(widget.scanData.gameID!);
    balance = utils.getBankBalanceBase(
        scanResults, widget.baseData.baseID!, account, widget.scanData.gameID!);
    setState(() {
      baseBalance = balance;
    });

    return balance;
  }

  @override
  Widget build(BuildContext context) {
    //Patrol
    //
    return FractionallySizedBox(
      widthFactor: 0.95,
      child: Column(
        children: [
          FractionallySizedBox(
            widthFactor: 0.99,
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  //color: Colors.red,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      "Base Details",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name: ",
                            style: Theme.of(context).textTheme.titleSmall),
                        Text(widget.baseData.baseName!),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Faction: ",
                            style: Theme.of(context).textTheme.titleSmall),
                        Text(Utils()
                            .getFractionDataByID(
                                widget.baseData.iDFaction!, widget.fractions)
                            .factionName!),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Base Balance: ",
                            style: Theme.of(context).textTheme.titleSmall),
                        Text(baseBalance.toString()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Base Level: ",
                            style: Theme.of(context).textTheme.titleSmall),
                        Text(widget.baseData.level.toString()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Details: ",
                            style: Theme.of(context).textTheme.titleSmall),
                        Expanded(
                          child: Text(widget.baseData.details!,
                              softWrap: false,
                              maxLines: 7,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          FractionallySizedBox(
            widthFactor: 0.99,
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  //color: Colors.red,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      "Patrol Details",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          width: 150,
                          child: Text("Patrol Tag:",
                              style: Theme.of(context).textTheme.titleSmall),
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
                                getPatrolBalance(
                                    widget.scanData.gameTag!, "Patrol");
                                getBaseBalance(Utils()
                                    .getFractionDataByID(
                                        widget.baseData.iDFaction!,
                                        widget.fractions)
                                    .factionName!);
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    InfoScoutDetails(
                      scanData: widget.scanData,
                      patrols: widget.patrols,
                      groups: widget.groups,
                      fractions: widget.fractions,
                      bankBalance: patrolBalance,
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
