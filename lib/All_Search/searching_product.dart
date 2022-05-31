import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:jalaram/Model/searching_product_model.dart';

import '../Connect_API/api.dart';
import '../product_catalogue/productdetails.dart';

class SearchingProduct extends StatefulWidget {
  const SearchingProduct({Key key}) : super(key: key);

  @override
  _SearchingProductState createState() => _SearchingProductState();
}

class _SearchingProductState extends State<SearchingProduct> {
  SearchProductModel spm;

  bool isLoading = true;

  String text = "";

  fetchSearchingProduct(String key) async {
    // await Future.delayed(Duration(milliseconds: 100), () async {
    Response response = await ApiServices().searchProducts(context, key);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      spm = SearchProductModel.fromJson(decoded);

      setState(() {
        isLoading = true;
      });
    }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios_rounded)),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        fetchSearchingProduct(value);
                      });
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.zero,
                            bottomRight: Radius.zero,
                            topLeft: Radius.circular(2),
                            bottomLeft: Radius.circular(2)),
                        borderSide: BorderSide(
                          color: Colors.grey[500],
                          width: 1.1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.zero,
                            bottomRight: Radius.zero,
                            topLeft: Radius.circular(2),
                            bottomLeft: Radius.circular(2)),
                        borderSide:
                            BorderSide(color: Colors.grey[500], width: 1.1),
                      ),
                      hintText: "Search your daily product",
                      hintStyle: GoogleFonts.dmSans(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                          letterSpacing: 0.5),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade500,
                      ),
                      hintTextDirection: TextDirection.ltr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.zero,
                            bottomRight: Radius.zero,
                            topLeft: Radius.circular(2),
                            bottomLeft: Radius.circular(2)),
                        borderSide: BorderSide(color: Colors.white, width: 1.1),
                      ),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                )),
              ],
            ),
            Divider(
              thickness: 9,
              color: Colors.grey.shade300,
            ),
            isLoading == true
                ? spm != null
                    ? Expanded(
                        child: ListView.builder(
                          itemCount:
                              spm.response == null ? 0 : spm.response.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
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
                                        SizedBox(
                                          height: 10,
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
                                          // child: Image.network(
                                          //   "",
                                          // ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 0.8),
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
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  spm.response[index].title
                                                              .length >
                                                          30
                                                      ? Text(
                                                          "${spm.response[index].title.toUpperCase()}...",
                                                          style: GoogleFonts
                                                              .dmSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black),
                                                        )
                                                      : Text(
                                                          "${spm.response[index].title.toUpperCase()}",
                                                          style: GoogleFonts
                                                              .dmSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 5),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "${spm.response[index].category}",
                                                          style: GoogleFonts
                                                              .dmSans(

                                                                  // fontWeight: FontWeight.bold,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                        Spacer(),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "${spm.response[index].cartoon.toString()}/Cartoon | ${spm.response[index].stock.toString()} Stock",
                                                    style: GoogleFonts.dmSans(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            "assets/rupee.png",
                                                            width: 10,
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            "${spm.response[index].price.toInt().toString()}",
                                                            style: GoogleFonts.dmSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black87,
                                                                fontSize: 13),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Image.asset(
                                                            "assets/rupee.png",
                                                            width: 10,
                                                            height: 10,
                                                            color: Colors.grey,
                                                          ),
                                                          Text(
                                                            "${spm.response[index].mrp.toInt().toString()}",
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
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        "${spm.response[index].discountPercentage.toInt().toString()}% OFF",
                                                        style:
                                                            GoogleFonts.dmSans(
                                                                color: Colors
                                                                    .green[700],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 13),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              ),
                                              Positioned(
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      8,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      8,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 10,
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                        ),
                                        onTap: () {
                                          String productId = spm.response[index].productId;
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => ProductDetails(
                                              productId:
                                              spm.response[index].productId,
                                            ),
                                          ));
                                          ApiServices().microProductDetails(productId, context);
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
                              ],
                            );
                          },
                        ),
                      )
                    : Container()
                : Container(),
          ],
        ),
      ),
    );
  }
}
