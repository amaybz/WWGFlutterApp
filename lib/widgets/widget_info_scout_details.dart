import 'package:flutter/material.dart';
import '../classes/factions.dart';
import '../classes/groups.dart';
import '../classes/patrol_results.dart';
import '../classes/scan_results.dart';

import '../classes/utils.dart';

class InfoScoutDetails extends StatefulWidget {
  const InfoScoutDetails({
    Key? key,
    required this.scanData,
    required this.patrols,
    required this.groups,
    required this.fractions,
  }) : super(key: key);

  final ScanData scanData;
  final List<PatrolData> patrols;
  final List<GroupData> groups;
  final List<FactionData> fractions;

  @override
  State<InfoScoutDetails> createState() => _InfoScoutDetailsState();
}

class _InfoScoutDetailsState extends State<InfoScoutDetails> {
  @override
  Widget build(BuildContext context) {
    if (widget.scanData.gameTag != null) {
      return Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ", style: Theme.of(context).textTheme.titleSmall),
            Text(Utils()
                .getPatrolDataByGameTag(
                    widget.scanData.gameTag as String, widget.patrols)
                .patrolName!),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Group: ", style: Theme.of(context).textTheme.titleSmall),
            Text(Utils()
                .getGroupDataByID(
                    Utils()
                        .getPatrolDataByGameTag(
                            widget.scanData.gameTag as String, widget.patrols)
                        .iDGroup!,
                    widget.groups)
                .groupName!),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Size: ", style: Theme.of(context).textTheme.titleSmall),
            Text(Utils()
                .getPatrolDataByGameTag(
                    widget.scanData.gameTag as String, widget.patrols)
                .sizeScore
                .toString()),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Faction: ", style: Theme.of(context).textTheme.titleSmall),
            Text(Utils()
                .getFractionDataByID(
                    Utils()
                        .getPatrolDataByGameTag(
                            widget.scanData.gameTag as String, widget.patrols)
                        .iDFaction!,
                    widget.fractions)
                .factionName!),
          ],
        ),
      ]);
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Name: ", style: Theme.of(context).textTheme.titleSmall),
          const Text("Please Select a Patrol"),
        ],
      );
    }
  }
}
