import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PendingOrder extends StatefulWidget {
  const PendingOrder({Key key}) : super(key: key);

  @override
  _PendingOrderState createState() => _PendingOrderState();
}

class _PendingOrderState extends State<PendingOrder> {
  Icon customIcon = Icon(Icons.search);
  Widget customSearchBar = Text(
    "My Orders",
    style: GoogleFonts.aBeeZee(
        color: Color.fromRGBO(22, 2, 105, 0.8), fontWeight: FontWeight.bold,fontSize: 18,letterSpacing: 1),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white60,
      //   elevation: 0,
      //   title:  Text(
      //     "My Orders",
      //     style: GoogleFonts.aBeeZee(
      //         color: Color.fromRGBO(255, 78, 91,1), fontWeight: FontWeight.bold,fontSize: 20,letterSpacing: 1),
      //   ),
      //   iconTheme: IconThemeData(color: Color.fromRGBO(255, 78, 91,1)),
      //   actions: [
      //     // GestureDetector(child: Icon(Icons.search),onTap: (){
      //     //   setState(() {
      //     //     if (this.customIcon.icon == Icons.search) {
      //     //       customSearchBar = Container(
      //     //         // decoration: BoxDecoration(
      //     //         //   border: Border(bottom: BorderSide(color: Colors.green)),
      //     //         // ),
      //     //         height: 40,
      //     //         child: TextField(
      //     //           decoration: InputDecoration(
      //     //               contentPadding: EdgeInsets.all(10),
      //     //               enabledBorder: OutlineInputBorder(
      //     //                 borderRadius: BorderRadius.zero,
      //     //                 borderSide: BorderSide(
      //     //                     color: Colors.grey.withOpacity(0.5), width: 2.0),
      //     //               ),
      //     //               focusedBorder: OutlineInputBorder(
      //     //                 borderRadius: BorderRadius.zero,
      //     //                 borderSide: BorderSide(
      //     //                     color: Colors.grey.withOpacity(0.5), width: 2),
      //     //               ),
      //     //               hintText: "Search your daily product",
      //     //               hintStyle: GoogleFonts.aBeeZee(
      //     //                   color: Colors.grey.shade500, fontSize: 13),
      //     //               prefixIcon: Icon(
      //     //                 Icons.search,
      //     //                 color: Colors.black,
      //     //               ),
      //     //               suffixIcon: IconButton(
      //     //                 icon: Icon(
      //     //                   Icons.cancel,
      //     //                   color: Colors.grey.withOpacity(0.5),
      //     //                 ),
      //     //                 onPressed: () {
      //     //                   setState(() {
      //     //                     customSearchBar = Text(
      //     //                       "Pending Orders",
      //     //                       style: GoogleFonts.aBeeZee(
      //     //                           color: Color.fromRGBO(22, 2, 105, 0.8),
      //     //                           fontWeight: FontWeight.bold,letterSpacing: 1),
      //     //                     );
      //     //                   });
      //     //                 },
      //     //               )),
      //     //         ),
      //     //       );
      //     //     }
      //     //     // else{
      //     //     //   this.customSearchBar = Text("All Products",style: GoogleFonts.openSans(color: Color.fromRGBO(22, 2, 105, 1)),);
      //     //     // }
      //     //   });
      //     // },),
      //
      //   ],
      // ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  GestureDetector(onTap: (){Navigator.pop(context);},child: Icon(Icons.arrow_back_ios,color: Color.fromRGBO(255, 78, 91,1),)),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "My Orders",
                    style: GoogleFonts.aBeeZee(
                        color: Color.fromRGBO(255, 78, 91,1), fontWeight: FontWeight.bold,fontSize: 20,letterSpacing: 2),
                  ),


                ],
              ),
            ),
            Divider(
              height: 15,

              thickness: 1.1,
            ),
            SizedBox(
              height: 80,
            ),
            Image.asset("assets/pendingorderimage.jpg",height: 250, width: 250,),
            Center(child: Text("You have not placed any order",style: TextStyle(color: Colors.grey,letterSpacing: 0.5),)),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Container(height: 50,child: RaisedButton(color: Color.fromRGBO(255, 78, 91,1),onPressed: (){},child: Text("START SHOPPING",style: TextStyle(color: Colors.white,letterSpacing: 1,fontWeight: FontWeight.bold),),)),
            ),

          ],
        ),
      ),

    );
  }
}
