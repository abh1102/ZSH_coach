

import 'package:zanadu_coach/feature/session/data/model/all_session_model.dart';

class AcceptModel {
  int? length;
  List<Sessions>? sessions;

  AcceptModel({this.length, this.sessions});

  AcceptModel.fromJson(Map<String, dynamic> json) {
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