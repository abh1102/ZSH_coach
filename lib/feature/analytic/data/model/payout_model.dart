class CoachPayoutModel {
  List<WEEKLY>? wEEKLY;
  List<WEEKLY>? mONTHLY;
  List<YEARLY>? yEARLY;

  CoachPayoutModel({this.wEEKLY, this.mONTHLY, this.yEARLY});

  CoachPayoutModel.fromJson(Map<String, dynamic> json) {
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
  int? amount;
  String? createdAt;

  WEEKLY({this.amount, this.createdAt});

  WEEKLY.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class YEARLY {
  int? amount;
  int? createdAt;

  YEARLY({this.amount, this.createdAt});

  YEARLY.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
