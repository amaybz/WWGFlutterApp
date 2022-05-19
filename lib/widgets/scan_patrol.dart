import 'dart:convert';

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:wwgnfcscoringsystem/classes/patrol_results.dart';
import 'package:wwgnfcscoringsystem/classes/utils.dart';

import '../classes/patrol_sign_in.dart';

class ScanPatrol extends StatefulWidget {
  const ScanPatrol(
      {Key? key,
      required this.patrolData,
      required this.onSignIn,
      required this.patrolsSignedIn,
      required this.onSignOut})
      : super(key: key);

  final List<PatrolData> patrolData;
  final Function(String patrolTag) onSignIn;
  final Function(String patrolTag) onSignOut;
  final List<PatrolSignIn> patrolsSignedIn;

  @override
  State<ScanPatrol> createState() => _ScanPatrolState();
}

class _ScanPatrolState extends State<ScanPatrol> {
  Map<String, dynamic>? nfcResult;
  NdefMessage? ndefMessage;
  String? ndefText = "";
  String? ndefId = "";
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
          final splitData = ndefText?.split(':');
          if (kDebugMode) {
            print(splitData);
          } // [Hello, world!];
          widget.onSignIn(splitData![0]);
        } catch (e) {
          await NfcManager.instance.stopSession().catchError((_) {
            /* no op */
          });
          setState(() => ndefText = '$e');
        }
      },
    ).catchError((e) => setState(() => ndefText = '$e'));
    nfcAvailable();
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
    setState(() {
      isAvailable = isAvailable;
    });
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

  Future<String?> handleTag(NfcTag tag) async {
    await nfcAvailable();
    if (isAvailable) {
      nfcResult = tag.data;
      print(nfcResult);
      var ndef = Ndef.from(tag);

      ndefMessage = await ndef?.read();
      NdefRecord? ndefRecord = ndefMessage?.records.first;

      //decode identifier
      final Uint8List ndefTagId = ndef?.additionalData["identifier"];
      ndefId = ndefTagId.toString();
      //decode Message
      final languageCodeLength = ndefRecord?.payload.first;
      final textBytes = ndefRecord?.payload.sublist(1 + languageCodeLength!);
      ndefText = utf8.decode(textBytes!);
      if (kDebugMode) {
        print("NFC: Scan Tag");
        print("Ndef ID: " + ndefId.toString());
        print("Ndef Text: " + ndefText.toString());
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
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(2.0),
            padding: const EdgeInsets.all(2.0),
            child: const Text("Base Sign in"),
          ),
          NFCScan(ndefText: ndefText, isAvailable: isAvailable),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
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
          Expanded(
            flex: 2,
            child: _buildListView(),
          ),
        ]);
  }

  Widget _buildListView() {
    return ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: widget.patrolsSignedIn.length,
        itemBuilder: (context, index) {
          return _buildRowPitData(widget.patrolsSignedIn[index]);
        });
  }

  Widget _buildRowPitData(PatrolSignIn item) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 250, maxWidth: 400),
          child: Column(
            children: [
              Text(item.iDPatrol.toString() +
                  ": " +
                  Utils()
                      .getPatrolDataByGameTag(
                          item.iDPatrol.toString(), widget.patrolData)
                      .patrolName
                      .toString()),
              Text("Sign in time: " + item.scanIn.toString()),
            ],
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(),
          onPressed: () {
            widget.onSignOut(item.iDPatrol!);
          },
          child: const Text('Check Out'),
        ),
      ]),
    );
  }
}

class NFCScan extends StatelessWidget {
  const NFCScan({
    Key? key,
    required this.ndefText,
    required this.isAvailable,
  }) : super(key: key);

  final String? ndefText;
  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    if (isAvailable) {
      return FractionallySizedBox(
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
              const Text("NFC: Press tag to back of device to login a patrol."),
              Text(ndefText!),
            ],
          ),
        ),
      );
    } else {
      return FractionallySizedBox(
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
            children: const [Text("NFC: Not available on this device.")],
          ),
        ),
      );
    }
  }
}
