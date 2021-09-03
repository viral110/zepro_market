import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jalaram/Home/imageslider.dart';
import 'package:jalaram/product_catalogue/products.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.notifications,
            color: Colors.black,
          ),
          SizedBox(
            width: 10,
          ),
        ],
        backgroundColor: Colors.white,
        title: Image.asset(
          "assets/logo.png",
          height: 82,
          width: 100,
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 190,
              child: ImageSlider(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        "PLACE AN ORDER",
                        style: GoogleFonts.aBeeZee(color: Colors.white),
                      ),
                      onPressed: () {},
                      color: Colors.blue[900],
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 7.51,
                            width: MediaQuery.of(context).size.width / 2.2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height / 7.51,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: Colors.blue[700],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "0",
                                    style: GoogleFonts.aBeeZee(
                                        fontSize: 20, color: Colors.blue[700]),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "PENDING ORDERS",
                                    style: GoogleFonts.aBeeZee(
                                        fontSize: 13, color: Colors.blue[700]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Products(),
                              ));
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 7.51,
                              width: MediaQuery.of(context).size.width / 2.15,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 7.51,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "1188",
                                      style: GoogleFonts.aBeeZee(
                                          fontSize: 20, color: Colors.green),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Product Catalogue".toUpperCase(),
                                      style: GoogleFonts.aBeeZee(
                                          fontSize: 12.9, color: Colors.green),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 7.51,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 7.51,
                            width: 10,
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "SERVICE PROVIDER",
                                style: GoogleFonts.aBeeZee(fontSize: 18),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Get connected with our provider",
                                style: GoogleFonts.aBeeZee(
                                    fontSize: 12.9, color: Colors.grey),
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
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 12,
                            width: MediaQuery.of(context).size.width / 2.19,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height / 12,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: Colors.brown,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Contact Us",
                                style: GoogleFonts.aBeeZee(
                                    fontSize: 18, color: Colors.brown),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Stack(
                        children: [
                          Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width / 2.15,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 60,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: Colors.teal[900],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Profile",
                                style: GoogleFonts.aBeeZee(
                                    fontSize: 18, color: Colors.teal[900]),
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
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 7.51,
                            width: MediaQuery.of(context).size.width / 2.19,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height / 7.51,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: Colors.red[800],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "SUGGESTION",
                                    style: GoogleFonts.aBeeZee(
                                        fontSize: 20, color: Colors.red[800]),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Give suggestions",
                                    style: GoogleFonts.aBeeZee(
                                        fontSize: 13, color: Colors.red[800]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 7.51,
                            width: MediaQuery.of(context).size.width / 2.15,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height / 7.51,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: Colors.lightBlueAccent,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "TERMS & \nCONDITIONS",
                                    style: GoogleFonts.aBeeZee(
                                        fontSize: 18,
                                        color: Colors.lightBlueAccent),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "View Details",
                                    style: GoogleFonts.aBeeZee(
                                        fontSize: 12.9,
                                        color: Colors.lightBlueAccent),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height / 7.51,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rate your experience!!!",
                      style: GoogleFonts.aBeeZee(fontSize: 19),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.blue[900],
                      child: Text(
                        "Rate Now",
                        style: GoogleFonts.aBeeZee(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 100,
                width: MediaQuery.of(context).size.width,
                child: SvgPicture.asset(
              assetName,

            )),
          ],
        ),
      ),
    );
  }

  final String assetName = 'assets/w1.svg';
}
