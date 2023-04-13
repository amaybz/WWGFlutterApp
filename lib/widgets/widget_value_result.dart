import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../classes/activities.dart';
import '../classes/scan_results.dart';

class ValueResult extends StatefulWidget {
  const ValueResult(
      {Key? key,
        required this.active ,
      required this.activityData,
      required this.scanData,
      required this.onChange,
      required this.txtValueResult,
      this.label = "Score"})
      : super(key: key);

  final ActivityData activityData;
  final ScanData scanData;
  final ValueChanged<int> onChange;
  final TextEditingController txtValueResult;
  final String label;
  final int active;

  @override
  State<ValueResult> createState() => _ValueResultState();
}

class _ValueResultState extends State<ValueResult> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.active == 1) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            width: 150,
            child: Text(widget.label + ":"),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: TextField(
                controller: widget.txtValueResult,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (string) {
                  widget.onChange(int.tryParse(string)!) ;
                }),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
