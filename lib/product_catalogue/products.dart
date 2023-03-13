import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:jalaram/Connect_API/api.dart';

import 'package:jalaram/Data_Provider/store_list_bool.dart';

import 'package:jalaram/Model/favourite_with_id.dart';
import 'package:jalaram/Model/home_cart_category_model.dart';
import 'package:jalaram/Model/micro_product.dart';
import 'package:jalaram/Model/price_counter_model.dart';
import 'package:jalaram/component/back_button.dart';
import 'package:jalaram/product_catalogue/productdetails.dart';

import '../Home/bottomnavbar.dart';

List<IncrementNumber> dataIncrement = [];

class Products extends StatefulWidget {
  int number;
  String priceFilter;
  String categoryHome;
  Products({this.number, this.priceFilter, this.categoryHome});
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  // var _valueOfBoolean = [];
  MicroProduct mp;
  PriceCounterModel pcm;

  Icon customIcon = Icon(Icons.search);

  Widget customSearchBar = Text(
    "All Products",
    style: GoogleFonts.aBeeZee(
        color: Color.fromRGBO(22, 2, 105, 1), fontWeight: FontWeight.bold),
  );

  Widget customTrendingBar = Text(
    "Trending Products",
    style: GoogleFonts.aBeeZee(
        color: Color.fromRGBO(22, 2, 105, 1), fontWeight: FontWeight.bold),
  );

  // Timer timer;

  bool isDownloadStart;

  Future onSelectNotifyPdf(String json) async {
    final obj = jsonDecode(json);
    if (obj['isSuccess']) {
      // OpenFile.open(obj['filePath']);
    }
  }

  @override
  void initState() {
    fetchMicroProducts();
    fetchCategory();
    // timer = Timer.periodic(Duration(microseconds: 100), (Timer t) => fetchMicroProducts());
    super.initState();
    // loadData();

    FlutterLocalNotificationsPlugin flip =
        new FlutterLocalNotificationsPlugin();

    // app_icon needs to be a added as a drawable
    // resource to the Android head project.
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var IOS = new IOSInitializationSettings();

    // initialise settings for both Android and iOS device.
    var settings = new InitializationSettings(android: android, iOS: IOS);
    flip.initialize(settings, onSelectNotification: onSelectNotifyPdf);

    isLoadingPdf = false;

    progress = 0.0;
  }

  List<int> addNumber = [];

  var accessProvider;

  final storePrice = [];

  num sum = 0;

  num storePayAmount = 0;

  bool isLoading = false;
  bool isLoadingPriceStore = false;

