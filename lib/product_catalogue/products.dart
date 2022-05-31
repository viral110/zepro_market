import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:jalaram/Connect_API/api.dart';
import 'package:jalaram/Data_Provider/data_provider.dart';
import 'package:jalaram/Model/favourite_with_id.dart';
import 'package:jalaram/Model/home_cart_category_model.dart';
import 'package:jalaram/Model/micro_product.dart';
import 'package:jalaram/Model/price_counter_model.dart';
import 'package:jalaram/product_catalogue/productdetails.dart';
import 'package:provider/provider.dart';

// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// ignore: must_be_immutable



List<IncrementNumber> dataIncrement = [];


class Products extends StatefulWidget {
  int number;
  String priceFilter;
  Products({this.number, this.priceFilter});
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  // var _valueOfBoolean = [];

  int _selectedCount = -1;

  MicroProduct mp;

  PriceCounterModel pcm;

  // final pdf = pw.Document();

  // List<bool> addBooleanVariable = [];

  Icon customIcon = Icon(Icons.search);
  Widget customSearchBar = Text(
    "All Products",
    style: GoogleFonts.aBeeZee(
        color: Color.fromRGBO(22, 2, 105, 1), fontWeight: FontWeight.bold),
  );

  // Timer timer;


  @override
  void initState() {
    widget.number == 0 ? fetchPriceCounterProducts() : fetchMicroProducts();
    fetchMicroProducts();
    fetchPriceCounterProducts();
    // timer = Timer.periodic(Duration(microseconds: 100), (Timer t) => fetchMicroProducts());
    super.initState();
    fetchCategory();
    ApiServices().microProducts(context);
  }

  List<int> addNumber = [];


  final storePrice = [];


  num sum = 0;


  num storePayAmount = 0;


  bool isLoading = false;
  bool isLoadingPriceStore = false;

