import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wwgnfcscoringsystem/widgets/scan_patrol.dart';

import 'login.dart';

class GameBases extends StatefulWidget {
  const GameBases({Key? key}) : super(key: key);

  @override
  State<GameBases> createState() => _GameBasesState();
}

class _GameBasesState extends State<GameBases> {
  int _selectedTab = 0;

  _navigateToLogin(BuildContext context) async {
    await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  void handleMenuClick(String value) async {
    switch (value) {
      case 'Work Offline':
        if (kDebugMode) {
          print("Work Offline Selected");
        }
        //showAlertDialogClearMatch(context);
        break;
      case 'Settings':
        if (kDebugMode) {
          print("Settings Selected");
        }
        //_navigateToSettings(context);
        break;
      case 'Login':
        if (kDebugMode) {
          print("Login Selected");
        }
        _navigateToLogin(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WWG - Base Title'),
        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: handleMenuClick,
              itemBuilder: (BuildContext context) {
                return {'Work Offline', 'Settings', 'Login'}
                    .map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              }),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedTab, // th
        onTap: (value) {
          setState(() => _selectedTab = value);
        }, // is will be set when a new tab is tapped
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_overscan),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Results',
          ),
        ],
      ),
      body: Column(
        children: [
          const Text("Base Contents here"),
          Container(
              margin: const EdgeInsets.all(0.0),
              padding: EdgeInsets.all(0.0),
              child: _showTab(_selectedTab)),
        ],
      ),
    );
  }

  _showTab(int index) {
    if (index == 0) {
      return ScanPatrol();
    }
  }
}
