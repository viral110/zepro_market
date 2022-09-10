import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:jalaram/Connect_API/api.dart';
import 'package:jalaram/Home/bottomnavbar.dart';
import 'package:jalaram/Register_Form/register.dart';
import 'package:jalaram/login_details/login_otp_page.dart';
import 'package:alt_sms_autofill/alt_sms_autofill.dart';

import 'package:provider/provider.dart';

import 'package:sms_autofill/sms_autofill.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class LoginWithMobile extends StatefulWidget {
  @override
  _LoginWithMobileState createState() => _LoginWithMobileState();
}

class _LoginWithMobileState extends State<LoginWithMobile> {
  final _globalKey = GlobalKey<FormState>();

  Future<FirebaseApp> _firebaseApp;

  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _otp = TextEditingController();

  String _commingSms = 'Unknown';

  String sendOtpString = '';

  Future<void> initSmsListener() async {

    String commingSms;
    try {
      commingSms = await AltSmsAutofill().listenForSms;
    } on PlatformException {
      commingSms = 'Failed to get Sms.';
    }
    if (!mounted) return;

    setState(() {
      _commingSms = commingSms;
      sendOtpString = _commingSms[63]+_commingSms[64]+_commingSms[65]+_commingSms[66];
      print(_commingSms[63]+_commingSms[64]+_commingSms[65]+_commingSms[66]);
    });

  }

  @override
  void dispose() {

    AltSmsAutofill().unregisterListener();
    super.dispose();

  }

  bool isLogged = false;
  bool otpSent = false;
  String uid;
  String _verificationId;

  // void _sendOtp() async {
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //       timeout: Duration(seconds: 40),
  //       phoneNumber: "+91${_phoneNumber.text}",
  //       verificationCompleted: verificationCompleted,
  //       verificationFailed: verificationFailed,
  //       codeSent: codeSent,
  //       codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  //   setState(() {
  //     otpSent = true;
  //   });
  // }
  //
  // void verificationCompleted(PhoneAuthCredential credential) async {
  //   await FirebaseAuth.instance.signInWithCredential(credential);
  //   if (FirebaseAuth.instance.currentUser != null) {
  //     setState(() {
  //       isLogged = true;
  //       uid = FirebaseAuth.instance.currentUser.uid;
  //       sendAndRegister();
  //     });
  //   } else {
  //     print("Something is error");
  //   }
  // }
  //
  // void verificationFailed(FirebaseAuthException exception) async {
  //   print(exception.message);
  //   setState(() {
  //     isLogged = false;
  //     otpSent = false;
  //   });
  // }
  //
  // void codeSent(String verificationId, [int a]) async {
  //   setState(() {
  //     _verificationId = verificationId;
  //     otpSent = true;
  //   });
  // }
  //
  // void codeAutoRetrievalTimeout(String verificationId) async {
  //   setState(() {
  //     _verificationId = verificationId;
  //     otpSent = true;
  //   });
  // }
  //
  // void verifyOtp() async {
  //   final credential = PhoneAuthProvider.credential(
  //       verificationId: _verificationId, smsCode: _otp.text);
  //   try {
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //     if (FirebaseAuth.instance.currentUser != null) {
  //       setState(() {
  //         isLogged = true;
  //         uid = FirebaseAuth.instance.currentUser.uid;
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _firebaseApp = Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
        // backgroundColor: Color.fromRGBO(171, 28, 36, 1),
        body: SafeArea(
      child: Form(
        key: _globalKey,
        child: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Color.fromRGBO(171, 28, 36, 1),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(alignment: Alignment.center, children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                            "assets/borderbg.png",
                          ),
                        ),
                      ),
                    ),
                    Image.asset(
                      "assets/onlyd.jpg",
                      height: 150,
                      width: 150,
                    ),
                  ]),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 45,
                    ),
                    Text(
                      "Welcome",
                      style: GoogleFonts.dmSans(
                          fontSize: 29,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Sign In access your account",
                      style: GoogleFonts.dmSans(
                        fontSize: 19,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 0,
                              child: Container(
                                height: 60,
                                width: 100,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  // color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset(
                                      "assets/indiaflag.jpg",
                                      height: 30,
                                      width: 30,
                                    ),
                                    Text(
                                      "+91",
                                      style: GoogleFonts.dmSans(
                                        fontSize: 19,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: TextFormField(
                                controller: _phoneNumber,
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.dmSans(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                decoration: new InputDecoration(
                                  hintText: '00000 00000',
                                  hintStyle: GoogleFonts.dmSans(
                                    color: Colors.white,
                                    fontSize: 20,
                                    letterSpacing: 1.3,
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      left: 8, right: 8, top: 15, bottom: 20),

                                  // labelText: "Mobile",
                                  // prefix: Text(
                                  //   "+91 | ",
                                  //   style: TextStyle(color: Colors.black87),
                                  // ),
                                  // enabled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 55,
                    ),
                    Container(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onPressed: () async {
                          setState(() {
                            sendAndRegister();
                          });
                        },
                        child: Text(
                          "GENERATE OTP",
                          style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              letterSpacing: 1),
                        ),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width / 1.19,
                      height: 60,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void sendAndRegister() async {
    if (_globalKey.currentState.validate()) {
      var mobileNum = _phoneNumber.text;

      Response result =
          await ApiServices().loginAuthWithOTP(mobileNum, context);

      // await SmsAutoFill().listenForCode();
    } else {
      Fluttertoast.showToast(msg: "Enter valid Data");
    }
  }
}

class Controller extends ControllerMVC {
  static String mobileScreen = "We will send you 6 digit verification code";
  static String otpScreen = "Enter the OTP sent to ";
}