  fetchMicroProducts() async {
    // await Future.delayed(Duration(milliseconds: 500), () async {
      Response response = await ApiServices().microProducts(context);
      var decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        mp = MicroProduct.fromJson(decoded);
        debugPrint("MP : ${mp.status}");
        dataIncrement = List.generate(mp.response.length, (index) {
          // storePrice.add(mp.response[index].price * mp.response[index].inCart);

          return IncrementNumber(

              productName: mp.response[index].title,
              counter: mp.response[index].inCart,
              isVisible: mp.response[index].cartStatus,
            priceTotal: mp.response[index].price.toInt() * mp.response[index].inCart.toDouble(),);

        });


        setState(() {

          isLoading = true;
        });
      }
    // });
  }

  List<String> storeIndexResponse = [];

  int numberProduct = 0;

  fetchPriceCounterProducts() async {
    // await Future.delayed(Duration(milliseconds: 500), () async {
      Response response =
          await ApiServices().getProductCounter(widget.priceFilter, context);
      var decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        mp = MicroProduct.fromJson(decoded);
        debugPrint("MP : ${mp.status}");
        numberProduct = mp.response.length;
        dataIncrement = List.generate(mp.response.length, (index) {
          storeIndexResponse.add(index.toString());
          return IncrementNumber(
              productName: mp.response[index].title,
              counter: mp.response[index].inCart,
              isVisible: mp.response[index].cartStatus);
        });
        setState(() {
          isLoadingPriceStore = true;
        });
      }
    // });
  }

  HomeCartCategory hcc;

  fetchCategory() async {
    // await Future.delayed(Duration(milliseconds: 100), () async {
      Response response = await ApiServices().getHomeCategory(context);
      var decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        hcc = HomeCartCategory.fromJson(decoded);
        setState(() {
          isLoading = true;
        });
      }
    // });
  }

  void _showPopupMenu() async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(800, 80, 0, 100),
      items: [
        PopupMenuItem(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.search,
                color: Color.fromRGBO(22, 2, 105, 1),
              ),
              Text("Search",
                  style: GoogleFonts.openSans(
                      color: Color.fromRGBO(22, 2, 105, 1))),
            ],
          ),
          value: 1,
          onTap: () {
            // Navigator.pop(context);
            setState(() {
              if (this.customIcon.icon == Icons.search) {
                customSearchBar = Container(
                  // decoration: BoxDecoration(
                  //   border: Border(bottom: BorderSide(color: Colors.green)),
                  // ),
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5), width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5), width: 2),
                        ),
                        hintText: "Search your daily product",
                        hintStyle: GoogleFonts.aBeeZee(
                            color: Colors.grey.shade500, fontSize: 13),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          onPressed: () {
                            setState(() {
                              customSearchBar = Text(
                                "All Products",
                                style: GoogleFonts.aBeeZee(
                                    color: Color.fromRGBO(22, 2, 105, 1),
                                    fontWeight: FontWeight.bold),
                              );
                            });
                          },
                        )),
                  ),
                );
              }
              // else{
              //   this.customSearchBar = Text("All Products",style: GoogleFonts.openSans(color: Color.fromRGBO(22, 2, 105, 1)),);
              // }
            });
          },
        ),
        PopupMenuItem(
          child: InkWell(
            onTap: () {
              debugPrint("Button Pressed");
              setState(() {
                // createPdf();
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.download,
                  color: Color.fromRGBO(22, 2, 105, 1),
                ),
                Text("Download",
                    style: GoogleFonts.openSans(
                        color: Color.fromRGBO(22, 2, 105, 1))),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.filter_list,
                color: Color.fromRGBO(22, 2, 105, 1),
              ),
              Text("Filter",
                  style: GoogleFonts.openSans(
                      color: Color.fromRGBO(22, 2, 105, 1))),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    );
  }

  // List<AddFavoriteWithId> changeInFavourite = [];





  int n = -1;

  String productId;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(22, 2, 105, 1),
        ),

        title: customSearchBar,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              color: Color.fromRGBO(22, 2, 105, 1),
              onPressed: () {
                _showPopupMenu();
              },
              icon: Icon(Icons.more_vert),
            ),
          ),
        ],
        // bottom: PreferredSize(
        //     child: Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(7),
        //           color: Colors.white,
        //         ),
        //         child: TextFormField(
        //           style: GoogleFonts.aBeeZee(),
        //           decoration: InputDecoration(
        //             hintStyle: TextStyle(color: Colors.blue[900]),
        //             border: OutlineInputBorder(
        //               borderSide: BorderSide(
        //                 color: Colors.white,
        //               ),
        //               borderRadius: BorderRadius.circular(5),
        //             ),
        //             contentPadding: EdgeInsets.all(10),
        //             hintText: 'Search for something',
        //
        //
        //             prefixIcon: Icon(Icons.search,color: Colors.blue[900],),
        //           ),
        //         ),
        //       ),
        //     ),
        //     preferredSize: Size(MediaQuery.of(context).size.width, 60)),
      ),
      backgroundColor: Colors.white,
      body: isLoading == false && isLoadingPriceStore == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                Expanded(
                  flex: 0,
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 10,
                    child: ListView.builder(
                      itemCount: hcc == null ?0 : hcc.catList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    hcc.catList[index].image,
                                  ),

                                  // child: Image.network(
                                  //   hcc.catList[index].image,
                                  //   fit: BoxFit.cover,
                                  //   height: 30,
                                  //
                                  // ),
                                  backgroundColor: Colors.white,
                                  radius: 25,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              " ${hcc.catList[index].name}",
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 13.4, color: Colors.black),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                isLoading == true || isLoadingPriceStore == true
                    ? Expanded(
                        flex: 12,
                        // height: MediaQuery.of(context).size.height / 1.05,
                        child: Container(
                          child: ListView.builder(
                            itemCount: mp == null ? 0 :mp.response.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              // String storeLastResponse = mp.response[index].productId;

                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // SizedBox(
                                          //   height: 10,
                                          // ),
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
                                              "${mp.urls.image}/${mp.response[index].banner.media}",
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 0.8),
                                              borderRadius:
                                                  BorderRadius.circular(6),
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
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    mp.response[index].title
                                                                .length >
                                                            30
                                                        ? Text(
                                                            "${mp.response[index].title.toUpperCase()}...",
                                                            style: GoogleFonts.dmSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    1.5,
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .black),
                                                          )
                                                        : Text(
                                                            "${mp.response[index].title.toUpperCase()}",
                                                            style: GoogleFonts.dmSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    1.5,
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "${mp.response[index].category}",
                                                          style: GoogleFonts
                                                              .dmSans(
                                                                  letterSpacing:
                                                                      1.5,
                                                                  // fontWeight: FontWeight.bold,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                        Spacer(),
                                                        dataIncrement[index]
                                                                .isVisible
                                                            ? Container(
                                                                child: Row(
                                                                  children: [
                                                                    GestureDetector(
                                                                        onTap:
                                                                            () async {
                                                                          await ApiServices().decrementProducts(
                                                                              mp.response[index].productId,
                                                                              1,
                                                                              context);
                                                                          setState(
                                                                              () {
                                                                            ApiServices().microProducts(context);
                                                                          });
                                                                          if (dataIncrement[index].counter <
                                                                              2) {
                                                                            dataIncrement[index].isVisible =
                                                                                !dataIncrement[index].isVisible;
                                                                          } else {
                                                                            dataIncrement[index].counter--;
                                                                          }
                                                                          debugPrint(
                                                                              "Decrement che : ${dataIncrement[index].counter}");
                                                                          fetchMicroProducts();
                                                                          // Fluttertoast.showToast(msg: "Product Decrement : ${dataIncrement[index].counter--}");
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .remove,
                                                                          size:
                                                                              20,
                                                                        )),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      "${dataIncrement[index].counter.toString()}",
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            dataIncrement[index].counter++;
                                                                            ApiServices().incrementProducts(mp.response[index].productId,
                                                                                1);
                                                                          });
                                                                          ApiServices()
                                                                              .microProducts(context);
                                                                          fetchMicroProducts();
                                                                          debugPrint(
                                                                              "Increment che : ${dataIncrement[index].counter}");
                                                                          // fetchMicroProducts();
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .add,
                                                                          size:
                                                                              20,
                                                                        )),
                                                                    SizedBox(
                                                                      width: 3,
                                                                    ),
                                                                  ],
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              2),
                                                                  border: Border.all(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              22,
                                                                              2,
                                                                              105,
                                                                              1)),
                                                                ),
                                                                width: 80,
                                                              )
                                                            : Container(
                                                                width: 80,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              2),
                                                                  border: Border.all(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              22,
                                                                              2,
                                                                              105,
                                                                              1)),
                                                                ),
                                                                child: InkWell(
                                                                  child: Text(
                                                                    "ADD",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      dataIncrement[
                                                                              index]
                                                                          .counter = 1;
                                                                      ApiServices().incrementProducts(
                                                                          mp.response[index]
                                                                              .productId,
                                                                          dataIncrement[index].counter);

                                                                      ApiServices()
                                                                          .getWishListProducts(
                                                                              context);
                                                                      dataIncrement[
                                                                              index]
                                                                          .isVisible = !dataIncrement[
                                                                              index]
                                                                          .isVisible;
                                                                    });
                                                                    fetchMicroProducts();
                                                                  },
                                                                ),
                                                                height: 22,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                              ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                      ],
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "${mp.response[index].cartoon.toString()}/Cartoon | ${mp.response[index].stock.toString()} Stock",
                                                          style: GoogleFonts.dmSans(
                                                            fontSize: 12,
                                                            letterSpacing: 1,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 25),
                                                          child: dataIncrement[index].priceTotal != 0
                                                          ?Text("Rs.${dataIncrement[index].priceTotal.toInt().toString()}".toString())
                                                          : Container(),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Expanded(
                                                      flex: 0,
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                            flex: 0,
                                                            child: Container(
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "Rs.",
                                                                    style: GoogleFonts.dmSans(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black87,
                                                                        letterSpacing:
                                                                            0.5,
                                                                        fontSize:
                                                                            13),
                                                                  ),
                                                                  Flexible(
                                                                    flex: 0,
                                                                    child: Text(
                                                                      "${mp.response[index].price.toInt().toString()}",
                                                                      style: GoogleFonts.dmSans(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .black87,
                                                                          letterSpacing:
                                                                              0.5,
                                                                          fontSize:
                                                                              13),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Flexible(
                                                            flex: 0,
                                                            child: Container(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Rs.",
                                                                    style: GoogleFonts.dmSans(
                                                                        letterSpacing:
                                                                            0.5,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize:
                                                                            13),
                                                                  ),
                                                                  Text(
                                                                    "${mp.response[index].mrp.toInt().toString()}",
                                                                    style: GoogleFonts.dmSans(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .lineThrough,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize:
                                                                            13),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          Flexible(
                                                            flex: 0,
                                                            child: Text(
                                                              "${mp.response[index].discountPercentage.toInt().toString()}% OFF",
                                                              style: GoogleFonts.dmSans(
                                                                  color: Colors
                                                                          .green[
                                                                      700],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 13),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "HSN Code : 122496-12%",
                                                          style: GoogleFonts
                                                              .dmSans(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 13,
                                                                  letterSpacing:
                                                                      1),
                                                        ),
                                                        Spacer(),
                                                        InkWell(
                                                          child: mp
                                                                      .response[
                                                                          index]
                                                                      .inFavorits ==
                                                                  true
                                                              ? Icon(
                                                                  Icons
                                                                      .favorite,
                                                                  color: Colors
                                                                      .red,
                                                                )
                                                              : Icon(
                                                                  Icons
                                                                      .favorite_border,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          onTap: () async {
                                                            setState(() {
                                                              if (mp
                                                                      .response[
                                                                          index]
                                                                      .inFavorits ==
                                                                  false) {
                                                                mp
                                                                    .response[
                                                                        index]
                                                                    .inFavorits = true;
                                                              } else {
                                                                mp
                                                                    .response[
                                                                        index]
                                                                    .inFavorits = false;
                                                              }
                                                            });
                                                            ApiServices()
                                                                .addAndDeleteToFavourite(mp
                                                                    .response[
                                                                        index]
                                                                    .productId);
                                                          },
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                          onTap: () {
                                            productId =
                                                mp.response[index].productId;
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetails(
                                                productId: mp
                                                    .response[index].productId,productFunc: fetchMicroProducts,number: 0,
                                              ),
                                            ));
                                            ApiServices().microProductDetails(
                                                productId, context);
                                            debugPrint(
                                                "Product Id Of Product : $productId");
                                            setState(() {});
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
                                  if(mp.response.length == index + 1)
                                    SizedBox(height: MediaQuery.of(context).size.height / 6.5,),
                                  // storeIndexResponse.last.toString() != null
                                  // ? SizedBox(height: 100,)
                                  //     : SizedBox(
                                  //   height: 0,
                                  // ),
                                ],
                              );
                            },
                          ),
                        ),
                      )
                    : Center(
                        child: Text("Products Not Available",style: TextStyle(color: Colors.black),),
                      ),
              ],
            ),
    );
  }

  addToWishList(String id) async {
    await Future.delayed(Duration(seconds: 1), () async {
      await ApiServices().addAndDeleteToFavourite(id);

      Fluttertoast.showToast(msg: "Successfully");
    });
  }
}
