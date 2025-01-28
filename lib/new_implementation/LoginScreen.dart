import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_connect/new_implementation/SignUpScreen.dart';
import 'package:firebase_connect/new_implementation/dashboard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toasty_box/toasty_box.dart';
import 'package:toasty_box/toast_enums.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  bool isPasswordVisible = false; // Toggle password visibility

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 233, 233),
      // backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          // Prevent overflow when keyboard appears
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Image.asset(
                  "assets/images/logo1.jpg",
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 25),
                // Logo or Welcome Text
                Text(
                  "Welcome Back!",
                  style: GoogleFonts.quicksand(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 10),
                // Login Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.white, Color(0xFFEEEEEE)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                      const BoxShadow(
                        color: Colors.white,
                        blurRadius: 8,
                        offset: Offset(-4, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Email Field
                      _buildTextField(
                        controller: emailController,
                        label: "User Email",
                        icon: Icons.email,
                        obscureText: false,
                      ),
                      const SizedBox(height: 16),
                      // Password Field with visibility toggle
                      _buildPasswordField(passwordController),
                      const SizedBox(height: 40),
                      // Login Button
                      ElevatedButton(
                        onPressed: () async {
                          // Handle login logic
                          if (emailController.text.trim().isNotEmpty &&
                              passwordController.text.trim().isNotEmpty) {
                            try {
                              UserCredential userCredential =
                                  await _firebaseAuth
                                      .signInWithEmailAndPassword(
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim());
                              ToastService.showSuccessToast(
                                context,
                                length: ToastLength.medium,
                                expandedHeight: 100,
                                message: "Login Successfull 🥂!",
                              );
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                return const HomeScreen();
                              }));
                            } on FirebaseAuthException catch (error) {
                              ToastService.showWarningToast(
                                context,
                                length: ToastLength.medium,
                                expandedHeight: 100,
                                message: "${error.message}",
                              );
                            }
                          } else {
                            ToastService.showWarningToast(
                              context,
                              length: ToastLength.medium,
                              expandedHeight: 100,
                              message: "Please fill all the Fields !",
                            );
                          }
                          setState(() {
                            emailController.clear();
                            passwordController.clear();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: Colors.blue,
                          shadowColor: Colors.blue.withOpacity(0.3),
                          elevation: 5,
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: GoogleFonts.quicksand(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      const TextSpan(text: "Don't Have an Account? "),
                      TextSpan(
                        text: "Sign Up",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green, // You can customize the color
                          decoration:
                              TextDecoration.underline, // Optional underline
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Add your SignUp tap action here
                            Navigator.push((context),
                                MaterialPageRoute(builder: (context) {
                              return SignUpScreen();
                            }));
                          },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                // Footer
                Text(
                  "Powered by Shivam Khule",
                  style: GoogleFonts.quicksand(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String label,
      required IconData icon,
      required TextEditingController controller,
      required bool obscureText}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFEEEEEE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(3, 3),
          ),
          const BoxShadow(
            color: Colors.white,
            blurRadius: 6,
            offset: Offset(-3, -3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.black54),
          hintText: label,
          hintStyle: GoogleFonts.quicksand(
            fontSize: 16,
            color: Colors.black38,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFEEEEEE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(3, 3),
          ),
          const BoxShadow(
            color: Colors.white,
            blurRadius: 6,
            offset: Offset(-3, -3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: !isPasswordVisible,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.lock, color: Colors.black54),
          hintText: "Password",
          hintStyle: GoogleFonts.quicksand(
            fontSize: 16,
            color: Colors.black38,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.black54,
            ),
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
          ),
        ),
      ),
    );
  }
}
