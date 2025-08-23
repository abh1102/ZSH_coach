class NotesModel {
  String? sId;
  String? userId;
  String? coachId;

  String? notes;
  String? createdAt;
  String? updatedAt;
  int? iV;

  NotesModel(
      {this.sId,
      this.userId,
      this.coachId,
    
      this.notes,
      this.createdAt,
      this.updatedAt,
      this.iV});

  NotesModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    coachId = json['coachId'];

    notes = json['notes'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['coachId'] = this.coachId;

    data['notes'] = this.notes;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
