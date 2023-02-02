// ignore_for_file: prefer_const_constructors

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class CustomLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/images/Reactive-spinner.png",
            fit: BoxFit.cover,
            height: 30,
            width: 30,
          ),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(46, 14, 54, 1)),
            strokeWidth: 2,
          ),
        ],
      ),
    );
  }
}
