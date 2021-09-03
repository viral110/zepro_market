import 'dart:async';
import 'package:rxdart/rxdart.dart';



class LoginWithAuth {
  final _loginNumber = BehaviorSubject<String>();

  //Getters
  Stream<String> get loginNumber => _loginNumber.stream;

  //setters
  Function(String) get changeMobileNumber => _loginNumber.sink.add;

  void dispose() {
    _loginNumber.close();
  }
}