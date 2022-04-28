class BankResults {
  String? message;
  List<Data>? data;

  BankResults({this.message, this.data});

  BankResults.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? iDAccount;
  String? accountName;
  int? dep;
  int? withdraw;
  int? displayPatrolBalance;
  int? displayBaseBalance;

  Data(
      {this.iDAccount,
      this.accountName,
      this.dep,
      this.withdraw,
      this.displayPatrolBalance,
      this.displayBaseBalance});

  Data.fromJson(Map<String, dynamic> json) {
    iDAccount = json['IDAccount'];
    accountName = json['AccountName'];
    dep = json['Dep'];
    withdraw = json['Withdraw'];
    displayPatrolBalance = json['DisplayPatrolBalance'];
    displayBaseBalance = json['DisplayBaseBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IDAccount'] = iDAccount;
    data['AccountName'] = accountName;
    data['Dep'] = dep;
    data['Withdraw'] = withdraw;
    data['DisplayPatrolBalance'] = displayPatrolBalance;
    data['DisplayBaseBalance'] = displayBaseBalance;
    return data;
  }
}
