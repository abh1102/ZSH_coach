import 'package:zanadu_coach/feature/session/data/model/calendar_available_model.dart';

class WeeklyScheduleModel {
  String? date;
  List<TimeSlots>? timeSlots;

  WeeklyScheduleModel({this.date, this.timeSlots});

  WeeklyScheduleModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['timeSlots'] != null) {
      timeSlots = <TimeSlots>[];
      json['timeSlots'].forEach((v) {
        timeSlots!.add(new TimeSlots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.timeSlots != null) {
      data['timeSlots'] = this.timeSlots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
