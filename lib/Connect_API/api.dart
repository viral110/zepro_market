import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jalaram/Data_Provider/favourite_provider.dart';
import 'package:jalaram/Model/get_feed_back_user.dart';
import 'package:jalaram/Model/get_profile_image.dart';
import 'package:jalaram/Model/local_database.dart';
import 'package:jalaram/Model/register_auth_model.dart';
import 'package:jalaram/Pending_Order/pendingorder.dart';
import 'package:jalaram/Register_Form/register.dart';
import 'package:jalaram/Splash_Screen/splashscreen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:jalaram/Data_Provider/data_provider.dart';
import 'package:jalaram/Helper/string_helper.dart';
import 'package:jalaram/Model/decrement_product_model.dart';
import 'package:jalaram/Model/fetch_cart_item_model.dart';
import 'package:jalaram/Model/fetch_order_id.dart';
import 'package:jalaram/Model/get_current_order_his_model.dart';
import 'package:jalaram/Model/get_wishlist_products.dart';
import 'package:jalaram/Model/home_cart_category_model.dart';
import 'package:jalaram/Model/home_new_arrival_model.dart';
import 'package:jalaram/Model/main_banner_home.dart';
import 'package:jalaram/Model/micro_product.dart';
import 'package:jalaram/Model/micro_product_details.dart';
import 'package:jalaram/Model/multiple_banner_home.dart';
import 'package:jalaram/Model/notification_model.dart';
import 'package:jalaram/Model/price_counter_model.dart';
import 'package:jalaram/Model/searching_product_model.dart';
import 'package:jalaram/Model/token.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../Data_Provider/store_list_bool.dart';
import '../Home/bottomnavbar.dart';
import '../add_to_cart_part/confirm_order.dart';
import 'package:dio/dio.dart';

import '../login_details/login_otp_page.dart';
import 'data_base.dart';

final storageKey = FlutterSecureStorage();

List<String> orderIdForGlobal = [];

String filePathForOpenFile = "";

final storeKeyByGet = GetStorage();

String feedbackId = "";

