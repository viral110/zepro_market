import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jalaram/Contact_Us/contactus.dart';

import 'package:jalaram/Pending_Order/pendingorder.dart';
import 'package:jalaram/Suggestion/suggestion.dart';
import 'package:jalaram/Terms%20&%20Conditions/termsconditions.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromRGBO(255, 78, 91, 1),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width / 20,
        child: ListView(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 19,
                ),
                Stack(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage("assets/hanuman.jpg"),
                      ),
                    ),
                    Positioned(
                      child: Icon(
                        Icons.edit,
                        size: 14,
                        color: Colors.white,
                      ),
                      height: 20,
                      left: 195,
                      top: 1,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Aleena Hanshika",
                  style: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 1,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Divider(
                  height: 10,
                  thickness: 10,
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(
              height: 10,
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
                  height: 32,
                  width: 35,
                  color: Colors.white,
                ),
                title: Text(
                  'My Orders',
                  style: GoogleFonts.aBeeZee(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                dense: true,
              ),
            ),
            Divider(
              color: Colors.white,
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
                  height: 27,
                  width: 27,
                  color: Colors.white,
                ),
                title: Text(
                  'Contact us',
                  style: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                dense: true,
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 1,
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
                  height: 27,
                  width: 27,
                  color: Colors.white,
                ),
                title: Text(
                  'Suggestion',
                  style: GoogleFonts.aBeeZee(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                dense: true,
              ),
            ),
            Divider(
              color: Colors.white,
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
                  height: 27,
                  width: 27,
                  color: Colors.white,
                ),
                title: Text(
                  'Terms & Conditions',
                  style: GoogleFonts.aBeeZee(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                dense: true,
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 1,
            ),
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => AboutUs(),
                //     ));
              },
              child: ListTile(
                //menu item of Drawer
                leading: Image.asset(
                  "assets/new/5.png",
                  height: 31,
                  width: 31,
                  color: Colors.white,
                ),
                title: Text(
                  'Help & Support',
                  style: GoogleFonts.aBeeZee(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                dense: true,
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 1,
            ),
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => AboutUs(),
                //     ));
              },
              child: ListTile(
                //menu item of Drawer
                leading: Image.asset(
                  "assets/new/6.png",
                  height: 23,
                  width: 23,
                  color: Colors.white,
                ),
                title: Text(
                  'Logout',
                  style: GoogleFonts.aBeeZee(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                dense: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
