import 'package:zanadu_coach/feature/login/data/model/coach_model.dart';

class AllHealthCoachesModel {
  String? sId;
  String? userId;
  Profile? profile;
  bool? isApproved;
  IsVerifed? isVerifed;
  String? createdAt;
  String? updatedAt;
  int? iV;
  CoachInfo? coachInfo;
  int? countSessions;

  AllHealthCoachesModel(
      {this.sId,
      this.userId,
      this.profile,
      this.isApproved,
      this.isVerifed,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.coachInfo,
      this.countSessions});

  AllHealthCoachesModel.fromJson(Map<String, dynamic> json) {
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
    coachInfo = json['coachInfo'] != null
        ? new CoachInfo.fromJson(json['coachInfo'])
        : null;
    countSessions = json['countSessions'];
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
   if (this.coachInfo != null) {
      data['coachInfo'] = this.coachInfo!.toJson();
    }
    data['countSessions'] = this.countSessions;
    return data;
  }
}
