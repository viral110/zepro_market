import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';



import '../Connect_API/api.dart';
import '../Model/home_cart_category_model.dart';
import '../product_catalogue/products.dart';

class CategoriesPopular extends StatefulWidget {
  const CategoriesPopular({Key key}) : super(key: key);

  @override
  _CategoriesPopularState createState() => _CategoriesPopularState();
}

class _CategoriesPopularState extends State<CategoriesPopular> {
  HomeCartCategory hcc;

  bool isLoadingCategory = false;

  fetchCategory() async {
    // await Future.delayed(Duration(milliseconds: 100), () async {
    final response = await ApiServices().getHomeCategory(context);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      hcc = HomeCartCategory.fromJson(decoded);

      setState(() {
        isLoadingCategory = true;
      });
    }
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:isLoadingCategory == false
            ? Center(
          child: CircularProgressIndicator(),
        )
            :  Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 15, left: 12, bottom: 20),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Color.fromRGBO(255, 78, 91, 1),
                              )),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            "All Categories",
                            style: GoogleFonts.aBeeZee(
                                color: Color.fromRGBO(255, 78, 91, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                letterSpacing: 2),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GridView.builder(
                        itemCount: hcc.catList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 5,
                            childAspectRatio: 0.9),
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Products(
                                          categoryHome: hcc.catList[index].name,
                                          number: 1),
                                    ),
                                  );
                                },
                                child: Material(
                                  elevation: 6,
                                  borderRadius: BorderRadius.circular(40),
                                  child: FittedBox(
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          hcc.catList[index].image),
                                      radius: 41,
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              hcc.catList[index].name.split(" ").length > 1
                                  ? Text(
                                      " ${hcc.catList[index].name.split(" ")[0]}\n ${hcc.catList[index].name.split(" ")[1]}",
                                      style: GoogleFonts.dmSans(
                                        fontSize: 13.4,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      "${hcc.catList[index].name}\n",
                                      style: GoogleFonts.dmSans(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),

    );
  }
}
