import 'package:flutter/material.dart';

class Logindetails extends ChangeNotifier {
  String userEmail;

  Logindetails({required this.userEmail});

  void setUserEmail(String userEmail) {
    this.userEmail = userEmail;
    notifyListeners();
  }
}