  fetchMicroProducts() async {
    // await Future.delayed(Duration(milliseconds: 500), () async {
    final response = await ApiServices().microProducts(context);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      mp = MicroProduct.fromJson(decoded);
      debugPrint("MP : ${mp.status}");
      print(mp.response[3].price);

      setState(() {
        numberProduct = mp.response.length;
      });
      if (widget.number == 0) {
        openAndCloseLoadingDialog(context: context);
        fetchPriceCounterProducts();
        Navigator.of(context).pop();
      }

      dataIncrement = List.generate(mp.response.length, (index) {
        // storePrice.add(mp.response[index].price * mp.response[index].inCart);
        isFavouriteBtn.add(false);
        storeBoolForFavourite.add(false);
        return IncrementNumber(
          productName: mp.response[index].title,
          counter: mp.response[index].inCart,
          isVisible: mp.response[index].cartStatus,
          priceTotal: mp.response[index].price.toInt() *
              mp.response[index].inCart.toDouble(),
        );
      });

      if (widget.number == 1) {
        fetchSearchingProduct(widget.categoryHome);
      }
      if (widget.number == 5) {
        Future.delayed(
          Duration(milliseconds: 300),
          () => fetchTrendingProducts(),
        );
      }

      setState(() {
        isLoading = true;
      });
    }
    // });
  }

  String text = "";

  List<bool> isFavouriteBtn = [];

  fetchSearchingProduct(String key) async {
    // await Future.delayed(Duration(milliseconds: 100), () async {
    final response = await ApiServices().searchProducts(context, key);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        mp.response = null;
      });
      mp = MicroProduct.fromJson(decoded);
      print("Search : ${mp.response.length}");
      dataIncrement = List.generate(mp.response.length, (index) {
        storeIndexResponse.add(index.toString());
        return IncrementNumber(
            productName: mp.response[index].title,
            counter: mp.response[index].inCart,
            isVisible: mp.response[index].cartStatus,
            priceTotal: mp.response[index].price.toInt() *
                mp.response[index].inCart.toDouble());
      });
      setState(() {
        isLoading = true;
      });
    }
    // });
  }

  List<String> storeIndexResponse = [];

  int numberProduct = 0;
  int productDataLength = 0;

  bool isFirstAllProduct = false;

  fetchPriceCounterProducts() async {
    // await Future.delayed(Duration(milliseconds: 500), () async {
    Response response =
        await ApiServices().getProductCounter(widget.priceFilter, context);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      mp = MicroProduct.fromJson(decoded);
      debugPrint("MP : ${mp.status}");
      setState(() {
        numberProduct = mp.response.length;
      });
      dataIncrement = List.generate(mp.response.length, (index) {
        storeIndexResponse.add(index.toString());
        return IncrementNumber(
          productName: mp.response[index].title,
          counter: mp.response[index].inCart,
          isVisible: mp.response[index].cartStatus,
          priceTotal: mp.response[index].price.toInt() *
              mp.response[index].inCart.toDouble(),
        );
      });
      setState(() {
        isLoading = true;
      });
    }
    // });
  }

  List storeBoolForFavourite = [];

  HomeCartCategory hcc;

  fetchPriceSearch(int highValue) async {
    int lowValue = highValue - 1;
    print(highValue - 1);
    final response =
        await ApiServices().getSearchByPrice(lowValue, highValue, context);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      mp = MicroProduct.fromJson(decoded);

      setState(() {});
    }
  }

  List makeColorChangeList = [];

  fetchCategory() async {
    // await Future.delayed(Duration(milliseconds: 100), () async {
    final response = await ApiServices().getHomeCategory(context);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      hcc = HomeCartCategory.fromJson(decoded);
      for (int i = 0; i <= hcc.catList.length; i++) {
        isActiveCateWithColor.add(false);
        makeColorChangeList.add(false);
      }
      setState(() {
        isLoading = true;
      });
    }
    // });
  }

  fetchStockInProducts() async {
    // await Future.delayed(Duration(milliseconds: 100), () async {
    mp = null;
    final response = await ApiServices().getStockInProduct(context);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      mp = MicroProduct.fromJson(decoded);
      setState(() {});
    }
    // });
  }

  fetchStockOutOfProducts() async {
    // await Future.delayed(Duration(milliseconds: 100), () async {
    mp = null;
    final response = await ApiServices().getStockOutOfProduct(context);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      mp = MicroProduct.fromJson(decoded);
      setState(() {});
    }
    // });
  }

  fetchTrendingProducts() async {
    // await Future.delayed(Duration(milliseconds: 100), () async {
    mp = null;
    final response = await ApiServices().getTrendingProducts(context);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      mp = MicroProduct.fromJson(decoded);
      setState(() {
        numberProduct = mp.response.length;
      });
      dataIncrement = List.generate(
        mp.response.length,
        (index) {
          storeIndexResponse.add(index.toString());
          return IncrementNumber(
            productName: mp.response[index].title,
            counter: mp.response[index].inCart,
            isVisible: mp.response[index].cartStatus,
            priceTotal: mp.response[index].price.toInt() *
                mp.response[index].inCart.toDouble(),
          );
        },
      );
    }
    // });
  }

  bool isActiveSearchBar = false;

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
              SizedBox(
                width: 5,
              ),
              Text("Search",
                  style: GoogleFonts.openSans(
                      color: Color.fromRGBO(22, 2, 105, 1))),
            ],
          ),
          value: 1,
          onTap: () {
            // Navigator.pop(context);
            setState(
              () {
                if (this.customIcon.icon == Icons.search) {
                  setState(() {
                    isActiveSearchBar = true;
                  });
                  customSearchBar = Row(
                    children: [
                      GestureDetector(
                        child: Icon(Icons.arrow_back_ios_sharp),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottomNavBar(index: 0),
                              ));
                        },
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Container(
                            height: 40,
                            child: TextField(
                              onChanged: (value) {
                                if (value == "") {
                                  fetchMicroProducts();
                                }

                                setState(() {
                                  fetchSearchingProduct(value);
                                  fetchPriceSearch(int.parse(value));
                                });
                              },
                              style: GoogleFonts.dmSans(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 10),
                                enabledBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(22, 2, 105, 1),
                                      width: 1.7),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(22, 2, 105, 1),
                                      width: 1.7),
                                ),
                                hintText: "Search",
                                hintStyle: GoogleFonts.dmSans(
                                    color: Colors.grey.shade500,
                                    fontSize: 15,
                                    letterSpacing: 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          },
        ),
        // PopupMenuItem(
        //   child: InkWell(
        //     onTap: () {
        //       debugPrint("Button Pressed");
        //       Navigator.pop(context);
        //       setState(() {
        //         category = "";
        //         isSwitched = false;
        //         showDialogForDownloadOption(context);
        //
        //         // createPdf();
        //       });
        //     },
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       children: [
        //         Icon(
        //           Icons.download,
        //           color: Color.fromRGBO(22, 2, 105, 1),
        //         ),
        //         Text("Download",
        //             style: GoogleFonts.openSans(
        //                 color: Color.fromRGBO(22, 2, 105, 1))),
        //       ],
        //     ),
        //   ),
        // ),
        PopupMenuItem(
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
              categoryFilter = "";
              showDialogForFilterOption(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.filter_list,
                  color: Color.fromRGBO(22, 2, 105, 1),
                ),
                SizedBox(
                  width: 5,
                ),
                Text("Apply Filter",
                    style: GoogleFonts.openSans(
                        color: Color.fromRGBO(22, 2, 105, 1))),
              ],
            ),
          ),
        ),
      ],
      elevation: 8.0,
    );
  }

  double progress = 0;
  bool didDownloadPDF = false;
  String progressString = '';
  bool isLoadingPdf;

  void updateProgress(done, total) {
    progress = done / total;
    print("Done : $done");
    print("total : $total");
    if (!mounted) return;
    setState(() {
      if (progress >= 1) {
        didDownloadPDF = true;
        return Container();
      } else {
        progressString = (progress * 100).toStringAsFixed(0) + '%';
      }
    });
    if (done == total) {
      setState(() {
        progressString = "Downloaded";
        print(progressString);
      });
    }
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
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                  Colors.white,
                )),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.dmSans(
                    color: Color.fromRGBO(255, 78, 91, 1),
                  ),
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
                onPressed: () {
                  setState(() {
                    mp.response[index].inFavorits = false;
                  });
                  ApiServices()
                      .addAndDeleteToFavourite(mp.response[index].productId);
                  Navigator.pop(context);
                },
                child: Text(
                  "Remove",
                  style: GoogleFonts.dmSans(color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                  Color.fromRGBO(255, 78, 91, 1),
                )),
              ),
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  // void updateProgressNew() {
  //   const oneSec = const Duration(seconds: 1);
  //   new Timer.periodic(oneSec, (Timer t) {
  //     if (!mounted) return;
  //
  //     setState(() {
  //       progress += 0.1;
  //       // we "finish" downloading here
  //       if (progress.toStringAsFixed(1) == '1.0') {
  //         isLoadingPdf = false;
  //         t.cancel();
  //         return;
  //       }
  //     });
  //   });
  // }

  showDialogForDownloadOption(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                height: 270,
                // width: MediaQuery.of(context).size.width * 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Which products you want to download?",
                        style: GoogleFonts.dmSans(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              child: Radio(
                                value: "With Price",
                                groupValue: category,
                                activeColor: Color.fromRGBO(255, 78, 91, 1),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                onChanged: (value) async {
                                  setState(() {
                                    category = value;
                                    print("category : $category");
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "With Price",
                              style: GoogleFonts.dmSans(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              child: Radio(
                                value: "Without Price",
                                groupValue: category,
                                activeColor: Color.fromRGBO(255, 78, 91, 1),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                onChanged: (value) {
                                  setState(() {
                                    category = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Without Price",
                              style: GoogleFonts.dmSans(),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Flexible(
                              flex: 1,
                              child: Text(
                                "Do you want to download without deluxe logo?",
                                style: GoogleFonts.dmSans(),
                              )),
                          Transform.scale(
                            scale: 1,
                            child: Switch(
                              onChanged: (value) {
                                setState(() {
                                  isSwitched = value;
                                  print(isSwitched);
                                });
                              },
                              value: isSwitched,
                              activeColor: Color.fromRGBO(255, 78, 91, 1),
                              activeTrackColor: Color.fromRGBO(255, 78, 91, 1)
                                  .withOpacity(0.4),
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 10, top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    width: 1.2,
                                    color: Color.fromRGBO(255, 78, 91, 1),
                                  ),
                                ),
                                child: Text("CANCEL")),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (isSwitched == false &&
                                  category == "With Price") {
                                setState(() {});
                                // var temDir = await getTemporaryDirectory();
                                openAndCloseLoadingDialog(context: context);

                                ApiServices().downloadPdfWithPrice(
                                    context, "on", "on",
                                    stepProgress: updateProgress);
                              } else if (category == "Without Price" &&
                                  isSwitched == false) {
                                openAndCloseLoadingDialog(context: context);
                                setState(() {});
                                ApiServices().downloadPdfWithPrice(
                                    context, "off", "on",
                                    stepProgress: updateProgress);
                              } else if (isSwitched == true &&
                                  category == "With Price") {
                                setState(() {});
                                ApiServices().downloadPdfWithPrice(
                                    context, "on", "off",
                                    stepProgress: updateProgress);
                              } else if (isSwitched == true &&
                                  category == "Without Price") {
                                setState(() {});

                                ApiServices().downloadPdfWithPrice(
                                    context, "off", "off",
                                    stepProgress: updateProgress);
                              }
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 10, bottom: 10),
                              margin: EdgeInsets.only(
                                  left: 10, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Color.fromRGBO(255, 78, 91, 1),
                              ),
                              child: Text(
                                "DOWNLOAD",
                                style: GoogleFonts.dmSans(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  showDialogForFilterOption(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                height: MediaQuery.of(context).size.height / 3.32,
                // width: MediaQuery.of(context).size.width * 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Apply Filter",
                        style: GoogleFonts.dmSans(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              child: Radio(
                                value: "Top Trending Products",
                                groupValue: categoryFilter,
                                activeColor: Color.fromRGBO(255, 78, 91, 1),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                onChanged: (value) {
                                  setState(() {
                                    categoryFilter = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Top Trending Products",
                              style: GoogleFonts.dmSans(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              child: Radio(
                                value: "Out of stock",
                                groupValue: categoryFilter,
                                activeColor: Color.fromRGBO(255, 78, 91, 1),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                onChanged: (value) {
                                  setState(() {
                                    categoryFilter = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Out of stock",
                              style: GoogleFonts.dmSans(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              child: Radio(
                                value: "In stock",
                                groupValue: categoryFilter,
                                activeColor: Color.fromRGBO(255, 78, 91, 1),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                onChanged: (value) {
                                  setState(() {
                                    categoryFilter = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "In stock",
                              style: GoogleFonts.dmSans(),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 10, top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    width: 1.2,
                                    color: Color.fromRGBO(255, 78, 91, 1),
                                  ),
                                ),
                                child: Text("CANCEL")),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (categoryFilter == "In stock") {
                                setState(() {
                                  fetchStockInProducts();
                                });
                              } else if (categoryFilter == "Out of stock") {
                                setState(() {
                                  fetchStockOutOfProducts();
                                });
                              } else if (categoryFilter ==
                                  "Top Trending Products") {
                                setState(() {
                                  fetchTrendingProducts();
                                });
                              }
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 10, bottom: 10),
                              margin: EdgeInsets.only(
                                  left: 10, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Color.fromRGBO(255, 78, 91, 1),
                              ),
                              child: Text(
                                "Apply",
                                style: GoogleFonts.dmSans(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  bool isSwitched = false;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  String category = "";

  String categoryFilter = "";

  List<bool> isActiveCateWithColor = [];

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
        title: widget.number == 5 ? customTrendingBar : customSearchBar,
        actions: [
          widget.number == 5
              ? Container()
              : isActiveSearchBar == true
                  ? Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: IconButton(
                        color: Color.fromRGBO(22, 2, 105, 1),
                        onPressed: () {
                          setState(() {
                            // ProductControllerGetx.to.microProductsGetx(context);
                            isActiveSearchBar = false;
                            customSearchBar = Text(
                              "All Products",
                              style: GoogleFonts.aBeeZee(
                                  color: Color.fromRGBO(22, 2, 105, 1),
                                  fontWeight: FontWeight.bold),
                            );
                          });
                        },
                        icon: Icon(Icons.close),
                      ),
                    )
                  : Padding(
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
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () {
          return ApiServices().microProducts(context);
        },
        key: _refreshIndicatorKey,
        child: isLoading == false
            ? Center(
                child: CircularProgressIndicator(),
              )
            : mp == null && hcc == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      widget.number == 5
                          ? Container()
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 8,
                              child: ListView.builder(
                                itemCount: hcc.catList.isEmpty
                                    ? 0
                                    : hcc.catList.length + 1,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 18,
                                          ),
                                          index == 0
                                              ? GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      isFirstAllProduct = true;
                                                      openAndCloseLoadingDialog(
                                                          context: context);
                                                      fetchMicroProducts();
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      // color: Colors
                                                      //     .grey.shade200,
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/category4.png"),
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    // child: Image.asset("assets/category.png",height: 40,width: 40,),
                                                  ),
                                                )
                                              : GestureDetector(
                                                  child: Container(
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                        hcc.catList[index - 1]
                                                            .image,
                                                      ),
                                                      backgroundColor:
                                                          Colors.grey[300],
                                                      radius: 25,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: makeColorChangeList[
                                                                    index] ==
                                                                true
                                                            ? isFirstAllProduct ==
                                                                    true
                                                                ? Color
                                                                    .fromRGBO(
                                                                        4,
                                                                        75,
                                                                        90,
                                                                        1)
                                                                : Color
                                                                    .fromRGBO(
                                                                        22,
                                                                        2,
                                                                        105,
                                                                        1)
                                                            : Color.fromRGBO(
                                                                4, 75, 90, 1),
                                                        width: makeColorChangeList[
                                                                    index] ==
                                                                true
                                                            ? isFirstAllProduct ==
                                                                    true
                                                                ? 1
                                                                : 2
                                                            : 1,
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    isFirstAllProduct = false;
                                                    for (int i = 0;
                                                        i <
                                                            makeColorChangeList
                                                                .length;
                                                        i++) {
                                                      if (makeColorChangeList[
                                                              i] ==
                                                          true) {
                                                        makeColorChangeList[i] =
                                                            false;
                                                      } else {
                                                        makeColorChangeList[i] =
                                                            false;
                                                      }
                                                    }
                                                    setState(() {
                                                      makeColorChangeList[
                                                          index] = true;
                                                    });
                                                    print(hcc.catList[index - 1]
                                                        .name);
                                                    fetchSearchingProduct(hcc
                                                        .catList[index - 1]
                                                        .name);

                                                    setState(() {});
                                                  },
                                                ),
                                          SizedBox(
                                            width: 16,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      index == 0
                                          ? Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isFirstAllProduct = true;
                                                    openAndCloseLoadingDialog(
                                                        context: context);
                                                    fetchMicroProducts();
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "ALL \nPRODUCT",
                                                  style: GoogleFonts.dmSans(
                                                    fontSize: 13.4,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            )
                                          : hcc.catList[index - 1].name
                                                      .split(" ")
                                                      .length >
                                                  1
                                              ? Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        fetchSearchingProduct(
                                                            hcc
                                                                .catList[
                                                                    index - 1]
                                                                .name);
                                                      });
                                                    },
                                                    child: Text(
                                                      " ${hcc.catList[index - 1].name.split(" ")[0]}\n ${hcc.catList[index - 1].name.split(" ")[1]}",
                                                      style: GoogleFonts.dmSans(
                                                        fontSize: 13.4,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                )
                                              : Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        fetchSearchingProduct(
                                                            hcc
                                                                .catList[
                                                                    index - 1]
                                                                .name);
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                        "${hcc.catList[index - 1].name}\n",
                                                        style:
                                                            GoogleFonts.dmSans(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                ),
                                    ],
                                  );
                                },
                              ),
                            ),
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            isLoading == true && numberProduct != 0
                                ? mp.response.length == 0
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        itemCount: mp.response == null
                                            ? 0
                                            : mp.response.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  productId = mp.response[index]
                                                      .productId;
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductDetails(
                                                        productId: productId,
                                                        productFunc:
                                                            fetchMicroProducts,
                                                        number: 0,
                                                      ),
                                                    ),
                                                  );

                                                  debugPrint(
                                                      "Product Id Of Product : $productId");
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            print(
                                                                "Hello World");
                                                          },
                                                          child: Container(
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
                                                            child:
                                                                Image.network(
                                                              "${mp.urls.image}/${mp.response[index].banner.media}",
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 0.8),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                            ),
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
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                mp.response[index].title
                                                                            .length >
                                                                        30
                                                                    ? RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          children: [
                                                                            TextSpan(
                                                                              text: '${mp.response[index].title.toUpperCase()}'.substring(0, 30),
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
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    : Text(
                                                                        "${mp.response[index].title.toUpperCase()}",
                                                                        style: GoogleFonts.dmSans(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            letterSpacing:
                                                                                1.5,
                                                                            fontSize:
                                                                                13,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      "${mp.response[index].category}",
                                                                      style: GoogleFonts.dmSans(
                                                                          letterSpacing: 1.5,
                                                                          // fontWeight: FontWeight.bold,
                                                                          fontSize: 12,
                                                                          color: Colors.grey),
                                                                    ),
                                                                    Spacer(),
                                                                    mp.response[index].stock <=
                                                                            0
                                                                        ? Text(
                                                                            "Out of Stock",
                                                                            style:
                                                                                GoogleFonts.dmSans(color: Colors.red),
                                                                          )
                                                                        : Container(),
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
                                                                      "${mp.response[index].cartoon.toString()}/Cartoon | ${mp.response[index].stock <= 0 ? "0" : mp.response[index].stock.toString()} Stock",
                                                                      style: GoogleFonts
                                                                          .dmSans(
                                                                        fontSize:
                                                                            12,
                                                                        letterSpacing:
                                                                            1,
                                                                      ),
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
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                "Rs.",
                                                                                style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 0.5, fontSize: 13),
                                                                              ),
                                                                              Flexible(
                                                                                flex: 0,
                                                                                child: (mp.response[index].price % 1) == 0
                                                                                    ? Text(
                                                                                        "${mp.response[index].price.toInt().toString()}",
                                                                                        style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 0.5, fontSize: 13),
                                                                                      )
                                                                                    : Text(
                                                                                        "${mp.response[index].price}",
                                                                                        style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 0.5, fontSize: 13),
                                                                                      ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Flexible(
                                                                        flex: 0,
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "Rs.",
                                                                                style: GoogleFonts.dmSans(letterSpacing: 0.5, color: Colors.grey, fontSize: 13),
                                                                              ),
                                                                              Text(
                                                                                "${mp.response[index].mrp.toInt().toString()}",
                                                                                style: GoogleFonts.dmSans(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 13),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            4,
                                                                      ),
                                                                      Flexible(
                                                                        flex: 0,
                                                                        child:
                                                                            Text(
                                                                          "${mp.response[index].discountPercentage.toInt().toString()}% OFF",
                                                                          style: GoogleFonts.dmSans(
                                                                              color: Colors.green[700],
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 13),
                                                                        ),
                                                                      ),
                                                                      Spacer(),
                                                                      InkWell(
                                                                        child: mp.response[index].inFavorits ==
                                                                                true
                                                                            ? Icon(
                                                                                Icons.favorite,
                                                                                color: Colors.red,
                                                                              )
                                                                            : storeBoolForFavourite[index] == false
                                                                                ? Icon(
                                                                                    Icons.favorite_border,
                                                                                    color: Colors.black,
                                                                                  )
                                                                                : SizedBox(
                                                                                    height: 20,
                                                                                    width: 20,
                                                                                    child: CircularProgressIndicator(
                                                                                      strokeWidth: 3,
                                                                                      color: Colors.grey.shade800,
                                                                                      backgroundColor: Colors.grey.shade400,
                                                                                    ),
                                                                                  ),
                                                                        onTap:
                                                                            () async {
                                                                          setState(
                                                                              () {
                                                                            storeBoolForFavourite[index] =
                                                                                true;
                                                                          });
                                                                          setState(
                                                                              () {
                                                                            if (mp.response[index].inFavorits ==
                                                                                false) {
                                                                              Future.delayed(
                                                                                Duration(seconds: 1),
                                                                                () {
                                                                                  setState(() {
                                                                                    mp.response[index].inFavorits = true;
                                                                                    ApiServices().addAndDeleteToFavourite(mp.response[index].productId);
                                                                                  });
                                                                                  setState(() {
                                                                                    storeBoolForFavourite[index] = false;
                                                                                  });
                                                                                },
                                                                              );
                                                                            } else {
                                                                              storeBoolForFavourite[index] = false;
                                                                              showDilogE(context: context, index: index);
                                                                            }
                                                                          });
                                                                        },
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                                Text(
                                                                  "HSN Code : ${mp.response[index].hsn == null ? '0' : mp.response[index].hsn}-${mp.response[index].gst == null ? '0' : mp.response[index].gst}%",
                                                                  style: GoogleFonts.dmSans(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          13,
                                                                      letterSpacing:
                                                                          1),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                      ),
                                                      flex: 1,
                                                      fit: FlexFit.loose,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Divider(
                                                thickness: 0.5,
                                                color: Colors.grey,
                                                indent: 10,
                                                endIndent: 5,
                                              ),
                                              if (mp.response.length ==
                                                  index + 1)
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      6.5,
                                                ),
                                              // storeIndexResponse.last.toString() != null
                                              // ? SizedBox(height: 100,)
                                              //     : SizedBox(
                                              //   height: 0,
                                              // ),
                                            ],
                                          );
                                        },
                                      )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  bool isDownloadedText = true;

  addToWishList(String id) async {
    await Future.delayed(Duration(seconds: 1), () async {
      await ApiServices().addAndDeleteToFavourite(id);

      Fluttertoast.showToast(msg: "Successfully");
    });
  }
}
