import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  final String username;
  final String ruolo;
  final String nome;
  final String cognome;
  final String password;
  final String email;

  User({
    @required this.username,
    @required this.ruolo,
    @required this.nome,
    @required this.cognome,
    @required this.password,
    @required this.email,
  });
}
