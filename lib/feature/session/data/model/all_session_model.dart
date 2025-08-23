import 'package:zanadu_coach/feature/login/data/model/coach_model.dart';
import 'package:zanadu_coach/feature/users/data/model/get_user_detail_model.dart';

class AllSessionModel {
  int? length;
  List<Sessions>? sessions;

  AllSessionModel({this.length, this.sessions});

  AllSessionModel.fromJson(Map<String, dynamic> json) {
    length = json['length'];
    if (json['sessions'] != null) {
      sessions = <Sessions>[];
      json['sessions'].forEach((v) {
        sessions!.add(new Sessions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['length'] = this.length;
    if (this.sessions != null) {
      data['sessions'] = this.sessions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sessions {
  String? sId;
  String? sessionType;
  String? title;
  String? description;
  String? startDate;
  String? endDate;
  String? offeringName;
  String? chatroomId;
  int? noOfSlots;
  String? coachId;
  String? channelName;
  bool? isApproved;
  String? status;
  CoachInfo? coachInfo;
  CoachProfile? coachProfile;
  List<String>? userId;
  UserInfo? userInfo;

  Sessions(
      {this.sId,
      this.sessionType,
      this.title,
      this.chatroomId,
      this.description,
      this.startDate,
      this.endDate,
      this.offeringName,
      this.noOfSlots,
      this.coachId,
      this.channelName,
      this.isApproved,
      this.status,
      this.coachInfo,
      this.coachProfile,
      this.userId,
      this.userInfo});

  Sessions.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sessionType = json['sessionType'];
    title = json['title'];
    description = json['description'];
    chatroomId = json['chatroomId'];
    startDate = json['startDate'];
    offeringName = json['offeringName'];
    endDate = json['endDate'];
    noOfSlots = json['noOfSlots'];
    coachId = json['coachId'];
    channelName = json['channelName'];
    isApproved = json['isApproved'];
    status = json['status'];
    coachInfo = json['coachInfo'] != null
        ? new CoachInfo.fromJson(json['coachInfo'])
        : null;
    coachProfile = json['coachProfile'] != null
        ? new CoachProfile.fromJson(json['coachProfile'])
        : null;
    userId = json['userId'].cast<String>();
    userInfo = json['userInfo'] != null
        ? new UserInfo.fromJson(json['userInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['sessionType'] = this.sessionType;
    data['title'] = this.title;
    data['description'] = this.description;
    data['startDate'] = this.startDate;
    data['chatroomId'] = this.chatroomId;
    data['endDate'] = this.endDate;
    data['offeringName'] = this.offeringName;
    data['noOfSlots'] = this.noOfSlots;
    data['coachId'] = this.coachId;
    data['channelName'] = this.channelName;
    data['isApproved'] = this.isApproved;
    data['status'] = this.status;
    if (this.coachInfo != null) {
      data['coachInfo'] = this.coachInfo!.toJson();
    }
    if (this.coachProfile != null) {
      data['coachProfile'] = this.coachProfile!.toJson();
    }
    data['userId'] = this.userId;
    if (this.userInfo != null) {
      data['userInfo'] = this.userInfo!.toJson();
    }
    return data;
  }
}

class CoachInfo {
  String? sId;
  String? userId;
  String? offeringId;
  String? description;
  String? image;
  String? likes;
  String? rating;
  List<MyVideos>? myVideos;
  String? createdAt;
  String? updatedAt;
  int? iV;

  CoachInfo(
      {this.sId,
      this.userId,
      this.offeringId,
      this.description,
      this.image,
      this.likes,
      this.rating,
      this.myVideos,
      this.createdAt,
      this.updatedAt,
      this.iV});

  CoachInfo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    offeringId = json['offeringId'];
    description = json['description'];
    image = json['image'];
    likes = json['likes'];
    rating = json['rating'];
    if (json['myVideos'] != null) {
      myVideos = <MyVideos>[];
      json['myVideos'].forEach((v) {
        myVideos!.add(new MyVideos.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['offeringId'] = this.offeringId;
    data['description'] = this.description;
    data['image'] = this.image;
    data['likes'] = this.likes;
    data['rating'] = this.rating;
    if (this.myVideos != null) {
      data['myVideos'] = this.myVideos!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class MyVideos {
  String? title;
  String? videoType;
  String? description;
  bool? isApproved;
  String? file;
  String? sId;

  MyVideos(
      {this.title, this.description, this.isApproved, this.file, this.sId});

  MyVideos.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    isApproved = json['isApproved'];
    file = json['file'];
    videoType = json['videoType'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['isApproved'] = this.isApproved;
    data['file'] = this.file;
    data['videoType'] = this.videoType;
    data['_id'] = this.sId;
    return data;
  }
}

class CoachProfile {
  String? sId;
  String? userId;
  Profile? profile;
  bool? isApproved;
  IsVerifed? isVerifed;
  String? createdAt;
  String? updatedAt;
  int? iV;

  CoachProfile(
      {this.sId,
      this.userId,
      this.profile,
      this.isApproved,
      this.isVerifed,
      this.createdAt,
      this.updatedAt,
      this.iV});

  CoachProfile.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    isApproved = json['isApproved'];
    isVerifed = json['isVerifed'] != null
        ? new IsVerifed.fromJson(json['isVerifed'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    data['isApproved'] = this.isApproved;
    if (this.isVerifed != null) {
      data['isVerifed'] = this.isVerifed!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Profile {
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

  Profile(
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

  Profile.fromJson(Map<String, dynamic> json) {
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
