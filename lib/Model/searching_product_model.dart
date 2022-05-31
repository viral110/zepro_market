class SearchProductModel {
  List<ResponseSearchProduct> response;
  bool status;

  SearchProductModel({this.response, this.status});

  SearchProductModel.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <ResponseSearchProduct>[];
      json['response'].forEach((v) {
        response.add(new ResponseSearchProduct.fromJson(v));
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

class ResponseSearchProduct {
  Banner banner;
  int cartoon;
  String category;
  double discountPercentage;
  bool isTrending;
  double mrp;
  double price;
  String productId;
  int stock;
  String title;

  ResponseSearchProduct(
      {this.banner,
        this.cartoon,
        this.category,
        this.discountPercentage,
        this.isTrending,
        this.mrp,
        this.price,
        this.productId,
        this.stock,
        this.title});

  ResponseSearchProduct.fromJson(Map<String, dynamic> json) {
    banner =
    json['banner'] != null ? new Banner.fromJson(json['banner']) : null;
    cartoon = json['cartoon'];
    category = json['category'];
    discountPercentage = json['discount_percentage'];
    isTrending = json['isTrending'];
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
    data['isTrending'] = this.isTrending;
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
