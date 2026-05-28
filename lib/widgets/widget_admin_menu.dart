import 'package:flutter/material.dart';
import 'package:wwgnfcscoringsystem/new_score_adjustment_page.dart';

class AdminMenu extends StatefulWidget {
  const AdminMenu({Key? key, required this.accessLevel, required this.gameID}) : super(key: key);

  final int accessLevel;
  final int gameID;

  @override
  State<AdminMenu> createState() => _AdminMenuState();
}

class _AdminMenuState extends State<AdminMenu> {
  @override
  Widget build(BuildContext context) {
    if (widget.accessLevel < 1) {
      return Column(children: [
        const Text("Admin Menu Testing"),
        ListTile(
          title: const Text("Score Adjustment"),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewScoreAdjustmentPage(gameID: widget.gameID)),
            );
          },
        )
      ]);
    }
    return Container();
  }
}
