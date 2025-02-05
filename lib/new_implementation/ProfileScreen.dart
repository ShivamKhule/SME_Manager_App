import 'dart:developer';

import 'package:firebase_connect/controller/LoginDetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../db_helper.dart';

class ProfileScreenNew extends StatefulWidget {
  const ProfileScreenNew({Key? key}) : super(key: key);

  @override
  _ProfileScreenNewState createState() => _ProfileScreenNewState();
}

class _ProfileScreenNewState extends State<ProfileScreenNew> {
  Map<String, dynamic>? userData;

  DBHelper dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      // Step 1: Fetch Data from Local Storage (SQLite)
      Map<String, dynamic>? localData = await dbHelper.getProfile();

      if (localData != null) {
        setState(() {
          userData = {
            ...localData, // Copy all other fields
            'address': {
              'line1': localData['address_line1'] ?? "",
              'line2': localData['address_line2'] ?? "",
              'landmark': localData['landmark'] ?? "",
              'city': localData['city'] ?? "",
              'district': localData['district'] ?? "",
              'state': localData['state'] ?? "",
              'pincode': localData['pincode'] ?? "",
            }
          };
        });
      }

      // Step 2: Fetch Data from Firebase (Only if local data is not found)
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(Provider.of<Logindetails>(context, listen: false).userEmail)
          .get();

      if (doc.exists) {
        setState(() {
          userData = doc.data() as Map<String, dynamic>;

          // Save structured data to SQLite for offline use
          dbHelper.insertProfile(userData!);
        });
      } else {
        print("No user data found in Firebase.");
      }
    } catch (e) {
      print("Error fetching profile data: $e");
    }
    log("$userData");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Profile Details",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Profile Content
          userData == null
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white))
              : Container(
                  margin: EdgeInsets.only(top: 105),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Picture with Neumorphic Effect
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    spreadRadius: 2)
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              backgroundImage:
                                  userData!['profileImage'] != null &&
                                          userData!['profileImage'].isNotEmpty
                                      ? NetworkImage(userData!['profileImage'])
                                      : null,
                              child: userData!['profileImage'] == null ||
                                      userData!['profileImage'].isEmpty
                                  ? const Icon(Icons.person,
                                      size: 60, color: Colors.white)
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Profile Info Card
                        _glassmorphicCard(
                          child: Column(
                            children: [
                              _buildProfileTile(
                                Icons.business,
                                "Company Name",
                                userData!['company_name'] ?? "N/A",
                              ),
                              _buildProfileTile(
                                Icons.person,
                                "Owner Name",
                                userData!['owner_name'] ?? "N/A",
                              ),
                              _buildProfileTile(
                                Icons.confirmation_number,
                                "GSTIN",
                                userData!['gstin'] ?? "N/A",
                              ),
                              _buildProfileTile(
                                Icons.email,
                                "Email",
                                userData!['email'],
                              ),
                              _buildProfileTile(
                                Icons.phone,
                                "Mobile",
                                userData!['mobile'] ?? "N/A",
                              ),
                              _buildProfileTile(
                                Icons.work,
                                "Business Domain",
                                userData!['business_domain'] ?? "N/A",
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Address Card (Only if Address Exists)
                        if (userData!['address'] != null)
                          _glassmorphicCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Business Address",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const Divider(color: Colors.white54),
                                _buildProfileTile(
                                    Icons.location_on,
                                    "Address Line 1",
                                    userData!['address']['line1']),
                                _buildProfileTile(
                                    Icons.location_on,
                                    "Address Line 2",
                                    userData!['address']['line2']),
                                _buildProfileTile(Icons.location_city, "City",
                                    userData!['address']['city']),
                                _buildProfileTile(Icons.map, "District",
                                    userData!['address']['district']),
                                _buildProfileTile(Icons.home_work, "State",
                                    userData!['address']['state']),
                                _buildProfileTile(Icons.pin_drop, "Pincode",
                                    userData!['address']['pincode']),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // Glassmorphic Card
  Widget _glassmorphicCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }

  // Profile Info Tile Widget with Icon Styling
  Widget _buildProfileTile(IconData icon, String title, String? value) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.3),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white70),
      ),
      subtitle: Text(
        value ?? "N/A",
        style: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }
}

// import 'dart:developer';

// import 'package:firebase_connect/controller/LoginDetails.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// import '../db_helper.dart';

// class ProfileScreenNew extends StatefulWidget {
//   const ProfileScreenNew({Key? key}) : super(key: key);

//   @override
//   _ProfileScreenNewState createState() => _ProfileScreenNewState();
// }

