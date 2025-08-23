class CoachSessionHours {
  dynamic totalGroupSessionsHour;
  dynamic totalOneToOneSessionsHour;
  dynamic totalOrientationSessionsHour;

  CoachSessionHours(
      {this.totalGroupSessionsHour,
      this.totalOneToOneSessionsHour,
      this.totalOrientationSessionsHour});

  CoachSessionHours.fromJson(Map<String, dynamic> json) {
    totalGroupSessionsHour = json['totalGroupSessionsHour'];
    totalOneToOneSessionsHour = json['totalOneToOneSessionsHour'];
    totalOrientationSessionsHour = json['totalOrientationSessionsHour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalGroupSessionsHour'] = this.totalGroupSessionsHour;
    data['totalOneToOneSessionsHour'] = this.totalOneToOneSessionsHour;
    data['totalOrientationSessionsHour'] = this.totalOrientationSessionsHour;
    return data;
  }
}
