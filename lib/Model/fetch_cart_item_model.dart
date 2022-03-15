import 'dart:convert';

class FetchAddToCartItem {
  List<Cart> cart;
  bool status;
  Urls urls;

  FetchAddToCartItem({this.cart, this.status, this.urls});

  FetchAddToCartItem.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      cart = <Cart>[];
      json['cart'].forEach((v) {
        cart.add(new Cart.fromJson(v));
      });
    }
    status = json['status'];
    urls = json['urls'] != null ? new Urls.fromJson(json['urls']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cart != null) {
      data['cart'] = this.cart.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    if (this.urls != null) {
      data['urls'] = this.urls.toJson();
    }
    return data;
  }
}

class Cart {
  int count;
  String markDatetime;
  Product product;

  Cart({this.count, this.markDatetime, this.product});

  Cart.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    markDatetime = json['mark_datetime'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['mark_datetime'] = this.markDatetime;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}

class Product {
  Banner banner;
  int cartoon;
  String category;
  double discountPercentage;
  double mrp;
  double price;
  String productId;
  int stock;
  String title;

  Product(
      {this.banner,
        this.cartoon,
        this.category,
        this.discountPercentage,
        this.mrp,
        this.price,
        this.productId,
        this.stock,
        this.title});

  Product.fromJson(Map<String, dynamic> json) {
    banner =
    json['banner'] != null ? new Banner.fromJson(json['banner']) : null;
    cartoon = json['cartoon'];
    category = json['category'];
    discountPercentage = json['discount_percentage'];
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
    data['cartoon'] = this.cartoon;
    data['category'] = this.category;
    data['discount_percentage'] = this.discountPercentage;
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
