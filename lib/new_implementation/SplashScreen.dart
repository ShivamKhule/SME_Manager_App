import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_connect/controller/LoginDetails.dart';
import 'package:firebase_connect/new_implementation/LoginScreen.dart';
import 'package:firebase_connect/new_implementation/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<Map<String, String?>> getUserCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? email = prefs.getString('email');
    return {'userId': userId, 'email': email};
  }

  void whereToGO() async {
    Map<String, String?> userData = await getUserCredentials();

    if (userData['userId'] != null && userData['email'] != null) {
      // User is logged in, navigate to the home page
      Provider.of<Logindetails>(context, listen: false)
          .setUserEmail(userData['email']!);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // User is not logged in, navigate to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4)).then((val) {
      whereToGO();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/videos/SplashAnimation.json',
          width: 200,
          height: 200,
          repeat: true,
        ),
      ),
    );
  }
}
