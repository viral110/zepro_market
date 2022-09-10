import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:jalaram/Register_Form/register.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../Connect_API/api.dart';
import '../Home/bottomnavbar.dart';

class LoginOTPPage extends StatefulWidget {
  String phoneNum;
  LoginOTPPage({this.phoneNum, Key key}) : super(key: key);

  @override
  _LoginOTPPageState createState() => _LoginOTPPageState();
}

class _LoginOTPPageState extends State<LoginOTPPage>{
  TextEditingController _otp = TextEditingController();
  String otpValue = "";


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
      _otp.text = sendOtpString;
      print(_commingSms[63]+_commingSms[64]+_commingSms[65]+_commingSms[66]);
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    initSmsListener();
    print(sendOtpString);

    super.initState();
  }

  @override
  void dispose() {

    AltSmsAutofill().unregisterListener();
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    // debugPrint("value"+otpValueNew);
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Color.fromRGBO(171, 28, 36, 1),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2.4,
                // width: MediaQuery.of(context).size.width,
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
                    "Hello!",
                    style: GoogleFonts.dmSans(
                        fontSize: 29,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Good to see you back.",
                    style: GoogleFonts.dmSans(
                      fontSize: 19,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Expanded(
                    flex: 0,
                    child: Container(
                      width: 250,
                      child: PinFieldAutoFill(
                        autoFocus: true,
                        controller: _otp,
                        cursor: Cursor(color: Colors.white),
                        decoration: UnderlineDecoration(
                          // bgColorBuilder:
                          //     FixedColorBuilder(Colors.white),
                          obscureStyle: ObscureStyle(
                            isTextObscure: false,
                          ),
                          gapSpace: 20,
                          textStyle:
                              TextStyle(fontSize: 20, color: Colors.white),
                          colorBuilder: FixedColorBuilder(Colors.white),
                        ),
                        codeLength: 4,
                        // onCodeSubmitted: (String val){
                        //   print(val);
                        // }
                        onCodeChanged: (String val) async {
                          print(val);

                          if (val.length == 4) {
                            await Future.delayed(Duration(seconds: 1));
                            FocusScope.of(context).requestFocus(FocusNode());
                            sendAndRegister(val);
                            otpValue = val;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive OTP?",
                        style: GoogleFonts.aBeeZee(
                            color: Colors.white, fontSize: 18),
                      ),
                      FlatButton(
                          onPressed: () {
                            // _sendOtp();
                          },
                          child: Text("RESEND",
                              style: GoogleFonts.aBeeZee(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ))),
                    ],
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Container(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onPressed: () async {
                        setState(() {
                          sendAndRegister(otpValue);
                        });
                      },
                      child: Text(
                        "SUBMIT",
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
    );
  }

  void sendAndRegister(String otp) async {
    if (otp != null) {
      Response result =
          await ApiServices().otpSentBackend(widget.phoneNum, otp, context);

      var decoded = result.body;

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Register(),
          ));

    } else {
      Fluttertoast.showToast(msg: "Enter valid Data");
    }
  }


}
