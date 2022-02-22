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
    "assets/bags.png",
    "assets/chef.png",
    "assets/dress.png",
    "assets/grocery-cart.png",
    "assets/responsive.png",
    "assets/smartphone.png",
  ];

  List trendingProduct1 = [
    'assets/product_image/1.jpeg',
    'assets/product_image/2.jpeg',
    'assets/product_image/3.jpeg',
    'assets/product_image/4.jpeg',
    'assets/product_image/5.jpeg',
  ];

  List newarrival = [
    'assets/product_image/1.jpeg',
    'assets/product_image/1.jpeg',
    'assets/product_image/1.jpeg',
    'assets/product_image/1.jpeg',
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
                      height: 40,
                      width: 110,
                    ),
                    SizedBox(
                      width: 155,
                    ),
                    SizedBox(
                      width: 7,
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
              //       Image.asset("assets/menu.png",color: Colors.red,height: 18,width: 18,),
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
                                color: Colors.grey[400],
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.zero,
                                  bottomRight: Radius.zero,
                                  topLeft: Radius.circular(2),
                                  bottomLeft: Radius.circular(2)),
                              borderSide: BorderSide(
                                  color: Colors.grey[400], width: 1.5),
                            ),
                            hintText: "Search your daily product",
                            hintStyle: GoogleFonts.aBeeZee(
                                color: Colors.grey.shade500),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            hintTextDirection: TextDirection.ltr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.zero,
                                  bottomRight: Radius.zero,
                                  topLeft: Radius.circular(2),
                                  bottomLeft: Radius.circular(2)),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
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
                              color: Colors.grey[400],
                              width: 1.4,
                            ),
                            right: BorderSide(
                              //                   <--- left side
                              color: Colors.grey[400],
                              width: 1.4,
                            ),
                            bottom: BorderSide(
                              //                   <--- left side
                              color: Colors.grey[400],
                              width: 1.4,
                            ),
                          ),
                          // borderRadius: BorderRadius.only(
                          //     topRight: Radius.circular(2.0),
                          //     bottomRight: Radius.circular(2.0),
                          //     topLeft: Radius.zero,
                          //     ),

                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 28,
                          color: Colors.black54.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                flex: 0,
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 10,
                  child: ListView.builder(
                    itemCount: categoryName.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              CircleAvatar(
                                child: Image.asset(
                                  categoryIcon[index],
                                  fit: BoxFit.cover,
                                  height: 30,
                                  color: Colors.black87,
                                ),
                                backgroundColor: Colors.grey[200],
                                radius: 25,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            " ${categoryName[index]}",
                            style: GoogleFonts.aBeeZee(
                                fontSize: 13.4, color: Colors.black),
                          ),
                        ],
                      );
                    },
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
                  height: MediaQuery.of(context).size.height / 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ImageSlider(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/fire.png",
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(
                    width: 1,
                  ),
                  Text(
                    "TRENDING PRODUCT",
                    style: TextStyle(
                        fontFamily: 'Apple',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Color.fromRGBO(22, 2, 105, 1)),
                  ),
                  Spacer(),
                  Text(
                    "LAST 7 DAY",
                    style: TextStyle(
                        fontFamily: 'Apple',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                        color: Color.fromRGBO(22, 2, 105, 1)),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),
              Expanded(
                flex: 0,
                child: Container(
                    height: MediaQuery.of(context).size.height / 13,
                    width: MediaQuery.of(context).size.width,
                    child: trending1()),
              ),
              SizedBox(
                height: 25,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: MediaQuery.of(context).size.height / 13.0,
                  width: MediaQuery.of(context).size.width,
                  child: trending2(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: RaisedButton(
                  onPressed: () {},
                  child: Text(
                    "See All",
                    style: GoogleFonts.aBeeZee(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                        color: Color.fromRGBO(22, 2, 105, 1)),
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
              ),
              Divider(
                color: Colors.grey[500],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.network(
                    "http://www.wearedesignteam.com/design/images/deal-of-the-day-png-icon.png",
                    height: 30,
                    width: 30,
                  ),
                  // Image.network("https://www.flaticon.com/free-icon/deal_522568?term=deal&page=1&position=3&page=1&position=3&related_id=522568&origin=search",height: 30,width: 30,),

                  Text(
                    "Deal of the Day".toUpperCase(),
                    style: TextStyle(
                        fontFamily: 'Apple',
                        letterSpacing: 1,
                        color: Color.fromRGBO(22, 2, 105, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  // Image.asset("assets/dealofday.png",height: 40,width: 40,),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: 350,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        child: Container(
                          height: MediaQuery.of(context).size.height / 3,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(dealofDays[akda]),
                        ),
                        alignment: Alignment.center,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        bestSellingTitle[akda],
                        style: TextStyle(
                            fontFamily: 'Apple',
                            fontWeight: FontWeight.bold,
                            fontSize: 13.8),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        bestSellingCategory[akda],
                        style: TextStyle(
                            fontFamily: 'Apple',
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: Colors.grey),
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
                                width: 12,
                                height: 12,
                              ),
                              Text(
                                bestSellingPrice[akda].toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/rupee.png",
                                width: 12,
                                height: 12,
                                color: Colors.grey,
                              ),
                              Text(
                                bestSellingPrice[akda].toString(),
                                style: GoogleFonts.nunitoSans(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "85% OFF",
                            style: GoogleFonts.nunitoSans(
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: dealofDaysWidget(),
              ),
              Divider(
                color: Colors.grey[500],
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  " New Arrivals".toUpperCase(),
                  style: TextStyle(
                      fontFamily: 'Apple',
                      letterSpacing: 1,
                      color: Color.fromRGBO(22, 2, 105, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 240,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          child: Image.network(bestSellingImage[index]),
                          color: Colors.grey[100],
                        ),
                        Positioned(
                          child: Text(
                            '${bestSellingTitle[index]}'.toUpperCase(),
                            style: GoogleFonts.nunitoSans(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          width: MediaQuery.of(context).size.width / 2,
                          top: 180,
                        ),
                        Positioned(
                          child: Column(
                            children: [
                              // Text(
                              //   "\$" + bestSellingPrice[index].toString(),
                              //   style: GoogleFonts.nunitoSans(
                              //       fontSize: 14,
                              //       fontWeight: FontWeight.bold,
                              //       color: Colors.orange[400]),
                              // ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/rupee.png",
                                        width: 12,
                                        height: 12,
                                      ),
                                      Text(
                                        bestSellingPrice[akda].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        "assets/rupee.png",
                                        width: 12,
                                        height: 12,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        bestSellingPrice[akda].toString(),
                                        style: GoogleFonts.nunitoSans(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "85% OFF",
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          top: 215,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget trending1() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                    image: AssetImage(trendingProduct1[0]), fit: BoxFit.cover)),
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
                    image: AssetImage(trendingProduct1[1]), fit: BoxFit.cover)),
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
                    image: AssetImage(trendingProduct1[2]), fit: BoxFit.cover)),
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
                    image: AssetImage(trendingProduct1[3]), fit: BoxFit.cover)),
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
                    image: AssetImage(trendingProduct1[4]), fit: BoxFit.cover)),
            height: 50,
            width: 50,
          ),
        ],
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
    'PLASTIC WATERPROOF MAGIC MALE FEMALE',
    'PLASTIC WATERPROOF MAGIC MALE FEMALE',
    'Google Pixel',
    'Earbuds with Mic',
  ];
  List bestSellingImage = [
    "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.soundguys.com%2Fwp-content%2Fuploads%2F2015%2F07%2FSennheiser-HD-820-1024x1024.jpg&f=1&nofb=1",
    "https://i5.walmartimages.com/asr/c67bebef-646f-4cbb-9f06-432b491540cd_1.a85f65354949e93ab03dcb078a7d6495.jpeg?odnHeight=612&odnWidth=612&odnBg=FFFFFF",
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
