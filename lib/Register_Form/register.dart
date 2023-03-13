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

String storeLocation = "";

class Register extends StatefulWidget {
  int value;
  bool isActive;
  Register({this.value, this.isActive});
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
  TextEditingController pnumberController = TextEditingController();

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
      // Fluttertoast.showToast(msg: "get profile products");
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

      // Fluttertoast.showToast(msg: "get profile products");
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

    pnumberController.text = ra.mobNumber;
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade100,
          child: SafeArea(
            child: isGetProfile == false
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
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
                        isGetProfileImage == true
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircleAvatar(
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
                                  ),
                                  isGetProfileImage == true
                                      ? _image == null && gpp.image == null
                                          ? Container()
                                          : Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: InkWell(
                                                onTap: () {
                                                  print("Hello World");
                                                  showImageChooseBottom(
                                                      context);
                                                },
                                                child: Container(
                                                  height: 22,
                                                  width: 22,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black,
                                                  ),
                                                  child: Icon(Icons.edit,
                                                      color: Colors.white,
                                                      size: 12),
                                                ),
                                              ),
                                            )
                                      : Container(),
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Note: Your own profile picture is mandatory",
                          style: GoogleFonts.dmSans(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 60,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            widget.isActive == true
                                ? SizedBox()
                                : Align(
                                    child: Text(
                                      "Sign Up",
                                      style: GoogleFonts.nunito(
                                          fontSize: 32,
                                          color: Colors.black,
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
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value == "" || value.isEmpty) {
                                        return "Enter Valid Name";
                                      }
                                      return null;
                                    },
                                    style: GoogleFonts.dmSans(
                                      color: Colors.black,
                                    ),
                                    controller: nameController,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Colors.black,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(171, 28, 36, 1),
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
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value == "" || value.isEmpty) {
                                        return "Enter Valid Email";
                                      }
                                      return null;
                                    },
                                    controller: emailController,
                                    style: GoogleFonts.dmSans(
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Colors.black,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
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
                                    "Mobile",
                                    style: GoogleFonts.aBeeZee(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value == "" || value.isEmpty) {
                                        return "Enter Valid Number";
                                      }
                                      return null;
                                    },
                                    style: GoogleFonts.dmSans(
                                      color: Colors.black,
                                    ),
                                    controller: pnumberController,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.cell_tower,
                                          color: Colors.black,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(171, 28, 36, 1),
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
                                    "Company Name",
                                    style: GoogleFonts.aBeeZee(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value == "" || value.isEmpty) {
                                        return "Enter Company Name";
                                      }
                                      return null;
                                    },
                                    controller: companyNameController,
                                    style:
                                        GoogleFonts.dmSans(color: Colors.black),
                                    decoration: InputDecoration(
                                        prefixIcon: Image.asset(
                                          "assets/company.png",
                                          height: 10,
                                          width: 10,
                                          color: Colors.black,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
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
                                  widget.isActive == true
                                      ? SizedBox()
                                      : Text(
                                          "Where are you from?",
                                          style: GoogleFonts.aBeeZee(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  widget.isActive == true
                                      ? SizedBox()
                                      : Theme(
                                          data: Theme.of(context).copyWith(
                                              unselectedWidgetColor:
                                                  Colors.black,
                                              disabledColor: Colors.blue),
                                          child: Row(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Radio(
                                                      focusColor: Colors.black,
                                                      activeColor: Colors.black,
                                                      hoverColor: Colors.black,
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
                                                      color: Colors.black,
                                                    ),
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
                                                      activeColor: Colors.black,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          val = value;
                                                        });
                                                      }),
                                                  Text(
                                                    "Other City",
                                                    style: GoogleFonts.aBeeZee(
                                                      color: Colors.black,
                                                    ),
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
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                        Color.fromRGBO(255, 78, 91, 1),
                                      )),
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

                                        if (widget.isActive == false) {
                                          if (_formKey.currentState
                                                  .validate() &&
                                              _image != null) {
                                            await ApiServices()
                                                .profileImageUpload(
                                                    context, _image);

                                            await ApiServices().registerAuth(
                                              name,
                                              email,
                                              companyName,
                                              address,
                                              landmark,
                                              pincode,
                                              0,
                                              context,
                                            );
                                          } else {
                                            return Fluttertoast.showToast(
                                                msg:
                                                    "Please Provide Image or Other Data");
                                          }
                                        }

                                        if (widget.isActive == true) {
                                          if (_formKey.currentState
                                                  .validate()) {
                                            await ApiServices()
                                                .profileImageUpload(
                                                    context, _image);

                                            await ApiServices().registerAuth(
                                              name,
                                              email,
                                              companyName,
                                              address,
                                              landmark,
                                              pincode,
                                              1,
                                              context,
                                            );
                                          }
                                        }

                                        storeKeyByGet.write(
                                            "Location", address);
                                      },
                                      child: Text(
                                        "SUBMIT",
                                        style: GoogleFonts.dmSans(
                                            color: Colors.white,
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
                      ],
                    ),
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
    return widget.isActive != true
        ? SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Address",
                style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 7,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                height: 45,
                child: Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.location_searching,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(ra.address),
                  ],
                ),
              ),
            ],
          );
  }

  Widget fromOtherCity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Address",
          style: GoogleFonts.aBeeZee(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 7,
        ),
        widget.isActive == true
            ? Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                height: 45,
                child: Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.location_searching,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(ra.address),
                  ],
                ),
              )
            : TextFormField(
                style: GoogleFonts.dmSans(color: Colors.black),
                controller: addressController,
                validator: (value) {
                  if (value == "" || value.isEmpty) {
                    return "Enter Valid Address";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.location_searching,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
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
          style: GoogleFonts.aBeeZee(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 7,
        ),
        widget.isActive == true
            ? Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                height: 45,
                child: Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.flag,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(ra.landmark),
                  ],
                ),
              )
            : TextFormField(
                validator: (value) {
                  if (value == "" || value.isEmpty) {
                    return "Enter Valid Landmark";
                  }
                  return null;
                },
                controller: landmarkController,
                style: GoogleFonts.dmSans(color: Colors.black),
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.flag,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
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
          style: GoogleFonts.aBeeZee(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 7,
        ),
        widget.isActive == true
            ? Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                height: 45,
                child: Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.location_on,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(ra.pincode),
                  ],
                ),
              )
            : TextFormField(
                validator: (value) {
                  if (value == "" || value.isEmpty) {
                    return "Enter Valid Pincode";
                  }
                  return null;
                },
                controller: pinCodeController,
                style: GoogleFonts.dmSans(color: Colors.black),
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
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
