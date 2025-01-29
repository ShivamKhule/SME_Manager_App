import 'dart:developer';

import 'package:firebase_connect/controller/LoginDetails.dart';
import 'package:firebase_connect/new_implementation/DrawerPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'productsListings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String gstin = "27ABCDE1234F1Z5";
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<Map<String, String>> categories = [
    {
      "imageUrl":
          "assets/images/products/chair.jpg",
      "categoryName": "Electronics"
    },
    {
      "imageUrl":
          "assets/images/products/cupboard.jpg",
      "categoryName": "Furniture"
    },
    {
      "imageUrl":
          "assets/images/products/showcase.jpg",
      "categoryName": "Furniture"
    },
    {
      "imageUrl":
          "assets/images/products/dinnerset.jpg",
      "categoryName": "Electronics"
    },
    {
      "imageUrl":
          "assets/images/products/sofa.jpg",
      "categoryName": "Electronics"
    },
  ];

  void _showCalendarDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select a Date',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TableCalendar(
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    Navigator.pop(context);
                  },
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      shape: BoxShape.circle,
                    ),
                    weekendTextStyle: TextStyle(color: Colors.red),
                    defaultTextStyle: TextStyle(color: Colors.black),
                    outsideTextStyle: TextStyle(color: Colors.grey),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekendStyle: TextStyle(color: Colors.red),
                    weekdayStyle: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String> userEmail() async{
    String userEmail = Provider.of<Logindetails>(context).userEmail;
    log("email : $userEmail");
    return userEmail;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showCalendarDialog();
              setState(() {});
            },
            icon: const Icon(
              Icons.calendar_today_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          const Icon(
            Icons.notifications_active_outlined,
            color: Colors.white,
            size: 26,
          ),
          const SizedBox(width: 12),
        ],
      ),
      drawer: const Drawer(
        backgroundColor: Colors.white,
        child: Drawerpage(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.04, right: screenWidth * 0.04, bottom: screenWidth * 0.045),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Header
              Container(
                padding: EdgeInsets.all(screenWidth * 0.03),
                margin: EdgeInsets.only(top: screenHeight * 0.02),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: Offset(0, 3),
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade300, Colors.blue.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: screenWidth * 0.1,
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // "R. K. Enterprises",
                            Provider.of<Logindetails>(context, listen: false).userEmail,
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "GSTIN: $gstin",
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Sales and Purchase Overview
              Container(
                padding: EdgeInsets.all(screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: Offset(0, 3),
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: [Colors.grey.shade300, Colors.grey.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        "Sales and Purchase Overview",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      trailing: Icon(Icons.bar_chart, color: Colors.teal),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.black,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StatCard(
                          title: "Total Sales",
                          amount: "₹50,000",
                          icon: Icons.attach_money,
                          color: Colors.green,
                        ),
                        StatCard(
                          title: "Total Purchase",
                          amount: "₹30,000",
                          icon: Icons.shopping_cart,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Module Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ModuleButton(
                    title: "Sales",
                    imagePath: "assets/images/sale-up.png",
                    onTap: () => Navigator.of(context).pushNamed("/sales"),
                  ),
                  ModuleButton(
                    title: "Purchase",
                    imagePath: "assets/images/purchase.png",
                    onTap: () => Navigator.of(context).pushNamed("/purchase"),
                  ),
                  ModuleButton(
                    title: "Reports",
                    imagePath: "assets/images/quickBilling.png",
                    onTap: () => Navigator.of(context).pushNamed("/reports"),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              // Categories Section
              const Text(
                "Categories",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                physics:
                    const NeverScrollableScrollPhysics(), // Disable scrolling for GridView
                shrinkWrap: true, // Allow GridView to shrink
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 22,
                  mainAxisSpacing: 22,
                  childAspectRatio: 10 / 12,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryCard(
                    imageUrl: category["imageUrl"]!,
                    title: category["categoryName"]!,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductsListingPage(
                            categoryName: category["categoryName"]!,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;

  const StatCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 6),
        Text(
          amount,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class ModuleButton extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const ModuleButton({
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width * 0.275,
        height: height * 0.16,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 10,
              spreadRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: width * 0.16,
              height: height * 0.08,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback onTap;

  const CategoryCard({
    required this.imageUrl,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 10,
              offset: Offset(0, 3),
              spreadRadius: 3
            ),
          ],
          image: DecorationImage(
            // image: NetworkImage(imageUrl),
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(8),
            color: Colors.black.withOpacity(0.5),
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}




// import 'dart:developer';

// import 'package:firebase_connect/new_implementation/DrawerPage.dart';
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';

// import 'productsListings.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String gstin = "27ABCDE1234F1Z5";
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;

//   final List<Map<String, String>> categories = [
//     {
//       "imageUrl":
//           "https://via.placeholder.com/150/FF0000/FFFFFF?text=Category+1",
//       "categoryName": "Electronics"
//     },
//     {
//       "imageUrl":
//           "https://via.placeholder.com/150/00FF00/FFFFFF?text=Category+2",
//       "categoryName": "Furniture"
//     },
//     {
//       "imageUrl":
//           "https://via.placeholder.com/150/0000FF/FFFFFF?text=Category+3",
//       "categoryName": "Furniture"
//     },
//     {
//       "imageUrl":
//           "https://via.placeholder.com/150/FFFF00/FFFFFF?text=Category+4",
//       "categoryName": "Electronics"
//     },
//     {
//       "imageUrl":
//           "https://via.placeholder.com/150/FF00FF/FFFFFF?text=Category+5",
//       "categoryName": "Electronics"
//     },
//     {
//       "imageUrl":
//           "https://via.placeholder.com/150/00FFFF/FFFFFF?text=Category+6",
//       "categoryName": "Category 6"
//     },
//     {
//       "imageUrl":
//           "https://via.placeholder.com/150/808080/FFFFFF?text=Category+7",
//       "categoryName": "Category 7"
//     },
//     {
//       "imageUrl":
//           "https://via.placeholder.com/150/800000/FFFFFF?text=Category+8",
//       "categoryName": "Category 8"
//     },
//   ];

//   void _showCalendarDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   'Select a Date',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 TableCalendar(
//                   firstDay: DateTime(2000),
//                   lastDay: DateTime(2100),
//                   focusedDay: _focusedDay,
//                   selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//                   onDaySelected: (selectedDay, focusedDay) {
//                     setState(() {
//                       _selectedDay = selectedDay;
//                       _focusedDay = focusedDay;
//                     });
//                     Navigator.pop(context);
//                   },
//                   calendarStyle: const CalendarStyle(
//                     todayDecoration: BoxDecoration(
//                       color: Colors.blueAccent,
//                       shape: BoxShape.circle,
//                     ),
//                     selectedDecoration: BoxDecoration(
//                       color: Colors.purpleAccent,
//                       shape: BoxShape.circle,
//                     ),
//                     weekendTextStyle: TextStyle(color: Colors.red),
//                     defaultTextStyle: TextStyle(color: Colors.black),
//                     outsideTextStyle: TextStyle(color: Colors.grey),
//                   ),
//                   headerStyle: const HeaderStyle(
//                     formatButtonVisible: false,
//                     titleCentered: true,
//                     titleTextStyle: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blueAccent,
//                     ),
//                   ),
//                   daysOfWeekStyle: const DaysOfWeekStyle(
//                     weekendStyle: TextStyle(color: Colors.red),
//                     weekdayStyle: TextStyle(color: Colors.black),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text('Close'),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenWidth = MediaQuery.of(context).size.width;
//     var screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Dashboard',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.blue,
//         elevation: 0,
//         centerTitle: true,
//         // leading: Container(
//         //   margin: const EdgeInsets.only(left: 8, right: 5, top: 8, bottom: 7),
//         //   decoration: BoxDecoration(
//         //     border: Border.all(),
//         //     borderRadius: BorderRadius.circular(30),
//         //   ),
//         //   child:
//         //       IconButton(onPressed: () {}, icon: const Icon(Icons.menu_sharp)),
//         // ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               _showCalendarDialog();
//               setState(() {});
//             },
//             icon: const Icon(
//               Icons.calendar_today_outlined,
//               color: Colors.white,
//               size: 24,
//             ),
//           ),
//           const SizedBox(
//             width: 15,
//           ),
//           const Icon(
//             Icons.notifications_active_outlined,
//             color: Colors.white,
//             size: 26,
//           ),
//           const SizedBox(
//             width: 12,
//           ),
//         ],
//       ),
//       drawer: const Drawer(
//         backgroundColor: Colors.white,
//         child: Drawerpage(),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.only(left: screenWidth * 0.04, right: screenWidth * 0.04, bottom: screenWidth * 0.045),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Company Header
//               Container(
//                 padding: EdgeInsets.all(screenWidth * 0.03),
//                 margin: EdgeInsets.only(top: screenHeight * 0.02),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 6,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                   gradient: LinearGradient(
//                     colors: [Colors.blue.shade300, Colors.blue.shade500],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomLeft,
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: screenWidth * 0.1,
//                     ),
//                     SizedBox(width: screenWidth * 0.04),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "R. K. Enterprises",
//                             style: TextStyle(
//                               fontSize: screenWidth * 0.05,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           Text(
//                             "GSTIN: $gstin",
//                             style: TextStyle(
//                               fontSize: screenWidth * 0.035,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: screenHeight * 0.02),

//               // Sales and Purchase Overview
//               Container(
//                 padding: EdgeInsets.all(screenWidth * 0.03),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 6,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                   gradient: LinearGradient(
//                     colors: [Colors.grey.shade300, Colors.grey.shade500],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomLeft,
//                   ),
//                 ),
//                 child: const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ListTile(
//                       title: Text(
//                         "Sales and Purchase Overview",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 18),
//                       ),
//                       trailing: Icon(Icons.bar_chart, color: Colors.teal),
//                     ),
//                     Divider(
//                       thickness: 1,
//                       color: Colors.black,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         StatCard(
//                           title: "Total Sales",
//                           amount: "₹50,000",
//                           icon: Icons.attach_money,
//                           color: Colors.green,
//                         ),
//                         StatCard(
//                           title: "Total Purchase",
//                           amount: "₹30,000",
//                           icon: Icons.shopping_cart,
//                           color: Colors.orange,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: screenHeight * 0.02),

//               // Module Navigation
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ModuleButton(
//                     title: "Sales",
//                     imagePath: "assets/images/sale-up.png",
//                     onTap: () => Navigator.of(context).pushNamed("/sales"),
//                   ),
//                   ModuleButton(
//                     title: "Purchase",
//                     imagePath: "assets/images/purchase.png",
//                     onTap: () => Navigator.of(context).pushNamed("/purchase"),
//                   ),
//                   ModuleButton(
//                     title: "Reports",
//                     imagePath: "assets/images/quickBilling.png",
//                     onTap: () => Navigator.of(context).pushNamed("/reports"),
//                   ),
//                 ],
//               ),
//               SizedBox(height: screenHeight * 0.02),

//               // Categories Section
//               const Text(
//                 "Categories",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               GridView.builder(
//                 physics:
//                     const NeverScrollableScrollPhysics(), // Disable scrolling for GridView
//                 shrinkWrap: true, // Allow GridView to shrink
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 22,
//                   mainAxisSpacing: 22,
//                   childAspectRatio: 10 / 12,
//                 ),
//                 itemCount: categories.length,
//                 itemBuilder: (context, index) {
//                   final category = categories[index];
//                   return CategoryCard(
//                     imageUrl: category["imageUrl"]!,
//                     title: category["categoryName"]!,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ProductsListingPage(
//                             categoryName: category["categoryName"]!,
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Stat Card Widget
// class StatCard extends StatelessWidget {
//   final String title;
//   final String amount;
//   final IconData icon;
//   final Color color;

//   const StatCard({
//     required this.title,
//     required this.amount,
//     required this.icon,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 30,
//           backgroundColor: color.withOpacity(0.2),
//           child: Icon(icon, color: color, size: 26),
//         ),
//         const SizedBox(height: 6),
//         Text(
//           amount,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           title,
//           style: const TextStyle(
//               color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
// }

// class ModuleButton extends StatelessWidget {
//   final String title;
//   final String imagePath;
//   final VoidCallback onTap;

//   const ModuleButton({
//     required this.title,
//     required this.imagePath,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: width * 0.28,
//         height: height * 0.16,
//         // margin: const EdgeInsets.symmetric(horizontal: 8.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 6,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Icon with gradient circle background
//             Image.asset(
//               imagePath,
//               width: width * 0.16,
//               height: height * 0.09,
//             ),
//             const SizedBox(height: 12),
//             // Title Text
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CategoryCard extends StatelessWidget {
//   final String imageUrl;
//   final String title;
//   final VoidCallback onTap;

//   const CategoryCard({
//     required this.imageUrl,
//     required this.title,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 6,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Image.network(
//                 imageUrl,
//                 width: double.infinity,
//                 height: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.black.withOpacity(0.6),
//                     Colors.black.withOpacity(0.2),
//                   ],
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text(
//                     title,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Explore More",
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.teal,
//                         ),
//                       ),
//                       SizedBox(width: 4),
//                       Icon(
//                         Icons.arrow_forward,
//                         color: Colors.teal,
//                         size: 16,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CategoryDetailPage extends StatelessWidget {
//   final String categoryName;

//   const CategoryDetailPage({required this.categoryName});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(categoryName),
//       ),
//       body: Center(
//         child: Text(
//           'Welcome to $categoryName',
//           style: const TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }
