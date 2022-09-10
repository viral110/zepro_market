import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:jalaram/Connect_API/api.dart';
import 'package:jalaram/Data_Provider/data_provider.dart';
import 'package:jalaram/Data_Provider/store_list_bool.dart';

import 'package:jalaram/Model/favourite_with_id.dart';
import 'package:jalaram/Model/home_cart_category_model.dart';
import 'package:jalaram/Model/micro_product.dart';
import 'package:jalaram/Model/price_counter_model.dart';
import 'package:jalaram/product_catalogue/productdetails.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../Home/bottomnavbar.dart';
import '../Model/searching_product_model.dart';

// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// ignore: must_be_immutable

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
      OpenFile.open(obj['filePath']);
    }
  }

  @override
  void initState() {
    fetchMicroProducts();
    // timer = Timer.periodic(Duration(microseconds: 100), (Timer t) => fetchMicroProducts());
    super.initState();
    // loadData();
    fetchCategory();

    ApiServices().microProducts(context);

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

  // loadData () async {
  //   widget.number == 0 ? await fetchPriceCounterProducts() : await fetchMicroProducts();
  // }

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
      setState(() {
        numberProduct = mp.response.length;
      });
      if (widget.number == 0) {
        mp = null;
        fetchPriceCounterProducts();
      }

      dataIncrement = List.generate(mp.response.length, (index) {
        // storePrice.add(mp.response[index].price * mp.response[index].inCart);

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

  fetchSearchingProduct(String key) async {
    // await Future.delayed(Duration(milliseconds: 100), () async {
    Response response = await ApiServices().searchProducts(context, key);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      mp = MicroProduct.fromJson(decoded);
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

  HomeCartCategory hcc;

  fetchPriceSearch(int highValue) async {
    int lowValue = highValue - 1;
    print(highValue - 1);
    Response response =
        await ApiServices().getSearchByPrice(lowValue, highValue, context);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      mp = MicroProduct.fromJson(decoded);

      setState(() {});
    }
  }

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

  fetchStockInProducts() async {
    // await Future.delayed(Duration(milliseconds: 100), () async {
    Response response = await ApiServices().getStockInProduct(context);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      mp = MicroProduct.fromJson(decoded);
      setState(() {});
    }
    // });
  }

  fetchStockOutOfProducts() async {
    // await Future.delayed(Duration(milliseconds: 100), () async {
    Response response = await ApiServices().getStockOutOfProduct(context);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      mp = MicroProduct.fromJson(decoded);
      setState(() {});
    }
    // });
  }

  fetchTrendingProducts() async {
    // await Future.delayed(Duration(milliseconds: 100), () async {
    Response response = await ApiServices().getTrendingProducts(context);
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
                              builder: (context) => BottomNavBar(),
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
                                    color: Colors.blueAccent, width: 1.7),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 1.7),
                              ),
                              hintText: "Search your daily product",
                              hintStyle: GoogleFonts.dmSans(
                                  color: Colors.grey.shade500, fontSize: 13),

                              // prefixIcon: Icon(
                              //   Icons.search,
                              //   color: Colors.black,
                              // ),
                              // suffixIcon: IconButton(
                              //   icon: Icon(
                              //     Icons.cancel,
                              //     color: Colors.grey.withOpacity(0.5),
                              //   ),
                              //   onPressed: () {
                              //     setState(() {
                              //       fetchMicroProducts();
                              //       customSearchBar = Text(
                              //         "All Products",
                              //         style: GoogleFonts.aBeeZee(
                              //             color: Color.fromRGBO(22, 2, 105, 1),
                              //             fontWeight: FontWeight.bold),
                              //       );
                              //     });
                              //   },
                              // ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
              Navigator.pop(context);
              setState(() {
                category = "";
                isSwitched = false;
                showDialogForDownloadOption(context);

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
                Text("Filter",
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

  void updateProgressNew() {
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(oneSec, (Timer t) {
      if (!mounted) return;

      setState(() {
        progress += 0.1;
        // we "finish" downloading here
        if (progress.toStringAsFixed(1) == '1.0') {
          isLoadingPdf = false;
          t.cancel();
          return;
        }
      });
    });
  }

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
                                activeColor: Color.fromRGBO(4, 75, 90, 1),
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
                                activeColor: Color.fromRGBO(4, 75, 90, 1),
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
                              activeColor: Color.fromRGBO(4, 75, 90, 1),
                              activeTrackColor:
                                  Color.fromRGBO(4, 75, 90, 1).withOpacity(0.4),
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
                                    color: Color.fromRGBO(4, 75, 90, 1),
                                  ),
                                ),
                                child: Text("CANCEL")),
                          ),
                          GestureDetector(
                            onTap: () async {
                              Navigator.pop(context);

                              if (isSwitched == false &&
                                  category == "With Price") {
                                setState(() {
                                  isLoadingPdf = true;
                                  updateProgressNew();
                                });
                                // var temDir = await getTemporaryDirectory();
                                await ApiServices().downloadPdfWithPrice(
                                    context, "on", "on",
                                    stepProgress: updateProgress);
                              } else if (category == "Without Price" &&
                                  isSwitched == false) {
                                setState(() {
                                  isLoadingPdf = true;
                                  updateProgressNew();
                                });
                                await ApiServices().downloadPdfWithPrice(
                                    context, "off", "on",
                                    stepProgress: updateProgress);
                              } else if (isSwitched == true &&
                                  category == "With Price") {
                                setState(() {
                                  isLoadingPdf = true;
                                  updateProgressNew();
                                });
                                await ApiServices().downloadPdfWithPrice(
                                    context, "on", "off",
                                    stepProgress: updateProgress);
                              } else if (isSwitched == true &&
                                  category == "Without Price") {
                                setState(() {
                                  isLoadingPdf = true;
                                  updateProgressNew();
                                });
                                await ApiServices().downloadPdfWithPrice(
                                    context, "off", "off",
                                    stepProgress: updateProgress);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 10, bottom: 10),
                              margin: EdgeInsets.only(
                                  left: 10, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Color.fromRGBO(4, 75, 90, 1),
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
                                activeColor: Color.fromRGBO(4, 75, 90, 1),
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
                                activeColor: Color.fromRGBO(4, 75, 90, 1),
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
                                activeColor: Color.fromRGBO(4, 75, 90, 1),
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
                                    color: Color.fromRGBO(4, 75, 90, 1),
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
                                color: Color.fromRGBO(4, 75, 90, 1),
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

  // void toggleSwitch(bool value) {
  //   if (isSwitched == false) {
  //     setState(() {
  //       isSwitched = true;
  //     });
  //     print('Switch Button is ON');
  //   } else {
  //     setState(() {
  //       isSwitched = false;
  //     });
  //     print('Switch Button is OFF');
  //   }
  // }

  String category = "";

  String categoryFilter = "";

  // List<AddFavoriteWithId> changeInFavourite = [];

  int n = -1;

  String productId;

  @override
  Widget build(BuildContext context) {
    var movies = context.watch<StoreListBoolProvider>().movies;
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
                            fetchMicroProducts();
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
      body: isLoading == false
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
                    : Expanded(
                        flex: 0,
                        child: Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 7.9,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: ListView.builder(
                                  itemCount:
                                      hcc == null ? 0 : hcc.catList.length + 1,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                        fetchMicroProducts();
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        // color: Colors
                                                        //     .grey.shade200,
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/all-product-new.png"),
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      // child: Image.asset("assets/category.png",height: 40,width: 40,),
                                                    ),
                                                  )
                                                : GestureDetector(
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
                                                    onTap: () {
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
                                            ? Text(
                                                "All Product\n",
                                                style: GoogleFonts.aBeeZee(
                                                    fontSize: 13.4,
                                                    color: Colors.black),
                                              )
                                            : hcc.catList[index - 1].name
                                                        .split(" ")
                                                        .length >
                                                    1
                                                ? Text(
                                                    " ${hcc.catList[index - 1].name.split(" ")[0]}\n ${hcc.catList[index - 1].name.split(" ")[1]}",
                                                    style: GoogleFonts.aBeeZee(
                                                        fontSize: 13.4,
                                                        color: Colors.black),
                                                    textAlign: TextAlign.center,
                                                  )
                                                : Text(
                                                    "${hcc.catList[index - 1].name}\n"),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                SizedBox(
                  height: 2,
                ),
                progressString == "Downloaded"
                    ? isDownloadedText
                        ? Padding(
                            padding: const EdgeInsets.only(left: 7, right: 7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Downloaded Successfully"),
                                Text("100%"),
                              ],
                            ),
                          )
                        : Container()
                    : Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isLoadingPdf == true
                                ? Text("Downloading in progress..")
                                : Container(),
                            Text(progressString),
                          ],
                        ),
                      ),
                isLoadingPdf == true
                    ? Flexible(
                        flex: 1,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 7,
                            ),
                            Flexible(
                              flex: 1,
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.grey.shade300,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Color.fromRGBO(22, 2, 105, 1)),
                                value: progress,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            progressString != "Downloaded"
                                ? Container()
                                : Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          OpenFile.open("$filePathForOpenFile");
                                        },
                                        child: Text(
                                          "View",
                                          style: GoogleFonts.dmSans(
                                              color:
                                                  Color.fromRGBO(22, 2, 105, 1),
                                              fontWeight: FontWeight.w500),
                                        ),
                                        // style: ButtonStyle(
                                        //   backgroundColor: Color.fromRGBO(22, 2, 105, 1)
                                        // ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isLoadingPdf = false;
                                              isDownloadedText = false;
                                            });
                                          },
                                          child: Icon(Icons.close)),
                                      SizedBox(
                                        width: 7,
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      )
                    : Container(),
                isLoading == true  && numberProduct != 0
                    ? mp != null
                        ? Expanded(
                            flex: 12,
                            // height: MediaQuery.of(context).size.height / 1.05,
                            child: Container(
                              child: ListView.builder(
                                itemCount: mp == null ? 0 : mp.response.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  // String storeLastResponse = mp.response[index].productId;
                                  print(mp.response.length);
                                  return mainProductFunc(index, movies);
                                },
                              ),
                            ),
                          )
                        : Container()
                    : Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 4,
                            // bottom: MediaQuery.of(context).size.height / ,
                          ),
                          child: Container(
                            child: Text("No Product Available",style: GoogleFonts.dmSans(fontSize: 16),),
                          ),
                        ),
                      ),
              ],
            ),
    );
  }

  bool isDownloadedText = true;

  Widget mainProductFunc(int index, List<IncrementNumber> movies) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            productId = mp.response[index].productId;
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductDetails(
                productId: mp.response[index].productId,
                productFunc: fetchMicroProducts,
                number: 0,
              ),
            ));
            ApiServices().microProductDetails(productId, context);
            debugPrint("Product Id Of Product : $productId");
            setState(() {});
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 6,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(
                  //   height: 10,
                  // ),
                  GestureDetector(
                    onTap: () {
                      print("Hello World");
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height / 9,
                      child: Image.network(
                        "${mp.urls.image}/${mp.response[index].banner.media}",
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0.8),
                        borderRadius: BorderRadius.circular(6),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          mp.response[index].title.length > 30
                              ? Text(
                                  "${mp.response[index].title.toUpperCase()}...",
                                  style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                      fontSize: 13,
                                      color: Colors.black),
                                )
                              : Text(
                                  "${mp.response[index].title.toUpperCase()}",
                                  style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                      fontSize: 13,
                                      color: Colors.black),
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
                              mp.response[index].stock <= 0
                                  ? Text(
                                      "Out of Stock",
                                      style:
                                          GoogleFonts.dmSans(color: Colors.red),
                                    )
                                  : Container(),
                              // mp.response[index].stock <= 0
                              //     ? Text(
                              //         "Out of Stock",
                              //         style:
                              //             GoogleFonts.dmSans(color: Colors.red),
                              //       )
                              //     : dataIncrement[index].isVisible
                              //         ? GestureDetector(
                              //             onTap: () {
                              //               print("Hello World");
                              //             },
                              //             child: Container(
                              //               child: Row(
                              //                 children: [
                              //                   GestureDetector(
                              //                       onTap: () async {
                              //                         await ApiServices()
                              //                             .decrementProducts(
                              //                                 mp.response[index]
                              //                                     .productId,
                              //                                 1,
                              //                                 context);
                              //                         setState(() {
                              //                           ApiServices()
                              //                               .microProducts(
                              //                                   context);
                              //                         });
                              //                         if (dataIncrement[index]
                              //                                 .counter <
                              //                             2) {
                              //                           dataIncrement[index]
                              //                                   .isVisible =
                              //                               !dataIncrement[
                              //                                       index]
                              //                                   .isVisible;
                              //                         } else {
                              //                           dataIncrement[index]
                              //                               .counter--;
                              //                         }
                              //                         debugPrint(
                              //                             "Decrement che : ${dataIncrement[index].counter}");
                              //                         fetchMicroProducts();
                              //                         // Fluttertoast.showToast(msg: "Product Decrement : ${dataIncrement[index].counter--}");
                              //                       },
                              //                       child: Padding(
                              //                         padding:
                              //                             const EdgeInsets.only(
                              //                                 right: 10,
                              //                                 left: 7),
                              //                         child: Icon(
                              //                           Icons.remove,
                              //                           size: 20,
                              //                         ),
                              //                       )),
                              //                   SizedBox(
                              //                     width: 5,
                              //                   ),
                              //                   Text(
                              //                     "${dataIncrement[index].counter.toString()}",
                              //                     style: TextStyle(
                              //                         fontWeight:
                              //                             FontWeight.bold),
                              //                   ),
                              //                   SizedBox(
                              //                     width: 5,
                              //                   ),
                              //                   GestureDetector(
                              //                       onTap: () {
                              //                         setState(() {
                              //                           dataIncrement[index]
                              //                               .counter++;
                              //                           ApiServices()
                              //                               .incrementProducts(
                              //                                   mp
                              //                                       .response[
                              //                                           index]
                              //                                       .productId,
                              //                                   1);
                              //                         });
                              //                         ApiServices()
                              //                             .microProducts(
                              //                                 context);
                              //                         fetchMicroProducts();
                              //                         debugPrint(
                              //                             "Increment che : ${dataIncrement[index].counter}");
                              //                         // fetchMicroProducts();
                              //                       },
                              //                       child: Padding(
                              //                         padding:
                              //                             const EdgeInsets.only(
                              //                                 right: 7,
                              //                                 left: 10),
                              //                         child: Icon(
                              //                           Icons.add,
                              //                           size: 20,
                              //                         ),
                              //                       )),
                              //                   SizedBox(
                              //                     width: 3,
                              //                   ),
                              //                 ],
                              //                 mainAxisAlignment:
                              //                     MainAxisAlignment
                              //                         .spaceBetween,
                              //               ),
                              //               decoration: BoxDecoration(
                              //                 borderRadius:
                              //                     BorderRadius.circular(2),
                              //                 border: Border.all(
                              //                     color: Color.fromRGBO(
                              //                         22, 2, 105, 1)),
                              //               ),
                              //               // width: 90,
                              //             ),
                              //           )
                              //         : InkWell(
                              //             onTap: () {
                              //               setState(() {
                              //                 dataIncrement[index].counter = 1;
                              //               });
                              //               ApiServices()
                              //                   .getWishListProducts(context);
                              //
                              //               ApiServices().incrementProducts(
                              //                   mp.response[index].productId,
                              //                   dataIncrement[index].counter);
                              //
                              //               dataIncrement[index].isVisible =
                              //                   !dataIncrement[index].isVisible;
                              //               fetchMicroProducts();
                              //             },
                              //             child: Container(
                              //               width: 100,
                              //               decoration: BoxDecoration(
                              //                 borderRadius:
                              //                     BorderRadius.circular(2),
                              //                 border: Border.all(
                              //                     color: Color.fromRGBO(
                              //                         22, 2, 105, 1)),
                              //               ),
                              //               child: Text(
                              //                 "ADD",
                              //                 style: TextStyle(
                              //                     fontWeight: FontWeight.bold),
                              //               ),
                              //               height: 22,
                              //               alignment: Alignment.center,
                              //             ),
                              //           ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.start,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                "${mp.response[index].cartoon.toString()}/Cartoon | ${mp.response[index].stock <= 0 ? "0" : mp.response[index].stock.toString()} Stock",
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  letterSpacing: 1,
                                ),
                              ),
                              // Spacer(),
                              // Padding(
                              //   padding: const EdgeInsets.only(right: 25),
                              //   child: dataIncrement[index].priceTotal != 0
                              //       ? Text(
                              //           "Rs.${dataIncrement[index].priceTotal.toInt().toString()}"
                              //               .toString(),
                              //           style: GoogleFonts.dmSans(
                              //               fontWeight: FontWeight.bold),
                              //         )
                              //       : Container(),
                              // ),
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
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              letterSpacing: 0.5,
                                              fontSize: 13),
                                        ),
                                        Flexible(
                                          flex: 0,
                                          child: Text(
                                            "${mp.response[index].price.toInt().toString()}",
                                            style: GoogleFonts.dmSans(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                                letterSpacing: 0.5,
                                                fontSize: 13),
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
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Rs.",
                                          style: GoogleFonts.dmSans(
                                              letterSpacing: 0.5,
                                              color: Colors.grey,
                                              fontSize: 13),
                                        ),
                                        Text(
                                          "${mp.response[index].mrp.toInt().toString()}",
                                          style: GoogleFonts.dmSans(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey,
                                              fontSize: 13),
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
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  child: mp.response[index].inFavorits == true
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
                                      if (mp.response[index].inFavorits ==
                                          false) {
                                        mp.response[index].inFavorits = true;
                                      } else {
                                        mp.response[index].inFavorits = false;
                                      }
                                    });
                                    ApiServices().addAndDeleteToFavourite(
                                        mp.response[index].productId);
                                  },
                                ),
                                SizedBox(
                                  width: 20,
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
                                color: Colors.grey,
                                fontSize: 13,
                                letterSpacing: 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
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
        if (mp.response.length == index + 1)
          SizedBox(
            height: MediaQuery.of(context).size.height / 6.5,
          ),
        // storeIndexResponse.last.toString() != null
        // ? SizedBox(height: 100,)
        //     : SizedBox(
        //   height: 0,
        // ),
      ],
    );
  }

  addToWishList(String id) async {
    await Future.delayed(Duration(seconds: 1), () async {
      await ApiServices().addAndDeleteToFavourite(id);

      Fluttertoast.showToast(msg: "Successfully");
    });
  }
}
