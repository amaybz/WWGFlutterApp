import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../classes/activities.dart';
import '../classes/scan_results.dart';

class ValueResult extends StatefulWidget {
  const ValueResult(
      {Key? key,
      required this.activityData,
      required this.scanData,
      required this.onChange,
      required this.txtValueResult,
      this.label = "Score"})
      : super(key: key);

  final ActivityData activityData;
  final ScanData scanData;
  final ValueChanged<ScanData> onChange;
  final TextEditingController txtValueResult;
  final String label;

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
    if (widget.activityData.valueResultField == 1) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            width: 100,
            child: Text(widget.label + ":"),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: TextField(
                controller: widget.txtValueResult,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (string) {
                  widget.scanData.resultValue = int.tryParse(string);
                }),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
