class HomeCartCategory {
  List<CatList> catList;
  bool status;

  HomeCartCategory({this.catList, this.status});

  HomeCartCategory.fromJson(Map<String, dynamic> json) {
    if (json['cat_list'] != null) {
      catList = <CatList>[];
      json['cat_list'].forEach((v) {
        catList.add(new CatList.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.catList != null) {
      data['cat_list'] = this.catList.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class CatList {
  String image;
  String name;

  CatList({this.image, this.name});

  CatList.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['name'] = this.name;
    return data;
  }
}
