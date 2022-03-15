import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jalaram/Connect_API/api.dart';
import 'package:jalaram/Home/bottomnavbar.dart';
import 'package:jalaram/Home/imageslider.dart';
import 'package:jalaram/dummypage.dart';
import 'package:jalaram/product_catalogue/products.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List categoryIcon = [
    "assets/spoon.png",
    'assets/9.png',
    'assets/10.png',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 7, top: 10, bottom: 10, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/logo.png",
                      height: 50,
                      width: 110,
                    ),
                    SizedBox(
                      width: 155,
                    ),
                    Image.asset(
                      "assets/bell.jpeg",
                      height: 35,
                      width: 35,
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
              // Padding(
              //   padding: const EdgeInsets.only(left: 12),
              //   child: Row(
              //     children: [
              //       Image.asset(
              //         "assets/menu.png",
              //         color: Colors.red,
              //         height: 18,
              //         width: 18,
              //       ),
              //       SizedBox(
              //         width: 10,
              //       ),
              //       Text(
              //         "Categories",
              //         style: GoogleFonts.openSans(
              //           fontSize: 20,
              //           letterSpacing: 1,
              //           color: Color.fromRGBO(7, 19, 107, 1),
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        height: 42,
                        width: MediaQuery.of(context).size.width / 1.26,
                        child: TextFormField(
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
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.1),
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
                      padding:
                          const EdgeInsets.only(left: 13, bottom: 20, top: 10),
                      child: Text(
                        "Popular Categories",
                        style: GoogleFonts.dmSans(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 13, bottom: 20, top: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Products(),
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
              Expanded(
                flex: 0,
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 7,
                  child: ListView.builder(
                    itemCount: categoryName.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 11,
                              ),
                              Material(
                                elevation: 6,
                                borderRadius: BorderRadius.circular(40),
                                child: FittedBox(
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage(categoryIcon[index]),
                                    radius: 41,
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            " ${categoryName[index]}",
                            style: GoogleFonts.dmSans(
                                fontSize: 13.4, color: Colors.black),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 12.5,
              ),

              Expanded(
                flex: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3.5,
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
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.black),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Products(),
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

              Divider(
                thickness: 7,
                color: Colors.grey[200],
              ),
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
                padding: const EdgeInsets.only(left: 13, bottom: 20, top: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Price store",
                    style: GoogleFonts.dmSans(
                        fontSize: 22,
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
                          Container(
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
                                  padding: const EdgeInsets.only(left: 22),
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
                                              fontWeight: FontWeight.w900,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
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

              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height/1.8, // banner 2
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/poster.jpeg"),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 13, top: 8, right: 8,bottom: 8),
                  child: Text(
                    "New Arrivals",
                    style: GoogleFonts.dmSans(
                        letterSpacing: 1,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
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
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: ListView.builder(
                    shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Stack(

                        children: [

                          Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, left: 8, right: 8),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Image.network(
                                        images[index],
                                        fit: BoxFit.fill,
                                      ),
                                      color: Colors.grey[100],
                                      height: 300,
                                      width: 230,
                                    ),
                                    flex: 0,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8,bottom: 8),
                                      child: Text(
                                        '${bestSellingTitle[index]}',

                                        style: GoogleFonts.dmSans(
                                            fontSize: 16,
                                            letterSpacing: 1,
                                            // fontWeight: FontWeight.bold
                                        ),
                                        overflow: TextOverflow.fade,
                                        softWrap: true,
                                      ),
                                    ),
                                    flex: 0,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8,bottom: 8),
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
                                                bestSellingPrice[akda].toString(),
                                                style: GoogleFonts.dmSans(
                                                    fontWeight: FontWeight.bold,color: Colors.black, fontSize: 22),
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
                                                bestSellingPrice[akda].toString(),
                                                style: GoogleFonts.dmSans(
                                                    decoration:
                                                        TextDecoration.lineThrough,
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
                                  Container(
                                    // margin: EdgeInsets.all(8),

                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 78, 91, 1),
                                      borderRadius: BorderRadius.circular(0),
                                    ),

                                    child: Text(
                                      "Add to cart",
                                      style:
                                          GoogleFonts.dmSans(color: Colors.white),
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: 45,
                                    alignment: Alignment.center,
                                  ),
                                ],
                              ),
                            ),
                            width: 250,
                            margin: EdgeInsets.only(left: index == 0 ? 8 : 0),
                            decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      width: 0.1, style: BorderStyle.solid),
                                  bottom: BorderSide(width: 0.1),
                                  left: BorderSide(width: 0.1)),
                            ),
                            padding: EdgeInsets.all(8),
                          ),
                          Positioned(

                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.lightGreen,
                                borderRadius: BorderRadius.circular(0),

                              ),
                              child: Row(
                                children: [
                                  Text(" Save",style:
                                  GoogleFonts.dmSans(color: Colors.white),),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Image.asset(
                                    "assets/rupee.png",
                                    width: 12,
                                    height: 12,
                                    color: Colors.white,
                                  ),
                                  Text("400 ",style:
                                  GoogleFonts.dmSans(color: Colors.white),),
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
                height: MediaQuery.of(context).size.height/9.5, // banner 2
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    alignment: Alignment.center,
                    image: AssetImage("assets/static1.jpeg"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> images = [
    "https://img.freepik.com/free-photo/abstract-grunge-decorative-relief-navy-blue-stucco-wall-texture-wide-angle-rough-colored-background_1258-28311.jpg?size=626&ext=jpg",
    "https://img.freepik.com/free-photo/abstract-grunge-decorative-relief-navy-blue-stucco-wall-texture-wide-angle-rough-colored-background_1258-28311.jpg?size=626&ext=jpg",
  ];

  Widget trending1() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        child: ListView.builder(
          itemCount: trendingProduct1.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Material(
                  elevation: 1.5,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 200,
                    width: 130,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.1, color: Colors.grey[300]),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: AssetImage(trendingProduct1[index]),
                          fit: BoxFit.cover),
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

  Widget trending2() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                    image: AssetImage(trendingProduct2[0]), fit: BoxFit.cover)),
            height: 50,
            width: 50,
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                    image: AssetImage(trendingProduct2[1]), fit: BoxFit.cover)),
            height: 50,
            width: 50,
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                    image: AssetImage(trendingProduct2[2]), fit: BoxFit.cover)),
            height: 50,
            width: 50,
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                    image: AssetImage(trendingProduct2[3]), fit: BoxFit.cover)),
            height: 50,
            width: 50,
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                    image: AssetImage(trendingProduct2[4]), fit: BoxFit.cover)),
            height: 50,
            width: 50,
          ),
        ],
      ),
    );
  }

  Widget dealofDaysWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // color: Colors.red,
              ),
              alignment: Alignment.topCenter,
              height: 65,
              width: 73,
              child: Image.asset(
                dealofDays[0],
                fit: BoxFit.fill,
              ),
            ),
            onTap: () {
              setState(() {
                akda = 0;
              });
            },
          ),
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // color: Colors.red,
              ),
              alignment: Alignment.topCenter,
              height: 65,
              width: 73,
              child: Image.asset(
                dealofDays[1],
                fit: BoxFit.fill,
              ),
            ),
            onTap: () {
              setState(() {
                akda = 1;
              });
            },
          ),
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // color: Colors.red,
              ),
              alignment: Alignment.topCenter,
              height: 65,
              width: 73,
              child: Image.asset(
                dealofDays[2],
                fit: BoxFit.fill,
              ),
            ),
            onTap: () {
              setState(() {
                akda = 2;
              });
            },
          ),
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // color: Colors.red,
              ),
              alignment: Alignment.topCenter,
              height: 65,
              width: 73,
              child: Image.asset(
                dealofDays[3],
                fit: BoxFit.fill,
              ),
            ),
            onTap: () {
              setState(() {
                akda = 3;
                abc();
              });
            },
          ),
        ],
      ),
    );
  }

  Future<String> abc() async {
    String a = await storageKey.read(key: 'access_key');
    debugPrint("A : $a");
  }

  List categoryName = [
    '  Accessories',
    'Kitchen',
    'Fashion',
    'Grocery',
    'Electronics',
    'Mobile',
  ];
  final String assetName = 'assets/w1.svg';

  List bestSellingTitle = [
    'Plastic waterproof magic male female',
    'Plastic waterproof magic male female',
    'Google Pixel',
    'Earbuds with Mic',
  ];
  List bestSellingImage = [
    // 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",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSso0EGSUm6wgURxZ6oRdsQDBSNAzDLIWt5Uf8f2yfp2N080B5UbmctTuF0rIoB3y8cy8M&usqp=CAU",

    "https://i5.walmartimages.com/asr/50dc9eb9-925a-426a-aa51-2ef4ca322f66.2059af4a303b8a2f635481cb02dd4411.jpeg?odnHeight=612&odnWidth=612&odnBg=FFFFFF",
    "https://i5.walmartimages.com/asr/64d180da-4af8-4b6a-98e0-6651131a48c4.42c0f724594bc8811f0255d1b5d592ae.jpeg?odnHeight=612&odnWidth=612&odnBg=FFFFFF",
  ];
  List bestSellingPrice = [
    100,
    200,
    500,
    50,
  ];

  List bestSellingCategory = [
    'Home & Kitchen',
    'Home & Kitchen',
    'Beauty Product',
    'Kids Product',
  ];

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
