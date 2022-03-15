class DecrementNumber {
  int itemRemoved;
  String response;
  bool status;

  DecrementNumber({this.itemRemoved, this.response, this.status});

  DecrementNumber.fromJson(Map<String, dynamic> json) {
    itemRemoved = json['item_removed'];
    response = json['response'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_removed'] = this.itemRemoved;
    data['response'] = this.response;
    data['status'] = this.status;
    return data;
  }
}
