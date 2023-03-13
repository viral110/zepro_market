import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/avd.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart';
import 'package:jalaram/Connect_API/api.dart';
import 'package:jalaram/Data_Provider/data_provider.dart';

import 'package:jalaram/Model/fetch_order_id.dart';
import 'package:jalaram/Model/micro_product_details.dart';
import 'package:jalaram/add_to_cart_part/add_to_cart_page.dart';
import 'package:jalaram/component/back_button.dart';
import 'package:jalaram/product_catalogue/image_zoom.dart';
import 'package:modern_form_esys_flutter_share/modern_form_esys_flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:video_player/video_player.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';

import '../Model/fetch_cart_item_model.dart';
// import 'package:modern_form_esys_flutter_share/modern_form_esys_flutter_share.dart';

VideoPlayerController _videoPlayerController;

Future<void> _initializedVideoPlayer;

BuildContext buildContextNew;

BuildContext buildContextForImage;

BuildContext buildContextForVideo;

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

extension CapExtension on String {
  String get capitalizeFirstofEach =>
      this.split(" ").map((str) => str.capitalize()).join(" ");
}

class ShowstatusBool {
  bool isVisible;
  ShowstatusBool({this.isVisible});
}

class ProductDetails extends StatefulWidget {
  final String productId;
  final VoidCallback productFunc;
  final int number;

  ProductDetails({this.productId, this.productFunc, this.number});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails>
    with WidgetsBindingObserver {
  PageController controller = PageController();
  // Color color = Colors.grey;

  bool isLoading = false;
  bool isVisibleadd;

  MicroProductDetails mpd;

  FetchAddToCartItem fMyCart;

  int cartNumber;

  bool end = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (valueDesc == true && valueImage == false && valueVideo == false) {
    } else {
      if (state == AppLifecycleState.resumed) {
        if (valueDesc) {
          setState(() {
            stringDesc = true;
          });
        }
        if (stringDesc) {
          RegExp exp =
              RegExp(r'<[^>]*>|&[^;]+;', multiLine: true, caseSensitive: true);

          String h1 =
              "*${mpd.response.title}*\n\n*${mpd.response.description.replaceAll(exp, '')}* \n\n*Price Rs.$sharePrice*";
          String h2 =
              "*${mpd.response.title}*${mpd.response.description.replaceAll(exp, '')} \n*Price Rs.$percentPrice*";

          Share.text("helloWorld", h1, 'text/plain');
          stringDesc = false;
          valueDesc = false;
          valueImage = false;
          valueVideo = false;
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  void initState() {
    fetchMicroProductDetails();

    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (isLoading == true) {
        if (currentPageValue == mpd.response.banners.length) {
          end = true;
        } else if (currentPageValue == 0) {
          end = false;
        }
      }

      if (end == false) {
        currentPageValue++;
      } else {
        currentPageValue--;
      }

      controller.animateToPage(
        currentPageValue,
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeIn,
      );
    });
    // if(_videoPlayerController.value.isPlaying){
    //   _videoPlayerController.pause();
    // }
  }

  List<String> storeVideo = [];
  List<String> storeImage = [];
  List<ProductDetailsAddCart> pdAddcart = [];

  dynamic x;

  fetchAddToCartItem() async {
    // await Future.delayed(Duration(milliseconds: 500), () async {
    final response = await ApiServices().fetchAddToCartItem(context);
    var decoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      fMyCart = FetchAddToCartItem.fromJson(decoded);
      // Fluttertoast.showToast(msg: "Fetch Add to Cart");
    }
    // });
  }

  fetchMicroProductDetails() async {
    // await Future.delayed(Duration(milliseconds: 100), () async {
    Response response =
        await ApiServices().microProductDetails(widget.productId, context);
    var decoded = jsonDecode(response.body);
    debugPrint("Decoded : ${decoded.toString()}");
    if (response.statusCode == 200) {
      mpd = MicroProductDetails.fromJson(decoded);
      debugPrint("MPD : ${mpd.status}");
      cartNumber = mpd.response.inCart;
      isVisibleadd = mpd.response.cartStatus;

      ShowstatusBool(isVisible: mpd.response.cartStatus);
      x = ProductDetailsAddCart(
          isVisible: mpd.response.cartStatus, number: mpd.response.inCart);
      for (int i = 0; i < mpd.response.banners.length; i++) {
        if (mpd.response.banners[i].mediaType == "image") {
          storeImage.add("${mpd.urls.image}/${mpd.response.banners[i].media}");
        }
        if (mpd.response.banners[i].mediaType == "video") {
          storeVideo.add(mpd.response.banners[i].media);
          print("${mpd.urls.video}/${mpd.response.banners[i].media}");
          print(mpd.response.banners[i].media);
        }
      }

      setState(() {
        isLoading = true;
      });
    }
    // });
  }

  bool stringDesc = false;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _videoPlayerController?.dispose();

    super.dispose();

    // print("******* oooooo ******");
  }

