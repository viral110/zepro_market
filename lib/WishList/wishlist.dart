import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:jalaram/Connect_API/api.dart';

import 'package:jalaram/Model/get_wishlist_products.dart';
import 'package:jalaram/Splash_Screen/internet_connection_page.dart';
import 'package:jalaram/component/back_button.dart';
import 'package:jalaram/product_catalogue/products.dart';

import '../Home/bottomnavbar.dart';
import '../product_catalogue/productdetails.dart';

class WishList extends StatefulWidget {
  const WishList({Key key}) : super(key: key);

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  GetWishListProducts gwp;

  bool isGetFavourite = false;
  bool addButtonPressed = false;

  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

  List<StoreNumberCart> counterWishList = [];

  StreamSubscription internetConnection;
  bool isOffline = false;

  List productCartoon = [];
  List productName = [];
  List productCategory = [];
  List productStock = [];
  List productImage = [];

  Map<String, dynamic> mapStoreData = {};

  @override
  void initState() {
    checkInternetFunc();
    getFavouriteProducts();
    super.initState();
  }

  int total;

  checkInternetFunc() {
    internetConnection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isOffline = true;
        });
      } else if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          isOffline = false;

        });
      }
    });
  }

  getFavouriteProducts() async {
    await Future.delayed(Duration(milliseconds: 300), () async {
      final response = await ApiServices().getWishListProducts(context);
      var decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        gwp = GetWishListProducts.fromJson(decoded);
        total = gwp.response.length;
        print("total : $total");
        counterWishList = List.generate(
          gwp.response.length,
          (index) {
            productName.add(gwp.response[index].title);
            productCartoon.add(gwp.response[index].cartoon);
            productCategory.add(gwp.response[index].category);
            productStock.add(gwp.response[index].stock);
            productImage.add(gwp.response[index].banner.media);
            return StoreNumberCart(
                number: gwp.response[index].inCart,
                isVisible: gwp.response[index].cartStatus);
          },
        );

        // Fluttertoast.showToast(msg: "wishlist products");
        setState(() {
          isGetFavourite = true;
        });
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isOffline
            ? Center(child: Text("No Internet"),)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 12, bottom: 2),
                    child: Row(
                      children: [
                        // GestureDetector(
                        //     onTap: () {
                        //       Navigator.of(context).pop(context);
                        //     },
                        //     child: Icon(
                        //       Icons.arrow_back_ios,
                        //       color: Color.fromRGBO(255, 78, 91, 1),
                        //     )),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          "Wishlist",
                          style: GoogleFonts.aBeeZee(
                              color: Color.fromRGBO(255, 78, 91, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 2),
                        ),
                      ],
                    ),
                  ),
                  isGetFavourite != false && gwp != null
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: 2, left: 15, bottom: 3),
                          child: Text(
                            "${gwp.response.length} items",
                            style: GoogleFonts.dmSans(
                                fontSize: 15,
                                letterSpacing: 1,
                                color: Colors.black54),
                          ),
                        )
                      : Container(),
                  Divider(
                    height: 15,
                    thickness: 1.1,
                  ),
                  isGetFavourite == false
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                gwp.response != null && gwp.response.isNotEmpty
                                    ? Expanded(
                                        flex: 0,
                                        child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: gwp.response.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 6,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              4,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              9,
                                                          child: Image.network(
                                                            "${gwp.urls.image}/${gwp.response[index].banner.media}",
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    Colors.grey,
                                                                width: 0.8),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 7,
                                                    ),
                                                    Flexible(
                                                      child: GestureDetector(
                                                        child: Container(
                                                          child: Stack(
                                                            children: [
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  gwp.response[index].title
                                                                              .length >
                                                                          30
                                                                      ? RichText(
                                                                          text:
                                                                              TextSpan(
                                                                            children: [
                                                                              TextSpan(
                                                                                text: '${gwp.response[index].title.toUpperCase()}'.substring(0, 30),
                                                                                style: GoogleFonts.dmSans(
                                                                                  fontSize: 13,
                                                                                  color: Colors.black,
                                                                                  letterSpacing: 1.3,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                              ),
                                                                              TextSpan(
                                                                                text: '...',
                                                                                style: GoogleFonts.dmSans(
                                                                                  fontSize: 13,
                                                                                  color: Colors.black,
                                                                                  letterSpacing: 1,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      : Text(
                                                                          "${gwp.response[index].title.toUpperCase()}",
                                                                          style: GoogleFonts.dmSans(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 13,
                                                                              color: Colors.black,
                                                                              letterSpacing: 1.5),
                                                                        ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                5),
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          "${gwp.response[index].category}",
                                                                          style: GoogleFonts.dmSans(

                                                                              // fontWeight: FontWeight.bold,
                                                                              fontSize: 12,
                                                                              color: Colors.grey),
                                                                        ),
                                                                        Spacer(),
                                                                        // gwp.response[index].stock <=
                                                                        //         counterWishList[index]
                                                                        //             .number
                                                                        //     ? Text(
                                                                        //         "Out of Stock",
                                                                        //         style:
                                                                        //             GoogleFonts.dmSans(color: Colors.red),
                                                                        //       )
                                                                        //     : counterWishList[index]
                                                                        //             .isVisible
                                                                        //         ? Container(
                                                                        //             child: Row(
                                                                        //               children: [
                                                                        //                 GestureDetector(
                                                                        //                     onTap: () async {
                                                                        //                       await ApiServices().decrementProducts(gwp.response[index].productId, 1, context);
                                                                        //                       setState(() {
                                                                        //                         ApiServices().getWishListProducts(context);
                                                                        //                       });
                                                                        //                       if (counterWishList[index].number < 2) {
                                                                        //                         counterWishList[index].isVisible = !counterWishList[index].isVisible;
                                                                        //                       } else {
                                                                        //                         counterWishList[index].number--;
                                                                        //                       }
                                                                        //                       debugPrint("Decrement che : ${counterWishList[index].number}");
                                                                        //                       // Fluttertoast.showToast(msg: "Product Decrement : ${dataIncrement[index].counter--}");
                                                                        //                     },
                                                                        //                     child: Icon(
                                                                        //                       Icons.remove,
                                                                        //                       size: 20,
                                                                        //                     )),
                                                                        //                 SizedBox(
                                                                        //                   width: 5,
                                                                        //                 ),
                                                                        //                 Text(
                                                                        //                   "${counterWishList[index].number.toString()}",
                                                                        //                   style: TextStyle(fontWeight: FontWeight.bold),
                                                                        //                 ),
                                                                        //                 SizedBox(
                                                                        //                   width: 5,
                                                                        //                 ),
                                                                        //                 GestureDetector(
                                                                        //                     onTap: () {
                                                                        //                       setState(() {
                                                                        //                         counterWishList[index].number++;
                                                                        //                         ApiServices().incrementProducts(gwp.response[index].productId, counterWishList[index].number);
                                                                        //                       });
                                                                        //                       ApiServices().getWishListProducts(context);
                                                                        //                       debugPrint("Increment che : ${counterWishList[index].number}");
                                                                        //                     },
                                                                        //                     child: Icon(
                                                                        //                       Icons.add,
                                                                        //                       size: 20,
                                                                        //                     )),
                                                                        //                 SizedBox(
                                                                        //                   width: 3,
                                                                        //                 ),
                                                                        //               ],
                                                                        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        //             ),
                                                                        //             decoration: BoxDecoration(
                                                                        //               borderRadius: BorderRadius.circular(2),
                                                                        //               border: Border.all(color: Color.fromRGBO(22, 2, 105, 1)),
                                                                        //             ),
                                                                        //             width: 80,
                                                                        //           )
                                                                        //         : Container(
                                                                        //             width: 80,
                                                                        //             decoration: BoxDecoration(
                                                                        //               borderRadius: BorderRadius.circular(2),
                                                                        //               border: Border.all(color: Color.fromRGBO(22, 2, 105, 1)),
                                                                        //             ),
                                                                        //             child: InkWell(
                                                                        //               child: Text(
                                                                        //                 "ADD",
                                                                        //                 style: TextStyle(fontWeight: FontWeight.bold),
                                                                        //               ),
                                                                        //               onTap: () {
                                                                        //                 setState(() {
                                                                        //                   counterWishList[index].number = 1;
                                                                        //                   ApiServices().incrementProducts(gwp.response[index].productId, counterWishList[index].number);
                                                                        //                   addButtonPressed = true;
                                                                        //                   ApiServices().getWishListProducts(context);
                                                                        //                   counterWishList[index].isVisible = !counterWishList[index].isVisible;
                                                                        //                 });
                                                                        //               },
                                                                        //             ),
                                                                        //             height: 22,
                                                                        //             alignment: Alignment.center,
                                                                        //           ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        "${gwp.response[index].cartoon.toInt().toString()}/Cartoon | ${gwp.response[index].stock.toString()} Stock",
                                                                        style: GoogleFonts
                                                                            .dmSans(
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                      Spacer(),
                                                                      gwp.response[index].stock <=
                                                                              0
                                                                          ? Padding(
                                                                              padding: const EdgeInsets.only(right: 8),
                                                                              child: Text(
                                                                                "Out of Stock",
                                                                                style: GoogleFonts.dmSans(color: Colors.red),
                                                                              ),
                                                                            )
                                                                          : Container(),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Image
                                                                              .asset(
                                                                            "assets/rupee.png",
                                                                            width:
                                                                                10,
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          (gwp.response[index].price % 1) == 0
                                                                              ? Text(
                                                                                  "${gwp.response[index].price.toInt().toString()}",
                                                                                  style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 13),
                                                                                )
                                                                              : Text(
                                                                                  "${gwp.response[index].price}",
                                                                                  style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 13),
                                                                                ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Image
                                                                              .asset(
                                                                            "assets/rupee.png",
                                                                            width:
                                                                                10,
                                                                            height:
                                                                                10,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                          Text(
                                                                            "${gwp.response[index].mrp.toInt().toString()}",
                                                                            style: GoogleFonts.dmSans(
                                                                                decoration: TextDecoration.lineThrough,
                                                                                color: Colors.grey,
                                                                                fontSize: 13),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            4,
                                                                      ),
                                                                      Text(
                                                                        "${gwp.response[index].discountPercentage.toInt().toString()}% OFF",
                                                                        style: GoogleFonts.dmSans(
                                                                            color:
                                                                                Colors.green[700],
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 13),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        "HSN Code : ${gwp.response[index].hsn == null ? '0' : gwp.response[index].hsn}-${gwp.response[index].gst == null ? '0' : gwp.response[index].gst}%",
                                                                        style: GoogleFonts.dmSans(
                                                                            color: Colors
                                                                                .grey,
                                                                            fontSize:
                                                                                13,
                                                                            letterSpacing:
                                                                                1),
                                                                      ),
                                                                      Spacer(),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(right: 20),
                                                                        child:
                                                                            InkWell(
                                                                          child:
                                                                              Icon(
                                                                            Icons.favorite,
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          onTap:
                                                                              () async {
                                                                            showDilogE(
                                                                                context: context,
                                                                                index: index);
                                                                            // gwp = null;
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                ],
                                                              ),
                                                              Positioned(
                                                                child:
                                                                    Container(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height /
                                                                      8,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height /
                                                                      8,
                                                                  child: Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      // Text(
                                                                      //   "Out of stock",
                                                                      //   style: GoogleFonts.aBeeZee(
                                                                      //       fontSize: 11, color: Colors.red,fontWeight: FontWeight.bold),
                                                                      // ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                left: 150,
                                                                top: 40,
                                                              ),
                                                            ],
                                                          ),
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                        ),
                                                        onTap: () {
                                                          String productId = gwp
                                                              .response[index]
                                                              .productId;
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProductDetails(
                                                              productId: gwp
                                                                  .response[
                                                                      index]
                                                                  .productId,
                                                            ),
                                                          ));
                                                          ApiServices()
                                                              .microProductDetails(
                                                                  productId,
                                                                  context);
                                                        },
                                                      ),
                                                      flex: 1,
                                                      fit: FlexFit.loose,
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  thickness: 0.5,
                                                  color: Colors.grey,
                                                  indent: 10,
                                                  endIndent: 5,
                                                ),
                                                if (gwp.response.length ==
                                                    index + 1)
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            6.5,
                                                  ),
                                              ],
                                            );
                                          },
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          SizedBox(
                                            height: 80,
                                          ),
                                          Image.asset(
                                            "assets/wishlistimage.jpg",
                                            height: 250,
                                            width: 250,
                                          ),
                                          Center(
                                              child: Text(
                                            "Your wishlist is empty",
                                            style: GoogleFonts.aBeeZee(
                                                color: Colors.grey,
                                                letterSpacing: 1),
                                          )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 23, right: 23),
                                            child: Center(
                                                child: Text(
                                              '''Click ❤ to save items that you like in your wish list, you can review this items any time and can easily buy them''',
                                              style: GoogleFonts.aBeeZee(
                                                color: Colors.grey,
                                                letterSpacing: 1,
                                              ),
                                              textAlign: TextAlign.center,
                                            )),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Container(
                                                height: 50,
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                    Color.fromRGBO(
                                                        255, 78, 91, 1),
                                                  )),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              BottomNavBar(
                                                                  index: 2),
                                                        ));
                                                  },
                                                  child: Text(
                                                    "View Product",
                                                    style: GoogleFonts.dmSans(
                                                        color: Colors.white,
                                                        letterSpacing: 1.5,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
      ),
    );
  }

  showDilogE({BuildContext context, int index}) {
    return showDialog(
      context: context,
      builder: (context) => Container(
        width: MediaQuery.of(context).size.width / 1.2,
        child: AlertDialog(
          insetPadding: EdgeInsets.all(10),
          contentPadding: EdgeInsets.zero,
          title: Text(
            "Are you sure you want remove this items?",
            style: GoogleFonts.aBeeZee(fontSize: 14),
          ),
          actions: [
            Container(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
                child: Text(
                  "Cancel",
                  style:
                      GoogleFonts.dmSans(color: Color.fromRGBO(255, 78, 91, 1)),
                ),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(255, 78, 91, 1), width: 1.5),
                borderRadius: BorderRadius.circular(5),
              ),
              height: 40,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                  Color.fromRGBO(255, 78, 91, 1),
                )),
                onPressed: () async {
                  await ApiServices()
                      .addAndDeleteToFavourite(gwp.response[index].productId);

                  setState(() {});
                  getFavouriteProducts();
                  await ApiServices().getWishListProducts(context);
                  Navigator.pop(context);
                },
                child: Text(
                  "Remove",
                  style: GoogleFonts.dmSans(color: Colors.white),
                ),
              ),
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

class StoreNumberCart {
  int number;
  bool isVisible;
  StoreNumberCart({this.number, this.isVisible});
}
