import 'package:flutter/cupertino.dart';
import 'package:jalaram/Model/decrement_product_model.dart';
import 'package:jalaram/Model/favourite_with_id.dart';
import 'package:jalaram/Model/fetch_cart_item_model.dart';
import 'package:jalaram/Model/get_wishlist_products.dart';
import 'package:jalaram/Model/home_new_arrival_model.dart';
import 'package:jalaram/Model/main_banner_home.dart';
import 'package:jalaram/Model/micro_product.dart';
import 'package:jalaram/Model/micro_product_details.dart';
import 'package:jalaram/Model/multiple_banner_home.dart';
import 'package:jalaram/Model/price_counter_model.dart';
import 'package:jalaram/Model/searching_product_model.dart';
import 'package:jalaram/Model/token.dart';
import 'package:jalaram/product_catalogue/products.dart';

import '../Model/home_cart_category_model.dart';

class DataProvider extends ChangeNotifier {
  Tokens tokens;
  MicroProduct microProducts;
  MicroProductDetails microProductDetails;
  GetWishListProducts getWishListProducts;
  DecrementNumber decrementNumber;
  FetchAddToCartItem fetchAddToCartItem;
  PriceCounterModel priceCounterModel;
  HomeCartCategory homeCart;
  HomeNewArrival homeNArrival;
  MultipleBannerHome multipleBannerHome;
  MainBannerHome mainBannerHome;
  SearchProductModel searchProductModel;
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

  void getPriceCounter (PriceCounterModel pcm) {
    priceCounterModel = pcm;
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

  void getHomeCategory(HomeCartCategory hcc){
    homeCart = hcc;
    notifyListeners();
  }

  void getHomeNewArrival(HomeNewArrival hna){
    homeNArrival = hna;
    notifyListeners();
  }

  void getMultipleBannerHome(MultipleBannerHome mbh){
    multipleBannerHome = mbh;
    notifyListeners();
  }

  void getMainBannerHome(MainBannerHome mainbh){
    mainBannerHome = mainbh;
    notifyListeners();
  }

  void getSearchProduct(SearchProductModel spm){
    searchProductModel = spm;
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