  TextEditingController priceDescController = TextEditingController();
  TextEditingController percentDescController = TextEditingController();
  TextEditingController addMultipleController = TextEditingController();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  int currentPageValue = 0;

  bool onTapHeart = false;
  bool valueImage = false;
  bool valueDesc = false;
  bool valueVideo = false;

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  Future _refresh() {
    return fetchMicroProductDetails();
  }

  Map<String, TextStyle> styleText = {"hello": GoogleFonts.dmSans()};

  bool isFavouriteBtn = false;

  int addToCartProductInCart = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _refresh,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          // fetchMicroProducts();
                          if (widget.number == 0) {
                            widget.productFunc();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            BackButtonCustom(),
                            Spacer(),
                            mpd.response.inFavorits == true
                                ? IconButton(
                                    onPressed: () {
                                      if (mpd.response.inFavorits == true) {
                                        showDilogE(context: context);
                                      } else {
                                        setState(() {
                                          mpd.response.inFavorits = true;
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ))
                                : IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        isFavouriteBtn = true;
                                      });
                                      if (mpd.response.inFavorits == true) {
                                        showDilogE(context: context);
                                      } else {
                                        Future.delayed(
                                          Duration(seconds: 1),
                                          () {
                                            setState(() {
                                              mpd.response.inFavorits = true;

                                              ApiServices()
                                                  .addAndDeleteToFavourite(
                                                      mpd.response.productId);
                                            });
                                            setState(() {
                                              isFavouriteBtn = false;
                                            });
                                          },
                                        );
                                      }
                                    },
                                    icon: isFavouriteBtn == false
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
                                              backgroundColor:
                                                  Colors.grey.shade400,
                                            ),
                                          ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: IconButton(
                                  onPressed: () {
                                    return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return shareImagesAndVideoUsingDialog();
                                      },
                                    );
                                    // showPopUpForDesc("0");
                                  },
                                  icon: Icon(
                                    Icons.share_sharp,
                                    size: 18,
                                  )),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 0,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 4,
                              child: PageView.builder(
                                controller: controller,
                                onPageChanged: (value) {
                                  setState(() {
                                    currentPageValue = value;
                                  });
                                },
                                itemCount: mpd.response.banners.length,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ImageZoom(
                                              index: index,
                                              linkImage: mpd.urls.image,
                                              linkVideo: mpd.urls.video,
                                              url: mpd.response.banners,
                                              imageLinkLength:
                                                  storeImage.length,
                                              mediaTypeZoom: mpd.response
                                                  .banners[index].mediaType),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child: mpd.response.banners[index]
                                                  .mediaType ==
                                              "image"
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                // padding: EdgeInsets.all(50),
                                                margin: EdgeInsets.only(
                                                  top: 20,

                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        4,
                                                    right:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            4),

                                                // width: MediaQuery.of(context).size.width / 2,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                        "${mpd.urls.image}/${mpd.response.banners[index].media}"),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.orangeAccent,
                                              ),
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 24,
                                                child: Icon(Icons.play_arrow,
                                                    size: 32),
                                              ),
                                            ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            // Container(
                            //   height: 300,
                            //   width: MediaQuery.of(context).size.width,
                            //   child: FutureBuilder(
                            //       future: _initializedVideoPlayer,
                            //       builder: (context, snapshot) {
                            //         if (snapshot.connectionState ==
                            //             ConnectionState.done) {
                            //           return AspectRatio(
                            //             aspectRatio: _videoPlayerController
                            //                 .value.aspectRatio,
                            //             child:
                            //                 VideoPlayer(_videoPlayerController),
                            //           );
                            //         } else {
                            //           return Center(
                            //             child: CircularProgressIndicator(),
                            //           );
                            //         }
                            //       }),
                            // ),
                            Container(
                              margin: EdgeInsets.only(bottom: 5, top: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  for (int i = 0;
                                      i < mpd.response.banners.length;
                                      i++)
                                    if (i == currentPageValue) ...{
                                      circleBar(true,
                                          mpd.response.banners[i].mediaType),
                                    } else
                                      circleBar(false,
                                          mpd.response.banners[i].mediaType),
                                ],
                              ),
                            ),
                            // Text("zocro ecommerce",style: TextStyle(fontFamily: 'Apple',fontSize: 20),),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          mpd.response.title
                                              .toUpperCase(),
                                          style: GoogleFonts.dmSans(
                                            fontSize: 15,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "${mpd.response.category}",
                                    style: GoogleFonts.dmSans(
                                        fontSize: 13.5,
                                        color: Colors.grey,
                                        letterSpacing: 2.5),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          // Image.asset(
                                          //   "assets/rupee.png",
                                          //   width: 12,
                                          //   height: 12,
                                          // ),
                                          Text(
                                            "Rs.",
                                            style: GoogleFonts.dmSans(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                                letterSpacing: 1,
                                                fontSize: 15),
                                          ),
                                          (mpd.response.price % 1) == 0
                                          ? Text(
                                            "${mpd.response.price.toInt().toString()}",
                                            style: GoogleFonts.dmSans(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                                letterSpacing: 1,
                                                fontSize: 15),
                                          ):Text(
                                            "${mpd.response.price}",
                                            style: GoogleFonts.dmSans(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                                letterSpacing: 1,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Rs.",
                                            style: GoogleFonts.dmSans(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                letterSpacing: 1,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            "${mpd.response.mrp.toInt().toString()}",
                                            style: GoogleFonts.dmSans(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.grey,
                                                letterSpacing: 1,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "${mpd.response.discountPercentage.toInt().toString()}% OFF",
                                        style: GoogleFonts.dmSans(
                                            color: Colors.green[700],
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                            fontSize: 15),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text:
                                                mpd.response.cartoon.toString(),
                                            style: GoogleFonts.dmSans(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text: ' Items/Cartoon',
                                            style: GoogleFonts.dmSans(
                                                color: Colors.grey.shade600,
                                                letterSpacing: 1.5),
                                          ),
                                        ]),
                                      ),
                                      mpd.response.stock >= cartNumber
                                          ? cartNumber != 0
                                              ? Container(
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                          onTap: () async {
                                                            await ApiServices()
                                                                .decrementProducts(
                                                                    mpd.response
                                                                        .productId,
                                                                    1,
                                                                    context);

                                                            setState(() {
                                                              ApiServices()
                                                                  .microProductDetails(
                                                                      mpd.response
                                                                          .productId,
                                                                      context);
                                                            });
                                                            if (cartNumber <
                                                                2) {
                                                              await fetchAddToCartItem();
                                                              setState(() {

                                                                cartNumber = 0;
                                                              });


                                                            } else {
                                                              cartNumber--;
                                                            }

                                                            debugPrint(
                                                                "Decrement che : $cartNumber");
                                                            // Fluttertoast.showToast(msg: "Product Decrement : ${dataIncrement[index].counter--}");
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(9.0),
                                                            child: Icon(
                                                              Icons.remove,
                                                              size: 20,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            addMultipleController
                                                                    .text =
                                                                cartNumber
                                                                    .toString();
                                                            showDialogForAddMultiple(
                                                                context);
                                                          });

                                                        },
                                                        child: Text(
                                                          "${cartNumber.toString()}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      mpd.response.stock <=
                                                              cartNumber
                                                          ? Container()
                                                          : GestureDetector(
                                                              onTap: () async {
                                                                setState(() {
                                                                  cartNumber++;
                                                                });
                                                                await ApiServices()
                                                                    .incrementProducts(
                                                                        mpd.response
                                                                            .productId,
                                                                        1);
                                                                await ApiServices()
                                                                    .getWishListProducts(
                                                                        context);
                                                                debugPrint(
                                                                    "Increment che : $cartNumber");
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        9.0),
                                                                child: Icon(
                                                                  Icons.add,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .white,
                                                                ),
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
                                                    color: Color.fromRGBO(255, 78, 91, 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                  ),
                                                  // width: 65,
                                                  height: 35,
                                                )
                                              : mpd.response.stock <= cartNumber
                                                  ? Container()
                                                  : Container(
                                                      width: 65,
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(255, 78, 91, 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2),
                                                        // border: Border.all(
                                                        //     color: Color.fromRGBO(
                                                        //         22, 2, 105, 1)),
                                                      ),
                                                      child: InkWell(
                                                        child: Text(
                                                          "ADD",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              letterSpacing: 1,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        onTap: () async {
                                                          setState(() {
                                                            // isVisibleadd = !isVisibleadd;
                                                            loadAddProduct =
                                                                true;
                                                            cartNumber = 1;
                                                          });
                                                          await ApiServices()
                                                              .incrementProducts(
                                                                  mpd.response
                                                                      .productId,
                                                                  1);
                                                          await ApiServices()
                                                              .fetchAddToCartItem(
                                                                  context);
                                                          print("+++");

                                                          setState(() {});
                                                        },
                                                      ),
                                                      height: 35,
                                                      alignment:
                                                          Alignment.center,
                                                    )
                                          : Container(),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 80,
                                      width: 170,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Color.fromRGBO(255, 78, 91, 1),
                                            width: 1),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          mpd.response.stock != 0 &&
                                                  mpd.response.stock >= 0
                                              ? Text(
                                                  "${mpd.response.stock}",
                                                  style: GoogleFonts.dmSans(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              : Container(),
                                          mpd.response.stock <= 0
                                              ? Text(
                                                  "Out Of Stock",
                                                  style: GoogleFonts.dmSans(
                                                      fontSize: 18,
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.5),
                                                )
                                              : Text(
                                                  "In Stock",
                                                  style: GoogleFonts.dmSans(
                                                      fontSize: 20,
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.5),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Product Details : ",
                                    style: GoogleFonts.dmSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black,
                                        letterSpacing: 1.5),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 60),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Weight",
                                              style: GoogleFonts.dmSans(
                                                color: Colors.grey.shade600,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Dimension(L * B * H)",
                                              style: GoogleFonts.dmSans(
                                                color: Colors.grey.shade600,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "HSN Code : ",
                                              style: GoogleFonts.dmSans(
                                                color: Colors.grey.shade600,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            mpd.response.weight != 0.0
                                                ? Text(
                                              "${ mpd.response.weight}",
                                              style: GoogleFonts.dmSans(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),

                                            ): Padding(
                                              padding: const EdgeInsets.only(left: 25),
                                              child: Text(
                                                "-",
                                                style: GoogleFonts.dmSans(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                ),

                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            mpd.response.dimensions != ""
                                            ? Text(
                                              "${mpd.response.dimensions}",
                                              style: GoogleFonts.dmSans(
                                                color: Colors.black,
                                                letterSpacing: 1.5,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ): Padding(
                                              padding: const EdgeInsets.only(left: 25),
                                              child: Text(
                                                "-",
                                                style: GoogleFonts.dmSans(
                                                  color: Colors.black,
                                                  letterSpacing: 1.5,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${mpd.response.hsn}-${mpd.response.gst == null ? '0' : mpd.response.gst}%",
                                              style: GoogleFonts.dmSans(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "About Product : ",
                                        style: GoogleFonts.dmSans(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2,
                                            fontSize: 18),
                                      ),
                                      InkWell(
                                          onTap: () async {
                                            Clipboard.setData(ClipboardData(
                                                    text: removeAllHtmlTags(
                                                        mpd.response
                                                            .description,
                                                        1,
                                                        true)))
                                                .then((value) {
                                              setState(() {
                                                Fluttertoast.showToast(
                                                    msg: "Copied");
                                              });
                                            });

                                            // FlutterClipboard.copy(removeAllHtmlTags(mpd.response.description,1)).then(( value ) => print('copied'));
                                          },
                                          child: Icon(Icons.copy)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Flexible(
                                    flex: 0,
                                    child: mpd.response.description != null
                                        ? Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Html(
                                              shrinkWrap: true,
                                              style: {
                                                "h1": Style(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                "p": Style(
                                                    // fontFamily: 'Apple',
                                                    ),
                                              },
                                              data:
                                                  """${mpd.response.description}""",
                                            ),
                                          )
                                        : Container(child: Text("-")),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Product Gallery : ",
                                    style: GoogleFonts.dmSans(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Flexible(
                                    flex: 0,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: mpd.response.gallery.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Image.network(
                                                "${mpd.urls.image}/${mpd.response.gallery[index].media}",
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  mpd.response.youtubeLink == ""
                                      ? Container()
                                      : RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: "Youtube Link : ",
                                                  style: GoogleFonts.aBeeZee(
                                                      color: Colors.black,
                                                      fontSize: 16)),
                                              TextSpan(
                                                text: mpd.response.youtubeLink,
                                                style: GoogleFonts.aBeeZee(
                                                    color: Colors.blue,
                                                    fontSize: 16,
                                                    decoration: TextDecoration
                                                        .underline),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        launch(mpd.response
                                                            .youtubeLink);
                                                      },
                                              ),
                                            ],
                                          ),
                                        ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Provider.of<DataProvider>(context, listen: false)
                      .fetchAddToCartItem !=
                  null &&
              Provider.of<DataProvider>(context, listen: false)
                  .fetchAddToCartItem
                  .cart
                  .isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(13.0),
              child: Card(
                elevation: 4,
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 78, 91, 1),
                    // border: Border.all(width: 1.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Cart : ${Provider.of<DataProvider>(context, listen: false).fetchAddToCartItem.cart.length.toString()} Items",
                            style: GoogleFonts.dmSans(
                                color: Colors.white, fontSize: 16),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddToCartPage(
                                    productId: mpd.response.productId,
                                    isActiveBack: true,
                                    productDetailFunc: fetchMicroProductDetails,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.white),
                              ),
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "VIEW CART",
                                style: GoogleFonts.dmSans(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Container(),
    );
  }

  String categoryShare = "";

  Widget shareImagesAndVideoUsingDialog() {
    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "What do you want to share?",
              style: GoogleFonts.dmSans(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    child: Radio(
                      value: "Images",
                      groupValue: categoryShare,
                      activeColor: Color.fromRGBO(255, 78, 91, 1),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (value) {
                        setState(() {
                          categoryShare = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Images",
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
                      value: "Videos",
                      groupValue: categoryShare,
                      activeColor: Color.fromRGBO(255, 78, 91, 1),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (value) {
                        setState(() {
                          categoryShare = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Videos",
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
                      value: "Images&Videos",
                      groupValue: categoryShare,
                      activeColor: Color.fromRGBO(255, 78, 91, 1),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (value) {
                        setState(() {
                          categoryShare = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Images & Videos",
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
                      value: "Description",
                      groupValue: categoryShare,
                      activeColor: Color.fromRGBO(255, 78, 91, 1),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (value) {
                        setState(() {
                          categoryShare = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Description",
                    style: GoogleFonts.dmSans(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Color.fromRGBO(255, 78, 91, 1), width: 1.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.dmSans(fontSize: 16,color: Color.fromRGBO(255, 78, 91, 1)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isPrepareImage = true;
                    });
                    if (categoryShare == "Images") {
                      imageShare(0);
                      if (isLoadingAllContent) {
                        return showDialog(
                          context: context,
                          builder: (context) {
                            buildContextForImage = context;
                            return showDialogForProcessImageAndVideo(context,
                                isLoadingAllContent, storeImage.length);
                          },
                        );
                      }
                    } else if (categoryShare == "Videos") {
                      videoShare(0);
                      if (isLoadingAllContent) {
                        return showDialog(
                          context: context,
                          builder: (context) {
                            buildContextForVideo = context;
                            return showDialogForProcessImageAndVideo(context,
                                isLoadingAllContent, storeVideo.length);
                          },
                        );
                      }
                    } else if (categoryShare == "Images&Videos") {
                      imagevideoShare(0);

                      if (isLoadingAllContent) {
                        return showDialog(
                          context: context,
                          builder: (context) {
                            buildContextNew = context;
                            return showDialogForProcessImageAndVideo(
                                context,
                                isLoadingAllContent,
                                storeImage.length + storeVideo.length);
                          },
                        );
                      }
                      // return showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return showDialogForProcessImageAndVideo(context);
                      //   },
                      // );
                    } else if (categoryShare == "Description") {
                      showPopUpForDesc(mpd.response.price);
                    }
                    if (valueDesc == true) {
                      setState(() {
                        stringDesc = true;
                      });
                    }
                    // Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 78, 91, 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        "Share",
                        style: GoogleFonts.dmSans(
                            fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool loadAddProduct = false;

  removeAllHtmlTags(String htmlText, int number, bool isCopy) {
    RegExp exp =
        RegExp(r'<[^>]*>|&[^;]+;', multiLine: true, caseSensitive: true);

    // String copyString = htmlText.replaceAll(exp, "");

    // List arr = copyString.split('. ');

    // print(arr[0]);

    String h1 = isCopy == true
        ? "${mpd.response.title}\n\n${htmlText.replaceAll(exp, '\n')}\n"
        : "*${mpd.response.title}*\n${htmlText.replaceAll(exp, '\n')}\n*Price Rs.$sharePrice*";

    // String h2 = "*${mpd.response.title}*${mpd.response.description.replaceAll(exp, '')} \n*Price Rs.${}*";

    if (h1.isEmpty) return false;
    // return
    return number == 1 ? h1 : Share.text("h1", h1, "text/plain");
  }

  bool isPrepareImage = false;

  imageShare(int number) async {
    var request;
    Map<String, List<int>> imgMap = {};
    Uint8List bytes;

    setState(() {
      isLoadingAllContent = true;
    });

    for (int i = 0; i < mpd.response.banners.length; i++) {
      if (mpd.response.banners[i].mediaType == 'image') {
        request = await HttpClient().getUrl(
            Uri.parse("${mpd.urls.image}/${mpd.response.banners[i].media}"));

        var response = await request.close();
        print(response);
        bytes = await consolidateHttpClientResponseBytes(response);

        imgMap[i.toString() + ".jpg"] = bytes;
      }
    }

    setState(() {
      isLoadingAllContent = false;
      Navigator.pop(buildContextForImage);
    });

    debugPrint("Map Data : $imgMap");

    // await Share.files("esysimages",{
    //   'images1':bytes,
    // }, 'image/jpg',);

    if (imgMap.isEmpty) return false;
    await Share.files(
      "esysimages",
      imgMap,
      'image/jpg',
      // text:
      // number == 0 ? "" : removeAllHtmlTags(mpd.response.description, 1),
    );
  }

  videoShare(int number) async {
    var request;
    Map<String, List<int>> imgMap = {};
    Uint8List bytes;
    setState(() {
      isLoadingAllContent = true;
    });
    for (int i = 0; i < mpd.response.banners.length; i++) {
      if (mpd.response.banners[i].mediaType == 'video') {
        request = await HttpClient().getUrl(
            Uri.parse("${mpd.urls.video}/${mpd.response.banners[i].media}"));

        var response = await request.close();
        print(response);
        bytes = await consolidateHttpClientResponseBytes(response);

        imgMap[i.toString() + ".mp4"] = bytes;
      }
    }
    setState(() {
      isLoadingAllContent = false;
      Navigator.pop(buildContextForVideo);
    });
    if (imgMap.isEmpty) return false;
    await Share.files("video", imgMap, "video/mp4");
  }

  bool isLoadingAllContent = false;

  imagevideoShare(int number) async {
    var request;
    Map<String, List<int>> imgMap = {};
    Uint8List bytes;

    setState(() {
      isLoadingAllContent = true;
    });

    // if(isLoadingAllContent){
    //   return showDialog(context: context, builder: (context) => showDialogForProcessImageAndVideo(context),);
    // }

    for (int i = 0; i < mpd.response.banners.length; i++) {
      if (mpd.response.banners[i].mediaType == "video") {
        request = await HttpClient().getUrl(
            Uri.parse("${mpd.urls.video}/${mpd.response.banners[i].media}"));

        var response = await request.close();
        print(response);
        bytes = await consolidateHttpClientResponseBytes(response);

        imgMap[i.toString() + ".mp4"] = bytes;
      }

      if (mpd.response.banners[i].mediaType == "image") {
        request = await HttpClient().getUrl(
            Uri.parse("${mpd.urls.image}/${mpd.response.banners[i].media}"));

        var response = await request.close();
        print(response);
        bytes = await consolidateHttpClientResponseBytes(response);

        imgMap[i.toString() + ".jpg"] = bytes;
      }
    }
    setState(() {
      isLoadingAllContent = false;
      Navigator.pop(buildContextNew);
    });
    print(imgMap);

    // if (imgMap[".mp4"].isEmpty) return false;
    await Share.files("image/video", imgMap, "image/jpg/video/mp4");
  }

  Widget circleBar(bool isActive, String mediaType) {
    return mediaType == "video"
        ? Icon(
            Icons.play_arrow,
            size: 15,
            color: isActive
                ? Color.fromRGBO(255, 78, 91, 1)
                : Colors.grey,
          )
        : AnimatedContainer(
            duration: Duration(milliseconds: 150),
            margin: EdgeInsets.symmetric(horizontal: 4),
            height: isActive ? 8 : 8,
            width: isActive ? 8 : 8,
            decoration: BoxDecoration(
                color: isActive
                    ? Color.fromRGBO(255, 78, 91, 1)
                    : Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(12))),
          );
  }

  Widget showDialogForProcessImageAndVideo(
      BuildContext context, bool isActive, int number) {
    return StatefulBuilder(
      builder: (context, setState) {
        print(isLoadingAllContent);
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Sharing details",
                style: GoogleFonts.dmSans(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Image.asset(
                    "assets/image-video-check.png",
                    color: Colors.green,
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Images and Videos ($number Files)",
                    style: GoogleFonts.dmSans(fontSize: 14),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              LinearProgressIndicator(
                backgroundColor: Color.fromRGBO(255, 78, 91, 1).withOpacity(0.5),
                color: Color.fromRGBO(255, 78, 91, 1),
                minHeight: 5,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Sharing...",
                style: GoogleFonts.dmSans(fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }

  showDialogForAddMultiple(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: AlertDialog(
              insetPadding: EdgeInsets.all(10),
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Add Quantity",
                style: GoogleFonts.dmSans(fontSize: 14),
              ),
              content: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        controller: addMultipleController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.3),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Container(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "CANCEL",
                      style: GoogleFonts.aBeeZee(
                        color: Color.fromRGBO(255, 78, 91, 1),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromRGBO(255, 78, 91, 1), width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: 40,
                ),
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      int n = int.parse(addMultipleController.text);
                      print(mpd.response.stock);
                      int m = n;
                      print(m);
                      if (n > mpd.response.stock || m > mpd.response.stock) {
                        addMultipleController.text = "";
                        return Fluttertoast.showToast(
                            msg: "You entered out of stock");
                      } else {
                        setState(() {
                          ApiServices().incrementProducts(
                              mpd.response.productId, n - cartNumber);
                          cartNumber = n;
                        });
                      }

                      // setState(() {
                      //   // addMultipleController.text = "0";
                      //   ApiServices()
                      //       .incrementProducts(mpd.response.productId, n);
                      // });
                      // return Fluttertoast.showToast(msg: "You entered out of stock");

                      setState(() {});
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(255, 78, 91, 1))),
                    child: Text(
                      "OK",
                      style: GoogleFonts.aBeeZee(color: Colors.white),
                    ),
                  ),
                  decoration: BoxDecoration(
                    // color: Color.fromRGBO(4, 75, 90, 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: 40,
                ),
              ],
            ),
          );
        });
  }

  showDilogE({BuildContext context}) {
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
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style:
                      GoogleFonts.dmSans(color: Color.fromRGBO(4, 75, 90, 1)),
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
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Color.fromRGBO(255, 78, 91, 1),
                )),
                onPressed: () {
                  setState(() {
                    mpd.response.inFavorits = false;
                  });
                  ApiServices().addAndDeleteToFavourite(mpd.response.productId);
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

  String category = "By Amount";
  // TextEditingController priceDescController = TextEditingController();
  int totalPrice = 0;
  double sharePrice = 0;
  int percentPrice = 0;
  int percentShareValue = 0;

  showPopUpForDesc(double price) {
    // priceDescController.text = "";
    // priceDescController.selection = TextSelection.fromPosition(TextPosition(offset: priceDescController.text.length));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Want to share the price and description with your profit margin?",
                      style: GoogleFonts.dmSans(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Actual Price : Rs.${price % 1 == 0 ? price.toInt() : price}",
                      style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "SET PROFIT MARGIN",
                      style: GoogleFonts.dmSans(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          child: Radio(
                            value: "By Amount",
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
                          "By Amount",
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            color: category == "By Amount"
                                ? Color.fromRGBO(255, 78, 91, 1)
                                : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: 20,
                          child: Radio(
                            value: "By Percentage",
                            groupValue: category,
                            activeColor: Color.fromRGBO(255, 78, 91, 1),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onChanged: (value) {
                              setState(() {
                                category = value;
                                print(value);
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "By Percentage",
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            color: category == "By Percentage"
                                ? Color.fromRGBO(255, 78, 91, 1)
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 40,
                      child: category == "By Amount"
                          ? TextFormField(
                              cursorHeight: 20,
                              cursorColor: Colors.green,
                              style: GoogleFonts.dmSans(color: Colors.black),
                              onChanged: (string) {
                                print(string);
                                if (string.isEmpty && string == "") {
                                  setState(() {
                                    priceDescController.clear();
                                    totalPrice = 0;
                                  });
                                }
                                else{
                                  setState(() {
                                    totalPrice = int.parse(string.toString());
                                  });
                                }
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixIcon: category == "By Amount"
                                    ? Container(
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.all(7),
                                        width: 5,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image:
                                                AssetImage("assets/rupee.png"),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                contentPadding: EdgeInsets.all(0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.2,
                                  ),
                                ),
                              ),
                              controller: priceDescController,
                            )
                          : TextFormField(
                              cursorHeight: 20,
                              cursorColor: Colors.green,
                              style: GoogleFonts.dmSans(color: Colors.black),
                              onChanged: (str) {
                                if (str.isEmpty || str == null) {
                                  setState(() {
                                    percentDescController.clear();
                                    percentPrice = 0;
                                  });
                                } else {
                                  int storeString = int.parse(str);

                                  setState(() {
                                    percentPrice = storeString;
                                  });
                                }
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                suffixIcon: category == "By Percentage"
                                    ? Icon(
                                        Icons.percent,
                                        color: Colors.black,
                                      )
                                    : Container(),
                                contentPadding: EdgeInsets.only(left: 15),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.2,
                                  ),
                                ),
                              ),
                              controller: percentDescController,
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    category == "By Amount"
                        ? Text(
                            "Final price to be share: Rs.${totalPrice == 0 ? price : (price + totalPrice.toDouble())}",
                            style:
                                GoogleFonts.dmSans(fontWeight: FontWeight.w700),
                          )
                        : Text(
                            "Final price to be share: Rs.${percentPrice == 0 ? price : (price + (price * percentPrice.toDouble() / 100))}",
                            style:
                                GoogleFonts.dmSans(fontWeight: FontWeight.w700),
                          ),
                    const SizedBox(
                      height: 10,
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
                              child: Text("CANCEL",style: GoogleFonts.dmSans(color: Color.fromRGBO(255, 78, 91, 1),),)),
                        ),
                        GestureDetector(
                          onTap: () {
                            category == "By Amount"
                                ? sharePrice = totalPrice + price
                                : sharePrice =
                                    (price + (price * percentPrice / 100));
                            openAndCloseLoadingDialog(context: context);
                            removeAllHtmlTags(
                                mpd.response.description, 0, false);
                            Navigator.of(context).pop();

                            // if (valueDesc == true) {
                            //   setState(() {
                            //     stringDesc = true;
                            //   });
                            // }
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, top: 10, bottom: 10),
                            margin:
                                EdgeInsets.only(left: 10, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Color.fromRGBO(255, 78, 91, 1),
                            ),
                            child: Text(
                              "SHARE",
                              style: GoogleFonts.dmSans(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}

class ProductDetailsAddCart {
  int number;
  bool isVisible;

  ProductDetailsAddCart({this.number, this.isVisible});
}

class MultipleVideoPlayer extends StatefulWidget {
  String videoPathh;
  MultipleVideoPlayer({Key key, this.videoPathh}) : super(key: key);

  @override
  _MultipleVideoPlayerState createState() => _MultipleVideoPlayerState();
}

class _MultipleVideoPlayerState extends State<MultipleVideoPlayer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initVideo();

    // _videoPlayerController.addListener(
    //       () {
    //
    //   },
    // );

    _videoPlayerController.setLooping(true);
    _videoPlayerController.setVolume(1.0);
  }

  initVideo() {
    _videoPlayerController = VideoPlayerController.network(widget.videoPathh);
    _initializedVideoPlayer = _videoPlayerController.initialize();
  }

  void incrementCounter() {
    setState(() {
      _videoPlayerController.value.isPlaying
          ? _videoPlayerController.pause()
          : _videoPlayerController.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        FutureBuilder(
          future: _initializedVideoPlayer,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print(_videoPlayerController.value.aspectRatio);
              return Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        GestureDetector(
          onTap: incrementCounter,
          child: CircleAvatar(
            radius: 27,
            backgroundColor: Colors.black.withOpacity(0.6),
            child: Icon(_videoPlayerController.value.isPlaying
                ? Icons.pause
                : Icons.play_arrow),
          ),
        ),
      ],
    );
  }
}
