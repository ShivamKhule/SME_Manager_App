import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'SignUpPage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

bool isLogin = true;

class _AuthScreenState extends State<AuthScreen> {
  
  void toggleView() async {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginPage(toggleView: toggleView)
        : SignupPage(toggleView: toggleView);
  }
}
