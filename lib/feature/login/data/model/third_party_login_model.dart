class ThirdPartyLoginModel {
  bool? isFirstUser;
  bool? isEmailVerified;

  ThirdPartyLoginModel({this.isFirstUser, this.isEmailVerified});

  ThirdPartyLoginModel.fromJson(Map<String, dynamic> json) {
    isFirstUser = json['isFirstUser'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isFirstUser'] = this.isFirstUser;
    data['isEmailVerified'] = this.isEmailVerified;
    return data;
  }
}
