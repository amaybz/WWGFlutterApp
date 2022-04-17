import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class ScanPatrol extends StatefulWidget {
  const ScanPatrol({
    Key? key,
  }) : super(key: key);

  @override
  State<ScanPatrol> createState() => _ScanPatrolState();
}

class _ScanPatrolState extends State<ScanPatrol> {
  Map<String, dynamic>? nfcResult;
  bool isAvailable = false;

  Future<bool> nfcAvailable() async {
    isAvailable = await NfcManager.instance.isAvailable();
    return isAvailable;
  }

  Future<Map<String, dynamic>?> _tagRead() async {
    await nfcAvailable();
    if (isAvailable) {
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        nfcResult = tag.data;
        NfcManager.instance.stopSession();
      });
      print("Scan NFC");
      print(nfcResult);
    } else {
      {
        print("No NFC");
      }
    }
    return nfcResult;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("NFC scan"),
        ElevatedButton(
            onPressed: () {
              _tagRead();
            },
            child: const Text("NFC Scan"))
      ],
    );
  }
}
