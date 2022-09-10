import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jalaram/Connect_API/api.dart';
import 'package:jalaram/Model/get_profile_image.dart';
import 'package:jalaram/Model/register_auth_model.dart';
import 'package:jalaram/login_details/loginwithmobile.dart';

class Register extends StatefulWidget {
  int value;
  Register({this.value});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final picker = ImagePicker();

  int val;
  bool _value = false;

  String _streetNumber = '';
  String _street = '';
  String _city = '';
  String _zipCode = '';
  File _image;
  String stateValue = "";
  String cityValue = "";
  String countryValue = "";

  TextEditingController _cityAndStateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();

  @override
  void dispose() {
    _cityAndStateController.dispose();
    super.dispose();
  }

  bool isGetProfile = false;
  bool isGetProfileImage = false;

  RegisterAuth ra;
  GetProfilePic gpp;

  getProfileData() async {
    // await Future.delayed(Duration(milliseconds: 300), () async {
    Response response = await ApiServices().registerAuthGet(context);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ra = RegisterAuth.fromJson(decoded);
      getProfileImages();
      setVariableAsTextFeild();
      Fluttertoast.showToast(msg: "get profile products");
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

      Fluttertoast.showToast(msg: "get profile products");
      setState(() {
        isGetProfileImage = true;
      });
    }
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileData();
  }

  setVariableAsTextFeild() {
    nameController.text = ra.name;
    emailController.text = ra.email;
    companyNameController.text = ra.companyName;
    if (ra.address == "Surat") {
      setState(() {
        val = 1;
      });
    } else {
      setState(() {
        val = 2;
        addressController.text = ra.address;
        landmarkController.text = ra.landmark;
        pinCodeController.text = ra.pincode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(171, 28, 36, 1),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade100,
          child: SafeArea(
            child: isGetProfile == false
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 2.5,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(171, 28, 36, 1),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                  "assets/border2.png",
                                ),
                              ),
                            ),
                          ),
                          isGetProfileImage == true
                              ? CircleAvatar(
                                  radius: 64,
                                  child: _image != null || gpp.image != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(61),
                                          child: _image == null
                                              ? Image.network(
                                                  gpp.image,
                                                  height: 130,
                                                  width: 130,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.file(
                                                  _image,
                                                  height: 130,
                                                  width: 130,
                                                  fit: BoxFit.cover,
                                                ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            showImageChooseBottom(context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(61),
                                            ),
                                            width: 124,
                                            height: 124,
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ),
                                )
                              : Container(),
                          isGetProfileImage == true
                              ? _image == null && gpp.image == null
                                  ? Container()
                                  : Positioned(
                                      // right: 140,

                                      top: 190,
                                      bottom: 110,
                                      left: MediaQuery.of(context).size.width /
                                          1.65,
                                      child: InkWell(
                                        onTap: () {
                                          showImageChooseBottom(context);
                                        },
                                        child: Container(
                                          height: 22,
                                          width: 22,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black,
                                          ),
                                          child: Icon(Icons.edit,
                                              color: Colors.white, size: 12),
                                        ),
                                      ),
                                    )
                              : Container(),
                          Positioned(
                            bottom: 65,
                            child: Text(
                              "Note: Your own profile picture is mandatory",
                              style: GoogleFonts.dmSans(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              alignment: Alignment.topLeft,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                  icon: Icon(Icons.arrow_back_ios_rounded),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 60,
                      ),
                      Container(
                        color: Color.fromRGBO(171, 28, 36, 1),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 60,
                            ),
                            Align(
                              child: Text(
                                "Sign Up",
                                style: GoogleFonts.nunito(
                                    fontSize: 32,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2),
                              ),
                              alignment: Alignment.topCenter,
                            ),
                            SizedBox(
                              height: 27,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Name",
                                    style: GoogleFonts.aBeeZee(
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  TextField(
                                    style:
                                        GoogleFonts.dmSans(color: Colors.white),
                                    controller: nameController,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person,
                                            color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        contentPadding: EdgeInsets.all(12)),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Email",
                                    style: GoogleFonts.aBeeZee(
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  TextField(
                                    controller: emailController,
                                    style:
                                        GoogleFonts.dmSans(color: Colors.white),
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Colors.white,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        contentPadding: EdgeInsets.all(10)),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Company Name",
                                    style: GoogleFonts.aBeeZee(
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  TextField(
                                    controller: companyNameController,
                                    style:
                                        GoogleFonts.dmSans(color: Colors.white),
                                    decoration: InputDecoration(
                                        prefixIcon: Image.asset(
                                          "assets/company.png",
                                          height: 10,
                                          width: 10,
                                          color: Colors.white,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        contentPadding: EdgeInsets.all(10)),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Where are you from?",
                                    style: GoogleFonts.aBeeZee(
                                        color: Colors.white),
                                  ),
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                        unselectedWidgetColor: Colors.white,
                                        disabledColor: Colors.blue),
                                    child: Row(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Radio(
                                                focusColor: Colors.white,
                                                activeColor: Colors.white,
                                                hoverColor: Colors.white,
                                                value: 1,
                                                groupValue: val,
                                                onChanged: (value) {
                                                  setState(() {
                                                    val = value;
                                                  });
                                                }),
                                            Text(
                                              "Surat",
                                              style: GoogleFonts.aBeeZee(
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Radio(
                                                value: 2,
                                                groupValue: val,
                                                activeColor: Colors.white,
                                                onChanged: (value) {
                                                  setState(() {
                                                    val = value;
                                                  });
                                                }),
                                            Text(
                                              "Other City",
                                              style: GoogleFonts.aBeeZee(
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  val == 1 ? fromSurat() : fromOtherCity(),
                                  SizedBox(
                                    height: 18,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: RaisedButton(
                                      padding:
                                          EdgeInsets.only(top: 11, bottom: 11),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      color: Colors.white,
                                      onPressed: () async {
                                        String name = nameController.text;
                                        String email = emailController.text;
                                        String companyName =
                                            companyNameController.text;
                                        String address = "";
                                        String landmark = "";
                                        String pincode = "";
                                        if (val == 1) {
                                          address = "Surat";
                                        } else if (val == 2) {
                                          address = addressController.text;
                                          landmark = landmarkController.text;
                                          pincode = pinCodeController.text;
                                        }

                                        await ApiServices().profileImageUpload(
                                            context, _image);

                                        await ApiServices().registerAuth(
                                          name,
                                          email,
                                          companyName,
                                          address,
                                          landmark,
                                          pincode,
                                          widget.value,
                                          context,
                                        );
                                      },
                                      child: Text(
                                        "SUBMIT",
                                        style: GoogleFonts.nunito(
                                            color: Colors.black,
                                            letterSpacing: 2,
                                            fontSize: 19),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No Image Selected");
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No Image Selected");
      }
    });
  }

  void showImageChooseBottom(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Container(
            child: Wrap(
              children: [
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Photo Library'),
                    onTap: () {
                      getImageFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    getImageFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ));
        });
  }

  Widget fromSurat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "City",
        //   style: GoogleFonts.aBeeZee(),
        // ),
        // SizedBox(
        //   height: 7,
        // ),
        // TextField(
        //   decoration: InputDecoration(
        //       prefixIcon: Icon(Icons.location_on),
        //       border: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(5),
        //       ),
        //       contentPadding: EdgeInsets.all(12)),
        // ),
      ],
    );
  }

  Widget fromOtherCity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Address",
          style: GoogleFonts.dmSans(
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 7,
        ),
        TextField(
          style: GoogleFonts.dmSans(color: Colors.white),
          controller: addressController,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.location_searching,
                color: Colors.white,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.white),
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
              contentPadding: EdgeInsets.all(12)),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          "Landmark",
          style: GoogleFonts.dmSans(
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 7,
        ),
        TextField(
          controller: landmarkController,
          style: GoogleFonts.dmSans(color: Colors.white),
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.flag,
                color: Colors.white,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.white),
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
              contentPadding: EdgeInsets.all(12)),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          "Pincode",
          style: GoogleFonts.dmSans(
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 7,
        ),
        TextField(
          controller: pinCodeController,
          style: GoogleFonts.dmSans(color: Colors.white),
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.white),
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
              contentPadding: EdgeInsets.all(12)),
        ),
      ],
    );
  }
}
