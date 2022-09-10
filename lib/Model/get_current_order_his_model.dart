// To parse this JSON data, do
//
//     final getCurrentOrderHistory = getCurrentOrderHistoryFromJson(jsonString);

import 'dart:convert';

GetCurrentOrderHistory getCurrentOrderHistoryFromJson(String str) => GetCurrentOrderHistory.fromJson(json.decode(str));

String getCurrentOrderHistoryToJson(GetCurrentOrderHistory data) => json.encode(data.toJson());

class GetCurrentOrderHistory {
  GetCurrentOrderHistory({
    this.response,
    this.status,
    this.urls,
  });

  Map<String, List<dynamic>> response;
  bool status;
  Urls urls;

  factory GetCurrentOrderHistory.fromJson(Map<String, dynamic> json) => GetCurrentOrderHistory(
    response: Map.from(json["response"]).map((k, v) => MapEntry<String, List<dynamic>>(k, List<dynamic>.from(v.map((x) => x)))),
    status: json["status"],
    urls: Urls.fromJson(json["urls"]),
  );

  Map<String, dynamic> toJson() => {
    "response": Map.from(response).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
    "status": status,
    "urls": urls.toJson(),
  };
}

class ResponseClass {
  ResponseClass({
    this.count,
    this.markDatetime,
    this.orderId,
    this.product,
  });

  int count;
  String markDatetime;
  String orderId;
  Product product;

  factory ResponseClass.fromJson(Map<String, dynamic> json) => ResponseClass(
    count: json["count"],
    markDatetime: json["mark_datetime"],
    orderId: json["order_id"],
    product: Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "mark_datetime": markDatetime,
    "order_id": orderId,
    "product": product.toJson(),
  };
}

class Product {
  Product({
    this.banner,
    this.cartoon,
    this.category,
    this.discountPercentage,
    this.gst,
    this.hsn,
    this.isTrending,
    this.mrp,
    this.price,
    this.productId,
    this.stock,
    this.title,
  });

  Banner banner;
  int cartoon;
  String category;
  double discountPercentage;
  dynamic gst;
  String hsn;
  bool isTrending;
  int mrp;
  int price;
  String productId;
  int stock;
  String title;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    banner: Banner.fromJson(json["banner"]),
    cartoon: json["cartoon"],
    category: json["category"],
    discountPercentage: json["discount_percentage"].toDouble(),
    gst: json["gst"],
    hsn: json["hsn"],
    isTrending: json["isTrending"],
    mrp: json["mrp"],
    price: json["price"],
    productId: json["product_id"],
    stock: json["stock"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "banner": banner.toJson(),
    "cartoon": cartoon,
    "category": category,
    "discount_percentage": discountPercentage,
    "gst": gst,
    "hsn": hsn,
    "isTrending": isTrending,
    "mrp": mrp,
    "price": price,
    "product_id": productId,
    "stock": stock,
    "title": title,
  };
}

class Banner {
  Banner({
    this.id,
    this.media,
    this.mediaSection,
    this.mediaType,
    this.priority,
  });

  int id;
  String media;
  String mediaSection;
  String mediaType;
  int priority;

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    id: json["id"],
    media: json["media"],
    mediaSection: json["media_section"],
    mediaType: json["media_type"],
    priority: json["priority"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "media": media,
    "media_section": mediaSection,
    "media_type": mediaType,
    "priority": priority,
  };
}

class Urls {
  Urls({
    this.image,
    this.video,
  });

  String image;
  String video;

  factory Urls.fromJson(Map<String, dynamic> json) => Urls(
    image: json["image"],
    video: json["video"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "video": video,
  };
}
