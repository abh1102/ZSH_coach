class NotificationModel {
  String? userId;
  String? description;
  String? title;
  bool? isRead;
  String? dateTime;

  NotificationModel(
      {this.userId, this.description, this.isRead, this.dateTime});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    description = json['description'];
    title = json['title'];
    isRead = json['isRead'];
    dateTime = json['date_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['description'] = this.description;
    data['title'] = this.title;
    data['isRead'] = this.isRead;
    data['date_time'] = this.dateTime;
    return data;
  }
}
