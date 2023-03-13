import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:jalaram/Connect_API/api.dart';
import 'package:jalaram/Home/bottomnavbar.dart';
import 'package:jalaram/Register_Form/register.dart';
import 'package:jalaram/component/back_button.dart';
import 'package:jalaram/login_details/login_otp_page.dart';

import 'package:provider/provider.dart';

import 'package:sms_autofill/sms_autofill.dart';

class LoginWithMobile extends StatefulWidget {
  @override
  _LoginWithMobileState createState() => _LoginWithMobileState();
}

class _LoginWithMobileState extends State<LoginWithMobile> {
  final _globalKey = GlobalKey<FormState>();

  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _otp = TextEditingController();

  String _commingSms = 'Unknown';

  String sendOtpString = '';

  bool isLogged = false;
  bool otpSent = false;
  String uid;
  String _verificationId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
        body: SafeArea(
      child: Form(
        key: _globalKey,
        child: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width,
                child: Stack(alignment: Alignment.center, children: [
                  Image.asset(
                    "assets/login_number.jpg",
                  ),
                ]),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Welcome,",
                    style: GoogleFonts.dmSans(
                        fontSize: 29,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Sign In access your account",
                    style: GoogleFonts.dmSans(
                      fontSize: 19,
                      color: Colors.black,
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
                                border: Border.all(
                                    color: Color.fromRGBO(255, 78, 91, 1)),
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
                                      color: Colors.black,
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
                                color: Colors.black,
                                fontSize: 20,
                              ),
                              onChanged: (value) {
                                if (value.length == 10) {
                                  FocusScope.of(context).unfocus();
                                }
                              },
                              decoration: new InputDecoration(
                                hintText: '00000 00000',
                                hintStyle: GoogleFonts.dmSans(
                                  color: Colors.black,
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
                                    color: Color.fromRGBO(255, 78, 91, 1),
                                    width: 1,
                                  ),
                                ),

                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(255, 78, 91, 1),
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(255, 78, 91, 1),
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
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(255, 78, 91, 1),
                      )),
                      onPressed: () async {
                        if (_phoneNumber.text.length != 10) {
                          Fluttertoast.showToast(msg: "Enter Valid Number");
                        } else {
                          setState(() {
                            sendAndRegister();
                          });
                        }
                      },
                      child: Text(
                        "GENERATE OTP",
                        style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            letterSpacing: 1,
                            color: Colors.white),
                      ),
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
    ));
  }

  void sendAndRegister() async {
    if (_globalKey.currentState.validate()) {
      var mobileNum = _phoneNumber.text;

      if (mobileNum == "9157893772") {
        openAndCloseLoadingDialog(context: context);
        await ApiServices().loginForGoogleDevelop(mobileNum, context);
      } else {
        openAndCloseLoadingDialog(context: context);
        await ApiServices().loginAuthWithOTP(mobileNum, context);
      }

      // await SmsAutoFill().listenForCode();
    } else {
      Fluttertoast.showToast(msg: "Enter valid Data");
    }
  }
}

// class Controller extends ControllerMVC {
//   static String mobileScreen = "We will send you 6 digit verification code";
//   static String otpScreen = "Enter the OTP sent to ";
// }
