import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:jalaram/Contact_Us/contactus.dart';
import 'package:jalaram/Home/bottomnavbar.dart';
import 'package:jalaram/Home/homepage.dart';
import 'package:jalaram/Home/notification_page.dart';
import 'package:jalaram/Model/register_auth_model.dart';

import 'package:jalaram/Pending_Order/pendingorder.dart';
import 'package:jalaram/Register_Form/register.dart';
import 'package:jalaram/Suggestion/suggestion.dart';
import 'package:jalaram/Terms%20&%20Conditions/termsconditions.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../Connect_API/api.dart';
import '../Model/get_profile_image.dart';
import '../Splash_Screen/splashscreen.dart';
import '../main.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  RegisterAuth ra;
  GetProfilePic gpp;

  bool isGetProfile = false;
  bool isGetProfilePicture = false;

  getProfileData() async {
    // await Future.delayed(Duration(milliseconds: 300), () async {
    Response response = await ApiServices().registerAuthGet(context);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ra = RegisterAuth.fromJson(decoded);
      getProfileImages();
      // Fluttertoast.showToast(msg: "get profile products");
      setState(() {
        isGetProfile = true;
      });
    }
    // });
  }

  getProfileImages() async {
    // await Future.delayed(Duration(milliseconds: 300), () async {
    Response response = await ApiServices().getProfilePic(context);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      gpp = GetProfilePic.fromJson(decoded);
      print(gpp.image);
      // Fluttertoast.showToast(msg: "get profile Image");
      setState(() {
        isGetProfilePicture = true;
      });
    }
    // });
  }

  void showPopUpForLogOut() async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(800, 80, 0, 100),
      items: [
        PopupMenuItem(
          child: InkWell(
            onTap: () {
              storeKeyByGet.remove('access_token');
              storageKey.delete(key: 'access_token');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SplashScreen(),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/logout.png",
                  height: 26,
                  width: 26,
                  fit: BoxFit.cover,
                  // color: Colors.white,
                ),
                SizedBox(
                  width: 9,
                ),
                Text(
                  "Logout",
                  style: GoogleFonts.dmSans(
                    // color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  int value = 1;

  bool isActiveRagister = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isGetProfile == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BottomNavBar(index: 0),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 18,
                                // color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            "Profile",
                            style: GoogleFonts.dmSans(
                                fontSize: 18, color: Colors.black),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () async {
                                return showPopUpForLogOut();
                              },
                              child: Icon(Icons.more_vert),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 19,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Register(value: value,isActive: isActiveRagister),
                            ));
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 5, bottom: 5),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[100],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            isGetProfilePicture == true
                                ? CircleAvatar(
                                    radius: 32,
                                    // backgroundColor: Colors.white,
                                    backgroundImage: gpp.image != null
                                        ? NetworkImage("${gpp.image}")
                                        : AssetImage('assets/user.png'),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome to",
                                  style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    letterSpacing: 0,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                Text(
                                  ra.name ?? "",
                                  style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    letterSpacing: 0,
                                    // color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 11,
                    bottom: 12,
                    top: 8,
                  ),
                  child: Text(
                    "Information",
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 1,
                      // color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PendingOrder(),
                        ));
                  },
                  child: ListTile(
                    //menu item of Drawer
                    leading: Image.asset(
                      "assets/new/1.png",
                      height: 27,
                      width: 28,
                      // color: Colors.white,
                    ),
                    title: Text(
                      'My Orders',
                      style: GoogleFonts.dmSans(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,

                        fontSize: 15,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                        size: 15, color: Colors.black),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    dense: true,
                  ),
                ),
                Divider(
                  color: Colors.grey[200],
                  thickness: 1,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactUs(),
                        ));
                  },
                  child: ListTile(
                    //menu item of Drawer
                    leading: Image.asset(
                      "assets/new/2.png",
                      height: 20,
                      width: 20,
                      fit: BoxFit.fill,
                      // color: Colors.white,
                    ),
                    title: Text(
                      'Contact us',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Colors.black,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    dense: true,
                  ),
                ),
                Divider(
                  color: Colors.grey[200],
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 11,
                    bottom: 12,
                    top: 25,
                  ),
                  child: Text(
                    "Settings",
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 1,
                      // color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Suggestion(),
                        ));
                  },
                  child: ListTile(
                    //menu item of Drawer
                    leading: Image.asset(
                      "assets/new/3.png",
                      height: 22,
                      width: 22,
                      // color: Colors.white,
                    ),
                    title: Text(
                      'Suggestion',
                      style: GoogleFonts.dmSans(
                        // color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Colors.black,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    dense: true,
                  ),
                ),
                Divider(
                  color: Colors.grey[200],
                  thickness: 1,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TermsConditions(),
                        ));
                  },
                  child: ListTile(
                    //menu item of Drawer
                    leading: Image.asset(
                      "assets/new/4.png",
                      height: 24,
                      width: 24,
                      // color: Colors.white,
                    ),
                    title: Text(
                      'Terms & Conditions',
                      style: GoogleFonts.dmSans(
                        // color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Colors.black,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    dense: true,
                  ),
                ),
                Divider(
                  color: Colors.grey[200],
                  thickness: 1,
                ),
                GestureDetector(
                  onTap: () async {
                    String url = "https://wa.me/message/BNVDJLNNKI6XM1";
                    if (!await launch(url)) throw 'Could not launch $url';
                  },
                  child: ListTile(
                    //menu item of Drawer
                    leading: Image.asset(
                      "assets/new/5.png",
                      height: 28,
                      width: 28,
                      // color: Colors.white,
                    ),
                    title: Text(
                      'Help & Support',
                      style: GoogleFonts.dmSans(
                        // color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Colors.black,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    dense: true,
                  ),
                ),
                Divider(
                  color: Colors.grey[200],
                  thickness: 1,
                ),
                SizedBox(
                  height: 30,
                ),
                // InkWell(
                //   onTap: () {},
                //   child: Container(
                //     margin: EdgeInsets.only(
                //       left: 100,
                //       right: 100,
                //       top: 8,
                //     ),
                //     padding: EdgeInsets.all(8),
                //     // color: Colors.amber,
                //     decoration: BoxDecoration(
                //       border: Border.all(color: Colors.black),
                //     ),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Image.asset(
                //           "assets/logout.png",
                //           height: 26,
                //           width: 26,
                //           fit: BoxFit.cover,
                //           // color: Colors.white,
                //         ),
                //         SizedBox(
                //           width: 9,
                //         ),
                //         Text(
                //           "Logout",
                //           style: GoogleFonts.dmSans(
                //             // color: Colors.white,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 18,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "© Deluxe Ecommerce 2022 - India B2B Marketplace",
                      style: GoogleFonts.dmSans(
                        color: Colors.blueGrey,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5.5,
                ),
              ],
            ),
    );
  }
}
