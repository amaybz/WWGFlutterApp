class Groups {
  String? message;
  List<GroupData>? data;

  Groups({this.message, this.data});

  Groups.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <GroupData>[];
      json['data'].forEach((v) {
        data!.add(GroupData.fromJson(v));
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

class GroupData {
  int? iDGroup;
  String? groupName;
  String? contactName;
  String? contactPhone;
  String? contactEmail;
  int? iDUser;
  String? comments;

  GroupData(
      {this.iDGroup,
      this.groupName,
      this.contactName,
      this.contactPhone,
      this.contactEmail,
      this.iDUser,
      this.comments});

  GroupData.fromJson(Map<String, dynamic> json) {
    iDGroup = json['IDGroup'];
    groupName = json['GroupName'];
    contactName = json['ContactName'];
    contactPhone = json['ContactPhone'];
    contactEmail = json['ContactEmail'];
    iDUser = json['IDUser'];
    comments = json['Comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IDGroup'] = iDGroup;
    data['GroupName'] = groupName;
    data['ContactName'] = contactName;
    data['ContactPhone'] = contactPhone;
    data['ContactEmail'] = contactEmail;
    data['IDUser'] = iDUser;
    data['Comments'] = comments;
    return data;
  }
}
