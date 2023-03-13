import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({Key key}) : super(key: key);

  @override
  _TermsConditionsState createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10,top: 14,right: 10,bottom: 10),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Color.fromRGBO(255, 78, 91, 1.0),
                    )),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Terms & Conditions",
                  style: GoogleFonts.dmSans(
                      color: Color.fromRGBO(255, 78, 91, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 2),
                ),
              ],
            ),
          ),
          Divider(
            height: 15,
            thickness: 1.1,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              '''
★ We reserve the right to modify or terminate the services for any reason, without notice at any time. Not all Services and features are Available Is every jurisdiction and we are under no obligation to make any services or features available in any jurisdiction. 

★ We reserve the right to refuse service to anyone for any reason at any time.

★ Information for out of surat customers : Whenever you receive a parcel, when opening the parcel, the parcel made videos with 360 videos, If the Video is not made, the missing item claim will not be accepted.

★ All video's are just for reference only.

★ No any color choice available in any products.

★ No Return/ No Refund / No Replacement

★ You will get product color as per available stock.

★ There is no any Guaranty/Warranty available in any products.

★ We don’t have any branded products.

★ We are not responsible for any damage because of transport after delivered.

★ Minimum order amount for Customers from Surat is rs.50

★ Pay attention "Local seller", check the goods thoroughly, later the goods we are not accepting return or replacement of any products.

★ Customers have the option of self pick-up of the orders from the Deluxe Ecommerce app. We are not provide delivery services in surat.

★ Minimum order  amount for out of Surat customers is rs.1000
            ''',
              style: GoogleFonts.dmSans(fontSize: 13.5, letterSpacing: 1),
              textAlign: TextAlign.left,
            ),
          )
        ],
      ),
    );
  }
}
