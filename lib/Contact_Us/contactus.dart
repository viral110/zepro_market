import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Color.fromRGBO(255, 78, 91, 1),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Contact Us",
                    style: GoogleFonts.aBeeZee(
                        color: Color.fromRGBO(255, 78, 91, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 2),
                  ),
                ],
              ),
            ),
            Divider(
              height: 15,
              thickness: 1.1,
            ),
            SizedBox(
              height: 60,
            ),
            Image.asset(
              "assets/logo.png",
              height: 60,
              width: 110,
            ),
            SizedBox(
              height: 60,
            ),
            Divider(
              color: Colors.grey[200],
              height: 15,
              thickness: 5.5,
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "kATArgam".toUpperCase(),
                style: GoogleFonts.aBeeZee(
                  letterSpacing: 1,
                  color: Colors.green[900],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 05,
            ),
            Center(
              child: Text(
                '''14,MarutiNagar,mohan cha,
       Behing bus work shop,
                  surat
              '''
                    .toUpperCase(),
                style: GoogleFonts.aBeeZee(
                  letterSpacing: 1,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_pin,
                  color: Colors.amber[900],
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Open on map",
                  style: GoogleFonts.aBeeZee(
                      letterSpacing: 0.5, color: Colors.amber[900]),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.call,
                  color: Colors.green[900],
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "9157893772",
                  style: TextStyle(color: Colors.green[900]),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              color: Colors.grey[200],
              height: 15,
              thickness: 5.5,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.watch_later_outlined,
                  color: Colors.green[900],
                ),
                SizedBox(
                  width: 5,
                ),
                Center(
                  child: Text(
                    "Timings".toUpperCase(),
                    style: GoogleFonts.aBeeZee(
                      letterSpacing: 2,
                      color: Colors.green[900],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 05,
            ),
            Center(
              child: Text(
                "Monday - Saturday".toUpperCase(),
                style: GoogleFonts.aBeeZee(
                  letterSpacing: 1,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                "9 AM - 6 PM".toUpperCase(),
                style: GoogleFonts.aBeeZee(
                  letterSpacing: 1,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "Sunday".toUpperCase(),
                style: GoogleFonts.aBeeZee(
                  letterSpacing: 1,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                "9 AM - 1 PM".toUpperCase(),
                style: GoogleFonts.aBeeZee(
                  letterSpacing: 1,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "Our Lunch Time".toUpperCase(),
                style: GoogleFonts.aBeeZee(
                  letterSpacing: 1,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                "1 PM - 2 PM".toUpperCase(),
                style: GoogleFonts.aBeeZee(
                  letterSpacing: 1,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              color: Colors.grey[200],
              height: 15,
              thickness: 5.5,
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Our social preference",
                style: GoogleFonts.aBeeZee(
                  letterSpacing: 1,
                  fontSize: 18,
                  color: Colors.green[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/google.png",
                      height: 30,
                      width: 30,
                    ),
                    Image.asset(
                      "assets/facebook.png",
                      height: 30,
                      width: 30,
                    ),
                    Image.asset(
                      "assets/instagram.png",
                      height: 30,
                      width: 30,
                    ),
                    Image.asset(
                      "assets/telegram.png",
                      height: 30,
                      width: 30,
                    ),
                    Image.asset(
                      "assets/twitter.png",
                      height: 30,
                      width: 30,
                    ),
                    Image.asset(
                      "assets/youtube.png",
                      height: 30,
                      width: 30,
                    ),
                    Image.asset(
                      "assets/pinterest.png",
                      height: 30,
                      width: 30,
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Text(
                "Our Developer",
                style: GoogleFonts.aBeeZee(
                  letterSpacing: 1,
                  fontSize: 18,
                  color: Colors.green[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                "Viral Vegad",
                style: GoogleFonts.aBeeZee(
                  letterSpacing: 1,
                  fontSize: 12,
                  color: Colors.grey,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                "viralvegad2001@gmail.com",
                style: GoogleFonts.aBeeZee(
                  letterSpacing: 1,
                  fontSize: 12,
                  color: Colors.grey,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
