import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jalaram/Connect_API/api.dart';
import 'package:jalaram/Register_Form/register.dart';
import 'package:jalaram/bloc_pattern/blocpattern.dart';
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

  bool isLogged = false;
  bool otpSent = false;
  String uid;
  String _verificationId;

  void _sendOtp() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        timeout: Duration(seconds: 40),
        phoneNumber: "+91${_phoneNumber.text}",
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    setState(() {
      otpSent = true;
    });
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    await FirebaseAuth.instance.signInWithCredential(credential);
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        isLogged = true;
        uid = FirebaseAuth.instance.currentUser.uid;
      });
    } else {
      print("Something is error");
    }
  }

  void verificationFailed(FirebaseAuthException exception) async {
    print(exception.message);
    setState(() {
      isLogged = false;
      otpSent = false;
    });
  }

  void codeSent(String verificationId, [int a]) async {
    setState(() {
      _verificationId = verificationId;
      otpSent = true;
    });
  }

  void codeAutoRetrievalTimeout(String verificationId) async {
    setState(() {
      _verificationId = verificationId;
      otpSent = true;
    });
  }

  void verifyOtp() async {
    final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: _otp.text);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (FirebaseAuth.instance.currentUser != null) {
        setState(() {
          isLogged = true;
          uid = FirebaseAuth.instance.currentUser.uid;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _firebaseApp = Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<LoginWithAuth>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _globalKey,
          child: FutureBuilder(
            future: _firebaseApp,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return CircularProgressIndicator();
              return isLogged
                  ? sendAndRegister
                  : otpSent
                      ? SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/app1.png"),
                                    ),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "OTP verification",
                                  style: GoogleFonts.aBeeZee(fontSize: 22),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${Controller.otpScreen}" +
                                          "+91" +
                                          _phoneNumber.text,
                                      style: GoogleFonts.aBeeZee(
                                          fontSize: 16, color: Colors.black45),
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginWithMobile(),
                                              ));
                                        })
                                  ],
                                ),
                                SizedBox(
                                  height: 45,
                                ),
                                PinFieldAutoFill(
                                  autoFocus: true,
                                  controller: _otp,
                                  decoration: BoxLooseDecoration(
                                    strokeColorBuilder:
                                        FixedColorBuilder(Colors.grey),
                                    obscureStyle: ObscureStyle(
                                      isTextObscure: true,
                                    ),
                                    textStyle: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                  codeLength: 6,

                                  // onCodeChanged: (code) {
                                  //   print(code);
                                  //
                                  //   // FocusScope.of(context).requestFocus(FocusNode());
                                  // },
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't receive OTP?",
                                      style: GoogleFonts.aBeeZee(
                                          color: Color.fromRGBO(49, 60, 51, 1),
                                          fontSize: 18),
                                    ),
                                    FlatButton(
                                        onPressed: () {
                                          _sendOtp();
                                        },
                                        child: Text("Resend",
                                            style: GoogleFonts.aBeeZee(
                                              color: Color.fromRGBO(
                                                  255, 99, 71, 0.9),
                                              fontSize: 18,
                                            ))),
                                  ],
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Container(
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    onPressed: () {
                                      sendAndRegister();
                                    },
                                    child: Text("Verify"),
                                    color: Color.fromRGBO(255, 99, 71, 0.9),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Welcome to",
                                  style: GoogleFonts.nunito(
                                      fontSize: 29,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Zocro E-Commerce",
                                  style: GoogleFonts.nunito(
                                      fontSize: 33,
                                      color: Color.fromRGBO(255, 99, 71, 1),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/app.png"),
                                    ),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height / 3.4,
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Text(
                                  "Enter your phone number",
                                  style: GoogleFonts.aBeeZee(fontSize: 22),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${Controller.mobileScreen}",
                                  style: GoogleFonts.aBeeZee(
                                      fontSize: 16, color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                StreamBuilder(
                                    stream: bloc.loginNumber,
                                    builder: (context, snapshot) {
                                      return TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: _phoneNumber,
                                        decoration: InputDecoration(
                                          labelText: "Mobile",
                                          contentPadding: EdgeInsets.all(12),
                                          hintText: "Phone number",
                                          prefix: Text(
                                            "+91 | ",
                                            style: TextStyle(
                                                color: Colors.black87),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      );
                                    }),
                                SizedBox(
                                  height: 55,
                                ),
                                Container(
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    onPressed: () async {
                                      _sendOtp();

                                    },
                                    child: Text("GENERATE OTP"),
                                    color: Color.fromRGBO(255, 99, 71, 0.9),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                        );
            },
          ),
        ),
      ),
    );
  }
  void sendAndRegister () async {
    var userId;
    if(_globalKey.currentState.validate()){

      var mobileNum = _phoneNumber.text;
      var result = await loginAuth(userId, mobileNum);
      print(result.toString());

    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => Register(),));
  }
}

class Controller extends ControllerMVC {
  static String mobileScreen = "We will send you 6 digit verification code";
  static String otpScreen = "Enter the OTP sent to ";
}