class ApiServices {
  Future loginAuthWithOTP(String mobileNum, BuildContext context) async {
    try {
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(
            StringHelper.BASE_URL + "api/request_otp?mobile_number=$mobileNum");
        final response = await http.get(
          url,
          headers: {
            "Accept": "Application/json",
          },
        );
        print(response.body);
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          print(decoded);
          Fluttertoast.showToast(msg: "Login OTP sent");
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginOTPPage(phoneNum: mobileNum),
              ));
        } else {
          Fluttertoast.showToast(msg: decoded['type']);
        }
      } else {
        Fluttertoast.showToast(msg: "No Internet");
      }
    } catch (e) {
      debugPrint("Error Is : $e");
      // Fluttertoast.showToast(msg: "Something went Wrong");
    }
  }

  Future otpSentBackend(
      String mobileNum, String otp, BuildContext context) async {
    try {
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL +
            "api/authenticate?mob_number=$mobileNum&otp=$otp");
        final response = await http.get(
          url,
          headers: {
            "Accept": "Application/json",
          },
        );
        print(response.body);
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          print(decoded);
          Tokens tokens = Tokens.fromJson(decoded);
          Provider.of<DataProvider>(context, listen: false)
              .setTokenData(tokens);
          await storageKey.write(
              key: 'access_token', value: tokens.accessToken);
          await storageKey.write(
              key: 'refresh_token', value: tokens.refreshToken);
          await storageKey.write(
              key: 'new_user', value: tokens.newUser.toString());
          storeKeyByGet.write('access_token', tokens.accessToken);
          Fluttertoast.showToast(msg: "Login Successfully");
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Register(),
              ));
        } else {
          Fluttertoast.showToast(msg: decoded['message']);
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
          'Authorization':
              'Bearer ${await storageKey.read(key: 'access_token')}',
        });
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          MicroProduct microProducts = MicroProduct.fromJson(decoded);
          Provider.of<DataProvider>(context, listen: false)
              .getMicroProduct(microProducts);
          Provider.of<StoreListBoolProvider>(context, listen: false)
              .getData(microProducts);
          return response;
        } else if (response.statusCode == 401) {
          getRefreshToken();
        } else {
          debugPrint("${decoded['message']}");
          // Fluttertoast.showToast(msg: "${decoded['message']}");
        }
      } else {
        Fluttertoast.showToast(msg: "No Internet");
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
      debugPrint("${e.toString()}");
    }
  }

  Future microProductDetails(String productId, BuildContext context) async {
    try {
      debugPrint(productId);
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
      // Fluttertoast.showToast(msg: "${e.toString()}");
    }
  }

  Future addAndDeleteToFavourite(String productId,) async {
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
      // Fluttertoast.showToast(msg: "Error in addWishList : ${e.toString()}");
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
        print("viral:$decoded");
        if (response.statusCode == 200) {

          GetWishListProducts getWishListProducts =
              GetWishListProducts.fromJson(decoded);
          Provider.of<DataProvider>(context, listen: false)
              .getWishProducts(getWishListProducts);
          // List productCartoon = [];
          // List productName = [];
          // List productCategory = [];
          // List productStock = [];
          // List productImage = [];
          // for (int i = 0; i <= getWishListProducts.response.length; i++) {
          //   productName.add(getWishListProducts.response[i].title);
          //   productCategory.add(getWishListProducts.response[i].category);
          //   productImage.add(getWishListProducts.response[i].banner.media);
          //   productStock.add(getWishListProducts.response[i].stock);
          //   productCartoon.add(getWishListProducts.response[i].cartoon);
          // }
          // Provider.of<FavouriteListProvider>(context, listen: false)
          //     .fetchDataFromList(productName, productCategory, productCartoon,
          //         productStock, productImage);
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
      // Fluttertoast.showToast(msg: "${e.toString()}");
      debugPrint("Error : ${e.toString()}");
    }
  }

  Future decrementProducts(
      String productId, int numberProduct, BuildContext context) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      debugPrint("$numberProduct");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL +
            "api/user/reduce_cart_item/$productId?item_count=$numberProduct");
        final response = await http.get(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: "Decrement available");
          debugPrint("Decrement Available");
        } else if (response.statusCode == 401) {
          getRefreshToken();
        } else {
          Fluttertoast.showToast(msg: "${decoded['message']}");
        }
      } else {
        Fluttertoast.showToast(msg: "No Internet!!!");
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: "${e.toString()}");
    }
  }

  Future fetchAddToCartItem(BuildContext context) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL + "api/user/get_cart_items");
        final response = await http.get(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          FetchAddToCartItem fetchAddToCartItem =
              FetchAddToCartItem.fromJson(decoded);
          Provider.of<DataProvider>(context, listen: false)
              .fetchCartItems(fetchAddToCartItem);
          debugPrint("Fetch Add to Cart Item");

          return response;
        } else if (response.statusCode == 401) {
          getRefreshToken();
        } else {
          debugPrint(decoded['message'] + "-----------");
          Fluttertoast.showToast(msg: "${decoded['message']}");
        }
      } else {
        Fluttertoast.showToast(msg: "No Internet!!!");
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: "${e.toString()}");
    }
  }

  Future getProductCounter(String number, BuildContext context) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(
            StringHelper.BASE_URL + "api/filter_by_price?price=$number");
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
          debugPrint("${decoded['message']}");
        }
      } else {
        debugPrint("No Internet!!!");
      }
    } catch (e) {
      debugPrint("${e.toString()}");
    }
  }

  Future getSearchByPrice(
      int lowValue, int highValue, BuildContext context) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL +
            "api/filter_by_price?low_price=$lowValue&price=$highValue");
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
          debugPrint("${decoded['message']}");
        }
      } else {
        debugPrint("No Internet!!!");
      }
    } catch (e) {
      debugPrint("${e.toString()}");
    }
  }

  Future getHomeCategory(BuildContext context) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL + "api/get_category_list");
        final response = await http.get(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          HomeCartCategory homeCartCategory =
              HomeCartCategory.fromJson(decoded);
          Provider.of<DataProvider>(context, listen: false)
              .getHomeCategory(homeCartCategory);
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
      // Fluttertoast.showToast(msg: "${e.toString()}");
    }
  }

  Future getHomeNewArrival(BuildContext context) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL + "api/new_arrivals");
        final response = await http.get(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          HomeNewArrival homeNewArrival = HomeNewArrival.fromJson(decoded);
          Provider.of<DataProvider>(context, listen: false)
              .getHomeNewArrival(homeNewArrival);
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
      // Fluttertoast.showToast(msg: "${e.toString()}");
    }
  }

  Future multipleBanner(BuildContext context) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url =
            Uri.parse(StringHelper.BASE_URL + "api/get_app_banner/slider");
        final response = await http.get(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          MultipleBannerHome multipleBannerHome =
              MultipleBannerHome.fromJson(decoded);
          Provider.of<DataProvider>(context, listen: false)
              .getMultipleBannerHome(multipleBannerHome);
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
      // Fluttertoast.showToast(msg: "${e.toString()}");
    }
  }

  Future mainBannerHome(BuildContext context) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL + "api/get_app_banner/main");
        final response = await http.get(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          MainBannerHome mainBannerHome = MainBannerHome.fromJson(decoded);
          Provider.of<DataProvider>(context, listen: false)
              .getMainBannerHome(mainBannerHome);
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
      // Fluttertoast.showToast(msg: "${e.toString()}");
    }
  }

  Future deleteAddToCartItem(BuildContext context, String productId) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(
            StringHelper.BASE_URL + "api/user/remove_from_cart/$productId");
        final response = await http.delete(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: "Delete Product");
        } else if (response.statusCode == 401) {
          getRefreshToken();
        } else {
          Fluttertoast.showToast(msg: "${decoded['message']}");
        }
      } else {
        Fluttertoast.showToast(msg: "No Internet!!!");
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: "${e.toString()}");
    }
  }

  Future searchProducts(BuildContext context, String key) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL + "api/search?key=$key");
        final response = await http.get(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          MicroProduct searchProductModel = MicroProduct.fromJson(decoded);

          Provider.of<DataProvider>(context, listen: false)
              .getMicroProduct(searchProductModel);
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
      // Fluttertoast.showToast(msg: "${e.toString()}");
    }
  }

  Future confirmOrder(BuildContext context) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL + 'api/confirm_order');
        final response = await http.get(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          FetchOrderId fetchOrderId = FetchOrderId.fromJson(decoded);
          Provider.of<DataProvider>(context, listen: false)
              .fetchOrderId(fetchOrderId);
          debugPrint("Successfully");
          String orderId = fetchOrderId.orderId;

          orderIdForGlobal.add(orderId);
          storageKey.write(key: "orderId", value: jsonEncode(orderIdForGlobal));

          final storeProductId = LocalStoreProductId(
            productId: fetchOrderId.orderId,
            createdTime: DateTime.now(),
          );

          await LocalProductDetailsDataBase.instance.create(storeProductId);

          print(storeProductId);

          Fluttertoast.showToast(msg: "Confirm Order");
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ConfirmOrderPage(
              id: orderId,
            ),
          ));

          // debugPrint("Message Response : ${decoded.toString()}");
          return response;
        } else if (response.statusCode == 401) {
          getRefreshToken();
        } else {
          // Fluttertoast.showToast(msg: "${decoded['message']}");
        }
      } else {
        Fluttertoast.showToast(msg: "No Internet!!!");
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: "Error in confirmOrder : ${e.toString()}");
      debugPrint("Error in confirmOrder : ${e.toString()}");
    }
  }

  Future downloadPdfWithPrice(
      BuildContext context, String isWithPrice, String withFrontPage,
      {void stepProgress(int remain, int total)}) async {
    Dio dio = Dio();

    Map<String, dynamic> resultMap = {
      'isSuccess': false,
      "filePath": null,
      "error": null,
    };

    try {
      final List<int> _bytes = [];
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      String pdfName = "";
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL +
            'api/product_pdf?with_price=$isWithPrice&with_front_page=$withFrontPage');

        // final responseNew = await http.Client().send(http.Request("GET", url));
        // Map<String,String> mapString = {
        //   'Authorization': 'Bearer $aToken',
        // };
        // responseNew.headers.addAll(mapString);

        Response response = await dio.request(
          (StringHelper.BASE_URL +
              'api/product_pdf?with_price=$isWithPrice&with_front_page=$withFrontPage'),
          onReceiveProgress: stepProgress,
          queryParameters: {
            HttpHeaders.authorizationHeader: "Bearer $aToken",
            HttpHeaders.contentTypeHeader: 'application/json'
          },
          options: Options(
            responseType: ResponseType.bytes,
            method: 'GET',
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $aToken',
            },
          ),
        );

        var dir = await getExternalStorageDirectory();
        print(dir.path);
        if (isWithPrice == "on" && withFrontPage == "on") {
          pdfName = "With_Price";
        } else if (isWithPrice == "off" && withFrontPage == "on") {
          pdfName = "With_Out_Price";
        } else if (isWithPrice == "on" && withFrontPage == "off") {
          pdfName = "With_Price_Out_Logo";
        } else if (isWithPrice == "off" && withFrontPage == "off") {
          pdfName = "Out_Price_Logo";
        }
        var file =
            File("/storage/emulated/0/Download/Deluxeecommerce-$pdfName.pdf");

        await file.writeAsBytes(response.data);

        print(file);

        resultMap['filePath'] = file.path;
        filePathForOpenFile = file.path;
        resultMap['isSuccess'] = response.statusCode == 200;
        showNotificationPdf(resultMap);
        return file;
      } else {
        Fluttertoast.showToast(msg: "No Internet!!!");
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: "Error in confirmOrder : ${e.toString()}");
      resultMap['error'] = e.toString();
      debugPrint("Error in downloadPDF : ${e.toString()}");
    }
  }

  Future showNotificationPdf(Map<String, dynamic> mapdata) async {
    final android = AndroidNotificationDetails("channelId", "channelName",
        channelDescription: "channelDesc",
        priority: Priority.high,
        importance: Importance.high);
    final ios = IOSNotificationDetails();
    final notificationDetails = NotificationDetails(android: android, iOS: ios);
    final jsonMapPdf = jsonEncode(mapdata);
    final isSuccess = mapdata['isSuccess'];
    DateTime dateTime = DateTime.now();
    await FlutterLocalNotificationsPlugin().show(
        0,
        isSuccess
            ? "Deluxe Ecommerce-All Products catelogue_$dateTime"
            : "Failed",
        isSuccess
            ? "File Downloaded Successfully"
            : "File Download failed try again!",
        notificationDetails,
        payload: jsonMapPdf);
  }

  Future getHistoryConfirmOrder(BuildContext context) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL + 'api/get_current_order');
        final response = await http.get(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          print("hello");
          print(decoded);

          GetCurrentOrderHistory getCurrentOrderHistory =
              GetCurrentOrderHistory.fromJson(decoded);
          Provider.of<DataProvider>(context, listen: false)
              .getCurrentOrderProvider(getCurrentOrderHistory);
          // return getCurrentOrderHistoryFromJson(decoded);
          Fluttertoast.showToast(msg: "Fetch Order History");
          // String orderIdString = await storageKey.read(key: "orderId");
          // List<dynamic> listofitems = jsonDecode(orderIdString);
          // print(listofitems);s
          // print(data.response[orderIdForGlobal[0]][0].markDatetime);
          // print(orderIdForGlobal.length);

          return response;
        } else if (response.statusCode == 401) {
          getRefreshToken();
        } else {
          // Fluttertoast.showToast(msg: "${decoded['message']}");
        }
      } else {
        Fluttertoast.showToast(msg: "No Internet!!!");
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: "Error in confirmOrder : ${e.toString()}");
      debugPrint("Error in confirmOrder : ${e.toString()}");
    }
  }

  Future cancelConfirmOrder(BuildContext context, String productId) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(
            StringHelper.BASE_URL + 'api/cancel_order?order_id=$productId');
        final response = await http.get(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: "Canceled Order");
          getHistoryConfirmOrder(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavBar(),
              ));
          return response;
        } else if (response.statusCode == 401) {
          getRefreshToken();
        } else {
          // Fluttertoast.showToast(msg: "${decoded['message']}");
        }
      } else {
        Fluttertoast.showToast(msg: "No Internet!!!");
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: "Error in confirmOrder : ${e.toString()}");
      debugPrint("Error in confirmOrder : ${e.toString()}");
    }
  }

  Future getStockInProduct(BuildContext context) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL + "api/product_in_stock");
        final response = await http.get(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          MicroProduct stockInProductModel = MicroProduct.fromJson(decoded);

          Provider.of<DataProvider>(context, listen: false)
              .getMicroProduct(stockInProductModel);
          print("Decoded from stock in : $decoded");
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
      // Fluttertoast.showToast(msg: "${e.toString()}");
    }
  }

  Future getStockOutOfProduct(BuildContext context) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL + "api/product_out_of_stock");
        final response = await http.get(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          MicroProduct stockOutProductModel = MicroProduct.fromJson(decoded);

          Provider.of<DataProvider>(context, listen: false)
              .getMicroProduct(stockOutProductModel);
          print("Decoded from stock in : $decoded");
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
      // Fluttertoast.showToast(msg: "${e.toString()}");
    }
  }

  Future getTrendingProducts(BuildContext context) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL + "api/trending_products");
        final response = await http.get(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          MicroProduct trendingProductModel = MicroProduct.fromJson(decoded);

          Provider.of<DataProvider>(context, listen: false)
              .getMicroProduct(trendingProductModel);
          print("Decoded from stock in : $decoded");
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
      // Fluttertoast.showToast(msg: "${e.toString()}");
    }
  }

  Future registerAuth(
      String name,
      String email,
      String companyName,
      String address,
      String landmark,
      String pincode,
      int value,
      BuildContext context) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL + "api/profile");
        final response = await http.put(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        }, body: {
          'name': name,
          'email': email,
          'company_name': companyName,
          'address': address,
          'landmark': landmark,
          'pincode': pincode,
        });
        print(response.body);
        if (response.statusCode == 200) {
          var decoded = jsonDecode(response.body);
          print(decoded);
          Fluttertoast.showToast(msg: "Register successfully");
          if (value == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavBar(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SplashScreen(),
              ),
            );
          }
        }
      } else {
        Fluttertoast.showToast(msg: "No Internet");
      }
    } catch (e) {
      debugPrint("Error Is : $e");
      // Fluttertoast.showToast(msg: "Something went Wrong");
    }
  }

  Future profileImageUpload(
    BuildContext context,
    File image,
  ) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL + "api/pp");
        var headerList = {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        };
        final response = http.MultipartRequest("PUT", url);

        response.headers.addAll(headerList);
        var picFile = await http.MultipartFile.fromPath('pp', image.path);
        response.files.add(picFile);
        var res = await response.send();

        var responseData = await res.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        print(responseString);
        Fluttertoast.showToast(msg: "Image Upload Successfully");
      } else {
        Fluttertoast.showToast(msg: "No Internet");
      }
    } catch (e) {
      debugPrint("Error Is : $e");
      // Fluttertoast.showToast(msg: "Something went Wrong");
    }
  }

  Future registerAuthGet(BuildContext context) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL + "api/profile");
        final response = await http.get(
          url,
          headers: {
            "Accept": "Application/json",
            'Authorization': 'Bearer $aToken',
          },
        );
        print(response.body);
        if (response.statusCode == 200) {
          var decoded = jsonDecode(response.body);
          RegisterAuth registerAuth = RegisterAuth.fromJson(decoded);
          Provider.of<DataProvider>(context, listen: false)
              .getRegisterDetails(registerAuth);
          print(decoded);
          Fluttertoast.showToast(msg: "Register Get successfully");
          return response;
        }
      } else {
        Fluttertoast.showToast(msg: "No Internet");
      }
    } catch (e) {
      debugPrint("Error Is : $e");
      // Fluttertoast.showToast(msg: "Something went Wrong");
    }
  }

  Future getProfilePic(BuildContext context) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL + "api/pp");
        final response = await http.get(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          GetProfilePic getProfilePic = GetProfilePic.fromJson(decoded);

          Provider.of<DataProvider>(context, listen: false)
              .getProfilePicture(getProfilePic);

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
      // Fluttertoast.showToast(msg: "${e.toString()}");
    }
  }

  Future postFeedBack(BuildContext context, String textFeed) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL + "api/feedback");
        final response = await http.post(
          url,
          headers: {
            "Accept": "Application/json",
            'Authorization': 'Bearer $aToken',
          },
          body: {
            'feedback': textFeed,
          },
        );
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          feedbackId = decoded['feedback_id'];

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
      // Fluttertoast.showToast(msg: "${e.toString()}");
    }
  }

  Future postFeedbackImages(
      BuildContext context, String feedbackId, File imagesFeed) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL + "api/feedback_image");
        final response = http.MultipartRequest('PUT', url);
        var headerList = {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        };
        response.headers.addAll(headerList);
        var picFile = await http.MultipartFile.fromPath(
            'feedback_image', imagesFeed.path);
        response.headers.addAll(headerList);

        response.fields['feedback_id'] = feedbackId;
        response.files.add(picFile);
        var res = await response.send();

        var responseData = await res.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        print(responseString);

        // print("Multiple images : " + resBody.toString());

        // final response = await http.post(url, headers: {
        //   "Accept": "Application/json",
        //   'Authorization': 'Bearer $aToken',
        // },body: {
        //   'feedback_id' : feedbackId,
        //   'feedback_image' : imagesFeed
        // },);
        // var decoded = jsonDecode(response.body);
        // if (response.statusCode == 200) {
        //   Fluttertoast.showToast(msg: "Feedback submitted");
        //   return response;
        // } else if (response.statusCode == 401) {
        //   getRefreshToken();
        // } else {
        //   Fluttertoast.showToast(msg: "${decoded['message']}");
        // }

      } else {
        Fluttertoast.showToast(msg: "No Internet!!!");
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: "${e.toString()}");
    }
  }

  Future getFeedBackUser(BuildContext context) async {
    try {
      String aToken = await storageKey.read(key: 'access_token');
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(StringHelper.BASE_URL + "api/feedback");
        final response = await http.get(url, headers: {
          "Accept": "Application/json",
          'Authorization': 'Bearer $aToken',
        });
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          GetFeedBack getFeedBack = GetFeedBack.fromJson(decoded);

          Provider.of<DataProvider>(context, listen: false)
              .getFeedBackUserProvider(getFeedBack);

          Fluttertoast.showToast(msg: "Feedback get");

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
}
