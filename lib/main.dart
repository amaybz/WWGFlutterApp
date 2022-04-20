import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wwgnfcscoringsystem/classes/activities.dart';
import 'package:wwgnfcscoringsystem/classes/patrol_results.dart';
import 'package:wwgnfcscoringsystem/classes/wwgapi.dart';
import 'package:wwgnfcscoringsystem/base.dart';
import 'package:wwgnfcscoringsystem/login.dart';
import 'classes/base_results.dart';
import 'classes/games_results.dart';
import 'classes/sharedprefs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: const DarkLightTheme(),
    );
  }
}

bool _darkMode = false;

class DarkLightTheme extends StatefulWidget {
  const DarkLightTheme({Key? key}) : super(key: key);

  @override
  State<DarkLightTheme> createState() => _DarkLightThemeState();
}

class _DarkLightThemeState extends State<DarkLightTheme> {
  MySharedPrefs mySharedPrefs = MySharedPrefs();

  final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
  );

  final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WWG Scoring',
      theme: _darkMode ? _darkTheme : _lightTheme,
      home: MyHomePage(
        title: 'WWG Scoring',
        darkMode: _darkMode,
        onchangeDarkMode: (bool state) {
          setState(() {
            _darkMode = state;
            mySharedPrefs.saveBool("DarkMode", state);
          });
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {Key? key,
      required this.title,
      this.darkMode = false,
      this.onchangeDarkMode})
      : super(key: key);

  final String title;
  final bool darkMode;
  final ValueChanged<bool>? onchangeDarkMode;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MySharedPrefs mySharedPrefs = MySharedPrefs();
  String versionName = "";
  String versionCode = "";
  WebAPI webAPI = WebAPI();
  List<DropdownMenuItem<String>> listGamesDropdown = [
    const DropdownMenuItem(value: "0", child: Text("None Loaded")),
  ];
  String? selectedGame = "0";
  List<BaseData> listBases = [];
  bool loggedIn = false;
  List<ActivityData> listActivities = [];
  List<PatrolData> listPatrols = [];

  @override
  void initState() {
    super.initState();

    getVersionInfo();
    getTheme();
    getDataFromAPI();
  }

  void getTheme() async {
    bool darkMode = await mySharedPrefs.readBool("DarkMode");
    setState(() {
      widget.onchangeDarkMode!(darkMode);
    });
  }

  Future<APIValidateToken> validateAPIToken() async {
    webAPI.setApiKey(await mySharedPrefs.readStr('apikey'));
    APIValidateToken apiValidateToken =
        await webAPI.validateToken(webAPI.getApiKey);
    if (apiValidateToken.message == "Unauthorized") {
      _navigateToLogin(context);
    }

    return apiValidateToken;
  }

  void getDataFromAPI() async {
    APIValidateToken apiValidateToken = await validateAPIToken();
    loggedIn = await webAPI.getLoggedIn;
    if (kDebugMode) {
      print("logged in: " + loggedIn.toString());
    }
    if (loggedIn) {
      await getGames();
      getBases(selectedGame!);
      getActivities(selectedGame!);
      getPatrols(selectedGame!);
    }
  }

  Future<String?> getGames() async {
    GamesResults games = await webAPI.getGames();
    if (games.data != null) {
      List<GamesData> gamesDataList = games.data as List<GamesData>;
      listGamesDropdown.clear();
      selectedGame = null;
      for (GamesData gamesData in gamesDataList) {
        setState(() {
          listGamesDropdown.add(DropdownMenuItem(
              value: gamesData.gameID.toString(),
              child: Text(gamesData.gameName.toString())));
          if (gamesData.defaultGame == 1) {
            selectedGame = gamesData.gameID.toString();
          }
        });
      }
    }
    return selectedGame;
  }

  void getBases(String gameID) async {
    BasesResults bases = await webAPI.getBasesByGameID(gameID);
    if (bases.data != null) {
      List<BaseData> basesDataList = bases.data as List<BaseData>;
      setState(() {
        listBases = basesDataList;
      });
    }
  }

  void getActivities(String gameID) async {
    Activities activities = await webAPI.getActivitiesByGameID(gameID);
    if (activities.data != null) {
      List<ActivityData> activityDataList =
          activities.data as List<ActivityData>;
      setState(() {
        listActivities = activityDataList;
      });
    }
  }

  void getPatrols(String gameID) async {
    PatrolResults patrolResults = await webAPI.getPatrolsByGameID(gameID);
    if (patrolResults.data != null) {
      List<PatrolData> dataList = patrolResults.data as List<PatrolData>;
      setState(() {
        listPatrols = dataList;
      });
    }
  }

  void getVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      versionName = packageInfo.version;
      versionCode = packageInfo.buildNumber;
    });
  }

  _navigateToLogin(BuildContext context) async {
    await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  _navigateToGameBases(BuildContext context, int gameID, BaseData base) async {
    await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(
          builder: (context) => Base(
                gameID: gameID,
                base: base,
                activityData: listActivities,
                patrols: listPatrols,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (kDebugMode) {
      print("Screen Size: " + width.toString());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Weekend Wide Game'),
                  Text('Version: ' + versionName),
                ],
              ),
              decoration:
                  BoxDecoration(color: Theme.of(context).primaryColorDark),
            ),
            ListTile(
              title: const Text('Scoring'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Scan Tag'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Login'),
              onTap: () {
                Navigator.pop(context);
                _navigateToLogin(context);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Row(
                children: [
                  const Text('Dark Mode'),
                  Switch(
                      value: widget.darkMode,
                      onChanged: (toggle) {
                        setState(() {
                          widget.onchangeDarkMode!(toggle);
                        });
                      })
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
                'Welcome to Weekend Wide Game Scoring System to start select a Game.',
                style: Theme.of(context).textTheme.subtitle1),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 800),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButton(
                      value: selectedGame,
                      items: listGamesDropdown,
                      onChanged: (item) {
                        setState(() {
                          selectedGame = item as String;
                          getBases(selectedGame!);
                        });
                        if (kDebugMode) {
                          print("Selected Game: " + selectedGame!);
                        }
                      }),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            getDataFromAPI();
                          },
                          child: const Text("Refresh"))),
                ],
              ),
            ),
            Expanded(
              child: _buildListViewBases(),
            ),

            //FutureBuilder<APIValidateToken>(
            //    future: validateAPIToken(),
            //    builder: (BuildContext context,
            //        AsyncSnapshot<APIValidateToken> snapshot) {
            //      if (snapshot.hasData) {
            //        return Text(snapshot.data?.message as String,
            //            style: Theme.of(context).textTheme.subtitle1);
            //      } else {
            //        return const SizedBox(
            //          width: 60,
            //          height: 60,
            //          child: CircularProgressIndicator(),
            //       );
            //     }
            //   })
          ],
        ),
      ),
    );
  }

  Widget _buildListViewBases() {
    return ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: listBases.length,
        itemBuilder: (context, index) {
          //return Row();
          return _buildRowBases(listBases[index]);
        });
  }

  Widget _buildRowBases(BaseData item) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  Text(
                    item.baseName!,
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () {
                  setState(() {
                    _navigateToGameBases(context, item.gameID!, item);
                  });
                },
                child: const Text('Select'),
              ),
            ]),
      ),
    );
  }
}
