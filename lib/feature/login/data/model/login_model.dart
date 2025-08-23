class LoginModel {
  String? email;
  String? role;
  String? id;
  int? uid;
  String? accessToken;

  LoginModel({this.email, this.role, this.id, this.accessToken});

  LoginModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    role = json['role'];
    id = json['id'];
    uid = json['uid'];
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['email'] = email;
    data['role'] = role;
    data['id'] = id;
    data['uid'] = uid;
    data['accessToken'] = accessToken;
    return data;
  }
}
