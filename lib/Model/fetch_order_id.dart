class FetchOrderId {
  String orderId;
  bool status;

  FetchOrderId({this.orderId, this.status});

  FetchOrderId.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['status'] = this.status;
    return data;
  }
}
