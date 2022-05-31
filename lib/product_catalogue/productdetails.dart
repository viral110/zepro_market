import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:core';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/avd.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:http/http.dart';
import 'package:jalaram/Connect_API/api.dart';
import 'package:jalaram/Model/micro_product_details.dart';
import 'package:jalaram/add_to_cart_part/add_to_cart_page.dart';
import 'package:jalaram/product_catalogue/image_zoom.dart';
import 'package:modern_form_esys_flutter_share/modern_form_esys_flutter_share.dart';
import 'package:path_provider/path_provider.dart';

import 'package:video_player/video_player.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';
// import 'package:modern_form_esys_flutter_share/modern_form_esys_flutter_share.dart';

VideoPlayerController _videoPlayerController;

Future<void> _initializedVideoPlayer;

class ShowstatusBool {
  bool isVisible;
  ShowstatusBool({this.isVisible});
}

class ProductDetails extends StatefulWidget {
  final String productId;
  final VoidCallback productFunc;
  final int number;

  ProductDetails({this.productId,this.productFunc,this.number});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> with WidgetsBindingObserver{
  PageController controller = PageController();
  // Color color = Colors.grey;

  bool isLoading = false;
  bool isVisibleadd;

  MicroProductDetails mpd;

  int cartNumber;

  bool end = false;


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if(valueDesc){
        setState(() {
          stringDesc = true;
        });
      }
      if(stringDesc){
        Share.text("helloWorld", mpd.response.description, 'text/plain');
        stringDesc = false;
        valueDesc = false;
        valueImage = false;
        valueVideo = false;
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    fetchMicroProductDetails();

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }



  List<String> storeVideo = [];
  List<String> storeImage = [];
  List<ProductDetailsAddCart> pdAddcart = [];

  dynamic x;

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
            storeImage
                .add("${mpd.urls.image}/${mpd.response.banners[i].media}");
          }
          if (mpd.response.banners[i].mediaType == "video") {
            storeVideo.add(mpd.response.banners[i].media);
            _videoPlayerController = VideoPlayerController.network(
                "${mpd.urls.video}/${mpd.response.banners[i].media}");
            _initializedVideoPlayer = _videoPlayerController.initialize();
            _videoPlayerController.addListener(() {
              setState(() {});
            });

            _videoPlayerController.setLooping(true);
            _videoPlayerController.setVolume(1.0);
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

  void incrementCounter() {
    setState(() {
      _videoPlayerController.value.isPlaying
          ? _videoPlayerController.pause()
          : _videoPlayerController.play();
    });
  }

  int currentPageValue = 0;

  bool onTapHeart = false;
  bool valueImage = false;
  bool valueDesc = false;
  bool valueVideo = false;

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Color.fromRGBO(22, 2, 105, 1),),
        leading: InkWell(onTap: (){
          Navigator.pop(context);
          // fetchMicroProducts();
          if(widget.number == 0){
            widget.productFunc();
          }

          ApiServices().microProducts(context);
          setState(() {


          });

        },child: Icon(Icons.arrow_back)),
        backgroundColor: Colors.white,
        title: Text(
          "Product Details",
          style: GoogleFonts.aBeeZee(color: Color.fromRGBO(22, 2, 105, 1)),
        ),
      ),
      body: isLoading == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(

              scrollDirection: Axis.vertical,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: PageView.builder(
                    controller: controller,
                    onPageChanged: (value) {
                      getChangedPageAndMoveBar(value);
                    },
                    itemCount: mpd.response.banners.length,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ImageZoom(linkImage: mpd.urls.image,linkVideo: mpd.urls.video,url: mpd.response.banners,mediaTypeZoom: mpd.response.banners[index].mediaType),
                          ));
                        },
                        child: Container(
                          child: mpd.response.banners[index].mediaType ==
                                  "image"
                              ? Image.network(
                                  "${mpd.urls.image}/${mpd.response.banners[index].media}")
                              : Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    FutureBuilder(
                                        future: _initializedVideoPlayer,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return AspectRatio(
                                              aspectRatio:
                                                  _videoPlayerController
                                                      .value.aspectRatio,
                                              child: VideoPlayer(
                                                  _videoPlayerController),
                                            );
                                          } else {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        }),
                                    GestureDetector(
                                      onTap: incrementCounter,
                                      child: CircleAvatar(
                                        radius: 27,
                                        backgroundColor:
                                            Colors.black.withOpacity(0.6),
                                        child: Icon(_videoPlayerController
                                                .value.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow),
                                      ),
                                    ),
                                  ],
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
                //         if (snapshot.connectionState == ConnectionState.done) {
                //           return AspectRatio(
                //             aspectRatio: _videoPlayerController.value.aspectRatio,
                //             child: VideoPlayer(_videoPlayerController),
                //           );
                //         } else {
                //           return Center(
                //             child: CircularProgressIndicator(),
                //           );
                //         }
                //       }),
                // ),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < mpd.response.banners.length; i++)
                        if (i == currentPageValue) ...[circleBar(true)] else
                          circleBar(false),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${mpd.response.title}",
                              style: GoogleFonts.dmSans(
                                fontSize: 18,
                                letterSpacing: 1.5,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                return showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, setState) => Dialog(
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              3.2,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                // mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "What do you want to share?",
                                                    style: GoogleFonts.dmSans(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Checkbox(
                                                        value: valueImage,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            debugPrint(value
                                                                .toString());
                                                            valueImage = value;
                                                          });
                                                        },
                                                      ),
                                                      Text(
                                                        "Images",
                                                        style:
                                                            GoogleFonts.dmSans(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Checkbox(
                                                        value: valueVideo,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            debugPrint(value
                                                                .toString());
                                                            valueVideo = value;
                                                          });
                                                        },
                                                      ),
                                                      Text(
                                                        "Video",
                                                        style:
                                                            GoogleFonts.dmSans(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Checkbox(
                                                        splashRadius: 0,
                                                        value: valueDesc,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            debugPrint(value
                                                                .toString());
                                                            valueDesc = value;
                                                          });
                                                        },
                                                      ),
                                                      Text(
                                                        "Description",
                                                        style:
                                                            GoogleFonts.dmSans(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .lightBlueAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: Text("Cancel"),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      InkWell(
                                                        onTap: () {

                                                          if (valueImage ==
                                                                  true &&
                                                              valueVideo ==
                                                                  false &&
                                                              valueDesc ==
                                                                  false) {
                                                            imageShare(0);
                                                          } else if (valueVideo ==
                                                                  true &&
                                                              valueImage ==
                                                                  false &&
                                                              valueDesc ==
                                                                  false) {
                                                            videoShare(0);
                                                          } else if (valueImage ==
                                                                  true &&
                                                              valueDesc ==
                                                                  true &&
                                                              valueVideo ==
                                                                  false) {
                                                            imageShare(0);
                                                            stringDesc = true;
                                                            // removeAllHtmlTags(
                                                            //     mpd.response
                                                            //         .description,
                                                            //     0);
                                                          } else if (valueImage ==
                                                                  false &&
                                                              valueVideo ==
                                                                  false &&
                                                              valueDesc ==
                                                                  true) {
                                                            removeAllHtmlTags(
                                                                mpd.response
                                                                    .description,
                                                                0);
                                                          } else if (valueVideo ==
                                                                  true &&
                                                              valueImage ==
                                                                  false &&
                                                              valueDesc ==
                                                                  true) {
                                                            videoShare(0);
                                                            stringDesc = true;
                                                          } else if (valueVideo ==
                                                                  true &&
                                                              valueImage ==
                                                                  true &&
                                                              valueDesc ==
                                                                  true) {
                                                            imagevideoShare(1);
                                                          } else if (valueImage ==
                                                                  true &&
                                                              valueVideo ==
                                                                  true &&
                                                              valueDesc ==
                                                                  true) {
                                                            imagevideoShare(1);
                                                            stringDesc = true;

                                                          }
                                                          if(valueDesc == true){
                                                            setState((){
                                                              stringDesc = true;
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .lightBlueAccent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          child: Text("Send"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.share,
                                size: 18,
                              )),
                        ],
                      ),
                      // SizedBox(
                      //   height: 6,
                      // ),
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
                              Text(
                                "${mpd.response.price.toInt().toString().substring(0, 3)}",
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
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                    decoration: TextDecoration.lineThrough,
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
                                  onPressed: () {
                                    if (mpd.response.inFavorits == true) {
                                      showDilogE(context: context);
                                    } else {
                                      setState(() {
                                        mpd.response.inFavorits = true;
                                        ApiServices().addAndDeleteToFavourite(
                                            mpd.response.productId);
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.favorite_border,
                                    color: Colors.black,
                                  ))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: mpd.response.cartoon.toString(),
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
                          cartNumber != 0
                          ?Container(
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () async {
                                            await ApiServices()
                                                .decrementProducts(
                                                    mpd.response.productId,
                                                    1,
                                                    context);
                                            setState(() {
                                              ApiServices().microProductDetails(
                                                  mpd.response.productId,
                                                  context);
                                            });
                                            if (cartNumber < 2) {
                                              cartNumber = 0;
                                            } else {
                                              cartNumber--;
                                            }
                                            debugPrint(
                                                "Decrement che : ${cartNumber}");
                                            // Fluttertoast.showToast(msg: "Product Decrement : ${dataIncrement[index].counter--}");
                                          },
                                          child: Icon(
                                            Icons.remove,
                                            size: 20,
                                          )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${cartNumber.toString()}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              cartNumber++;
                                              ApiServices().incrementProducts(
                                                  mpd.response.productId, 1);
                                            });
                                            ApiServices()
                                                .getWishListProducts(context);
                                            debugPrint(
                                                "Increment che : ${cartNumber}");
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
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(
                                        color: Color.fromRGBO(22, 2, 105, 1)),
                                  ),
                                  width: 80,
                            height: 20,
                                ) : Container(
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                  color: Color.fromRGBO(22, 2, 105, 1)),
                            ),
                            child: InkWell(
                              child: Text(
                                "ADD",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                setState(() {
                                  // isVisibleadd = !isVisibleadd;
                                  cartNumber = 1;
                                  ApiServices().incrementProducts(
                                      mpd.response.productId, 1);

                                  ApiServices()
                                      .getWishListProducts(context);
                                });
                              },
                            ),
                            height: 22,
                            alignment: Alignment.center,
                          ),

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
                            border:
                                Border.all(color: Colors.lightBlue, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              mpd.response.stock != 0
                                  ? Text(
                                      "${mpd.response.stock}",
                                      style: GoogleFonts.dmSans(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Container(),
                              mpd.response.stock == 0
                                  ? Text(
                                      "Out Of Stock",
                                      style: GoogleFonts.dmSans(
                                          fontSize: 18,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5),
                                    )
                                  : Text(
                                      "In Stock",
                                      style: GoogleFonts.dmSans(
                                          fontSize: 20,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5),
                                    )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Product Details",
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${mpd.response.weight.toString()}",
                                  style: GoogleFonts.dmSans(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${mpd.response.dimensions}",
                                  style: GoogleFonts.dmSans(
                                    color: Colors.black,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${mpd.response.hsn}",
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "About Product",
                            style: GoogleFonts.dmSans(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                fontSize: 18),
                          ),
                          InkWell(
                              onTap: () async {
                                // videoShare();
                                // imageShare();
                                // removeAllHtmlTags(mpd.response.description);
                                Clipboard.setData(ClipboardData(
                                        text: removeAllHtmlTags(
                                            mpd.response.description, 1)))
                                    .then((value) {
                                  setState(() {
                                    Fluttertoast.showToast(msg: "Copied");
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
                        ?Container(
                          width: MediaQuery.of(context).size.width,
                          child: Html(
                            shrinkWrap: true,
                            data: """${mpd.response.description}""",
                          ),
                        ) : Container(child: Text("-")),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Expanded(
                        flex: 0,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: mpd.response.gallery.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height /
                                        2.6,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "${mpd.urls.image}/${mpd.response.gallery[index].media}"),
                                            fit: BoxFit.fill)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      mpd.response.youtubeLink == ""
                          ? Container()
                          : RichText(
                              text: TextSpan(children: [
                              TextSpan(
                                  text: "Youtube Link : ",
                                  style: GoogleFonts.aBeeZee(
                                      color: Colors.black, fontSize: 16)),
                              TextSpan(
                                  text: mpd.response.youtubeLink,
                                  style: GoogleFonts.aBeeZee(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launch(mpd.response.youtubeLink);
                                    }),
                            ])),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: cartNumber != 0
     ? Container(
        height: 60,
        width: 140,
        padding: EdgeInsets.all(0),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          isExtended: true,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddToCartPage(),
                ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    // height: 50,
                    width: 30,
                    child: Image.asset(
                      "assets/new/cart5.png",
                      height: 23,
                      width: 23,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    left: 14,
                    top: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      radius: 8,
                      child: cartNumber == 0
                          ? Text("0",
                              style: GoogleFonts.dmSans(
                                  fontSize: 10, color: Colors.black))
                          : Text(cartNumber.toString(),
                              style: GoogleFonts.dmSans(
                                  fontSize: 10, color: Colors.black)),
                    ),
                  ),
                ],
              ),
              Text(
                " View Cart",
                style: GoogleFonts.dmSans(fontSize: 14),
              ),
            ],
          ),
        ),
      ) : Container(),
    );
  }

  removeAllHtmlTags(String htmlText, int number) {
    RegExp exp =
        RegExp(r'<[^>]*>|&[^;]+;', multiLine: true, caseSensitive: true);

    String h1 = htmlText.replaceAll(exp, '');
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
      isPrepareImage = false;
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

    debugPrint("Map Data : $imgMap");

    // await Share.files("esysimages",{
    //   'images1':bytes,
    // }, 'image/jpg',);

    setState(() {
      isPrepareImage = true;
    });
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
    if (imgMap.isEmpty) return false;
    await Share.files("video", imgMap, "video/mp4");
  }

  imagevideoShare(int number) async {
    var request;
    Map<String, List<int>> imgMap = {};
    Uint8List bytes;
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
    // if (imgMap[".mp4"].isEmpty) return false;
    await Share.files("image/video", imgMap, "image/jpg/video/mp4");
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: isActive ? 7 : 7,
      width: isActive ? 7 : 7,
      decoration: BoxDecoration(
          color: isActive ? Colors.pink : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
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
              child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white,
                child: Text(
                  "Cancel",
                  style:
                      GoogleFonts.aBeeZee(color: Color.fromRGBO(22, 2, 105, 1)),
                ),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(22, 2, 105, 1), width: 1.5),
                borderRadius: BorderRadius.circular(5),
              ),
              height: 40,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
              ),
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    mpd.response.inFavorits = false;
                  });
                  ApiServices().addAndDeleteToFavourite(mpd.response.productId);
                  Navigator.pop(context);
                },
                child: Text(
                  "Remove",
                  style: GoogleFonts.aBeeZee(color: Colors.white),
                ),
                color: Color.fromRGBO(22, 2, 105, 1),
              ),
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailsAddCart {
  int number;
  bool isVisible;

  ProductDetailsAddCart({this.number, this.isVisible});
}
