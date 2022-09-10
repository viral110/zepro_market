// import 'package:assets_audio_player/assets_audio_player.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:jalaram/Model/fetch_order_id.dart';
import 'package:jalaram/Pending_Order/pendingorder.dart';

import '../Connect_API/api.dart';
import '../Home/bottomnavbar.dart';

class ConfirmOrderPage extends StatefulWidget {
  final String id;
  const ConfirmOrderPage({this.id, Key key}) : super(key: key);

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    callMusicFunc();

    // WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    audioPlayer = null;
    audioPlayer.dispose();
    super.dispose();
  }

  bool isLoading = false;

  Future callMusicFunc() async {
    String audioAsset = "assets/new/smstone.mp3";
    ByteData bytes = await rootBundle.load(audioAsset); //load sound from assets
    Uint8List soundbytes =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    int result = await audioPlayer.playBytes(soundbytes);
    if (result == 1) {
      //play success
      print("Sound playing successful.");
    } else {
      print("Error while playing sound.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading != true
            ? SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 0,
                      ),
                      Image.asset(
                        "assets/check-mark.png",
                        height: 130,
                        width: 130,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Order Confirmed",
                        style: GoogleFonts.dmSans(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Your Order is Confirmed. Thank you for shopping with us",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          color: Colors.black38,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Your Order ID is: \n       ${widget.id}",
                        style: GoogleFonts.dmSans(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Show this order ID to Cashier while pickup",
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            color: Colors.black38,
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Please Pickup your order within 24 hours.It will be automatically canceled after 24 hours of you order time",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                            fontSize: 16, color: Colors.red, letterSpacing: 0.6),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "We have received your order. One of our sales executives will contact you with further information regarding payment & shipping",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(fontSize: 16),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottomNavBar(),
                              ));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Color.fromRGBO(4, 75, 90, 1),
                          ),
                          child: Text(
                            "Back To Home",
                            style: GoogleFonts.dmSans(
                                color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                              text:
                                  "Note: For Out of Surat Seller Take Screenshot send on Whatsapp",
                              style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            ),
                            TextSpan(
                              text: "+918866884361",
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ])),
                    ],
                  ),
                ),
            )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
