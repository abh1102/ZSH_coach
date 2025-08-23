class PayoutTransactionModel {
  String? sId;
  String? coachId;
  int? amount;
  String? description;
  String? createdAt;
  String? updatedAt;
  int? iV;

  PayoutTransactionModel(
      {this.sId,
      this.coachId,
      this.amount,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.iV});

  PayoutTransactionModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    coachId = json['coachId'];
    amount = json['amount'];
    description = json['description'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['coachId'] = this.coachId;
    data['amount'] = this.amount;
    data['description'] = this.description;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
