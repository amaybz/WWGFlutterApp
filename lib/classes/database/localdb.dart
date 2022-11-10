import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wwgnfcscoringsystem/classes/bank_class.dart';
import 'package:wwgnfcscoringsystem/classes/base_results.dart';
import 'package:wwgnfcscoringsystem/classes/fractions.dart';
import 'package:wwgnfcscoringsystem/classes/games_results.dart';
import 'package:wwgnfcscoringsystem/classes/groups.dart';
import 'package:wwgnfcscoringsystem/classes/patrol_results.dart';
import 'package:wwgnfcscoringsystem/classes/patrol_sign_in.dart';
import 'package:wwgnfcscoringsystem/classes/scan_results.dart';

import '../activities.dart';

class LocalDB {
  static const _databaseName = "local_database.db";
  // Increment this version when you need to change the schema.
  static const _databaseVersion = 15;

  final String tblBases = "tblbases";
  final String tblGameConfig = "tblgameconfig";
  final String tblActivities = "tblactivities";
  final String tblPatrols = "tblpatrol";
  final String tblBaseSignIn = "tblbasesignin";
  final String tblScan = "tblscan";
  final String tblBankConfig = "tblbankconfig";
  final String tblFaction = "tblFaction";
  final String tblGroup = "tblgroup";

