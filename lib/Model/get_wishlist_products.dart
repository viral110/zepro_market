
class GetWishListProducts {
  List<ResponseGetWishList> response;
  bool status;
  Urls urls;

  GetWishListProducts({this.response, this.status});

  GetWishListProducts.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <ResponseGetWishList>[];
      json['response'].forEach((v) {
        response.add(new ResponseGetWishList.fromJson(v));
      });
    }
    status = json['status'];
    urls = json['urls'] != null ? new Urls.fromJson(json['urls']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    if (this.urls != null) {
      data['urls'] = this.urls.toJson();
    }
    return data;
  }
}

class ResponseGetWishList {
  Banner banner;
  bool cartStatus;
  int cartoon;
  String category;
  double discountPercentage;
  int inCart;
  double mrp;
  double price;
  String gst;
  String hsn;
  String productId;
  int stock;
  String title;

  ResponseGetWishList(
      {this.banner,
        this.cartStatus,
        this.cartoon,
        this.category,
        this.discountPercentage,
        this.inCart,
        this.mrp,
        this.price,
        this.hsn,
        this.gst,
        this.productId,
        this.stock,
        this.title});

  ResponseGetWishList.fromJson(Map<String, dynamic> json) {
    banner =
    json['banner'] != null ? new Banner.fromJson(json['banner']) : null;
    cartStatus = json['cart_status'];
    cartoon = json['cartoon'];
    category = json['category'];
    discountPercentage = json['discount_percentage'];
    inCart = json['in_cart'];
    mrp = json['mrp'];
    price = json['price'];
    gst = json['gst'];
    hsn = json['hsn'];
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
    data['discount_percentage'] = this.discountPercentage.toDouble();
    data['in_cart'] = this.inCart;
    data['mrp'] = this.mrp.toDouble();
    data['price'] = this.price.toDouble();
    data['gst'] = this.gst;
    data['hsn'] = this.hsn;
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
