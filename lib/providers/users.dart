// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'package:flutter/material.dart';
import 'user.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Users with ChangeNotifier {
  List<User> _students = [];

  Users(this._students);

  List<User> get students {
    return [..._students];
  }

  // User findById(String id) {
  //   return _students.firstWhere((element) => element.username == id);
  // }

  Future<void> fetchAndSetUsers() async {
    var url = 'https://formazione-reactive-api-rest.herokuapp.com/utenti';
    try {
      final response = await http.get(url);
      print(response);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      if (extractedData == null) {
        return;
      }
      final List<User> loadedUsers = [];
      extractedData.forEach((username, userData) {
        loadedUsers.add(User(
          username: userData["username"],
          ruolo: userData["ruolo"],
          nome: userData["nome"],
          cognome: userData["cognome"],
        ));
      });
      _students = loadedUsers;
      print(loadedUsers);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
