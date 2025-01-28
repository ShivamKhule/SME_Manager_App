  import 'package:firebase_connect/new_implementation/LoginScreen.dart';
import 'package:firebase_connect/new_implementation/categories.dart';
import 'package:firebase_connect/new_implementation/manageStaff.dart';
import 'package:firebase_connect/new_implementation/profileUpdateForm.dart';
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
  runApp(
    MaterialApp(
      initialRoute: '/login',
      // initialRoute: '/profileUpdate',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/sales': (context) => SalesScreen(),
        '/purchase': (context) => SalesScreen(), // Similar logic for purchase
        '/reports': (context) => ReportsScreen(),

        '/addSalesOwner': (context) => AddSalesOwnerScreen(),
        // '/addOrder': (context) => AddOrderScreen(ownerId: ''),
        '/addProduct': (context) => AddProductScreen(orderPath: ''),
        '/categories': (context) => Categories(),
        '/managestaff': (context) => const ManageStaffScreen(),
        '/profileUpdate': (context) => ProfileUpdatePage(),
      },
    ),
  );
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
