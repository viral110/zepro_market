import 'package:flutter/cupertino.dart';
import 'package:jalaram/Model/decrement_product_model.dart';
import 'package:jalaram/Model/favourite_with_id.dart';
import 'package:jalaram/Model/fetch_cart_item_model.dart';
import 'package:jalaram/Model/fetch_order_id.dart';
import 'package:jalaram/Model/get_current_order_his_model.dart';
import 'package:jalaram/Model/get_feed_back_user.dart';
import 'package:jalaram/Model/get_profile_image.dart';
import 'package:jalaram/Model/get_wishlist_products.dart';
import 'package:jalaram/Model/home_new_arrival_model.dart';
import 'package:jalaram/Model/main_banner_home.dart';
import 'package:jalaram/Model/micro_product.dart';
import 'package:jalaram/Model/micro_product_details.dart';
import 'package:jalaram/Model/multiple_banner_home.dart';
import 'package:jalaram/Model/notification_model.dart';
import 'package:jalaram/Model/price_counter_model.dart';
import 'package:jalaram/Model/register_auth_model.dart';
import 'package:jalaram/Model/searching_product_model.dart';
import 'package:jalaram/Model/token.dart';
import 'package:jalaram/product_catalogue/products.dart';

import '../Model/home_cart_category_model.dart';

class DataProvider extends ChangeNotifier {




  Tokens tokens;
  MicroProduct microProducts;
  MicroProductDetails microProductDetails;
  GetWishListProducts getWishListProducts;
  GetProfilePic getProfilePic;
  DecrementNumber decrementNumber;
  FetchAddToCartItem fetchAddToCartItem;
  PriceCounterModel priceCounterModel;
  HomeCartCategory homeCart;
  HomeNewArrival homeNArrival;
  MultipleBannerHome multipleBannerHome;
  MainBannerHome mainBannerHome;
  MicroProduct searchProductModel;
  FetchOrderId orderId;
  GetCurrentOrderHistory getCurrentOrderHistory;
  NotificationModel notificationModel;
  RegisterAuth registerAuth;
  GetFeedBack getFeedBack;


  // List<AddFavoriteWithId> storeHeart = [];



  void setTokenData(Tokens t) {
    tokens = t;
    notifyListeners();
  }

  void getMicroProduct(MicroProduct m) {
    microProducts = m;
    notifyListeners();
  }

  void getCurrentOrderProvider(GetCurrentOrderHistory gcoh){
    getCurrentOrderHistory = gcoh;
    notifyListeners();
  }

  void getNotification(NotificationModel nm){
    notificationModel = nm;
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

  void fetchCartItems(FetchAddToCartItem fdt) {
    fetchAddToCartItem = fdt;
    notifyListeners();
  }

  void getHomeCategory(HomeCartCategory hcc) {
    homeCart = hcc;
    notifyListeners();
  }

  void getHomeNewArrival(HomeNewArrival hna) {
    homeNArrival = hna;
    notifyListeners();
  }

  void getMultipleBannerHome(MultipleBannerHome mbh) {
    multipleBannerHome = mbh;
    notifyListeners();
  }

  void getMainBannerHome(MainBannerHome mainbh) {
    mainBannerHome = mainbh;
    notifyListeners();
  }

  // void getSearchProduct(MicroProduct spm) {
  //   searchProductModel = spm;
  //   notifyListeners();
  // }

  void fetchOrderId(FetchOrderId foi) {
    orderId = foi;
    notifyListeners();
  }

  void getRegisterDetails(RegisterAuth ra) {
    registerAuth = ra;
    notifyListeners();
  }

  void getProfilePicture(GetProfilePic gpp){
    getProfilePic = gpp;
    notifyListeners();
  }

  void getFeedBackUserProvider(GetFeedBack gfb){
    getFeedBack = gfb;
    notifyListeners();
  }

}
