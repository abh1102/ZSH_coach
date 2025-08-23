class AllUserListModel {
  String? sId;
  String? userId;
  String? coachId;
  UserList? userList;
  List<String>? offeringName;

  AllUserListModel({this.sId, this.userId, this.coachId, this.userList});

  AllUserListModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    if (json['offeringName'] != null) {
      offeringName = <String>[];
      json['offeringName'].forEach((v) {
        offeringName!.add(v);
      });
    }

    coachId = json['coachId'];
    userList = json['userList'] != null
        ? new UserList.fromJson(json['userList'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    if (this.offeringName != null) {
      data['offeringName'] = this.offeringName!.map((v) => v).toList();
    }

    data['coachId'] = this.coachId;
    if (this.userList != null) {
      data['userList'] = this.userList!.toJson();
    }
    return data;
  }
}

class UserList {
  String? fullName;
  String? phone;
  String? dOB;
  String? gender;
  List<String>? topHealthChallenges;
  String? state;
  String? image;

  UserList(
      {this.fullName,
      this.phone,
      this.dOB,
      this.gender,
      this.topHealthChallenges,
      this.state});

  UserList.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    phone = json['phone'];
    dOB = json['DOB'];
    gender = json['gender'];
    image = json['image'];
    topHealthChallenges = json['topHealthChallenges'].cast<String>();
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['phone'] = this.phone;
    data['DOB'] = this.dOB;
    data['gender'] = this.gender;
    data['image'] = this.image;
    data['topHealthChallenges'] = this.topHealthChallenges;
    data['state'] = this.state;
    return data;
  }
}
