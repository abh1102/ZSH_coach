import 'package:zanadu_coach/feature/login/data/model/coach_model.dart';

class SessionList {
  String? sId;
  String? sessionType;
  String? title;
  String? description;
  String? startDate;
  String? endDate;
  int? noOfSlots;
  String? coachId;
  List<String>? userId;
  String? channelName;
  bool? isApproved;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  SessionList(
      {this.sId,
      this.sessionType,
      this.title,
      this.description,
      this.startDate,
      this.endDate,
      this.noOfSlots,
      this.coachId,
      this.userId,
      this.channelName,
      this.isApproved,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.iV});

  SessionList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sessionType = json['sessionType'];
    title = json['title'];
    description = json['description'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    noOfSlots = json['noOfSlots'];
    coachId = json['coachId'];
    userId = json['userId'].cast<String>();
    channelName = json['channelName'];
    isApproved = json['isApproved'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['sessionType'] = this.sessionType;
    data['title'] = this.title;
    data['description'] = this.description;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['noOfSlots'] = this.noOfSlots;
    data['coachId'] = this.coachId;
    data['userId'] = this.userId;
    data['channelName'] = this.channelName;
    data['isApproved'] = this.isApproved;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class GetUserDetailModel {
  String? sId;
  String? userId;
  String? coachType;
  String? offeringId;
  bool? isActive;
  List<SessionList>? sessionList;
  String? coachId;
  CoachProfile? coachProfile;
  CoachInfo? coachInfo;
  UserInfo? userInfo;
  String? createdAt;

  GetUserDetailModel(
      {this.sId,
      this.userId,
      this.coachType,
      this.isActive,
      this.sessionList,
      this.coachId,
      this.coachProfile,
      this.userInfo,
      this.createdAt});

  GetUserDetailModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    coachType = json['coachType'];
    offeringId = json['offeringId'];
    isActive = json['isActive'];
    if (json['sessionList'] != null) {
      sessionList = <SessionList>[];
      json['sessionList'].forEach((v) {
        sessionList!.add(new SessionList.fromJson(v));
      });
    }
    coachId = json['coachId'];
    coachProfile = json['coachProfile'] != null
        ? new CoachProfile.fromJson(json['coachProfile'])
        : null;
    coachInfo = json['coachInfo'] != null
        ? new CoachInfo.fromJson(json['coachInfo'])
        : null;
    userInfo = json['userInfo'] != null
        ? new UserInfo.fromJson(json['userInfo'])
        : null;
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['coachType'] = this.coachType;
    data['offeringId'] = this.offeringId;
    data['isActive'] = this.isActive;
    if (this.sessionList != null) {
      data['sessionList'] = this.sessionList!.map((v) => v.toJson()).toList();
    }
    data['coachId'] = this.coachId;
    if (this.coachProfile != null) {
      data['coachProfile'] = this.coachProfile!.toJson();
    }
      if (this.coachInfo != null) {
      data['coachInfo'] = this.coachInfo!.toJson();
    }
    if (this.userInfo != null) {
      data['userInfo'] = this.userInfo!.toJson();
    }
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class CoachProfile {
  String? fullName;
  String? phone;
  String? dOB;
  String? gender;
  AreaOfSpecialization? areaOfSpecialization;
  String? country;
  String? state;
  String? image;
  Documents? documents;
  String? experience;

  CoachProfile(
      {this.fullName,
      this.phone,
      this.dOB,
      this.gender,
      this.areaOfSpecialization,
      this.country,
      this.state,
      this.image,
      this.documents,
      this.experience});

  CoachProfile.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    phone = json['phone'];
    dOB = json['DOB'];
    gender = json['gender'];
    areaOfSpecialization = json['areaOfSpecialization'] != null
        ? new AreaOfSpecialization.fromJson(json['areaOfSpecialization'])
        : null;
    country = json['country'];
    state = json['state'];
    image = json['image'];
    documents = json['documents'] != null
        ? new Documents.fromJson(json['documents'])
        : null;
    experience = json['experience'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['phone'] = this.phone;
    data['DOB'] = this.dOB;
    data['gender'] = this.gender;
    if (this.areaOfSpecialization != null) {
      data['areaOfSpecialization'] = this.areaOfSpecialization!.toJson();
    }
    data['country'] = this.country;
    data['state'] = this.state;
    data['image'] = this.image;
    if (this.documents != null) {
      data['documents'] = this.documents!.toJson();
    }
    data['experience'] = this.experience;
    return data;
  }
}

class UserInfo {
  String? fullName;
  String? phone;
  String? dOB;
  String? gender;
  List<String>? topHealthChallenges;
  String? state;
  String? image;

  UserInfo(
      {this.fullName,
      this.phone,
      this.dOB,
      this.gender,
      this.topHealthChallenges,
      this.state,
      this.image});

  UserInfo.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    phone = json['phone'];
    dOB = json['DOB'];
    gender = json['gender'];
    topHealthChallenges = json['topHealthChallenges'].cast<String>();
    state = json['state'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['phone'] = this.phone;
    data['DOB'] = this.dOB;
    data['gender'] = this.gender;
    data['topHealthChallenges'] = this.topHealthChallenges;
    data['state'] = this.state;
    data['image'] = this.image;
    return data;
  }
}
