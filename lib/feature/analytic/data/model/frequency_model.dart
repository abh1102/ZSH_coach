class CoachFrequencyModel {
  ORIENTATION? oRIENTATION;
  ORIENTATION? gROUP;
  ORIENTATION? oNEONONE;

  CoachFrequencyModel({this.oRIENTATION, this.gROUP, this.oNEONONE});

  CoachFrequencyModel.fromJson(Map<String, dynamic> json) {
    oRIENTATION = json['ORIENTATION'] != null
        ? new ORIENTATION.fromJson(json['ORIENTATION'])
        : null;
    gROUP =
        json['GROUP'] != null ? new ORIENTATION.fromJson(json['GROUP']) : null;
    oNEONONE = json['ONE-ON-ONE'] != null
        ? new ORIENTATION.fromJson(json['ONE-ON-ONE'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.oRIENTATION != null) {
      data['ORIENTATION'] = this.oRIENTATION!.toJson();
    }
    if (this.gROUP != null) {
      data['GROUP'] = this.gROUP!.toJson();
    }
    if (this.oNEONONE != null) {
      data['ONE-ON-ONE'] = this.oNEONONE!.toJson();
    }
    return data;
  }
}

class ORIENTATION {
  List<WEEKLY>? wEEKLY;
  List<WEEKLY>? mONTHLY;
  List<YEARLY>? yEARLY;

  ORIENTATION({this.wEEKLY, this.mONTHLY, this.yEARLY});

  ORIENTATION.fromJson(Map<String, dynamic> json) {
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
  int? count;
  String? createdAt;

  WEEKLY({this.count, this.createdAt});

  WEEKLY.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class YEARLY {
  int? count;
  int? createdAt;

  YEARLY({this.count, this.createdAt});

  YEARLY.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
