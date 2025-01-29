import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_connect/SME_Manager/AuthScreen.dart';
import 'package:firebase_connect/controller/LoginDetails.dart';
import 'package:firebase_connect/new_implementation/dashboard.dart';
import 'package:firebase_connect/new_implementation/manageStaff.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Drawerpage extends StatefulWidget {
  const Drawerpage({super.key});

  @override
  State createState() => _DrawerPageState();
}

class _DrawerPageState extends State {
  void toggleView() async {
    setState(() {
      isLogin = !isLogin;
    });
  }

  ListTile buildDrawerItem(IconData icon, String title,
      {Widget? page, IconData? add, Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: GoogleFonts.merienda(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: GestureDetector(
        onTap: () {},
        child: Icon(
          add,
          color: Colors.black87,
        ),
      ),
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => page!,
          ),
        );
      },
    );
  }

  // Firebase Data RETRIVE
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(Provider.of<Logindetails>(context).userEmail)
          .get();

      if (doc.exists) {
        setState(() {
          userData = doc.data() as Map<String, dynamic>;
        });
      } else {
        print("No user data found.");
      }
    } catch (e) {
      print("Error fetching profile data: $e");
    }
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
          // DrawerHeader(
          //   margin: const EdgeInsets.all(0),
          //   padding: const EdgeInsets.only(bottom: 0, left: 16, top: 10),
          //   decoration: const BoxDecoration(
          //     color: Colors.black87,
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const CircleAvatar(
          //         backgroundColor: Colors.white,
          //         radius: 30,
          //         child: Icon(Icons.business, size: 30, color: Colors.purple),
          //       ),
          //       const SizedBox(height: 7),
          //       Text(
          //         userData!['companyName'],
          //         style: TextStyle(color: Colors.white, fontSize: 20),
          //       ),
          //       const SizedBox(height: 2),
          //       Text(
          //         'GSTIN :- ${userData!['gstin']}',
          //         style: TextStyle(color: Colors.white, fontSize: 13),
          //       ),
          //       const SizedBox(height: 2),
          //       GestureDetector(
          //           onTap: () =>
          //               Navigator.popAndPushNamed(context, '/profileUpdate'),
          //           child: const Text(
          //             "Edit Profile",
          //             style: TextStyle(color: Colors.white, fontSize: 12),
          //           ))
          //     ],
          //   ),
          // ),
          DrawerHeader(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.only(bottom: 0, left: 16, top: 10),
            decoration: const BoxDecoration(
              color: Colors.black87,
            ),
            child: userData == null
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ) // Show a loader while data is being fetched
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: Icon(Icons.business,
                            size: 30, color: Colors.purple),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        userData!['companyName'] ?? "Company Name",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'GSTIN :- ${userData!['gstin'] ?? "N/A"}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      GestureDetector(
                        onTap: () => Navigator.popAndPushNamed(
                            context, '/profileUpdate'),
                        child: const Text(
                          "Edit Profile",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      )
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
          buildDrawerItem(
            Icons.logout,
            'Log Out',
            // page: LoginPage(toggleView: toggleView),
            color: Colors.red,
          ),
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

