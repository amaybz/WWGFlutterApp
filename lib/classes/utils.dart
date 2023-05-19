import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wwgnfcscoringsystem/base.dart';
import 'package:wwgnfcscoringsystem/classes/bank_class.dart';
import 'package:wwgnfcscoringsystem/classes/base_results.dart';
import 'package:wwgnfcscoringsystem/classes/factions.dart';
import 'package:wwgnfcscoringsystem/classes/groups.dart';
import 'package:wwgnfcscoringsystem/classes/patrol_results.dart';
import 'package:wwgnfcscoringsystem/classes/patrol_sign_in.dart';
import 'package:wwgnfcscoringsystem/classes/scan_results.dart';

class Utils {
  String getCurrentDateSQL() {
    //get current time
    DateTime now = DateTime.now();
    return now.year.toString() +
        "-" +
        now.month.toString() +
        "-" +
        now.day.toString() +
        " " +
        now.hour.toString() +
        ":" +
        now.minute.toString() +
        ":" +
        now.second.toString();
  }

  PatrolData getPatrolDataByGameTag(
      String gameTag, List<PatrolData> listPatrols) {
    PatrolData patrol = PatrolData();
    patrol = listPatrols.firstWhere((element) => element.gameTag == gameTag,
        orElse: () => PatrolData());
    return patrol;
  }

  GroupData getGroupDataByID(int iDGroup, List<GroupData> groups) {
    GroupData group = GroupData();
    group = groups.firstWhere((element) => element.iDGroup == iDGroup,
        orElse: () => GroupData());
    return group;
  }

  BaseData getBaseDataByID(int baseID, BasesResults bases) {
    BaseData baseData = BaseData();
    baseData = bases.data!.firstWhere((element) => element.baseID == baseID,
        orElse: () => BaseData());
    return baseData;
  }

  int getBankBalancePatrol(
      ScanResults scanResults, String gameTag, String account, int gameID) {
    ScanResults patrolScanResults = ScanResults();
    ScanResults patrolDeposits = ScanResults();
    ScanResults patrolWithdrawals = ScanResults();

    patrolScanResults.data = scanResults.data
        ?.where((i) => i.gameTag == gameTag && i.iDActivityCode == account)
        .toList();
    patrolDeposits.data =
        patrolScanResults.data?.where((i) => i.comment == "Deposit").toList();
    patrolWithdrawals.data = patrolScanResults.data
        ?.where((i) => i.comment == "Withdrawal")
        .toList();

    var deposits = 0;
    for (var i = 0; i < patrolDeposits.data!.length; i++) {
      deposits += patrolDeposits.data![i].resultValue!;
    }

    var withdrawals = 0;
    for (var i = 0; i < patrolWithdrawals.data!.length; i++) {
      withdrawals += patrolWithdrawals.data![i].resultValue!;
    }

    int patrolBalance = deposits - withdrawals;

    if (kDebugMode) {
      //print(patrolDeposits.data);
      print("Deposits: $deposits");
      // print(patrolWithdrawals.data);
      print("Withdrawals: $withdrawals");
      print("Balance: ${deposits - withdrawals}");
    }

    return patrolBalance;
  }

  int getBankBalanceBase(
      ScanResults scanResults, int baseID, String account, int gameID) {
    ScanResults baseScanResults = ScanResults();
    ScanResults baseDeposits = ScanResults();
    ScanResults baseWithdrawals = ScanResults();

    baseScanResults.data = scanResults.data
        ?.where((i) => i.baseID == baseID && i.iDActivityCode == account)
        .toList();
    baseDeposits.data =
        baseScanResults.data?.where((i) => i.comment == "Deposit").toList();
    baseWithdrawals.data =
        baseScanResults.data?.where((i) => i.comment == "Withdrawal").toList();

    var deposits = 0;
    int? bankDepositsLength = 0;
    bankDepositsLength = baseDeposits.data?.length;
    bankDepositsLength ??= 0;
    for (var i = 0; i < bankDepositsLength; i++) {
      deposits += baseDeposits.data![i].resultValue!;
    }
    int? bankWithdrawalsLength = 0;
    bankWithdrawalsLength = baseWithdrawals.data?.length;
    bankWithdrawalsLength ??= 0;
    var withdrawals = 0;
    for (var i = 0; i < bankWithdrawalsLength; i++) {
      withdrawals += baseWithdrawals.data![i].resultValue!;
    }

    int baseBalance = deposits - withdrawals;

    if (kDebugMode) {
      //print(patrolDeposits.data);
      print("Deposits: $deposits");
      // print(patrolWithdrawals.data);
      print("Withdrawals: $withdrawals");
      print("Balance: ${deposits - withdrawals}");
    }

    return baseBalance;
  }

  FactionData getFractionDataByID(int idFraction, List<FactionData> fractions) {
    FactionData fraction = FactionData();
    fraction = fractions.firstWhere(
        (element) => element.iDFaction == idFraction,
        orElse: () => FactionData());
    return fraction;
  }

  List<DropdownMenuItem<String>> convertPatrolsListToDropDownList(
      List<PatrolSignIn> patrolsSignedIn) {
    bool inList = false;
    List<DropdownMenuItem<String>> listPatrolsDropdown = [
      const DropdownMenuItem(value: "0", child: Text("Please Sign in a Patrol"))
    ];

    if (kDebugMode) {
      print("#Signed in Patrols");
      print(patrolsSignedIn.length);
    }

    if (patrolsSignedIn.isNotEmpty) {
      listPatrolsDropdown.clear();
      for (PatrolSignIn patrol in patrolsSignedIn) {
        for (int i = 0; i < listPatrolsDropdown.length; i++) {
          if (listPatrolsDropdown[i].value == patrol.iDPatrol) {
            inList = true;
          }
        }
        if (!inList) {
          listPatrolsDropdown.add(DropdownMenuItem(
              value: patrol.iDPatrol, child: Text(patrol.iDPatrol!)));
        }
      }
      return listPatrolsDropdown;
    } else {
      listPatrolsDropdown.clear();
      listPatrolsDropdown.add(const DropdownMenuItem(
          value: "0", child: Text("Please sign in a Patrol")));
      return listPatrolsDropdown;
    }
  }

  List<DropdownMenuItem<String>> convertListBankDataToAccountsDropDownList(
      List<BankData> listBankData) {
    List<DropdownMenuItem<String>> listAccountsDropDown = [
      const DropdownMenuItem(value: "0", child: Text("No Accounts Configured"))
    ];

    if (kDebugMode) {
      print("#Accountss");
      print(listBankData.length);
    }

    if (listBankData.isNotEmpty) {
      listAccountsDropDown.clear();
      for (BankData bankData in listBankData) {
        listAccountsDropDown.add(DropdownMenuItem(
            value: bankData.accountName, child: Text(bankData.accountName!)));
      }
      return listAccountsDropDown;
    } else {
      listAccountsDropDown.clear();
      listAccountsDropDown.add(const DropdownMenuItem(
          value: "0", child: Text("No Accounts Configured")));
      return listAccountsDropDown;
    }
  }
}
