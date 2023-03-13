import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jalaram/Connect_API/api.dart';
import 'package:jalaram/Connect_API/data_base.dart';
import 'package:jalaram/Home/bottomnavbar.dart';
import 'package:jalaram/Model/get_current_order_details_model.dart';
import 'package:jalaram/Model/get_current_order_his_model.dart';
import 'package:jalaram/Pending_Order/pendingorder.dart';
import 'package:jalaram/component/back_button.dart';

class PendingOrderDetailPage extends StatefulWidget {
  final String id;
  PendingOrderDetailPage({this.id, Key key}) : super(key: key);

  @override
  _PendingOrderDetailPageState createState() => _PendingOrderDetailPageState();
}

class _PendingOrderDetailPageState extends State<PendingOrderDetailPage> {
  OrderDetailsModel odm;

  var mrpPrice = [];

  num mrpsum = 0;
  num totalMrpsum = 0;

  getOrderDetailsApi() async {
    // await Future.delayed(Duration(milliseconds: 300), () async {
    final response =
        await ApiServices().getOrderDetails(context, widget.id.toString());
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      odm = OrderDetailsModel.fromJson(decoded);
      List.generate(odm.response.orders.length, (index) {
        mrpPrice.add(odm.response.orders[index].mrp *
            odm.response.orders[index].quantity);
      });
      for (num e in mrpPrice) {
        mrpsum += e;
      }
      totalMrpsum = mrpsum.toInt();
      print(decoded);
      setState(() {
        isLoading = true;
      });
    }
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    getOrderDetailsApi();
    super.initState();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 9, top: 14, right: 9),
          child: isLoading == false
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                            "Orders Details",
                            style: GoogleFonts.dmSans(
                                color: Color.fromRGBO(255, 78, 91, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                letterSpacing: 2),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ORDER ID",
                                  style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      color: Colors.black54,
                                      letterSpacing: 0.5),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "${widget.id}",
                                  style: GoogleFonts.dmSans(
                                      fontSize: 22,
                                      color: Colors.black,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 78, 91, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "NEW ORDER",
                              style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  color: Colors.white,
                                  letterSpacing: 1),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        "ORDER ON",
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          color: Colors.black54,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        "${odm.response.markDatetime}",
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          color: Colors.black,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        "ORDER STORE",
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          color: Colors.black54,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        "Yogi Chowk(H.O)",
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          color: Colors.black,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 28,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "PRODUCT DETAIL",
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              color: Colors.black,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              showDilogE(
                                context: context,
                              );
                            },
                            child: Text(
                              "Cancel Order",
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                color: Colors.red,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: odm.response.orders.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  // height: MediaQuery.of(context).size.height,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            "${odm.urls.image}/${odm.response.orders[index].banner.media}",
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: allWidget(index),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.black54,
                                  thickness: 0.6,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Amount",
                            style: GoogleFonts.dmSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                "assets/rupee.png",
                                height: 14.5,
                                width: 14.5,
                                color: Colors.black,
                              ),
                              Text(
                                totalMrpsum.toInt().toString(),
                                style: GoogleFonts.dmSans(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Discount",
                            style: GoogleFonts.dmSans(
                              fontSize: 18,
                              color: Color.fromRGBO(4, 75, 90, 1),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "-",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Color.fromRGBO(4, 75, 90, 1),
                                ),
                              ),
                              Image.asset(
                                "assets/rupee.png",
                                height: 14.5,
                                width: 14.5,
                                color: Color.fromRGBO(4, 75, 90, 1),
                              ),
                              Text(
                                "${totalMrpsum.toInt() - odm.response.totalPrice.toInt()}",
                                style: GoogleFonts.dmSans(
                                    fontSize: 18,
                                    color: Color.fromRGBO(4, 75, 90, 1),
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Payable Amount",
                            style: GoogleFonts.dmSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                "assets/rupee.png",
                                height: 14.5,
                                width: 14.5,
                                color: Colors.black,
                              ),
                              Text(
                                "${odm.response.totalPrice.ceilToDouble().toInt()}",
                                style: GoogleFonts.dmSans(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "PickUp your order within 24 hours. It will be auto canceled after 24 hours of your order time",
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Divider(
                        thickness: 1.4,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "STATUS HISTORY",
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.7,
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                width: 5,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Container(
                                height: 14,
                                width: 14,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(255, 78, 91, 1),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "NEW ORDER PLACED",
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Spacer(),
                          // Text(
                          //   "${widget.gcoh.response[widget.listOfId][0].markDatetime.substring(11, 16)}",
                          //   style: GoogleFonts.dmSans(
                          //     fontSize: 16,
                          //     color: Colors.grey,
                          //     fontWeight: FontWeight.w700,
                          //     letterSpacing: 0.5,
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Column allWidget(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width/1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 150,
                child: Text(
                  odm.response.orders[index].productName,
                  style: GoogleFonts.dmSans(fontSize: 14),
                ),
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/rupee.png",
                        height: 13.5,
                        width: 13.5,
                        color: Colors.black45,
                      ),
                      Text(
                        (odm.response.orders[index].price % 1 == 0)?"${odm.response.orders[index].price.toInt()} x ":"${odm.response.orders[index].price} x ",
                        style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: Colors.black45,
                            fontWeight: FontWeight.w700),
                        softWrap: false,
                      ),
                      Text(
                        odm.response.orders[index].quantity
                            .toInt()
                            .toString(),
                        style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: Colors.black45,
                            fontWeight: FontWeight.w700),
                        softWrap: false,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/rupee.png",
                        height: 13.5,
                        width: 13.5,
                        color: Colors.black,
                      ),
                      (odm.response.orders[index].price % 1) == 0
                      ? SizedBox(
                        width: 65,
                        child: Text(
                          "${odm.response.orders[index].price.toInt() * odm.response.orders[index].quantity.toInt()}",
                          style: GoogleFonts.dmSans(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ):SizedBox(
                        width: 65,
                        child: Text(
                          "${odm.response.orders[index].price * odm.response.orders[index].quantity.toInt()}",
                          style: GoogleFonts.dmSans(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "${odm.response.orders[index].quantity} Qty",
          style: GoogleFonts.dmSans(
              fontSize: 16.4,
              color: Colors.black45,
              fontWeight: FontWeight.bold),
        ),
        Flexible(
          flex: 0,
          child: Row(
            children: [
              Flexible(
                flex: 0,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/rupee.png",
                      height: 13.5,
                      width: 13.5,
                      color: Colors.black45,
                    ),
                    Text(
                      (odm.response.orders[index].price % 1 == 0)?odm.response.orders[index].price.toInt().toString():odm.response.orders[index].price.toString(),
                      style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: Colors.black45,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Flexible(
                flex: 0,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/rupee.png",
                      height: 13.5,
                      width: 13.5,
                      color: Colors.black45,
                    ),
                    Text(
                      "${odm.response.orders[index].mrp.toInt() * odm.response.orders[index].quantity}"
                          .toString(),
                      style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: Colors.black45,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Flexible(
                flex: 0,
                child: Text(
                  "${odm.response.orders[index].discount.toInt().toString()}% OFF",
                  style: GoogleFonts.dmSans(
                      color: Color.fromRGBO(4, 75, 90, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
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
            "Are you sure you want cancel this order?",
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
                  "No",
                  style:
                      GoogleFonts.dmSans(color: Color.fromRGBO(255, 78, 91, 1),),
                ),
              ),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Color.fromRGBO(255, 78, 91, 1), width: 1.5),
                borderRadius: BorderRadius.circular(5),
              ),
              height: 40,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  openAndCloseLoadingDialog(context: context);
                  await ApiServices().cancelConfirmOrder(context, widget.id);
                },
                child: Text(
                  "Yes",
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
}
