import 'package:firebase_connect/controller/LoginDetails.dart';
import 'package:firebase_connect/new_implementation/LoginScreen.dart';
import 'package:firebase_connect/new_implementation/ProfileScreen.dart';
import 'package:firebase_connect/new_implementation/SplashScreen.dart';
import 'package:firebase_connect/new_implementation/categories.dart';
import 'package:firebase_connect/new_implementation/manageStaff/ManageStaffList.dart';
// import 'package:firebase_connect/new_implementation/manageStaff.dart';
import 'package:firebase_connect/new_implementation/profileUpdateForm.dart';
import 'package:firebase_connect/new_implementation/purchase.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'new_implementation/addProduct.dart';
import 'extras/addSalesOwner.dart';
import 'new_implementation/dashboard.dart';
import 'new_implementation/reports.dart';
import 'new_implementation/sales.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // DatabaseHelper dbHelper = DatabaseHelper();
  // await dbHelper.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return Logindetails(userEmail: '');
      },
      child: MaterialApp(
        initialRoute: '/splash',
        // initialRoute: '/home',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/sales': (context) => SalesScreen(),
          '/purchase': (context) => PurchaseScreen(),
          '/reports': (context) => ReportsScreen(),
          '/addSalesOwner': (context) => AddSalesOwnerScreen(),
          '/addProduct': (context) => AddProductScreen(orderPath: ''),
          '/categories': (context) => Categories(),
          // '/managestaff': (context) => const ManageStaffScreen(),
          '/managestaff': (context) => const ManageStaffScreen(),
          '/profileUpdate': (context) => ProfileUpdatePage(),
          '/profileScreen': (context) => const ProfileScreenNew(),
        },
      ),
    );
  }
}

// import 'package:firebase_connect/SME_Manager/HomePage.dart';
// import 'package:firebase_connect/SME_Manager/LoginPage.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       // home: AuthScreen(),
//       home: Homepage()
//     );
//   }
// }
