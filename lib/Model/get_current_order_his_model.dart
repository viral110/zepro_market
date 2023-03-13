class GetCurrentOrderHistory {
  List<ResponseMicroOrder> response;
  bool status;

  GetCurrentOrderHistory({this.response, this.status});

  GetCurrentOrderHistory.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <ResponseMicroOrder>[];
      json['response'].forEach((v) {
        response.add(new ResponseMicroOrder.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class ResponseMicroOrder {
  int count;
  String markDatetime;
  String orderId;
  double totalPrice;

  ResponseMicroOrder({this.count, this.markDatetime, this.orderId, this.totalPrice});

  ResponseMicroOrder.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    markDatetime = json['mark_datetime'];
    orderId = json['order_id'];
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['mark_datetime'] = this.markDatetime;
    data['order_id'] = this.orderId;
    data['total_price'] = this.totalPrice;
    return data;
  }
}
