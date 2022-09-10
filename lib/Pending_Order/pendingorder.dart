import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:jalaram/Connect_API/data_base.dart';
import 'package:jalaram/Home/bottomnavbar.dart';
import 'package:jalaram/Model/fetch_cart_item_model.dart';
import 'package:jalaram/Model/get_current_order_his_model.dart';
import 'package:jalaram/Model/local_database.dart';
import 'package:jalaram/Pending_Order/pending_order_detailpage.dart';
import 'package:jalaram/product_catalogue/products.dart';

import '../Connect_API/api.dart';

class TotalIncrementProduct {
  double totalPrice;
  TotalIncrementProduct({this.totalPrice});
}

class ConfirmOrderStoreNumber {
  String id;

  ConfirmOrderStoreNumber({this.id});
}

class PendingOrder extends StatefulWidget {
  const PendingOrder({Key key}) : super(key: key);

  @override
  _PendingOrderState createState() => _PendingOrderState();
}

class _PendingOrderState extends State<PendingOrder> {
  Icon customIcon = Icon(Icons.search);

  GetCurrentOrderHistory gcoh;

  bool isLoading = true;

  int totalValue = 0;

  List<TotalIncrementProduct> totalIncrementProduct;

  List<dynamic> listofitems = [];

  num storeMrp = 0;
  num storeTotal = 0;

  final totalPrice = [];
  final mrpPrice = [];

  Map<String,dynamic> decodedStore = {};

  List<double> storeTotalValueList = [];

  getHistoryOrder() async {
    // await Future.delayed(Duration(milliseconds: 300), () async {
    Response response = await ApiServices().getHistoryConfirmOrder(context);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      gcoh = GetCurrentOrderHistory.fromJson(decoded);
      print(decoded);
      decodedStore = decoded;
      print(decodedStore);
      totalValue = gcoh.response.length;

      print(storeMrp);
      refreshNotes();
      Fluttertoast.showToast(msg: "Confirm Order");
      setState(() {
        isLoading = true;
      });
    }
    // });
  }

  List<LocalStoreProductId> notes;

  bool isLoadingDB = false;

  Map<String, List<dynamic>> storeTotalValue = {};

  var mergeMapUnique = <String, dynamic>{};

  Future refreshNotes() async {
    setState(() {
      isLoadingDB = true;
    });
    notes = await LocalProductDetailsDataBase.instance.readAllNotes();
    print("length : ${notes.length}");

    for (int i = 0; i < notes.length; i++) {
      // print(gcoh.response[notes[i].productId][1]);
      storeTotalValueList.add(gcoh.response[notes[i].productId].last);
    }

    // for (num e in totalPrice) {
    //   storeTotal += e;
    // }
    print("storeTotal : $mergeMapUnique");
    setState(() {
      isLoadingDB = false;
    });
  }

  void initState() {
    super.initState();
    getHistoryOrder();
    refreshNotes();
  }

  Widget customSearchBar = Text(
    "My Orders",
    style: GoogleFonts.aBeeZee(
        color: Color.fromRGBO(22, 2, 105, 0.8),
        fontWeight: FontWeight.bold,
        fontSize: 18,
        letterSpacing: 1),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading == false
            ? CircularProgressIndicator()
            : notes.length != 0
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 13, top: 14, bottom: 10, right: 13),
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Color.fromRGBO(255, 78, 91, 1),
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "My Orders",
                              style: GoogleFonts.dmSans(
                                  color: Color.fromRGBO(255, 78, 91, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  letterSpacing: 2),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        flex: 1,
                        child: ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PendingOrderDetailPage(
                                              index: index,
                                              gcoh: gcoh,
                                              listOfId: notes[index].productId,
                                              id: notes[index].id),
                                    ));
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 13, right: 13),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              notes[index].productId,
                                              style: GoogleFonts.dmSans(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 1),
                                            ),
                                            Spacer(),
                                            Icon(Icons.location_on),
                                            Text(
                                              "Yogi Chowk(H.O.)",
                                              style: GoogleFonts.dmSans(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.6),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/rupee.png",
                                              height: 14.5,
                                              width: 14.5,
                                            ),
                                            isLoadingDB == false
                                                ? Text(
                                                    "${storeTotalValueList[index].toInt().toString()} | ${gcoh.response[notes[index].productId].length - 1} Product",
                                                    style: GoogleFonts.dmSans(
                                                        fontSize: 16,
                                                        letterSpacing: 0.6),
                                                  )
                                                : CircularProgressIndicator(),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "NEW ORDER",
                                              style: GoogleFonts.dmSans(
                                                color: Color.fromRGBO(
                                                    4, 75, 90, 1),
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              "${gcoh.response[notes[index].productId][0][0]['mark_datetime'].toString()}",
                                              style: GoogleFonts.dmSans(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 1,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1.5,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 14, bottom: 10),
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Color.fromRGBO(255, 78, 91, 1),
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "My Orders",
                              style: GoogleFonts.dmSans(
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
                      SizedBox(
                        height: 80,
                      ),
                      Image.asset(
                        "assets/pendingorderimage.jpg",
                        height: 250,
                        width: 250,
                      ),
                      Center(
                          child: Text(
                        "You have not placed any order",
                        style: GoogleFonts.dmSans(
                            color: Colors.grey, letterSpacing: 0.5),
                      )),
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BottomNavBar(),
                                    ));
                              },
                              child: Text(
                                "START SHOPPING",
                                style: GoogleFonts.dmSans(
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ],
                  ),
      ),
    );
  }
}
