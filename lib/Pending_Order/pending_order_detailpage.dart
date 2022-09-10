import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jalaram/Connect_API/api.dart';
import 'package:jalaram/Connect_API/data_base.dart';
import 'package:jalaram/Home/bottomnavbar.dart';
import 'package:jalaram/Model/get_current_order_his_model.dart';
import 'package:jalaram/Pending_Order/pendingorder.dart';

class PendingOrderDetailPage extends StatefulWidget {
  final int index;
  final int id;
  final GetCurrentOrderHistory gcoh;

  String listOfId;
  PendingOrderDetailPage(
      {this.index, this.gcoh, this.id, this.listOfId, Key key})
      : super(key: key);

  @override
  _PendingOrderDetailPageState createState() => _PendingOrderDetailPageState();
}

class _PendingOrderDetailPageState extends State<PendingOrderDetailPage> {
  num storeTotal = 0;
  int storeDiscount = 0;
  int payableAmount = 0;

  final subPrice = [];
  final mrpPrice = [];

  num storeMrp = 0;

  final totalPrice = [];

  num storeMrpValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loopForStoreValue();
  }

  loopForStoreValue() {
    List.generate(widget.gcoh.response[widget.listOfId].length - 1, (index) {
      mrpPrice.add(widget
              .gcoh.response[widget.listOfId][0][index]['product']['mrp']
              .toInt() *
          widget.gcoh.response[widget.listOfId][0][index]['count'].toInt());
      print("Mrp Price : $mrpPrice");
      totalPrice.add(widget
              .gcoh.response[widget.listOfId][0][index]['product']['price']
              .toInt() *
          widget.gcoh.response[widget.listOfId][0][index]['count']);
    });
    for (num e in mrpPrice) {
      storeMrp += e;
    }
    for (num e in totalPrice) {
      storeTotal += e;
    }
    setState(() {
      isLoading = true;
    });
    print(storeMrp);
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 13, top: 14, right: 13),
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
                                  "${widget.listOfId}",
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
                              color: Color.fromRGBO(4, 75, 90, 1),
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
                        "${widget.gcoh.response[widget.listOfId][0][0]['mark_datetime']}",
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
                              bool isActive = false;
                              setState(() {
                                isActive = true;
                              });
                              await LocalProductDetailsDataBase.instance
                                  .delete(widget.id);
                              ApiServices()
                                  .cancelConfirmOrder(context, widget.listOfId);

                              setState(() {
                                isActive = false;
                              });


                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => BottomNavBar(),
                              //   ),
                              // );
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
                      Flexible(
                        flex: 0,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:
                                widget.gcoh.response[widget.listOfId].length -
                                    1,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                // width: MediaQuery.of(context).size.width,
                                // height: MediaQuery.of(context).size.height,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          "${widget.gcoh.urls.image}/${widget.gcoh.response[widget.listOfId][0][index]['product']['banner']['media']}",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              flex: 0,
                                              child: Text(
                                                widget.gcoh.response[
                                                        widget.listOfId][0]
                                                    [index]['product']['title'],
                                                style: GoogleFonts.dmSans(
                                                    fontSize: 18.4),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  13,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      "assets/rupee.png",
                                                      height: 13.5,
                                                      width: 13.5,
                                                      color: Colors.black45,
                                                    ),
                                                    Flexible(
                                                      flex: 0,
                                                      child: Text(
                                                        "${widget.gcoh.response[widget.listOfId][0][index]['product']['price'].toInt().toString()} x ",
                                                        style:
                                                            GoogleFonts.dmSans(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black45,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                        softWrap: false,
                                                      ),
                                                    ),
                                                    Text(
                                                      widget
                                                          .gcoh
                                                          .response[widget
                                                                  .listOfId][0]
                                                              [index]['count']
                                                          .toInt()
                                                          .toString(),
                                                      style: GoogleFonts.dmSans(
                                                          fontSize: 12,
                                                          color: Colors.black45,
                                                          fontWeight:
                                                              FontWeight.w700),
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
                                                    SizedBox(
                                                      width: 65,
                                                      child: Text(
                                                        "${widget.gcoh.response[widget.listOfId][0][index]['product']['price'].toInt() * widget.gcoh.response[widget.listOfId][0][index]['count']}",
                                                        style:
                                                            GoogleFonts.dmSans(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "${widget.gcoh.response[widget.listOfId][0][index]['count'].toString()} Qty",
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
                                                      widget
                                                          .gcoh
                                                          .response[widget
                                                                  .listOfId][0]
                                                              [index]['product']
                                                              ['price']
                                                          .toInt()
                                                          .toString(),
                                                      style: GoogleFonts.dmSans(
                                                          fontSize: 13,
                                                          color: Colors.black45,
                                                          fontWeight:
                                                              FontWeight.w700),
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
                                                      "${widget.gcoh.response[widget.listOfId][0][index]['product']['mrp'].toInt() * widget.gcoh.response[widget.listOfId][0][index]['count'].toInt()}"
                                                          .toString(),
                                                      style: GoogleFonts.dmSans(
                                                          fontSize: 13,
                                                          color: Colors.black45,
                                                          fontWeight:
                                                              FontWeight.w700),
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
                                                  "${widget.gcoh.response[widget.listOfId][0][index]['product']['discount_percentage'].toInt().toString()}% OFF",
                                                  style: GoogleFonts.dmSans(
                                                      color: Color.fromRGBO(
                                                          4, 75, 90, 1),
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                    ),
                                    // Flexible(
                                    //   flex: 1,
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.only(left: 0),
                                    //     child: Column(
                                    //       children: [
                                    //         Row(
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment.start,
                                    //           children: [
                                    //             Image.asset(
                                    //               "assets/rupee.png",
                                    //               height: 13.5,
                                    //               width: 13.5,
                                    //               color: Colors.black45,
                                    //             ),
                                    //             Text(
                                    //               "${widget.gcoh.response[widget.listOfId][index].product.price.toInt().toString()} x ",
                                    //               style: GoogleFonts.dmSans(
                                    //                   fontSize: 12,
                                    //                   color: Colors.black45,
                                    //                   fontWeight:
                                    //                       FontWeight.w700),
                                    //             ),
                                    //             Text(
                                    //               widget
                                    //                   .gcoh
                                    //                   .response[widget.listOfId]
                                    //                       [index]
                                    //                   .count
                                    //                   .toString(),
                                    //               style: GoogleFonts.dmSans(
                                    //                   fontSize: 12,
                                    //                   color: Colors.black45,
                                    //                   fontWeight:
                                    //                       FontWeight.w700),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         SizedBox(
                                    //           height: 8,
                                    //         ),
                                    //         Row(
                                    //           children: [
                                    //             Image.asset(
                                    //               "assets/rupee.png",
                                    //               height: 13.5,
                                    //               width: 13.5,
                                    //               color: Colors.black,
                                    //             ),
                                    //             Text(
                                    //               "${widget.gcoh.response[widget.listOfId][index].product.price.toInt() * widget.gcoh.response[widget.listOfId][widget.index].count}",
                                    //               style: GoogleFonts.dmSans(
                                    //                   fontSize: 16,
                                    //                   color: Colors.black,
                                    //                   fontWeight:
                                    //                       FontWeight.w500),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              );
                            },
                          ),
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
                                storeMrp.toInt().toString(),
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
                                "${storeMrp.toInt() - storeTotal.toInt()}",
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
                                "${storeTotal.toInt()}",
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
                                  color: Color.fromRGBO(4, 75, 90, 1),
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
}
