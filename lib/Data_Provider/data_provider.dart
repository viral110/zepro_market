import 'package:flutter/cupertino.dart';
import 'package:jalaram/Model/decrement_product_model.dart';
import 'package:jalaram/Model/favourite_with_id.dart';
import 'package:jalaram/Model/fetch_cart_item_model.dart';
import 'package:jalaram/Model/get_wishlist_products.dart';
import 'package:jalaram/Model/micro_product.dart';
import 'package:jalaram/Model/micro_product_details.dart';
import 'package:jalaram/Model/token.dart';
import 'package:jalaram/product_catalogue/products.dart';

class DataProvider extends ChangeNotifier {
  Tokens tokens;
  MicroProduct microProducts;
  MicroProductDetails microProductDetails;
  GetWishListProducts getWishListProducts;
  DecrementNumber decrementNumber;
  FetchAddToCartItem fetchAddToCartItem;
  // List<AddFavoriteWithId> storeHeart = [];

  void setTokenData(Tokens t) {
    tokens = t;
    notifyListeners();
  }

  void getMicroProduct(MicroProduct m) {
    microProducts = m;
    notifyListeners();
  }

  void getMicroProductDetails(MicroProductDetails mpd) {
    microProductDetails = mpd;
    notifyListeners();
  }

  void getWishProducts(GetWishListProducts gwlp) {
    getWishListProducts = gwlp;
    notifyListeners();
  }



  void incrementProduct(IncrementNumber iN) {
    iN.toggleNumber();
    notifyListeners();
  }

  void fetchCartItems (FetchAddToCartItem fdt) {
    fetchAddToCartItem = fdt;
    notifyListeners();
  }

  // void addFavouriteList (AddFavoriteWithId heart) {
  //   storeHeart.add(heart);
  //
  //   notifyListeners();
  // }
  //
  // void removeFavouriteList (AddFavoriteWithId heart) {
  //   storeHeart.remove(heart);
  //   notifyListeners();
  // }

}
