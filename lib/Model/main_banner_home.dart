class MainBannerHome {
  List<Banners> banners;
  bool status;
  String url;

  MainBannerHome({this.banners, this.status, this.url});

  MainBannerHome.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners.add(new Banners.fromJson(v));
      });
    }
    status = json['status'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banners != null) {
      data['banners'] = this.banners.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['url'] = this.url;
    return data;
  }
}

class Banners {
  String banner;
  String bannerType;
  int id;
  int priority;

  Banners({this.banner, this.bannerType, this.id, this.priority});

  Banners.fromJson(Map<String, dynamic> json) {
    banner = json['banner'];
    bannerType = json['banner_type'];
    id = json['id'];
    priority = json['priority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner'] = this.banner;
    data['banner_type'] = this.bannerType;
    data['id'] = this.id;
    data['priority'] = this.priority;
    return data;
  }
}