// class _ProfileScreenNewState extends State<ProfileScreenNew> {
//   Map<String, dynamic>? userData;

//   DatabaseHelper dbHelper = DatabaseHelper();

//   @override
//   void initState() {
//     super.initState();
//     fetchProfileData();
//   }

//   Future<void> fetchProfileData() async {
//     try {
//       List<Map<String, dynamic>> data = await dbHelper.fetchAndStoreData();
//       log("$data");

//       DocumentSnapshot doc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(Provider.of<Logindetails>(context, listen: false).userEmail)
//           .get();

//       if (doc.exists) {
//         setState(() {
//           userData = doc.data() as Map<String, dynamic>;
//         });
//       } else {
//         print("No user data found.");
//       }
//     } catch (e) {
//       print("Error fetching profile data: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         title: Text(
//           "Profile Details",
//           style: GoogleFonts.poppins(
//               fontWeight: FontWeight.w600, color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//             onPressed: () {
//               Navigator.of(context).pushReplacementNamed('/home');
//             },
//             icon: const Icon(Icons.arrow_back)),
//       ),
//       body: Stack(
//         children: [
//           // Gradient Background
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//           ),

//           // Profile Content
//           userData == null
//               ? const Center(
//                   child: CircularProgressIndicator(color: Colors.white))
//               : Container(
//                   margin: EdgeInsets.only(top: 105),
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         // Profile Picture with Neumorphic Effect
//                         Center(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                     color: Colors.black.withOpacity(0.2),
//                                     blurRadius: 8,
//                                     spreadRadius: 2)
//                               ],
//                             ),
//                             child: CircleAvatar(
//                               radius: 60,
//                               backgroundColor: Colors.white.withOpacity(0.2),
//                               backgroundImage:
//                                   userData!['profileImage'] != null &&
//                                           userData!['profileImage'].isNotEmpty
//                                       ? NetworkImage(userData!['profileImage'])
//                                       : null,
//                               child: userData!['profileImage'] == null ||
//                                       userData!['profileImage'].isEmpty
//                                   ? const Icon(Icons.person,
//                                       size: 60, color: Colors.white)
//                                   : null,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),

//                         // Profile Info Card with Glassmorphism
//                         _glassmorphicCard(
//                           child: Column(
//                             children: [
//                               _buildProfileTile(Icons.business, "Company Name",
//                                   userData!['company_name']),
//                               _buildProfileTile(Icons.person, "Owner Name",
//                                   userData!['owner_name']),
//                               _buildProfileTile(Icons.confirmation_number,
//                                   "GSTIN", userData!['gstin']),
//                               _buildProfileTile(
//                                   Icons.email,
//                                   "Email",
//                                   Provider.of<Logindetails>(context,
//                                           listen: false)
//                                       .userEmail),
//                               _buildProfileTile(
//                                   Icons.phone, "Mobile", userData!['mobile']),
//                               _buildProfileTile(Icons.work, "Business Domain",
//                                   userData!['business_domain']),
//                             ],
//                           ),
//                         ),

//                         const SizedBox(height: 20),

//                         // Address Card
//                         if (userData!['address'] != null)
//                           _glassmorphicCard(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Business Address",
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 const Divider(color: Colors.white54),
//                                 _buildProfileTile(
//                                     Icons.location_on,
//                                     "Address Line 1",
//                                     userData!['address']['line1']),
//                                 _buildProfileTile(
//                                     Icons.location_on,
//                                     "Address Line 2",
//                                     userData!['address']['line2']),
//                                 _buildProfileTile(Icons.location_city, "City",
//                                     userData!['address']['city']),
//                                 _buildProfileTile(Icons.map, "District",
//                                     userData!['address']['district']),
//                                 _buildProfileTile(Icons.home_work, "State",
//                                     userData!['address']['state']),
//                                 _buildProfileTile(Icons.pin_drop, "Pincode",
//                                     userData!['address']['pincode']),
//                               ],
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }

//   // Glassmorphic Card
//   Widget _glassmorphicCard({required Widget child}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.white.withOpacity(0.3)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }

//   // Profile Info Tile Widget with Icon Styling
//   Widget _buildProfileTile(IconData icon, String title, String? value) {
//     return ListTile(
//       leading: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.white.withOpacity(0.3),
//         ),
//         child: Icon(icon, color: Colors.white, size: 24),
//       ),
//       title: Text(
//         title,
//         style: GoogleFonts.poppins(
//             fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white70),
//       ),
//       subtitle: Text(
//         value ?? "N/A",
//         style: GoogleFonts.poppins(
//             fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
//       ),
//     );
//   }
// }
