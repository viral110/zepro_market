import 'dart:ffi';

class PriceCounterModel {
  int currentPage;
  int perPage;
  List<ResponsePriceCounter> response;
  bool status;
  int totalPages;
  Urls urls;

  PriceCounterModel(
      {this.currentPage,
      this.perPage,
      this.response,
      this.status,
      this.totalPages,
      this.urls});

  PriceCounterModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    perPage = json['per_page'];
    if (json['response'] != null) {
      response = <ResponsePriceCounter>[];
      json['response'].forEach((v) {
        response.add(new ResponsePriceCounter.fromJson(v));
      });
    }
    status = json['status'];
    totalPages = json['total_pages'];
    urls = json['urls'] != null ? new Urls.fromJson(json['urls']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['per_page'] = this.perPage;
    if (this.response != null) {
      data['response'] = this.response.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['total_pages'] = this.totalPages;
    if (this.urls != null) {
      data['urls'] = this.urls.toJson();
    }
    return data;
  }
}

class ResponsePriceCounter {
  Banner banner;
  bool cartStatus;
  int cartoon;
  String category;
  double discountPercentage;
  int inCart;
  bool inFavorits;
  double mrp;
  double price;
  String productId;
  int stock;
  String title;

  ResponsePriceCounter(
      {this.banner,
      this.cartStatus,
      this.cartoon,
      this.category,
      this.discountPercentage,
      this.inCart,
      this.inFavorits,
      this.mrp,
      this.price,
      this.productId,
      this.stock,
      this.title});

  ResponsePriceCounter.fromJson(Map<String, dynamic> json) {
    banner =
        json['banner'] != null ? new Banner.fromJson(json['banner']) : null;
    cartStatus = json['cart_status'];
    cartoon = json['cartoon'];
    category = json['category'];
    discountPercentage = json['discount_percentage'];
    inCart = json['in_cart'];
    inFavorits = json['in_favorits'];
    mrp = json['mrp'];
    price = json['price'];
    productId = json['product_id'];
    stock = json['stock'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banner != null) {
      data['banner'] = this.banner.toJson();
    }
    data['cart_status'] = this.cartStatus;
    data['cartoon'] = this.cartoon;
    data['category'] = this.category;
    data['discount_percentage'] = this.discountPercentage;
    data['in_cart'] = this.inCart;
    data['in_favorits'] = this.inFavorits;
    data['mrp'] = this.mrp;
    data['price'] = this.price;
    data['product_id'] = this.productId;
    data['stock'] = this.stock;
    data['title'] = this.title;
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
