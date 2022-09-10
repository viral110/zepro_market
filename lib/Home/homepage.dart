import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:jalaram/All_Search/searching_product.dart';
import 'package:jalaram/Connect_API/api.dart';
import 'package:jalaram/Home/bottomnavbar.dart';
import 'package:jalaram/Home/categories_popular.dart';
import 'package:jalaram/Home/imageslider.dart';
import 'package:jalaram/Home/notification_page.dart';
import 'package:jalaram/Model/home_cart_category_model.dart';
import 'package:jalaram/Model/main_banner_home.dart';
import 'package:jalaram/Model/multiple_banner_home.dart';
import 'package:jalaram/add_to_cart_part/add_to_cart_page.dart';

import 'package:jalaram/dummypage.dart';
import 'package:jalaram/product_catalogue/productdetails.dart';
import 'package:jalaram/product_catalogue/products.dart';

import '../Model/home_new_arrival_model.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List categoryIcon = [
    "assets/spoon.png",
    'assets/9.png',
    'assets/banner2.jpg',
    'assets/product_image/8.jpeg',
    "assets/responsive.png",
    "assets/smartphone.png",
  ];

  List trendingProduct1 = [
    "assets/spoon.png",
    'assets/product_image/2.jpeg',
    'assets/product_image/3.jpeg',
    'assets/product_image/4.jpeg',
    'assets/product_image/5.jpeg',
    'assets/product_image/1.jpeg',
    'assets/product_image/2.jpeg',
    'assets/product_image/3.jpeg',
    'assets/product_image/4.jpeg',
    'assets/product_image/5.jpeg',
  ];

  List newarrival = [
    'assets/123.jpg',
    'assets/123.jpg',
    'assets/123.jpg',
    'assets/123.jpg',
  ];

  List dealofDays = [
    'assets/product_image/2.jpeg',
    'assets/product_image/4.jpeg',
    'assets/product_image/6.jpeg',
    'assets/product_image/7.jpeg',
  ];

  List trendingProduct2 = [
    'assets/product_image/5.jpeg',
    'assets/product_image/6.jpeg',
    'assets/product_image/7.jpeg',
    'assets/product_image/8.jpeg',
    'assets/product_image/5.jpeg',
  ];

  int akda = 0;

  HomeCartCategory hcc;
  HomeNewArrival hna;
  MainBannerHome mainbh;

  bool isLoading = false;
  bool isLoadingCategory = false;
  bool isLoadingHomeBanner = false;
  bool isLoadingMultipleBanner = false;

  List<String> storeImageTrending = [];
  List storeIndex = [];

  @override
  void initState() {
    fetchCategory();
    fetchNewArrival();
    fetchMainSingleBannerHome();
    fetchMultipleBannerHome();
    print(storeKeyByGet.read('access_token'));
    super.initState();
  }

  fetchMainSingleBannerHome() async {
    // await Future.delayed(Duration(milliseconds: 100), () async {
    Response response = await ApiServices().mainBannerHome(context);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      mainbh = MainBannerHome.fromJson(decoded);

      setState(() {
        isLoadingHomeBanner = true;
      });
    }
    // });
  }

  MultipleBannerHome multipleBannerHome;

  fetchMultipleBannerHome() async {
    Response response = await ApiServices().multipleBanner(context);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      multipleBannerHome = MultipleBannerHome.fromJson(decoded);
      setState(() {
        isLoadingMultipleBanner = true;
      });
    }
  }

  fetchCategory() async {
    // await Future.delayed(Duration(milliseconds: 100), () async {
    Response response = await ApiServices().getHomeCategory(context);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      hcc = HomeCartCategory.fromJson(decoded);

      setState(() {
        isLoadingCategory = true;
      });
    }
    // });
  }

  fetchNewArrival() async {
    // await Future.delayed(Duration(milliseconds: 500), () async {
    Response response = await ApiServices().getHomeNewArrival(context);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      hna = HomeNewArrival.fromJson(decoded);
      // for(int i=0;i<=hna.response.length;i++){
      //   if(hna.response[i].isTrending == true){
      //     storeImageTrending.add(hna.response[i].banner.media);
      //   }
      // }

      setState(() {
        List.generate(hna.response.length, (index) {
          if (hna.response[index].isTrending == true) {
            storeIndex.add(index);
            debugPrint(storeIndex.length.toString());
            return storeImageTrending.add(hna.response[index].banner.media);
          } else {
            return null;
          }
        });
        isLoading = true;
      });
    }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: isLoading == true
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 11, top: 10, bottom: 10, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              print(storeKeyByGet.read('access_token'));
                            },
                            child: Image.asset(
                              "assets/Logo.png",
                              height: 50,
                              width: 110,
                            ),
                          ),
                          SizedBox(
                            width: 155,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotificationPage(),
                                  ));
                            },
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Image.asset(
                                  "assets/bell.jpeg",
                                  height: 35,
                                  width: 35,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(2.5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: Text(
                                    lengthOfNotify.toString(),
                                    style: GoogleFonts.dmSans(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 12, right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              height: 42,
                              width: MediaQuery.of(context).size.width / 1.26,
                              child: TextFormField(
                                readOnly: true,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SearchingProduct(),
                                      ));
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
                                    borderSide: BorderSide(
                                        color: Colors.grey[500], width: 1.1),
                                  ),
                                  hintText: "Search your daily product",
                                  hintStyle: GoogleFonts.dmSans(
                                      color: Colors.grey.shade500,
                                      fontSize: 14,
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
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1.1),
                                  ),
                                  contentPadding: EdgeInsets.all(12),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Container(
                              height: 42,
                              width: 50,
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide.none,
                                  top: BorderSide(
                                      //                   <--- left side
                                      color: Colors.grey[500],
                                      width: 1.1),
                                  right: BorderSide(
                                    //                   <--- left side
                                    color: Colors.grey[500],
                                    width: 1.1,
                                  ),
                                  bottom: BorderSide(
                                    //                   <--- left side
                                    color: Colors.grey[500],
                                    width: 1.1,
                                  ),
                                ),
                                color: Colors.white,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: const Radius.circular(13.0),
                                    topRight: const Radius.circular(13.0),
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 28,
                                  color: Colors.black54.withOpacity(0.4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 13, bottom: 20, top: 10),
                            child: Text(
                              "Explore Deluxe",
                              style: GoogleFonts.dmSans(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.7,
                                  color: Colors.black87),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 13, bottom: 20, top: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CategoriesPopular(),
                                    ));
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Show all ",
                                    style: GoogleFonts.dmSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0,
                                        color: Color.fromRGBO(22, 2, 105, 1)),
                                  ),
                                  Image.asset(
                                    "assets/next.png",
                                    height: 14,
                                    width: 14,
                                    color: Color.fromRGBO(22, 2, 105, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    isLoadingCategory == true
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 3.3,
                            child: GridView.count(
                              crossAxisCount: 3,
                              crossAxisSpacing: 4.0,
                              physics: NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 8.0,
                              children: List.generate(
                                hcc.catList.length >= 6
                                    ? 6
                                    : hcc.catList.length,
                                (index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Products(
                                                  categoryHome:
                                                      hcc.catList[index].name,
                                                  number: 1),
                                            ),
                                          );
                                        },
                                        child: Material(
                                          // elevation: 6,
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          child: FittedBox(
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  hcc.catList[index].image),
                                              radius: 37,
                                              backgroundColor: Colors.grey[300],
                                              // child: Image.network(
                                              //     hcc.catList[index].image,
                                              //     fit: BoxFit.fill),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        " ${hcc.catList[index].name}",
                                        style: GoogleFonts.dmSans(
                                            fontSize: 13.4,
                                            color: Colors.black),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          )
                        : Container(),

                    SizedBox(
                      height: 12.5,
                    ),
                    isLoadingMultipleBanner == false
                        ? Container(
                            color: Colors.grey,
                          )
                        : multipleBannerHome.banners.isEmpty
                            ? Container()
                            : Expanded(
                                flex: 0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 3.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ImageSlider(),
                                ),
                              ),

                    SizedBox(
                      height: 12.5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 13, right: 13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Trending Products",
                            style: GoogleFonts.dmSans(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: Colors.black87),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Products(number: 5),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Show all ",
                                  style: GoogleFonts.dmSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0,
                                      color: Color.fromRGBO(22, 2, 105, 1)),
                                ),
                                Image.asset(
                                  "assets/next.png",
                                  height: 14,
                                  width: 14,
                                  color: Color.fromRGBO(22, 2, 105, 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                          height: MediaQuery.of(context).size.height / 5,
                          width: MediaQuery.of(context).size.width,
                          child: trending1()),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Container(
                    //     height: MediaQuery.of(context).size.height / 13.0,
                    //     width: MediaQuery.of(context).size.width,
                    //     child: trending2(),
                    //   ),
                    // ),

                    // Divider(
                    //   thickness: 7,
                    //   color: Colors.grey[200],
                    // ),
                    SizedBox(
                      height: 5,
                    ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Image.network(
                    //       "http://www.wearedesignteam.com/design/images/deal-of-the-day-png-icon.png",
                    //       height: 30,
                    //       width: 30,
                    //     ),
                    //     // Image.network("https://www.flaticon.com/free-icon/deal_522568?term=deal&page=1&position=3&page=1&position=3&related_id=522568&origin=search",height: 30,width: 30,),

                    //     Text(
                    //       "Deal of the Day".toUpperCase(),
                    //       style: TextStyle(
                    //           fontFamily: 'Apple',
                    //           letterSpacing: 1,
                    //           color: Color.fromRGBO(22, 2, 105, 1),
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 15),
                    //     ),
                    //     // Image.asset("assets/dealofday.png",height: 40,width: 40,),
                    //   ],
                    // ),

                    Padding(
                      padding:
                          const EdgeInsets.only(left: 13, bottom: 20, top: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Price store",
                          style: GoogleFonts.dmSans(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 130,
                        child: ListView.builder(
                          itemCount: 6,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                SizedBox(
                                  width: 13,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Products(
                                                number: 0,
                                                priceFilter: priceCounter[index]
                                                    .toString()),
                                            maintainState: true));
                                  },
                                  child: Container(
                                    height: 130,
                                    width: 130,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 78, 91, 1),
                                      // border: Border.all(width: 5,color: Colors.tea),
                                      shape: BoxShape.rectangle,

                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 22),
                                          child: Align(
                                            child: Text(
                                              "UNDER",
                                              style: GoogleFonts.dmSans(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            ),
                                            alignment: Alignment.topLeft,
                                          ),
                                        ),
                                        Flexible(
                                          flex: 0,
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 21,
                                                    ),
                                                    Image.asset(
                                                      "assets/rupee.png",
                                                      height: 15,
                                                      width: 15,
                                                      color: Colors.white,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  "${priceCounter[index].toString()}",
                                                  style: GoogleFonts.dmSans(
                                                      fontSize: 51,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Colors.white),
                                                ),
                                              ],
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                            ),
                                            // height: 55,
                                          ),
                                        ),
                                      ],
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    ),
                    isLoadingHomeBanner == true
                        ? mainbh.banners.isEmpty
                            ? Container()
                            : Container(
                                alignment: Alignment.center,
                                height: MediaQuery.of(context).size.height /
                                    1.8, // banner 2
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(mainbh.url +
                                        '/' +
                                        mainbh.banners[0].banner),
                                  ),
                                ),
                              )
                        : Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height /
                                1.8, // banner 2
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/deluxelogo.jpg'),
                              ),
                            ),
                          ),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 13, top: 8, right: 8, bottom: 8),
                        child: Text(
                          "New Arrivals",
                          style: GoogleFonts.dmSans(
                              letterSpacing: 1,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.65,
                        child: ListView.builder(
                          shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: hna.response.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    setState(
                                      () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetails(
                                                    productId: hna
                                                        .response[index]
                                                        .productId),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, left: 8, right: 8),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Image.network(
                                                "${hna.urls.image}/${hna.response[index].banner.media}",
                                                fit: BoxFit.contain,
                                              ),
                                              color: Colors.white,
                                              height: 300,
                                              width: 230,
                                            ),
                                            flex: 0,
                                          ),
                                          Flexible(
                                            flex :0,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, bottom: 8),
                                              child: Align(
                                                child: Text(
                                                  '${hna.response[index].title.capitalizeFirstofEach}',
                                                  style: GoogleFonts.dmSans(
                                                    fontSize: 14,
                                                    letterSpacing: 1,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  overflow: TextOverflow.fade,
                                                  softWrap: true,
                                                ),
                                                alignment: Alignment.topLeft,
                                              ),
                                            ),

                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, bottom: 8),
                                              child: Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        "assets/rupee.png",
                                                        width: 18,
                                                        height: 18,
                                                        color: Colors.black,
                                                      ),
                                                      Text(
                                                        hna.response[index]
                                                            .price
                                                            .toInt()
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.dmSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 22),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Image.asset(
                                                        "assets/rupee.png",
                                                        width: 12,
                                                        height: 12,
                                                        color: Colors.grey,
                                                      ),
                                                      Text(
                                                        hna.response[index].mrp
                                                            .toInt()
                                                            .toString(),
                                                        style: GoogleFonts.dmSans(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            fontSize: 18,
                                                            color: Colors.grey),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            flex: 0,
                                          ),
                                          Spacer(),
                                          Expanded(
                                            child: InkWell(
                                              child: Container(
                                                // margin: EdgeInsets.all(8),

                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      255, 78, 91, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ),

                                                child: Text(
                                                  "Add to cart",
                                                  style: GoogleFonts.dmSans(
                                                      color: Colors.white),
                                                ),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 45,
                                                alignment: Alignment.center,
                                              ),
                                              onTap: () async {
                                                ApiServices().incrementProducts(
                                                    hna.response[index]
                                                        .productId,
                                                    1);
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "AddtoCart Successfully",
                                                    backgroundColor:
                                                        Colors.lightGreen,
                                                    textColor: Colors.white);
                                                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddToCartPage(),));
                                              },
                                            ),
                                            flex: 0,
                                          ),
                                        ],
                                      ),
                                    ),
                                    width: 250,
                                    margin: EdgeInsets.only(
                                        left: index == 0 ? 8 : 0),
                                    decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              width: 0.1,
                                              style: BorderStyle.solid),
                                          bottom: BorderSide(width: 0.1),
                                          left: BorderSide(width: 0.1)),
                                    ),
                                    padding: EdgeInsets.all(8),
                                  ),
                                ),
                                Positioned(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.lightGreen,
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          " Save",
                                          style: GoogleFonts.dmSans(
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Image.asset(
                                          "assets/rupee.png",
                                          width: 12,
                                          height: 12,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "${hna.response[index].mrp.toInt() - hna.response[index].price.toInt()} "
                                              .toString(),
                                          style: GoogleFonts.dmSans(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    height: 22,
                                  ),
                                  left: index == 0 ? 8 : 0,
                                  top: 13,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),

                    Container(
                      alignment: Alignment.center,
                      height:
                          MediaQuery.of(context).size.height / 8.8, // banner 2
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.center,
                          fit: BoxFit.fill,
                          image: AssetImage("assets/static2.jpg"),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 7.5,
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }

  Widget trending1() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: storeIndex.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetails(
                          productId: hna.response[index].productId,
                        ),
                      ),
                    );
                  },
                  child: Material(
                    elevation: 1.5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 200,
                      width: 130,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.1, color: Colors.grey[300]),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        image: DecorationImage(
                          image: NetworkImage(
                              "${hna.urls.image}/${storeImageTrending[index]}"),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<int> priceCounter = [
    49,
    99,
    199,
    299,
    399,
    499,
  ];
}

// Container(
//   height: MediaQuery.of(context).size.height / 3.3,
//   width: MediaQuery.of(context).size.width,
//   child: ListView.builder(
//     scrollDirection: Axis.horizontal,
//     itemCount: 4,
//     itemBuilder: (context, index) {
//       return Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 height: MediaQuery.of(context).size.height /
//                     3.9,
//                 color: Colors.green,
//                 width:
//                     MediaQuery.of(context).size.width / 2.4,
//                 child: Image.asset(
//                   newarrival[index],
//                   fit: BoxFit.fill,
//                 ),
//               ),
//               SizedBox(
//                 width: 12,
//               ),
//             ],
//           ),
//
//         ],
//       );
//     },
//   ),
// ),
