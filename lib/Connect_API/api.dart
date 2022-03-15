import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:jalaram/Data_Provider/data_provider.dart';
import 'package:jalaram/Helper/string_helper.dart';
import 'package:jalaram/Model/decrement_product_model.dart';
import 'package:jalaram/Model/fetch_cart_item_model.dart';
import 'package:jalaram/Model/get_wishlist_products.dart';
import 'package:jalaram/Model/micro_product.dart';
import 'package:jalaram/Model/micro_product_details.dart';
import 'package:jalaram/Model/token.dart';
import 'package:provider/provider.dart';

final storageKey = FlutterSecureStorage();

class ApiServices {
  Future loginAuth(String mobileNum, BuildContext context) async {
    try {
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL + "api/authenticate");
        final response = await http.post(url, headers: {
          "Accept": "Application/json",
        }, body: {
          'mob_number': mobileNum,
        });
        print(response.body);
        if (response.statusCode == 200) {
          var decoded = jsonDecode(response.body);
          Tokens tokens = Tokens.fromJson(decoded);
          Provider.of<DataProvider>(context, listen: false)
              .setTokenData(tokens);
          await storageKey.write(
              key: 'access_token', value: tokens.accessToken);
          await storageKey.write(
              key: 'refresh_token', value: tokens.refreshToken);
          Fluttertoast.showToast(msg: "Login successfully");
        }
      } else {
        Fluttertoast.showToast(msg: "No Internet");
      }
    } catch (e) {
      debugPrint("Error Is : $e");
      Fluttertoast.showToast(msg: "Something went Wrong");
    }
  }

  Future getRefreshToken() async {
    try {
      var url = Uri.parse(StringHelper.BASE_URL + "api/refresh_token");
      String rToken = await storageKey.read(key: 'refresh_token');
      final response = await http.post(url, headers: {
        "Accept": "Application/json",
        'Authorization': 'Bearer $rToken',
      });
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);
        if (decoded['status'] == true) {
          await storageKey.write(key: 'access_token', value: 'access_token');
        }
      }
    } catch (e) {}
  }

  Future microProducts(BuildContext context) async {
    MicroProduct microProducts;
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL + "api/product/showcase");
        final response = await http.get(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          MicroProduct microProducts = MicroProduct.fromJson(decoded);
          Provider.of<DataProvider>(context, listen: false)
              .getMicroProduct(microProducts);
          return response;
        } else if (response.statusCode == 401) {
          getRefreshToken();
        } else {
          Fluttertoast.showToast(msg: "${decoded['message']}");
        }
      } else {
        Fluttertoast.showToast(msg: "No Internet");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future microProductDetails(String productId, BuildContext context) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url =
            Uri.parse(StringHelper.BASE_URL + 'api/product/desc/$productId');
        final response = await http.get(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          MicroProductDetails microProductDetails =
              MicroProductDetails.fromJson(decoded);
          Provider.of<DataProvider>(context, listen: false)
              .getMicroProductDetails(microProductDetails);
          return response;
        } else if (response.statusCode == 401) {
          getRefreshToken();
        } else {
          Fluttertoast.showToast(msg: "${decoded['message']}");
        }
      } else {
        Fluttertoast.showToast(msg: "No Internet!!!");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "${e.toString()}");
    }
  }

  Future addAndDeleteToFavourite(String productId) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(
            StringHelper.BASE_URL + 'api/user/favorite_product/$productId');
        final response = await http.get(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        // var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          debugPrint("Successfully");
          Fluttertoast.showToast(msg: "add to wishlist");
          // debugPrint("Message Response : ${decoded.toString()}");
        } else if (response.statusCode == 401) {
          getRefreshToken();
        } else {
          // Fluttertoast.showToast(msg: "${decoded['message']}");
        }
      } else {
        Fluttertoast.showToast(msg: "No Internet!!!");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error in addWishList : ${e.toString()}");
      debugPrint("Error in addWishList : ${e.toString()}");
    }
  }

  Future getWishListProducts(BuildContext context) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url =
            Uri.parse(StringHelper.BASE_URL + "api/user/get_favorite_products");
        final response = await http.get(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          GetWishListProducts getWishListProducts =
              GetWishListProducts.fromJson(decoded);
          Provider.of<DataProvider>(context, listen: false)
              .getWishProducts(getWishListProducts);
          return response;
        } else if (response.statusCode == 401) {
          getRefreshToken();
        } else {
          Fluttertoast.showToast(msg: "${decoded['message']}");
        }
      } else {
        Fluttertoast.showToast(msg: "No Internet!!!");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "${e.toString()}");
    }
  }

  Future incrementProducts(String productId, int numberProduct) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      debugPrint("$numberProduct");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL +
            "api/user/add_to_cart/$productId?item_count=$numberProduct");
        final response = await http.get(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: "Increment available");
          debugPrint("Increment Available");
        } else if (response.statusCode == 401) {
          getRefreshToken();
        } else {
          debugPrint("Error");
          // Fluttertoast.showToast(msg: "${decoded['message']}");
          debugPrint("Error : ${decoded['message']}");
        }
      } else {
        Fluttertoast.showToast(msg: "No Internet!!!");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "${e.toString()}");
      debugPrint("Error : ${e.toString()}");

    }
  }

  Future decrementProducts(String productId,int numberProduct,BuildContext context) async {
    try{
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      debugPrint("$numberProduct");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty){
        var url = Uri.parse(StringHelper.BASE_URL + "api/user/reduce_cart_item/$productId?item_count=$numberProduct");
        final response = await http.get(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if(response.statusCode == 200){

          Fluttertoast.showToast(msg: "Decrement available");
          debugPrint("Decrement Available");
        }
        else if (response.statusCode == 401) {
          getRefreshToken();
        } else {
          Fluttertoast.showToast(msg: "${decoded['message']}");
        }
      }
      else{
        Fluttertoast.showToast(msg: "No Internet!!!");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "${e.toString()}");
    }
  }

  Future fetchAddToCartItem (BuildContext context) async {
    try{
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
        var url = Uri.parse(StringHelper.BASE_URL + "api/user/get_cart_items");
        final response = await http.get(url,headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if(response.statusCode == 200){
          FetchAddToCartItem fetchAddToCartItem = FetchAddToCartItem.fromJson(decoded);
          Provider.of<DataProvider>(context,listen: false).fetchCartItems(fetchAddToCartItem);
          debugPrint("Fetch Add to Cart Item");

          return response;
        } else if(response.statusCode == 401){
          getRefreshToken();
        } else{
          Fluttertoast.showToast(msg: "${decoded['message']}");
        }
      } else {
        Fluttertoast.showToast(msg: "No Internet!!!");
      }
    }catch (e){
      Fluttertoast.showToast(msg: "${e.toString()}");
    }
  }

}
