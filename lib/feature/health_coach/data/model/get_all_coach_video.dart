import 'package:zanadu_coach/feature/login/data/model/coach_model.dart';

class GetAllCoachVideo {
  String? sId;
  List<MyVideos>? myVideos;

  GetAllCoachVideo({this.sId, this.myVideos});

  GetAllCoachVideo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['myVideos'] != null) {
      myVideos = <MyVideos>[];
      json['myVideos'].forEach((v) {
        myVideos!.add(new MyVideos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.myVideos != null) {
      data['myVideos'] = this.myVideos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
