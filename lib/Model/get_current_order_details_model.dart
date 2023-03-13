class OrderDetailsModel {
  ResponseOrderDetails response;
  bool status;
  Urls urls;

  OrderDetailsModel({this.response, this.status, this.urls});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new ResponseOrderDetails.fromJson(json['response'])
        : null;
    status = json['status'];
    urls = json['urls'] != null ? new Urls.fromJson(json['urls']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    data['status'] = this.status;
    if (this.urls != null) {
      data['urls'] = this.urls.toJson();
    }
    return data;
  }
}

class ResponseOrderDetails {
  String markDatetime;
  String orderId;
  List<Orders> orders;
  double totalPrice;

  ResponseOrderDetails({this.markDatetime, this.orderId, this.orders, this.totalPrice});

  ResponseOrderDetails.fromJson(Map<String, dynamic> json) {
    markDatetime = json['mark_datetime'];
    orderId = json['order_id'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders.add(new Orders.fromJson(v));
      });
    }
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mark_datetime'] = this.markDatetime;
    data['order_id'] = this.orderId;
    if (this.orders != null) {
      data['orders'] = this.orders.map((v) => v.toJson()).toList();
    }
    data['total_price'] = this.totalPrice;
    return data;
  }
}

class Orders {
  Banner banner;
  double discount;
  String gst;
  String hsn;
  double mrp;
  double price;
  String productName;
  int quantity;

  Orders(
      {this.banner,
        this.discount,
        this.gst,
        this.hsn,
        this.mrp,
        this.price,
        this.productName,
        this.quantity});

  Orders.fromJson(Map<String, dynamic> json) {
    banner =
    json['banner'] != null ? new Banner.fromJson(json['banner']) : null;
    discount = json['discount'];
    gst = json['gst'];
    hsn = json['hsn'];
    mrp = json['mrp'];
    price = json['price'];
    productName = json['product_name'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banner != null) {
      data['banner'] = this.banner.toJson();
    }
    data['discount'] = this.discount;
    data['gst'] = this.gst;
    data['hsn'] = this.hsn;
    data['mrp'] = this.mrp;
    data['price'] = this.price;
    data['product_name'] = this.productName;
    data['quantity'] = this.quantity;
    return data;
  }
}

class Banner {
  int id;
  String media;
  String mediaSection;
  String mediaType;
  int priority;

  Banner(
      {this.id, this.media, this.mediaSection, this.mediaType, this.priority});

  Banner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    media = json['media'];
    mediaSection = json['media_section'];
    mediaType = json['media_type'];
    priority = json['priority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['media'] = this.media;
    data['media_section'] = this.mediaSection;
    data['media_type'] = this.mediaType;
    data['priority'] = this.priority;
    return data;
  }
}

class Urls {
  String image;
  String video;

  Urls({this.image, this.video});

  Urls.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['video'] = this.video;
    return data;
  }
}
