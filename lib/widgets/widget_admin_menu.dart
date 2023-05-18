import 'package:flutter/material.dart';

class AdminMenu extends StatefulWidget {
  const AdminMenu({Key? key, required this.accessLevel}) : super(key: key);

  final int accessLevel;

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
            //_navigateToLogin(context);
          },
        )
      ]);
    }
    return Container();
  }
}
