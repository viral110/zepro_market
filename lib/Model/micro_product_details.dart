class MicroProductDetails {
  ResponseMicroDetails response;
  bool status;
  Urls urls;

  MicroProductDetails({this.response, this.status, this.urls});

  MicroProductDetails.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new ResponseMicroDetails.fromJson(json['response'])
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

class ResponseMicroDetails {
  List<BannersMicroDetails> banners;
  bool cartStatus;
  int cartoon;
  String category;
  String description;
  String dimensions;
  double discountPercentage;
  List<GalleryOfProduct> gallery;
  String hsn;
  int inCart;
  bool inFavorits;
  double mrp;
  double price;
  String productId;
  String status;
  int stock;
  String title;
  double weight;
  String youtubeLink;

  ResponseMicroDetails(
      {this.banners,
      this.cartStatus,
      this.cartoon,
      this.category,
      this.description,
      this.dimensions,
      this.discountPercentage,
      this.gallery,
      this.hsn,
      this.inCart,
      this.inFavorits,
      this.mrp,
      this.price,
      this.productId,
      this.status,
      this.stock,
      this.title,
      this.weight,
      this.youtubeLink});

  ResponseMicroDetails.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = new List<BannersMicroDetails>();
      json['banners'].forEach((v) {
        banners.add(new BannersMicroDetails.fromJson(v));
      });
    }
    cartStatus = json['cart_status'];
    cartoon = json['cartoon'];
    category = json['category'];
    description = json['description'];
    dimensions = json['dimensions'];
    discountPercentage = json['discount_percentage'];
    if (json['gallery'] != null) {
      gallery = new List<GalleryOfProduct>();
      json['gallery'].forEach((v) {
        gallery.add(new GalleryOfProduct.fromJson(v));
      });
    }
    hsn = json['hsn'];
    inCart = json['in_cart'];
    inFavorits = json['in_favorits'];
    mrp = json['mrp'];
    price = json['price'];
    productId = json['product_id'];
    status = json['status'];
    stock = json['stock'];
    title = json['title'];
    weight = json['weight'];
    youtubeLink = json['youtube_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banners != null) {
      data['banners'] = this.banners.map((v) => v.toJson()).toList();
    }
    data['cart_status'] = this.cartStatus;
    data['cartoon'] = this.cartoon;
    data['category'] = this.category;
    data['description'] = this.description;
    data['dimensions'] = this.dimensions;
    data['discount_percentage'] = this.discountPercentage.toDouble();
    if (this.gallery != null) {
      data['gallery'] = this.gallery.map((v) => v.toJson()).toList();
    }
    data['hsn'] = this.hsn;
    data['in_cart'] = this.inCart;
    data['in_favorits'] = this.inFavorits;
    data['mrp'] = this.mrp.toInt();
    data['price'] = this.price.toDouble();
    data['product_id'] = this.productId;
    data['status'] = this.status;
    data['stock'] = this.stock;
    data['title'] = this.title;
    data['weight'] = this.weight;
    data['youtube_link'] = this.youtubeLink;
    return data;
  }
}

class GalleryOfProduct {
  int id;
  String media;
  String mediaSection;
  String mediaType;
  int priority;

  GalleryOfProduct(
      {this.id, this.media, this.mediaSection, this.mediaType, this.priority});

  GalleryOfProduct.fromJson(Map<String, dynamic> json) {
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

class BannersMicroDetails {
  int id;
  String media;
  String mediaSection;
  String mediaType;
  int priority;

  BannersMicroDetails(
      {this.id, this.media, this.mediaSection, this.mediaType, this.priority});

  BannersMicroDetails.fromJson(Map<String, dynamic> json) {
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
