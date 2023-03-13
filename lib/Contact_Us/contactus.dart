import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  // final UrlLauncherPlatform launcher = UrlLauncherPlatform.instance;

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
                  InkWell(
                    onTap: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Color.fromRGBO(255, 78, 91, 1),
                    ),
                  ),
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
              "assets/Logo.png",
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
                "Yogi chowk".toUpperCase(),
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
              child: SizedBox(
                width: 350,
                child: Text(
                  '316,Shajanand Business Hub,near savaliya circle,yogi chowk,surat,pincode-395010,'
                      .toUpperCase(),
                  style: GoogleFonts.aBeeZee(
                    letterSpacing: 1,
                    // fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
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
                InkWell(
                  onTap: () async {
                    setState(() {});
                    final availableMaps = await MapLauncher.installedMaps;
                    await availableMaps.first.showMarker(
                      coords: Coords(21.210162, 72.889681),
                      title: "Deluxe Ecommerce",
                    );
                    // String mapLocation =
                    //     "https://www.google.com/maps/dir/23.038489,72.4613188/Sahjanand+Business+hub.,+Raj+Mandir+Society+Rd,+Mansarovar+Society,+Yoginagar+Society,+Surat,+Gujarat+395010/@22.1200669,71.7364397,8z/data=!3m1!4b1!4m9!4m8!1m1!4e1!1m5!1m1!1s0x3be04f79a74a6f3b:0xa7b7c18080662a88!2m2!1d72.8898503!2d21.2100438";
                    // launch(mapLocation);
                    // MapsLauncher.launchCoordinates(21.210162, 72.889681);
                  },
                  child: Text(
                    "Open on map",
                    style: GoogleFonts.aBeeZee(
                        letterSpacing: 0.5, color: Colors.amber[900]),
                  ),
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
                // MaterialButton(
                //     onPressed: () {
                //
                //       // _makingPhoneCall();
                //       // FlutterPhoneDirectCaller.callNumber("+918866884361");
                //     },
                //     child: Text("Phone")),
                InkWell(
                  onTap: () {
                    // Clipboard.setData(ClipboardData(
                    //     text: "+918866884361"),)
                    //     .then((value) {
                    //   setState(() {
                    //     Fluttertoast.showToast(
                    //         msg: "Copied");
                    //
                    //   });
                    // });
                    _makingPhoneCall();
                  },
                  child: Text(
                    "+91 88668-84361",
                    style: TextStyle(color: Colors.green[900]),
                  ),
                ),
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
                "Our social preference".toUpperCase(),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Image.asset(
                      "assets/google.png",
                      height: 30,
                      width: 30,
                    ),
                    onTap: () {
                      launch(
                          "https://www.google.com/search?q=Deluxe+Ecommerce&oq=Deluxe+Ecommerce+&aqs=chrome..69i57j69i60j0i390l2.3388j0j9&client=ms-android-vivo-rvo2&sourceid=chrome-mobile&ie=UTF-8#trex=m_t:lcl_akp,rc_f:nav,rc_ludocids:4328397084949093083,rc_q:Deluxe%2520Ecommerce,ru_q:Deluxe%2520Ecommerce,trex_id:qNTnCb&lpg=cid:CgIgAQ%3D%3D");
                    },
                  ),
                  GestureDetector(
                    child: Image.asset(
                      "assets/facebook.png",
                      height: 30,
                      width: 30,
                    ),
                    onTap: () {
                      launch(
                          "https://www.facebook.com/Deluxe-Ecommerce-108933204896928/");
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      launch(
                          "https://instagram.com/deluxe_ecommerce?igshid=YmMyMTA2M2Y=");
                    },
                    child: Image.asset(
                      "assets/instagram.png",
                      height: 30,
                      width: 30,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      launch("https://telegram.me/deluxeecommerce");
                    },
                    child: Image.asset(
                      "assets/telegram.png",
                      height: 30,
                      width: 30,
                    ),
                  ),
                  GestureDetector(
                    child: Image.asset(
                      "assets/twitter.png",
                      height: 30,
                      width: 30,
                    ),
                    onTap: () {
                      launch(
                          "https://twitter.com/DeluxeEcommerce?t=dDVtQdJ27lRLDxJ7Vw8bzw&s=08");
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      launch(
                          "https://www.youtube.com/channel/UCqjNR83j4BtiqPYctw6OdVQ");
                    },
                    child: Image.asset(
                      "assets/youtube.png",
                      height: 30,
                      width: 30,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      launch("https://in.pinterest.com/deluxeecommerce/");
                    },
                    child: Image.asset(
                      "assets/pinterest.png",
                      height: 30,
                      width: 30,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Center(child: Text('4.0.3')),
            SizedBox(
              height: 5,
            ),

            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  _makingPhoneCall() async {
    // var url = Uri.parse("tel:8866884361");
    // if (await canLaunchUrl(url)) {
    //   await launchUrl(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
    launch("tel:8866884361");
    // launch(""); // Try now
  }
}
