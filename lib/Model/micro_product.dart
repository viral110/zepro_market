class MicroProduct {
  int currentPage;
  int perPage;
  List<ResponseMicro> response;
  bool status;
  int totalPages;
  Urls urls;

  MicroProduct(
      {this.currentPage,
        this.perPage,
        this.response,
        this.status,
        this.totalPages,
        this.urls});

  MicroProduct.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    perPage = json['per_page'];
    // if (json['response'] != null) {
    //   response = new List<ResponseMicro>();
    //   json['response'].forEach((v) {
    //     response.add(new ResponseMicro.fromJson(v));
    //   });
    // }
    response = List.from(json['response']).map((e) => ResponseMicro.fromJson(e)).toList();
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
    // data['response'] = this.response.map((e) => e.toJson()).toList();
    data['status'] = this.status;
    data['total_pages'] = this.totalPages;
    if (this.urls != null) {
      data['urls'] = this.urls.toJson();
    }
    return data;
  }
}

class ResponseMicro {
  Banner banner;
  int cartoon;
  String category;
  double discountPercentage;
  double mrp;
  double price;
  bool inCart;
  bool inFavorits;
  String productId;
  int stock;
  String title;

  ResponseMicro(
      {this.banner,
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

  ResponseMicro.fromJson(Map<String, dynamic> json) {
    banner =
    json['banner'] != null ? new Banner.fromJson(json['banner']) : null;
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
    data['cartoon'] = this.cartoon;
    data['category'] = this.category;
    data['discount_percentage'] = this.discountPercentage.toDouble();
    data['in_cart'] = this.inCart;
    data['in_favorits'] = this.inFavorits;
    data['mrp'] = this.mrp.toDouble();
    data['price'] = this.price.toDouble();
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
