import 'dart:convert';

// AddFavoriteWithId addFavoriteFromJson(String str) => AddFavoriteWithId.fromJson(json.decode(str));
//
// String addFavoriteToJson(AddFavoriteWithId data) => json.encode(data.toJson());
//
// class AddFavoriteWithId {
//   AddFavoriteWithId({
//     this.isFavorite,
//     this.id,
//   });
//
//   bool isFavorite;
//   String id;
//
//   factory AddFavoriteWithId.fromJson(Map<String, dynamic> json) => AddFavoriteWithId(
//     isFavorite: json["is_favorite"] == null ? null : json["is_favorite"],
//     id: json["id"] == null ? null : json["id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "is_favorite": isFavorite == null ? null : isFavorite,
//     "id": id == null ? null : id,
//   };
// }

class IncrementNumber {
  String productName;
  bool isVisible;
  int counter;
  double priceTotal;

  IncrementNumber({this.productName,this.isVisible,this.counter,this.priceTotal});


  void toggleNumber(){
    counter++;
  }

  void decreaseDown(){
    counter == 0 ? 0 : counter--;
  }
}
