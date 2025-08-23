class CoachRatingModel {
  List<WEEKLY>? wEEKLY;
  List<WEEKLY>? mONTHLY;
  List<YEARLY>? yEARLY;

  CoachRatingModel({this.wEEKLY, this.mONTHLY, this.yEARLY});

  CoachRatingModel.fromJson(Map<String, dynamic> json) {
    if (json['WEEKLY'] != null) {
      wEEKLY = <WEEKLY>[];
      json['WEEKLY'].forEach((v) {
        wEEKLY!.add(new WEEKLY.fromJson(v));
      });
    }
    if (json['MONTHLY'] != null) {
      mONTHLY = <WEEKLY>[];
      json['MONTHLY'].forEach((v) {
        mONTHLY!.add(new WEEKLY.fromJson(v));
      });
    }
    if (json['YEARLY'] != null) {
      yEARLY = <YEARLY>[];
      json['YEARLY'].forEach((v) {
        yEARLY!.add(new YEARLY.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.wEEKLY != null) {
      data['WEEKLY'] = this.wEEKLY!.map((v) => v.toJson()).toList();
    }
    if (this.mONTHLY != null) {
      data['MONTHLY'] = this.mONTHLY!.map((v) => v.toJson()).toList();
    }
    if (this.yEARLY != null) {
      data['YEARLY'] = this.yEARLY!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WEEKLY {
  dynamic myRating;
  String? createdAt;

  WEEKLY({this.myRating, this.createdAt});

  WEEKLY.fromJson(Map<String, dynamic> json) {
    myRating = json['myRating'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['myRating'] = this.myRating;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class YEARLY {
  dynamic myRating;
  dynamic createdAt;

  YEARLY({this.myRating, this.createdAt});

  YEARLY.fromJson(Map<String, dynamic> json) {
    myRating = json['myRating'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['myRating'] = this.myRating;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
