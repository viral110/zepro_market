import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:http/http.dart';
import 'package:jalaram/Connect_API/api.dart';
import 'package:jalaram/Model/micro_product_details.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';
import 'dart:ui' as ui;
import 'package:url_launcher/url_launcher.dart';

VideoPlayerController _videoPlayerController;

Future<void> _initializedVideoPlayer;

class ProductDetails extends StatefulWidget {
  final String productId;
  ProductDetails({this.productId});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  PageController controller = PageController();
  // Color color = Colors.grey;

  List<String> videoLink = [
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
  ];

  String videoUrl =
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4";

  bool isLoading = false;
  MicroProductDetails mpd;

  @override
  void initState() {
    fetchMicroProductDetails();
    super.initState();
  }

  List<String> storeVideo = [];

  fetchMicroProductDetails() async {
    await Future.delayed(Duration(milliseconds: 100), () async {
      Response response =
          await ApiServices().microProductDetails(widget.productId, context);
      var decoded = jsonDecode(response.body);
      debugPrint("Decoded : ${decoded.toString()}");
      if (response.statusCode == 200) {
        mpd = MicroProductDetails.fromJson(decoded);
        debugPrint("MPD : ${mpd.status}");
        for (int i = 0; i < mpd.response.banners.length; i++) {
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
    });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
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
        iconTheme: IconThemeData(color: Color.fromRGBO(22, 2, 105, 1)),
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
                      return Container(
                        child: mpd.response.banners[index].mediaType == "image"
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
                                            aspectRatio: _videoPlayerController
                                                .value.aspectRatio,
                                            child: VideoPlayer(
                                                _videoPlayerController),
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      }),
                                  GestureDetector(
                                    onTap: incrementCounter,
                                    child: CircleAvatar(
                                      radius: 27,
                                      backgroundColor:
                                          Colors.black.withOpacity(0.6),
                                      child: Icon(
                                          _videoPlayerController.value.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow),
                                    ),
                                  ),
                                ],
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
                              onPressed: () {},
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
                            fontSize: 13.5, color: Colors.grey, letterSpacing: 2.5),
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
                              Text("Rs.",style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  letterSpacing: 1,
                                  fontSize: 15),),
                              Text(
                                "${mpd.response.price.toString().substring(0,3)}",
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
                              Text("Rs.",style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  letterSpacing: 1,
                                  fontSize: 15),),
                              Text(
                                "${mpd.response.mrp.toString()}",
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
                            "${mpd.response.discountPercentage.toString()}% OFF",
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
                                        ApiServices().addAndDeleteToFavourite(mpd.response.productId);

                                      });
                                    }
                                  },
                                  icon: Icon(Icons.favorite_border, color: Colors.black,))
                          // FavoriteButton(
                          //   iconSize: 35,
                          //   isFavorite: true,
                          //   valueChanged: (_isFavorite) {
                          //     if (_isFavorite == false) {
                          //       return showDialog(
                          //         context: context,
                          //         builder: (context) => Container(
                          //           width: MediaQuery.of(context).size.width / 1.2,
                          //           child: AlertDialog(
                          //             insetPadding: EdgeInsets.all(10),
                          //             contentPadding: EdgeInsets.zero,
                          //             title: Text(
                          //               "Are you sure you want remove this items?",
                          //               style: GoogleFonts.aBeeZee(fontSize: 14),
                          //             ),
                          //             actions: [
                          //               Container(
                          //                 child: RaisedButton(
                          //                   onPressed: () {
                          //                     setState(() {
                          //                       //Navigator.pop(context);
                          //                       if (_isFavorite == false) {
                          //                         _isFavorite = true;
                          //                       }
                          //                       print(_isFavorite);
                          //                       // if(_isFavorite == true){
                          //                       //   setState(() {
                          //                       //     color = color == Colors.grey ? Colors.red : Colors.grey;
                          //                       //   });
                          //                       // }
                          //                     });
                          //                     Navigator.pop(context);
                          //                   },
                          //                   color: Colors.white,
                          //                   child: Text(
                          //                     "Cancel",
                          //                     style: GoogleFonts.aBeeZee(
                          //                         color:
                          //                             Color.fromRGBO(22, 2, 105, 1)),
                          //                   ),
                          //                 ),
                          //                 decoration: BoxDecoration(
                          //                   border: Border.all(
                          //                       color: Color.fromRGBO(22, 2, 105, 1),
                          //                       width: 1.5),
                          //                   borderRadius: BorderRadius.circular(5),
                          //                 ),
                          //                 height: 40,
                          //               ),
                          //               Container(
                          //                 decoration: BoxDecoration(
                          //                   borderRadius: BorderRadius.circular(3),
                          //                 ),
                          //                 child: RaisedButton(
                          //                   onPressed: () {
                          //                     Navigator.pop(context);
                          //                   },
                          //                   child: Text(
                          //                     "Remove",
                          //                     style: GoogleFonts.aBeeZee(
                          //                         color: Colors.white),
                          //                   ),
                          //                   color: Color.fromRGBO(22, 2, 105, 1),
                          //                 ),
                          //                 height: 40,
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       );
                          //     }
                          //   },
                          // ),
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
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue[900]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 25,
                            width: 80,
                            child: RaisedButton(
                              color: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onPressed: () {},
                              child: Text(
                                "ADD",
                                style: GoogleFonts.dmSans(
                                    color: Colors.blue[900]),
                              ),
                            ),
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
                            border: Border.all(color: Colors.lightBlue,width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              mpd.response.stock != 0
                              ?Text("${mpd.response.stock}",style: GoogleFonts.dmSans(fontSize: 20,fontWeight: FontWeight.bold),)
                              : Container(),
                              mpd.response.stock == 0
                              ?Text("Out Of Stock",style: GoogleFonts.dmSans(fontSize: 18,color: Colors.red, fontWeight: FontWeight.bold,letterSpacing: 1.5),)
                                  :Text("In Stock",style: GoogleFonts.dmSans(fontSize: 20, color: Colors.green,fontWeight: FontWeight.bold,letterSpacing: 1.5),)

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
                                  "12242916-18%",
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
                          Icon(Icons.copy),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Html(
                        data: """${mpd.response.description}""",
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
                                    height: MediaQuery.of(context).size.height / 2.6,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "${mpd.urls.image}/${mpd.response.gallery[index].media}"),fit: BoxFit.fill)),
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
                      ?Container()
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
    );
  }

  // Future<Null> urlFileShare() async {
  //   setState(() {
  //     button2 = true;
  //   });
  //   final RenderBox box = context.findRenderObject();
  //   if (Platform.isAndroid) {
  //     var url = 'https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg';
  //     var response = await get(Uri.parse(url));
  //     final documentDirectory = (await getExternalStorageDirectory()).path;
  //     File imgFile = new File('$documentDirectory/flutter.png');
  //     imgFile.writeAsBytesSync(response.bodyBytes);
  //     Share.shareFile(('$documentDirectory/flutter.png'),
  //         subject: 'URL File Share',
  //         text: 'Hello, check your share files!',
  //         sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  //   } else {
  //     Share.share('Hello, check your share files!',
  //         subject: 'URL File Share',
  //         sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  //   }
  //   setState(() {
  //     button2 = false;
  //   });
  // }


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

