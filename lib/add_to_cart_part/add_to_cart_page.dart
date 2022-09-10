import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:jalaram/Connect_API/api.dart';
import 'package:jalaram/Data_Provider/data_provider.dart';
import 'package:jalaram/Home/bottomnavbar.dart';
import 'package:jalaram/Model/fetch_cart_item_model.dart';
import 'package:collection/collection.dart';
import 'package:jalaram/Model/fetch_order_id.dart';
import 'package:jalaram/add_to_cart_part/confirm_order.dart';
import 'package:jalaram/product_catalogue/products.dart';
import 'package:provider/provider.dart';

class AddToCartPage extends StatefulWidget {
  const AddToCartPage({
    Key key,
  }) : super(key: key);

  @override
  _AddToCartPageState createState() => _AddToCartPageState();
}

class _AddToCartPageState extends State<AddToCartPage> {
  FetchAddToCartItem fMyCart;

  bool isLoading = false;

  var subPrice = [];
  var mrpPrice = [];

  List<MyCartStoreNumber> storeNumber = [];

  List<MyTotalInstantPriceMrp> storeMrpPriceBoth = [];

  num storePayAmount = 0;
  num storeDiscount = 0;
  num storeMrpValue = 0;
  num storeTotalPriceChangeable = 0;

  num sum = 0;
  num mrpSum = 0;

  int storeTotalItem = 0;
  int dummyVariable = 0;

  double discountProduct = 0;

  FetchOrderId foi;

