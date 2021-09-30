import 'dart:convert';

import 'package:http/http.dart' as http;


Future loginAuth (String userId, String mobileNum) async {
  var url = Uri.parse("https://testapps.pythonanywhere.com/api/authenticate");
  final response = await http.post(url,headers: {
    "Accept": "Application/json",
  },body: {
    'user_id':userId,
    'mob_number':mobileNum,
  });
  print(response.body);
  var decoded = json.decode(response.body);
  print(decoded);
  return decoded;
}