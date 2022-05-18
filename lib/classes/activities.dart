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
  int? successPartialFailResultField;
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
  int? scoringPartial;
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
      this.successPartialFailResultField,
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
      this.scoringPartial,
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
    successPartialFailResultField = json['SuccessPartialFailResultField'];
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
    scoringPartial = json['Scoring_Partial'];
    scoringFail = json['Scoring_Fail'];
    scoringValue = double.parse(json['Scoring_Value'].toString());
    dropDownFieldListID = json['DropDownFieldListID'];
    passBasedonValueResult = json['PassBasedonValueResult'];
    passValue = json['PassValue'];
    baseControl = json['BaseControl'];
    gameID = json['GameID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ActivityID'] = activityID;
    data['BaseID'] = baseID;
    data['ActivityName'] = activityName;
    data['ActivityCode'] = activityCode;
    data['ValueResultName'] = valueResultName;
    data['ValueResultField'] = valueResultField;
    data['ValueResultMax'] = valueResultMax;
    data['ValueResultName2'] = valueResultName2;
    data['ValueResultField2'] = valueResultField2;
    data['SuccessFailResultField'] = successFailResultField;
    data['SuccessPartialFailResultField'] = successPartialFailResultField;
    data['CommentField'] = commentField;
    data['ActivityType'] = activityType;
    data['RandomGen'] = randomGen;
    data['RandomGenListID'] = randomGenListID;
    data['Trade'] = trade;
    data['HideSubmitButton'] = hideSubmitButton;
    data['Bank'] = bank;
    data['Alert'] = alert;
    data['AlertRule'] = alertRule;
    data['AlertCount'] = alertCount;
    data['AlertMessage'] = alertMessage;
    data['AlertMessageFail'] = alertMessageFail;
    data['Reward'] = reward;
    data['RewardValue'] = rewardValue;
    data['Upgrades'] = upgrades;
    data['ItemCrafting'] = itemCrafting;
    data['Ranking'] = ranking;
    data['DisableWithdrawal'] = disableWithdrawal;
    data['DropDownField'] = dropDownField;
    data['Scoring_type'] = scoringType;
    data['Scoring_Success'] = scoringSuccess;
    data['Scoring_Partial'] = scoringPartial;
    data['Scoring_Fail'] = scoringFail;
    data['Scoring_Value'] = scoringValue;
    data['DropDownFieldListID'] = dropDownFieldListID;
    data['PassBasedonValueResult'] = passBasedonValueResult;
    data['PassValue'] = passValue;
    data['BaseControl'] = baseControl;
    data['GameID'] = gameID;
    return data;
  }
}
