import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jalaram/Contact_Us/contactus.dart';

import 'package:jalaram/Pending_Order/pendingorder.dart';
import 'package:jalaram/Register_Form/register.dart';
import 'package:jalaram/Suggestion/suggestion.dart';
import 'package:jalaram/Terms%20&%20Conditions/termsconditions.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
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
                          Navigator.pop(context);
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
                      style:
                          GoogleFonts.dmSans(fontSize: 18, color: Colors.black),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          "assets/bell.jpeg",
                          height: 30,
                          width: 30,
                        ),
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
                        builder: (context) => Register(),
                      ));
                },
                child: Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
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
                      CircleAvatar(
                        radius: 32,
                        // backgroundColor: Colors.white,
                        backgroundImage: AssetImage("assets/hanuman.jpg"),
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
                            "Aleena Hanshika",
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
              trailing:
                  Icon(Icons.arrow_forward_ios, size: 15, color: Colors.black),
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
            height: MediaQuery.of(context).size.height / 15,
          ),
          Container(
            margin: EdgeInsets.only(
              left: 100,
              right: 100,
              top: 8,
            ),
            padding: EdgeInsets.all(8),
            // color: Colors.amber,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
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
