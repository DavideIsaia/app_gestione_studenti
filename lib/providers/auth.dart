// ignore_for_file: avoid_print

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  bool loggedIn = false;

  Future<void> login(String user, String password) async {
    final url =
        'https://formazione-reactive-api-rest.herokuapp.com/loginMobile/$user/$password';

    final response = await http.post(url);
    print(response.body);
    if (response.body == 'FRMOB') {
      // print('bentornato admin!');
      loggedIn = true;
    } else {
      // print('non sei un admin.');
      loggedIn = false;
    }
    isLogged(loggedIn);
    notifyListeners();
  }

  bool isLogged(loggedIn) {
    if (loggedIn == true) {
      print('loggato');
      return true;
    } else {
      print('non loggato');
      return false;
    }
  }

  bool get isAuth {
    if (isLogged(loggedIn) == true) {
      print('autorizzato');
      return true;
    } else {
      print('non autorizzato');
      return false;
    }
  }

  Future<void> logout() async {
    isLogged(loggedIn) == false;
    isAuth == false;
    notifyListeners();
  }
}