  fetchOrderId() async {
    await Future.delayed(Duration(milliseconds: 300), () async {
      Response response = await ApiServices().confirmOrder(context);
      var decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        foi = FetchOrderId.fromJson(decoded);
        print(foi.orderId);
        orderId = foi.orderId;

        setState(() {
          orderId = foi.orderId;
          isLoading = true;
        });
      }
    });
  }

  fetchPriceWithProvider() async {
    List.generate(fMyCart.cart.length, (index) {
      subPrice.add(fMyCart.cart[index].product.price *
          fMyCart.cart[index].count);

      mrpPrice
          .add(fMyCart.cart[index].product.mrp * fMyCart.cart[index].count);
    });
    for (num e in subPrice) {
      sum += e;
    }
    for (num e in mrpPrice) {
      mrpSum += e;
    }
    storePayAmount = sum.toDouble();
    discountProduct = mrpSum.toDouble() - sum.toDouble();


    storeMrpValue = mrpSum.toDouble();
    storeDiscount = discountProduct.toDouble();
  }

  fetchAddToCartItem() async {
    // await Future.delayed(Duration(milliseconds: 500), () async {
    Response response = await ApiServices().fetchAddToCartItem(context);
    var decoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      fMyCart = FetchAddToCartItem.fromJson(decoded);
      Fluttertoast.showToast(msg: "Fetch Add to Cart");

      setState(() {
        storeTotalItem = fMyCart.cart.length;
      });


      storeMrpPriceBoth = List.generate(fMyCart.cart.length, (index) {
        return MyTotalInstantPriceMrp(
            price: fMyCart.cart[index].product.price.toInt() *
                fMyCart.cart[index].count.toInt(),
            mrpPrice: fMyCart.cart[index].product.mrp.toInt() *
                fMyCart.cart[index].count.toInt());
      });

      storeNumber = List.generate(fMyCart.cart.length, (index) {
        return MyCartStoreNumber(number: fMyCart.cart[index].count);
      });

      fetchPriceWithProvider();

      setState(() {

        isLoading = true;
      });
    }
    // });
  }

  Timer timer;

  String orderId = "";

  @override
  void initState() {
    fetchAddToCartItem();
    fetchPriceWithProvider();
    // timer = Timer(Duration(seconds: 5), ()=>fetchAddToCartItem());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "My Cart",
                    style: GoogleFonts.aBeeZee(
                        color: Color.fromRGBO(255, 78, 91, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 2),
                  ),
                ],
              ),
            ),
            Divider(
              height: 15,
              thickness: 1.1,
            ),
            isLoading == false
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : fMyCart.cart.isEmpty
                    ? Column(
                        children: [
                          SizedBox(
                            height: 80,
                          ),
                          Image.asset(
                            "assets/pendingorderimage.jpg",
                            height: 250,
                            width: 300,
                            fit: BoxFit.fill,
                          ),
                          Center(
                              child: Text(
                            "Your cart is empty!",
                            style: GoogleFonts.aBeeZee(
                                color: Colors.grey, letterSpacing: 1),
                          )),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 23, right: 23),
                            child: Center(
                                child: Text(
                              '''Looks like you haven't added anything to your cart yet''',
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
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Container(
                                height: 50,
                                child: RaisedButton(
                                  color: Color.fromRGBO(255, 78, 91, 1),
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => Products(),
                                    //     ));
                                  },
                                  child: Text(
                                    "Shop Now",
                                    style: GoogleFonts.dmSans(
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ),
                        ],
                      )
                    : Expanded(
                        child: Column(
                          children: [
                            Container(
                              height: fMyCart.cart.length == 2
                                  ? MediaQuery.of(context).size.height / 3.5
                                  : fMyCart.cart.length == 1
                                      ? MediaQuery.of(context).size.height / 8
                                      : MediaQuery.of(context).size.height /
                                          2.28,
                              child: ListView.builder(
                                itemCount: fMyCart.cart.length,
                                shrinkWrap: true,
                                physics: fMyCart.cart.length == 3 ||
                                        fMyCart.cart.length == 1 ||
                                        fMyCart.cart.length == 2
                                    ? NeverScrollableScrollPhysics()
                                    : AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    9,
                                                child: Image.network(
                                                  "${fMyCart.urls.image + '/' + fMyCart.cart[index].product.banner.media}",
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 0.8),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                    "${fMyCart.cart[index].product.title}",
                                                    style: GoogleFonts.dmSans(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 1.5,
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                                Row(
                                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${fMyCart.cart[index].product.category}",
                                                      style: GoogleFonts.dmSans(
                                                          letterSpacing: 1.5,
                                                          // fontWeight: FontWeight.bold,
                                                          fontSize: 12,
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 7,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          GestureDetector(
                                                              onTap: () async {
                                                                await ApiServices().decrementProducts(
                                                                    fMyCart
                                                                        .cart[
                                                                            index]
                                                                        .product
                                                                        .productId,
                                                                    1,
                                                                    context);

                                                                // fetchAddToCartItem();
                                                                setState(() {});

                                                                storePayAmount = (storePayAmount -
                                                                    (fMyCart
                                                                        .cart[
                                                                            index]
                                                                        .product
                                                                        .price
                                                                        .toInt()));
                                                                storeMrpValue =
                                                                    (storeMrpValue -
                                                                        fMyCart
                                                                            .cart[index]
                                                                            .product
                                                                            .mrp);

                                                                debugPrint(
                                                                    storeTotalPriceChangeable
                                                                        .toString());
                                                                storeDiscount = (storeDiscount -
                                                                    (fMyCart
                                                                            .cart[
                                                                                index]
                                                                            .product
                                                                            .mrp -
                                                                        fMyCart
                                                                            .cart[index]
                                                                            .product
                                                                            .price));

                                                                storeNumber[
                                                                        index]
                                                                    .number--;

                                                                ApiServices()
                                                                    .fetchAddToCartItem(
                                                                        context);
                                                              },
                                                              child: Icon(
                                                                Icons.remove,
                                                                size: 20,
                                                              )),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "${storeNumber[index].number}",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          GestureDetector(
                                                              onTap: () async {
                                                                await ApiServices().incrementProducts(
                                                                    fMyCart
                                                                        .cart[
                                                                            index]
                                                                        .product
                                                                        .productId,
                                                                    1);
                                                                ApiServices()
                                                                    .fetchAddToCartItem(
                                                                        context);
                                                                // fetchAddToCartItem();
                                                                setState(() {});
                                                                storePayAmount = (storePayAmount +
                                                                    (fMyCart
                                                                        .cart[
                                                                            index]
                                                                        .product
                                                                        .price));
                                                                storeMrpValue =
                                                                    (storeMrpValue +
                                                                        fMyCart
                                                                            .cart[index]
                                                                            .product
                                                                            .mrp);
                                                                storeDiscount = (storeDiscount +
                                                                    (fMyCart
                                                                            .cart[
                                                                                index]
                                                                            .product
                                                                            .mrp -
                                                                        fMyCart
                                                                            .cart[index]
                                                                            .product
                                                                            .price));
                                                                storeNumber[
                                                                        index]
                                                                    .number++;
                                                                // await ApiServices().fetchAddToCartItem(context);
                                                                // fetchAddToCartItem();
                                                                setState(() {

                                                                });
                                                              },
                                                              child: Icon(
                                                                Icons.add,
                                                                size: 20,
                                                              )),
                                                          SizedBox(
                                                            width: 3,
                                                          ),
                                                        ],
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3),
                                                        color: Colors
                                                            .grey.shade200,
                                                      ),
                                                      width: 85,
                                                      height: 25,
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    InkWell(
                                                      child: fMyCart.cart[index].product.inFavorits == true
                                                          ? Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                      )
                                                          : Icon(
                                                        Icons.favorite_border,
                                                        color: Colors.black,
                                                      ),
                                                      onTap: () async {
                                                        setState(() {
                                                          if (fMyCart.cart[index].product.inFavorits ==
                                                              false) {
                                                            fMyCart.cart[index].product.inFavorits = true;
                                                          } else {
                                                            fMyCart.cart[index].product.inFavorits = false;
                                                          }
                                                        });
                                                        ApiServices().addAndDeleteToFavourite(
                                                            fMyCart.cart[index].product.productId);
                                                      },
                                                    ),
                                                    // Spacer(),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    InkWell(
                                                      child: Icon(
                                                        Icons.delete,
                                                        size: 22,
                                                      ),
                                                      onTap: () async {
                                                        await ApiServices()
                                                            .deleteAddToCartItem(
                                                                context,
                                                                fMyCart
                                                                    .cart[index]
                                                                    .product
                                                                    .productId);
                                                        setState(() {
                                                          // storePayAmount = 0;
                                                          storeMrpValue = storeMrpValue - (fMyCart.cart[index].count * fMyCart.cart[index].product.mrp);
                                                          storePayAmount = storePayAmount-(fMyCart.cart[index].count*fMyCart.cart[index].product.price);
                                                          storeDiscount = storeMrpValue - storePayAmount;

                                                          subPrice = null;
                                                          mrpPrice = null;
                                                          fetchAddToCartItem();


                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Rs. ${Provider.of<DataProvider>(context).fetchAddToCartItem.cart[index].count.toInt() * Provider.of<DataProvider>(context).fetchAddToCartItem.cart[index].product.price.toInt()}",
                                                      // "Rs. ${subPrice[index].toString()}", //subPrice[index].toString(),
                                                      style: GoogleFonts.dmSans(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black87,
                                                          letterSpacing: 0.5,
                                                          fontSize: 13),
                                                    ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Rs.",
                                                          style: GoogleFonts
                                                              .dmSans(
                                                                  letterSpacing:
                                                                      0.5,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 13),
                                                        ),
                                                        Text(
                                                          "${Provider.of<DataProvider>(context).fetchAddToCartItem.cart[index].count.toInt() * Provider.of<DataProvider>(context).fetchAddToCartItem.cart[index].product.mrp.toInt()}",
                                                          style: GoogleFonts.dmSans(
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 13),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text(
                                                      "${fMyCart.cart[index].product.discountPercentage.toInt().toString()}% OFF",
                                                      style: GoogleFonts.dmSans(
                                                          color:
                                                              Colors.green[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.45,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                9,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Divider(
                              thickness: 6,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 7, right: 7, bottom: 7, top: 7),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Price Breakup",
                                  style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5),
                                ),
                              ),
                            ),
                            Divider(),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 7, right: 7, bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "MRP($storeTotalItem item) ",
                                    style: GoogleFonts.dmSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1.5),
                                  ),
                                  Text(
                                    "${storeMrpValue.toInt().toString()}",
                                    style: GoogleFonts.dmSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 7, right: 7, bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Discount",
                                    style: GoogleFonts.dmSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                        color: Colors.green[700]),
                                  ),
                                  Text(
                                    "${storeDiscount.toInt().toString()}",
                                    style: GoogleFonts.dmSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.green[700]),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 7, right: 7),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Payable Amount",
                                    style: GoogleFonts.dmSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5),
                                  ),
                                  Text(
                                    "${storePayAmount.toInt().toString()}",
                                    style: GoogleFonts.dmSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await ApiServices().confirmOrder(context);

                                setState(() {});
                              },
                              child: Container(
                                height: 45,
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Text(
                                  "Confirm Order",
                                  style: GoogleFonts.dmSans(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 8,
            ),
          ],
        ),
      ),
      // floatingActionButton: Container(
      //   height: 70,
      //   width: MediaQuery.of(context).size.width/1.08,
      //   decoration: BoxDecoration(
      //     // color: Color.fromRGBO(255, 78, 91, 1),
      //     borderRadius: BorderRadius.circular(10),
      //   ),
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Container(
      //           alignment: Alignment.center,
      //           decoration: BoxDecoration(
      //             color: Colors.white12,
      //             borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10)),
      //           ),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Text("Rs.$sum",
      //                   style: GoogleFonts.dmSans(
      //                       color: Colors.black,
      //                       fontWeight: FontWeight.bold,
      //                       letterSpacing: 1.4,
      //                       fontSize: 18)),
      //               Text("View Price Breakup",
      //                   style: GoogleFonts.dmSans(
      //                       color: Color.fromRGBO(255, 78, 91, 1),
      //                       fontWeight: FontWeight.bold,
      //                       letterSpacing: 1.4,
      //                       fontSize: 14)),
      //             ],
      //           ),
      //         ),
      //         Container(
      //           alignment: Alignment.center,
      //           width: MediaQuery.of(context).size.width/2.15,
      //           height: 70,
      //           decoration: BoxDecoration(
      //             color: Color.fromRGBO(255, 78, 91, 1),
      //             borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10)),
      //           ),
      //           child: Text(
      //             "Place Order",
      //             style: GoogleFonts.dmSans(
      //                 color: Colors.white,
      //                 fontWeight: FontWeight.bold,
      //                 letterSpacing: 1.4,
      //                 fontSize: 18),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      //
      // ),
    );
  }
}

class MyCartStoreNumber {
  int number;

  MyCartStoreNumber({this.number});
}

class MyTotalInstantPriceMrp {
  int price;
  int mrpPrice;

  MyTotalInstantPriceMrp({this.price, this.mrpPrice});
}
