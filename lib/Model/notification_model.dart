class NotificationModel {
  List<ResponseNotify> response;
  bool status;

  NotificationModel({this.response, this.status});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <ResponseNotify>[];
      json['response'].forEach((v) {
        response.add(new ResponseNotify.fromJson(v));
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

class ResponseNotify {
  int id;
  String message;
  String productId;

  ResponseNotify({this.id, this.message, this.productId});

  ResponseNotify.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['product_id'] = this.productId;
    return data;
  }
}
