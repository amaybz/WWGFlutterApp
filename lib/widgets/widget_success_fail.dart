import 'package:flutter/material.dart';
import 'package:wwgnfcscoringsystem/classes/activities.dart';
import 'package:wwgnfcscoringsystem/classes/scan_results.dart';

class SuccessFailField extends StatefulWidget {
  const SuccessFailField(
      {Key? key,
      required this.activityData,
      required this.scanData,
      required this.onChange})
      : super(key: key);
  final ActivityData activityData;
  final ScanData scanData;
  final ValueChanged<ScanData> onChange;

  @override
  State<SuccessFailField> createState() => _SuccessFailFieldState();
}

class _SuccessFailFieldState extends State<SuccessFailField> {
  List<DropdownMenuItem<String>> listSuccessFail = [
    const DropdownMenuItem(value: "Success", child: Text("Success")),
    const DropdownMenuItem(value: "Fail", child: Text("Fail")),
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.activityData.successFailResultField == 1) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            width: 100,
            child: const Text("Result:"),
          ),
          Flexible(
              fit: FlexFit.loose,
              child: DropdownButton(
                isExpanded: true,
                value: widget.scanData.result,
                items: listSuccessFail,
                onChanged: (item) {
                  setState(() {
                    widget.scanData.result = item.toString();
                  });
                },
              )),
        ],
      );
    } else {
      return Container();
    }
  }
}
