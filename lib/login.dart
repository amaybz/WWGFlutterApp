import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'classes/api_login.dart';
import 'classes/database/sharedprefs.dart';
import 'classes/database/wwgapi.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController? _txtUsername;
  TextEditingController? _txtPassword;
  MySharedPrefs mySharedPrefs = MySharedPrefs();

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
    }
  }

  Future<APILogin> doAPILogin(String userName, String password) async {
    WebAPI webAPI = WebAPI();
    APILogin apiLogin = await webAPI.login(userName, password);
    mySharedPrefs.saveStr('apikey', apiLogin.jwt!);
    if (apiLogin.message == "Successful login.") {
      Navigator.pop(context);
    }
    return apiLogin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WWG Login'), actions: <Widget>[
        PopupMenuButton<String>(
            onSelected: handleMenuClick,
            itemBuilder: (BuildContext context) {
              return {'Work Offline', 'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            }),
      ]),
      body: LogInForm(
        txtUsername: _txtUsername,
        txtPassword: _txtPassword,
        onSubmit: (user) {
          if (kDebugMode) {
            print("Login Pressed");
            print(user[0]);
            //print(user[1]);
          }

          doAPILogin(user[0], user[1]);
        },
      ),
    );
  }
}

class LogInForm extends StatefulWidget {
  const LogInForm({
    Key? key,
    required this.onSubmit,
    this.txtUsername,
    this.txtPassword,
  }) : super(key: key);

  final TextEditingController? txtUsername;
  final TextEditingController? txtPassword;
  final ValueChanged<List<String>> onSubmit;

  @override
  State<LogInForm> createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  String? _username = "";
  String? _password = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            children: [
              ConstrainedBox(
                constraints:
                    const BoxConstraints(maxHeight: 200, maxWidth: 200),
                child: TextField(
                  controller: widget.txtUsername,
                  onChanged: (String text) {
                    setState(() {
                      _username = text;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "User Name",
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              ConstrainedBox(
                constraints:
                    const BoxConstraints(maxHeight: 200, maxWidth: 200),
                child: TextField(
                  controller: widget.txtPassword,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  onChanged: (String text) {
                    setState(() {
                      _password = text;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxHeight: 200, maxWidth: 200),
                  child: ElevatedButton(
                    onPressed: () {
                      List<String> user = [];
                      user.add(_username!);
                      user.add(_password!);

                      setState(() {
                        widget.onSubmit(user);
                      });
                    },
                    child: const Text("Login"),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
