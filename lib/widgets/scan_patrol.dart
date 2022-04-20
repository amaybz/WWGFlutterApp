import 'dart:convert';

import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:wwgnfcscoringsystem/classes/patrol_results.dart';

class ScanPatrol extends StatefulWidget {
  const ScanPatrol({
    Key? key,
    required this.patrolData,
    required this.onSignIn,
  }) : super(key: key);

  final List<PatrolData> patrolData;
  final Function(String patrolTag) onSignIn;

  @override
  State<ScanPatrol> createState() => _ScanPatrolState();
}

class _ScanPatrolState extends State<ScanPatrol> {
  Map<String, dynamic>? nfcResult;
  NdefMessage? ndefMessage;
  String? ndefText = "";
  bool isAvailable = false;
  List<DropdownMenuItem<String>> listPatrolsDropdown = [
    const DropdownMenuItem(value: "0", child: Text("No Patrols Loaded"))
  ];
  String? selectedPatrol;

  @override
  void initState() {
    super.initState();
    updatePatrolsDropDown();
    if (kDebugMode) {
      print("NFC: Starting Session");
    }
    NfcManager.instance.startSession(
      onDiscovered: (tag) async {
        try {
          final result = await handleTag(tag);
          if (result == null) return;
          setState(() => ndefText = result);
        } catch (e) {
          await NfcManager.instance.stopSession().catchError((_) {
            /* no op */
          });
          setState(() => ndefText = '$e');
        }
      },
    ).catchError((e) => setState(() => ndefText = '$e'));
  }

  @override
  void dispose() {
    if (kDebugMode) {
      print("NFC: Close Session");
    }
    NfcManager.instance.stopSession().catchError((_) {
      /* no op */
    });
    super.dispose();
  }

  Future<bool> nfcAvailable() async {
    isAvailable = await NfcManager.instance.isAvailable();
    return isAvailable;
  }

  void updatePatrolsDropDown() {
    if (widget.patrolData.isNotEmpty) {
      listPatrolsDropdown.clear();
      for (PatrolData patrol in widget.patrolData) {
        setState(() {
          listPatrolsDropdown.add(DropdownMenuItem(
              value: patrol.gameTag,
              child: Text(patrol.gameTag! + " " + patrol.patrolName!)));
        });
      }
    } else {
      setState(() {
        listPatrolsDropdown.clear();
        listPatrolsDropdown.add(const DropdownMenuItem(
            value: "0", child: Text("No Patrols Loaded")));
      });
    }
  }

  Future<String?> handleTag(tag) async {
    await nfcAvailable();
    if (isAvailable) {
      nfcResult = tag.data;
      var ndef = Ndef.from(tag);
      ndefMessage = await ndef?.read();
      NdefRecord? ndefRecord = ndefMessage?.records.first;
      final languageCodeLength = ndefRecord?.payload.first;
      final textBytes = ndefRecord?.payload.sublist(1 + languageCodeLength!);
      ndefText = utf8.decode(textBytes!);
      if (kDebugMode) {
        print("NFC: Scan Tag");
        print(nfcResult);
        print(ndefText);
      }
    } else {
      {
        ndefText = "No NFC device";
        if (kDebugMode) {
          print("No NFC");
        }
      }
    }
    return ndefText;
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.99,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(2.0),
            padding: const EdgeInsets.all(2.0),
            child: const Text("Base Sign in"),
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
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  const Text(
                      "NFC: Press tag to back of device to login a patrol."),
                  Text(ndefText!),
                ],
              ),
            ),
          ),
          const Text("OR"),
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
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    const Text(
                        "Barcode: Click here to scan the Patrols barcode"),
                    ElevatedButton(
                        onPressed: () {}, child: const Text("Scan Barcode")),
                  ],
                )),
          ),
          const Text("OR"),
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
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Text: Select Patrol from dropdown"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButton(
                            value: selectedPatrol,
                            items: listPatrolsDropdown,
                            onChanged: (item) {
                              setState(() {
                                selectedPatrol = item.toString();
                              });
                            }),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              widget.onSignIn(selectedPatrol!);
                            },
                            child: const Text("Sign In"),
                          ),
                        )
                      ],
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
