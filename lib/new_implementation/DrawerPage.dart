import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_connect/controller/LoginDetails.dart';
import 'package:firebase_connect/db_helper.dart';
import 'package:firebase_connect/new_implementation/LoginScreen.dart';
import 'package:firebase_connect/new_implementation/dashboard.dart';
import 'package:firebase_connect/new_implementation/manageStaff/ManageStaffScreen.dart';
// import 'package:firebase_connect/new_implementation/manageStaff.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Drawerpage extends StatefulWidget {
  const Drawerpage({super.key});

  @override
  State createState() => _DrawerPageState();
}

class _DrawerPageState extends State {
  void toggleView() async {
    // setState(() {
    //   isLogin = !isLogin;
    // });
  }

  ListTile buildDrawerItem(
    IconData icon,
    String title, {
    Widget? page,
    IconData? add,
    Color? color,
    VoidCallback? function, // Optional function argument
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: GoogleFonts.merienda(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: add != null
          ? GestureDetector(
              onTap: () {},
              child: Icon(add, color: Colors.black87),
            )
          : null,
      onTap: () {
        if (function != null) {
          function();
        } else if (page != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
    );
  }

  void _logout() async {
    log("User logged out.");
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    }
  }

  DBHelper dbHelper = DBHelper();

  dynamic data;

  Future<void> profileData() async {
    data = await dbHelper.getProfile();
    log("Fetched Data: $data");
    setState(() {});
  }

  void getProfileDetails() async {
    final detailsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Logindetails>(context, listen: false).userEmail)
        .get();

    if (detailsSnapshot.exists) {
      final newData = detailsSnapshot.data();
      log("Data on Home Screen: $newData");

      if (mounted) {
        setState(() {
          detailsData = newData;
        });
      }
    } else {
      log("Document does not exist.");
    }
  }

  dynamic detailsData;

  @override
  void initState() {
    super.initState();
    getProfileDetails();
    profileData();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Dynamic padding and margins based on screen width
    double drawerWidth =
        screenWidth * 0.6; // Drawer width will be 60% of screen width
    double fontSize = screenWidth * 0.05; // Text size based on screen width

    return SizedBox(
      height: screenHeight,
      width: drawerWidth,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.only(bottom: 0, left: 16, top: 10),
            decoration: const BoxDecoration(
              color: Colors.black87,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed("/profileScreen");
                  },
                  child: CircleAvatar(
                    radius: screenWidth * 0.084,
                    backgroundImage: detailsData != null &&
                            detailsData['profile_image'] != null
                        ? NetworkImage(detailsData['profile_image'])
                        : null,
                    backgroundColor: Colors
                        .grey[300], // Fallback color when no image is found
                    child: detailsData == null ||
                            detailsData['profile_image'] == null
                        ? Icon(Icons.person,
                            size: screenWidth * 0.1, color: Colors.white)
                        : null, // Show icon if no image is found
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  detailsData != null
                      ? detailsData['company_name'] ?? "No Name Found"
                      : "Loading...",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 2),
                Text(
                  "GSTIN: ${detailsData != null ? detailsData["gstin"] ?? "N/A" : "N/A"}",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                const SizedBox(height: 2),
                GestureDetector(
                    onTap: () =>
                        Navigator.popAndPushNamed(context, '/profileUpdate'),
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ))
              ],
            ),
          ),
          buildDrawerItem(Icons.home, 'Home',
              color: Colors.blueAccent, page: const HomeScreen()),
          buildDrawerItem(Icons.people, 'Parties',
              color: Colors.blueAccent, add: Icons.add),
          buildDrawerItem(Icons.category, 'Products',
              color: Colors.blueAccent, add: Icons.add),
          buildDrawerItem(Icons.business_center, 'Expense',
              color: Colors.blueAccent, add: Icons.add),
          buildDrawerItem(Icons.manage_accounts, 'Manage Staff',
              color: Colors.blueAccent,
              add: Icons.add,
              page: const ManageStaffScreen()),
          const Divider(),
          buildDrawerItem(Icons.settings, 'Settings', color: Colors.blueAccent),
          buildDrawerItem(Icons.logout, 'Log Out',
              color: Colors.red, function: _logout),
        ],
      ),
    );
  }
}



// import 'package:firebase_connect/SME_Manager/AuthScreen.dart';
// import 'package:firebase_connect/SME_Manager/LoginPage.dart';
// import 'package:firebase_connect/new_implementation/dashboard.dart';
// import 'package:firebase_connect/new_implementation/manageStaff.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class Drawerpage extends StatefulWidget {
//   const Drawerpage({super.key});

//   @override
//   State createState() => _DrawerPageState();
// }

// class _DrawerPageState extends State {
//   void toggleView() async {
//     setState(() {
//       isLogin = !isLogin;
//     });
//   }

//   ListTile buildDrawerItem(IconData icon, String title, {Widget? page,
//       IconData? add, Color? color}) {
//     return ListTile(
//       leading: Icon(icon, color: color),
//       title: Text(
//         title,
//         style: GoogleFonts.merienda(color: color, fontWeight: FontWeight.w700,),
//       ),
//       trailing: GestureDetector(
//         onTap: () {},
//         child: Icon(add,
//         color: Colors.black87,
//         ),
//       ),
//       onTap: () {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => page!,
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height,
//       width: 180,
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           const DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.black87,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   backgroundColor: Colors.white,
//                   radius: 30,
//                   child: Icon(Icons.business, size: 30, color: Colors.purple),
//                 ),
//                 SizedBox(height: 7),
//                 Text(
//                   'CompanyName',
//                   style: TextStyle(color: Colors.white, fontSize: 20),
//                 ),
//                 SizedBox(height: 2),
//                 Text(
//                   'GSTIN :- 27ABCDE1234F1Z5',
//                   style: TextStyle(color: Colors.white, fontSize: 13),
//                 ),
//                 SizedBox(height: 2),
//                 Text("Edit Profile", style: TextStyle(color: Colors.white, fontSize: 10),)
//                 // Row(
//                 //   children: [
//                 //     Spacer(),
//                 //     Text("Edit Profile", style: TextStyle(color: Colors.white, fontSize: 10),)
//                 //   ],
//                 // )
//               ],
//             ),
//           ),
//           buildDrawerItem(Icons.home, 'Home', color: Colors.blueAccent, page: const HomeScreen()),
//           buildDrawerItem(Icons.people, 'Parties', color: Colors.blueAccent, add: Icons.add),
//           buildDrawerItem(Icons.category, 'Products', color: Colors.blueAccent, add: Icons.add),
//           // buildDrawerItem(Icons.shopping_cart, 'Sale', color: Colors.blueAccent, add: Icons.add),
//           // buildDrawerItem(Icons.shopping_bag, 'Purchase', color: Colors.blueAccent, add: Icons.add),
//           buildDrawerItem(Icons.business_center, 'Expense', color: Colors.blueAccent, add: Icons.add),
//           buildDrawerItem(Icons.manage_accounts, 'Manage Staff', color: Colors.blueAccent, add: Icons.add, page: const ManageStaffScreen()),
//           // buildDrawerItem(Icons.bar_chart, 'Reports', color: Colors.blueAccent),
//           const Divider(),
//           // buildDrawerItem(
//           //     Icons.production_quantity_limits, 'Other Products', color: Colors.blueAccent),
//           buildDrawerItem(Icons.settings, 'Settings', color: Colors.blueAccent),
//           buildDrawerItem(
//               Icons.logout, 'Log Out', page: LoginPage(toggleView: toggleView), color: Colors.red,),
//         ],
//       ),
//     );
//   }
// }

