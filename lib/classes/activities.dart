class Activities {
  String? message;
  List<ActivityData>? data;

  Activities({this.message, this.data});

  Activities.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <ActivityData>[];
      json['data'].forEach((v) {
        data!.add(ActivityData.fromJson(v));
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

class ActivityData {
  int? activityID;
  int? baseID;
  String? activityName;
  String? activityCode;
  String? valueResultName;
  int? valueResultField;
  int? valueResultMax;
  String? valueResultName2;
  int? valueResultField2;
  int? successFailResultField;
  int? commentField;
  int? activityType;
  int? randomGen;
  int? randomGenListID;
  int? trade;
  int? hideSubmitButton;
  int? bank;
  int? alert;
  int? alertRule;
  int? alertCount;
  String? alertMessage;
  String? alertMessageFail;
  int? reward;
  int? rewardValue;
  int? upgrades;
  int? itemCrafting;
  int? ranking;
  int? disableWithdrawal;
  int? dropDownField;
  int? scoringType;
  int? scoringSuccess;
  int? scoringFail;
  double? scoringValue;
  int? dropDownFieldListID;
  int? passBasedonValueResult;
  int? passValue;
  int? baseControl;
  int? gameID;

  ActivityData(
      {this.activityID,
      this.baseID,
      this.activityName,
      this.activityCode,
      this.valueResultName,
      this.valueResultField,
      this.valueResultMax,
      this.valueResultName2,
      this.valueResultField2,
      this.successFailResultField,
      this.commentField,
      this.activityType,
      this.randomGen,
      this.randomGenListID,
      this.trade,
      this.hideSubmitButton,
      this.bank,
      this.alert,
      this.alertRule,
      this.alertCount,
      this.alertMessage,
      this.alertMessageFail,
      this.reward,
      this.rewardValue,
      this.upgrades,
      this.itemCrafting,
      this.ranking,
      this.disableWithdrawal,
      this.dropDownField,
      this.scoringType,
      this.scoringSuccess,
      this.scoringFail,
      this.scoringValue,
      this.dropDownFieldListID,
      this.passBasedonValueResult,
      this.passValue,
      this.baseControl,
      this.gameID});

  ActivityData.fromJson(Map<String, dynamic> json) {
    activityID = json['ActivityID'];
    baseID = json['BaseID'];
    activityName = json['ActivityName'];
    activityCode = json['ActivityCode'];
    valueResultName = json['ValueResultName'];
    valueResultField = json['ValueResultField'];
    valueResultMax = json['ValueResultMax'];
    valueResultName2 = json['ValueResultName2'];
    valueResultField2 = json['ValueResultField2'];
    successFailResultField = json['SuccessFailResultField'];
    commentField = json['CommentField'];
    activityType = json['ActivityType'];
    randomGen = json['RandomGen'];
    randomGenListID = json['RandomGenListID'];
    trade = json['Trade'];
    hideSubmitButton = json['HideSubmitButton'];
    bank = json['Bank'];
    alert = json['Alert'];
    alertRule = json['AlertRule'];
    alertCount = json['AlertCount'];
    alertMessage = json['AlertMessage'];
    alertMessageFail = json['AlertMessageFail'];
    reward = json['Reward'];
    rewardValue = json['RewardValue'];
    upgrades = json['Upgrades'];
    itemCrafting = json['ItemCrafting'];
    ranking = json['Ranking'];
    disableWithdrawal = json['DisableWithdrawal'];
    dropDownField = json['DropDownField'];
    scoringType = json['Scoring_type'];
    scoringSuccess = json['Scoring_Success'];
    scoringFail = json['Scoring_Fail'];
    scoringValue = double.parse(json['Scoring_Value'].toString());
    dropDownFieldListID = json['DropDownFieldListID'];
    passBasedonValueResult = json['PassBasedonValueResult'];
    passValue = json['PassValue'];
    baseControl = json['BaseControl'];
    gameID = json['GameID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ActivityID'] = this.activityID;
    data['BaseID'] = this.baseID;
    data['ActivityName'] = this.activityName;
    data['ActivityCode'] = this.activityCode;
    data['ValueResultName'] = this.valueResultName;
    data['ValueResultField'] = this.valueResultField;
    data['ValueResultMax'] = this.valueResultMax;
    data['ValueResultName2'] = this.valueResultName2;
    data['ValueResultField2'] = this.valueResultField2;
    data['SuccessFailResultField'] = this.successFailResultField;
    data['CommentField'] = this.commentField;
    data['ActivityType'] = this.activityType;
    data['RandomGen'] = this.randomGen;
    data['RandomGenListID'] = this.randomGenListID;
    data['Trade'] = this.trade;
    data['HideSubmitButton'] = this.hideSubmitButton;
    data['Bank'] = this.bank;
    data['Alert'] = this.alert;
    data['AlertRule'] = this.alertRule;
    data['AlertCount'] = this.alertCount;
    data['AlertMessage'] = this.alertMessage;
    data['AlertMessageFail'] = this.alertMessageFail;
    data['Reward'] = this.reward;
    data['RewardValue'] = this.rewardValue;
    data['Upgrades'] = this.upgrades;
    data['ItemCrafting'] = this.itemCrafting;
    data['Ranking'] = this.ranking;
    data['DisableWithdrawal'] = this.disableWithdrawal;
    data['DropDownField'] = this.dropDownField;
    data['Scoring_type'] = this.scoringType;
    data['Scoring_Success'] = this.scoringSuccess;
    data['Scoring_Fail'] = this.scoringFail;
    data['Scoring_Value'] = this.scoringValue;
    data['DropDownFieldListID'] = this.dropDownFieldListID;
    data['PassBasedonValueResult'] = this.passBasedonValueResult;
    data['PassValue'] = this.passValue;
    data['BaseControl'] = this.baseControl;
    data['GameID'] = this.gameID;
    return data;
  }
}