  // Make this a singleton class.
  LocalDB._privateConstructor();
  static final LocalDB instance = LocalDB._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    String path = join(await getDatabasesPath(), _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  void _createTables(Database db, int version) async {
    final String createTblBankConfig = "CREATE TABLE IF NOT EXISTS " +
        tblBankConfig +
        "("
            "IDAccount INTEGER PRIMARY KEY, "
            "AccountName TEXT, "
            "Dep INTEGER,"
            "Withdraw INTEGER,"
            "DisplayPatrolBalance INTEGER,"
            "DisplayBaseBalance INTEGER"
            ")";

    final String createTblBases = "CREATE TABLE IF NOT EXISTS " +
        tblBases +
        "("
            "BaseID INTEGER PRIMARY KEY, "
            "GameID INTEGER, "
            "BaseName TEXT,"
            "BaseCode TEXT,"
            "RandomEvents INTEGER,"
            "RandomChance INTEGER,"
            "RandomListID INTEGER,"
            "level INTEGER,"
            "IDFaction INTEGER,"
            "Bank INTEGER,"
            "Details TEXT)";

    final String createTblGameConfig = "CREATE TABLE IF NOT EXISTS " +
        tblGameConfig +
        "("
            "GameID INTEGER PRIMARY KEY, "
            "GameName TEXT, "
            "DeviceName TEXT, "
            "Remote INTEGER,"
            "DefaultGame INTEGER)";

    final String createTblActivities = "CREATE TABLE IF NOT EXISTS " +
        tblActivities +
        "("
            "ActivityID INTEGER PRIMARY KEY,"
            "BaseID INTEGER,"
            "ActivityName TEXT,"
            "ActivityCode TEXT,"
            "ValueResultName TEXT,"
            "ValueResultField INTEGER,"
            "ValueResultMax INTEGER,"
            "ValueResultName2 TEXT,"
            "ValueResultField2 INTEGER,"
            "SuccessFailResultField INTEGER,"
            "SuccessPartialFailResultField INTEGER,"
            "CommentField INTEGER,"
            "ActivityType INTEGER,"
            "RandomGen INTEGER,"
            "RandomGenListID INTEGER,"
            "Trade INTEGER,"
            "HideSubmitButton INTEGER,"
            "Bank INTEGER,"
            "Alert INTEGER,"
            "AlertRule INTEGER,"
            "AlertCount INTEGER,"
            "AlertMessage TEXT,"
            "AlertMessagePartial TEXT,"
            "AlertMessageFail TEXT,"
            "Reward INTEGER,"
            "RewardValue INTEGER,"
            "Upgrades INTEGER,"
            "ItemCrafting INTEGER,"
            "Ranking INTEGER,"
            "DisableWithdrawal INTEGER,"
            "DropDownField INTEGER,"
            "Scoring_type INTEGER,"
            "Scoring_Success INTEGER,"
            "Scoring_Partial INTEGER,"
            "Scoring_Fail INTEGER,"
            "Scoring_Value INTEGER,"
            "DropDownFieldListID INTEGER,"
            "PassBasedonValueResult INTEGER,"
            "PassValue INTEGER,"
            "BaseControl INTEGER,"
            "GameID INTEGER"
            ")";

    final String createTblPatrols = "CREATE TABLE IF NOT EXISTS " +
        tblPatrols +
        "("
            "IDPatrol INTEGER PRIMARY KEY, "
            "IDGroup INTEGER, "
            "GameID INTEGER, "
            "PatrolName TEXT,"
            "GameTag TEXT,"
            "AgeScore INTEGER,"
            "SizeScore INTEGER,"
            "Handicap INTEGER,"
            "IDFaction INTEGER)";

    final String createTblBaseSignIn = "CREATE TABLE IF NOT EXISTS " +
        tblBaseSignIn +
        "("
            "IDSignIn INTEGER PRIMARY KEY, "
            "IDPatrol TEXT, "
            "IDBaseCode TEXT, "
            "ScanIn TEXT,"
            "ScanOut TEXT,"
            "Status INTEGER,"
            "GameID INTEGER,"
            "offline INTEGER"
            ")";

    final String createTblScan = "CREATE TABLE IF NOT EXISTS " +
        tblScan +
        "("
            "GameTag TEXT NOT NULL, "
            "ScanTime TEXT NOT NULL, "
            "GameID INTEGER, "
            "IDBaseCode TEXT,"
            "IDActivityCode TEXT,"
            "Comment TEXT,"
            "Offline INTEGER,"
            "ResultValue INTEGER,"
            "Result TEXT,"
            "IDOpponent TEXT,"
            "IDFaction TEXT,"
            "PRIMARY KEY (GameTag, ScanTime)"
            ")";

    final String createTblFaction = "CREATE TABLE IF NOT EXISTS " +
        tblFaction +
        "("
            "IDFaction INTEGER PRIMARY KEY, "
            "FactionName TEXT, "
            "GameID INTEGER"
            ")";

    final String createTblGroup = "CREATE TABLE IF NOT EXISTS " +
        tblGroup +
        "("
            "IDGroup INTEGER PRIMARY KEY, "
            "GroupName TEXT, "
            "ContactName TEXT, "
            "ContactPhone TEXT, "
            "ContactEmail TEXT, "
            "IDUser INTEGER, "
            "Comments TEXT"
            ")";

    await db.execute(createTblBases);
    await db.execute(createTblGameConfig);
    await db.execute(createTblActivities);
    await db.execute(createTblPatrols);
    await db.execute(createTblBaseSignIn);
    await db.execute(createTblScan);
    await db.execute(createTblBankConfig);
    await db.execute(createTblFaction);
    await db.execute(createTblGroup);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute("DROP TABLE IF EXISTS $tblBases");
    await db.execute("DROP TABLE IF EXISTS $tblGameConfig");
    await db.execute("DROP TABLE IF EXISTS $tblActivities");
    await db.execute("DROP TABLE IF EXISTS $tblPatrols");
    await db.execute("DROP TABLE IF EXISTS $tblBaseSignIn");
    await db.execute("DROP TABLE IF EXISTS $tblScan");
    await db.execute("DROP TABLE IF EXISTS $tblBankConfig");
    await db.execute("DROP TABLE IF EXISTS $tblFaction");
    await db.execute("DROP TABLE IF EXISTS $tblGroup");
    _createTables(db, newVersion);
  }

  Future<int?> insertGamesData(GamesData gamesData) async {
    // Get a reference to the database.
    final Database? db = await database;
    int? insertedID = await db?.insert(
      tblGameConfig,
      gamesData.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return insertedID;
  }

  Future<int?> insertGroupData(GroupData groupData) async {
    // Get a reference to the database.
    final Database? db = await database;
    int? insertedID = await db?.insert(
      tblGroup,
      groupData.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return insertedID;
  }

  Future<int?> insertFractionData(FractionData fractionData) async {
    // Get a reference to the database.
    final Database? db = await database;
    int? insertedID = await db?.insert(
      tblFaction,
      fractionData.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return insertedID;
  }

  Future<int?> insertScan(ScanData scanData) async {
    // Get a reference to the database.
    final Database? db = await database;
    int? insertedID = await db?.insert(
      tblScan,
      scanData.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return insertedID;
  }

  Future<int?> insertBankData(BankData bankData) async {
    // Get a reference to the database.
    final Database? db = await database;
    int? insertedID = await db?.insert(
      tblBankConfig,
      bankData.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return insertedID;
  }

  Future<int?> insertPatrolSignIn(PatrolSignIn patrolSignIn) async {
    // Get a reference to the database.
    final Database? db = await database;
    int? insertedID = await db?.insert(
      tblBaseSignIn,
      patrolSignIn.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return insertedID;
  }

  Future<int?> insertBaseData(BaseData baseData) async {
    // Get a reference to the database.
    final Database? db = await database;
    int? insertedID = await db?.insert(
      tblBases,
      baseData.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return insertedID;
  }

  Future<int?> insertActivityData(ActivityData activityData) async {
    // Get a reference to the database.
    final Database? db = await database;
    int? insertedID = await db?.insert(
      tblActivities,
      activityData.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return insertedID;
  }

  Future<int?> insertPatrolData(PatrolData patrolData) async {
    // Get a reference to the database.
    final Database? db = await database;
    int? insertedID = await db?.insert(
      tblPatrols,
      patrolData.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return insertedID;
  }

  Future<List<PatrolSignIn>> listPatrolSignIn() async {
    // Get a reference to the database.
    final Database? db = await database;

    // Query the table for all records.
    final List<Map<dynamic, dynamic>>? maps =
        await db?.query(tblBaseSignIn, where: 'Status=?', whereArgs: [1]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps!.length, (i) {
      return PatrolSignIn.fromJson(maps[i] as Map<String, dynamic>);
    });
  }

  Future<bool> isPatrolSignedIn(String gameTag) async {
    // Get a reference to the database.
    final Database? db = await database;
    // Query the table for all records.
    final List<Map<String, dynamic>>? maps = await db?.query(tblBaseSignIn,
        where: 'IDPatrol=?, Status=1', whereArgs: [gameTag]);
    List<PatrolSignIn> patrolSignIns = [];
    patrolSignIns = List.generate(maps!.length, (i) {
      return PatrolSignIn.fromJson(maps[i]);
    });
    if (patrolSignIns.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<int?> signOutPatrol(PatrolSignIn patrolSignIn) async {
    // Get a reference to the database.
    final Database? db = await database;

    // row to update
    Map<String, dynamic> row = {
      "Status": 2,
      "ScanOut": patrolSignIn.scanOut,
      "offline": 1,
    };
    int? updateCount = 0;
    // do the update and get the number of affected rows
    updateCount = await db?.update(tblBaseSignIn, row,
        where: 'IDPatrol=? and Status=1 and IDBaseCode=?',
        whereArgs: [patrolSignIn.iDPatrol, patrolSignIn.iDBaseCode]);
    return updateCount;
  }

  Future<List<PatrolSignIn>> listPatrolSignInOfflineRecords() async {
    // Get a reference to the database.
    final Database? db = await database;
    // Query the table for all records.
    final List<Map<String, dynamic>>? maps =
        await db?.query(tblBaseSignIn, where: 'offline=?', whereArgs: [1]);
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps!.length, (i) {
      return PatrolSignIn.fromJson(maps[i]);
    });
  }

  Future<List<ScanData>> listScanDataOfflineRecords() async {
    // Get a reference to the database.
    final Database? db = await database;
    // Query the table for all records.
    final List<Map<String, dynamic>>? maps =
        await db?.query(tblScan, where: 'offline=?', whereArgs: [1]);
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps!.length, (i) {
      return ScanData.fromJson(maps[i]);
    });
  }

  Future<int?> updateOfflineScanData(
      String gameTag, String scanTime, int status) async {
    // Get a reference to the database.
    final Database? db = await database;

    Map<String, dynamic> row = {"Offline": status};
    int? updateCount = 0;
    // do the update and get the number of affected rows
    updateCount = await db?.update(tblScan, row,
        where: 'GameTag=? and ScanTime=?', whereArgs: [gameTag, scanTime]);
    return updateCount;
  }

  Future<List<BaseData>> listBaseData() async {
    // Get a reference to the database.
    final Database? db = await database;

    // Query the table for all records.
    final List<Map<dynamic, dynamic>>? maps = await db?.query(tblBases);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps!.length, (i) {
      return BaseData.fromJson(maps[i] as Map<String, dynamic>);
    });
  }

  Future<List<FractionData>> listFractionData() async {
    // Get a reference to the database.
    final Database? db = await database;

    // Query the table for all records.
    final List<Map<dynamic, dynamic>>? maps = await db?.query(tblFaction);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps!.length, (i) {
      return FractionData.fromJson(maps[i] as Map<String, dynamic>);
    });
  }

  Future<List<BankData>> listBankData() async {
    // Get a reference to the database.
    final Database? db = await database;

    // Query the table for all records.
    final List<Map<dynamic, dynamic>>? maps = await db?.query(tblBankConfig);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps!.length, (i) {
      return BankData.fromJson(maps[i] as Map<String, dynamic>);
    });
  }

  Future<List<ActivityData>> listActivityData() async {
    // Get a reference to the database.
    final Database? db = await database;

    // Query the table for all records.
    final List<Map<dynamic, dynamic>>? maps = await db?.query(tblActivities);

    // Convert the List<Map<String, dynamic> into a List<>.
    return List.generate(maps!.length, (i) {
      return ActivityData.fromJson(maps[i] as Map<String, dynamic>);
    });
  }

  Future<List<PatrolData>> listPatrolData() async {
    // Get a reference to the database.
    final Database? db = await database;

    // Query the table for all records.
    final List<Map<dynamic, dynamic>>? maps = await db?.query(tblPatrols);

    // Convert the List<Map<String, dynamic> into a List<>.
    return List.generate(maps!.length, (i) {
      return PatrolData.fromJson(maps[i] as Map<String, dynamic>);
    });
  }

  Future<List<GroupData>> listGroupData() async {
    // Get a reference to the database.
    final Database? db = await database;

    // Query the table for all records.
    final List<Map<dynamic, dynamic>>? maps = await db?.query(tblGroup);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps!.length, (i) {
      return GroupData.fromJson(maps[i] as Map<String, dynamic>);
    });
  }

  Future<List<GamesData>> listGamesData() async {
    // Get a reference to the database.
    final Database? db = await database;

    // Query the table for all records.
    final List<Map<dynamic, dynamic>>? maps = await db?.query(tblGameConfig);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps!.length, (i) {
      return GamesData(
        gameID: maps[i]['GameID'],
        gameName: maps[i]['GameName'],
        deviceName: maps[i]['DeviceName'],
        remote: maps[i]['Remote'],
        defaultGame: maps[i]['DefaultGame'],
      );
    });
  }

  Future<void> clearGamesData() async {
    // Get a reference to the database.
    final Database? db = await database;
    //delete all teams in DB
    await db?.execute("delete from " + tblGameConfig);
  }

  Future<void> clearGroupData() async {
    // Get a reference to the database.
    final Database? db = await database;
    //delete all teams in DB
    await db?.execute("delete from " + tblGroup);
  }

  Future<void> clearFractionData() async {
    // Get a reference to the database.
    final Database? db = await database;
    //delete all teams in DB
    await db?.execute("delete from " + tblFaction);
  }

  Future<void> clearBaseData() async {
    // Get a reference to the database.
    final Database? db = await database;
    //delete all teams in DB
    await db?.execute("delete from " + tblBases);
  }

  Future<void> clearActivitiesData() async {
    // Get a reference to the database.
    final Database? db = await database;
    //delete all teams in DB
    await db?.execute("delete from " + tblActivities);
  }

  Future<void> clearPatrolsData() async {
    // Get a reference to the database.
    final Database? db = await database;
    //delete all teams in DB
    await db?.execute("delete from " + tblPatrols);
  }

  Future<void> clearPatrolSignIn() async {
    // Get a reference to the database.
    final Database? db = await database;
    //delete all teams in DB
    await db?.execute("delete from " + tblBaseSignIn);
  }

  Future<void> clearBankData() async {
    // Get a reference to the database.
    final Database? db = await database;
    //delete all teams in DB
    await db?.execute("delete from " + tblBankConfig);
  }
}
