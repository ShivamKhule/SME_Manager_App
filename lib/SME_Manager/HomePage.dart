import 'package:firebase_connect/SME_Manager/QuickBilling.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'DrawerPage.dart';
import 'SalesPage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List products = [
    'assets/images/products/chair.jpg',
    'assets/images/products/cupboard.jpg',
    'assets/images/products/dinnerset.jpg',
    'assets/images/products/doublebed.jpg',
    'assets/images/products/showcase.jpg',
    'assets/images/products/sofa.jpg',
    'assets/images/products/sofachair.jpg',
    'assets/images/products/studytable.jpg',
    'assets/images/products/chair.jpg',
    'assets/images/products/cupboard.jpg',
    'assets/images/products/dinnerset.jpg',
    'assets/images/products/doublebed.jpg',
    'assets/images/products/showcase.jpg',
    'assets/images/products/sofa.jpg',
    'assets/images/products/sofachair.jpg',
    'assets/images/products/studytable.jpg',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        /*leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context){
                return const Drawerpage();
              })
            );
          },
          icon: const Icon(
            Icons.menu_open,
            size: 32,
            color: Colors.white,
          ),
        ),*/
        title: Text(
          "CompanyName",
          style: GoogleFonts.merienda(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
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
          const SizedBox(
            width: 15,
          ),
          const Icon(
            Icons.notifications_active_outlined,
            color: Colors.white,
            size: 26,
          ),
          const SizedBox(
            width: 12,
          ),
        ],
      ),
      drawer: const Drawer(
        backgroundColor: Colors.white,
        child: Drawerpage(),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 18, bottom: 8, right: 18),
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom:
                                BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.miscellaneous_services_outlined,
                              color: Colors.blueAccent,
                              size: 25,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Services",
                              style: GoogleFonts.merienda(
                                color: Colors.blueAccent,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) {
                                  return const SalesPage();
                                },
                              ),
                            );
                          },
                          child: Container(
                            width: 110,
                            height: 150,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(top: 20, bottom: 12),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 225, 74, 71),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/sale-up.png',
                                  width: 45,
                                  height: 40,
                                  color: Colors.white,
                                ),
                                const Spacer(),
                                Text(
                                  'Sales',
                                  style: GoogleFonts.merienda(
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 110,
                          height: 150,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 20, bottom: 12),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 58, 173, 85),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/purchase.png',
                                width: 55,
                                height: 45,
                                color: Colors.white,
                              ),
                              const Spacer(),
                              Text(
                                'Purchase',
                                style: GoogleFonts.merienda(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) {
                                  return const QuickBilling();
                                },
                              ),
                            );
                          },
                          child: Container(
                            width: 110,
                            height: 150,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(top: 20, bottom: 12),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 160, 55, 240),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/quickBilling.png',
                                  width: 55,
                                  height: 45,
                                  color: Colors.white,
                                ),
                                const Spacer(),
                                Text(
                                  'Quick',
                                  style: GoogleFonts.merienda(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Billing',
                                  style: GoogleFonts.merienda(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 18, right: 18),
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom:
                                BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.trending_up,
                              color: Colors.blueAccent,
                              size: 27,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Quick Access",
                              style: GoogleFonts.merienda(
                                color: Colors.blueAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 75,
                              height: 75,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.blueAccent, width: 3),
                              ),
                              child: const Icon(
                                Icons.text_snippet_outlined,
                                color: Colors.black,
                                size: 45,
                              ),
                            ),
                            const Text(
                              "Bills",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 75,
                              height: 75,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.blueAccent, width: 3),
                              ),
                              child: const Icon(
                                Icons.data_exploration_outlined,
                                color: Colors.black,
                                size: 45,
                              ),
                            ),
                            const Text(
                              "Expenses",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 75,
                              height: 75,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.blueAccent, width: 3),
                              ),
                              child: const Icon(
                                Icons.production_quantity_limits_outlined,
                                color: Colors.black,
                                size: 45,
                              ),
                            ),
                            const Text(
                              "Products",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 75,
                              height: 75,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // gradient: LinearGradient(colors: [Colors.black, Colors.grey]),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.blueAccent, width: 3),
                              ),
                              child: const Icon(
                                Icons.library_books_outlined,
                                color: Colors.black,
                                size: 45,
                              ),
                            ),
                            const Text(
                              "Reports",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 18, right: 18),
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom:
                                BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.category_outlined,
                              color: Colors.blueAccent,
                              size: 27,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Product Categories",
                              style: GoogleFonts.merienda(
                                color: Colors.blueAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      alignment: WrapAlignment.center,
                      children: List.generate(12, (index) {
                        return SizedBox(
                          width: 160,
                          height: 130,
                          child: Card(
                            color: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            child: Center(
                              /*child: Text(
                                'Card ${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),*/
                              /*child: Image.asset(
                                "assets/images/products/sofa.jpg",
                                fit: BoxFit.fill,
                                width: 160,
                                height: 130,
                              ),*/
                              child: Image.asset(
                                products[index],
                                fit: BoxFit.fill,
                                width: 160,
                                height: 130,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



/*
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Sales Graph',
                            style: GoogleFonts.merienda(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            width: 180,
                            height: 140,
                            child: Image.asset(
                              "assets/images/salesgraph.jpeg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Product List',
                            style: GoogleFonts.merienda(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 180,
                            height: 120,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        child: SizedBox(
                                          width: 50,
                                          height: 30,
                                          child: Text(
                                            "Item 1",
                                            style: GoogleFonts.merienda(
                                              color: Colors.blueAccent,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        child: SizedBox(
                                          width: 50,
                                          height: 30,
                                          child: Text(
                                            "Item 2",
                                            style: GoogleFonts.merienda(
                                              color: Colors.blueAccent,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        child: SizedBox(
                                          width: 50,
                                          height: 30,
                                          child: Text(
                                            "Item 3",
                                            style: GoogleFonts.merienda(
                                              color: Colors.blueAccent,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        child: SizedBox(
                                          width: 50,
                                          height: 30,
                                          child: Text(
                                            "Item 4",
                                            style: GoogleFonts.merienda(
                                              color: Colors.blueAccent,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        child: SizedBox(
                                          width: 50,
                                          height: 30,
                                          child: Text(
                                            "Item 5",
                                            style: GoogleFonts.merienda(
                                              color: Colors.blueAccent,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        child: SizedBox(
                                          width: 50,
                                          height: 30,
                                          child: Text(
                                            "Item 6",
                                            style: GoogleFonts.merienda(
                                              color: Colors.blueAccent,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        child: SizedBox(
                                          width: 50,
                                          height: 30,
                                          child: Text(
                                            "Item 7",
                                            style: GoogleFonts.merienda(
                                              color: Colors.blueAccent,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        child: SizedBox(
                                          width: 50,
                                          height: 30,
                                          child: Text(
                                            "Item 8",
                                            style: GoogleFonts.merienda(
                                              color: Colors.blueAccent,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        child: SizedBox(
                                          width: 50,
                                          height: 30,
                                          child: Text(
                                            "Item 9",
                                            style: GoogleFonts.merienda(
                                              color: Colors.blueAccent,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        child: SizedBox(
                                          width: 50,
                                          height: 30,
                                          child: Text(
                                            "Item 10",
                                            style: GoogleFonts.merienda(
                                              color: Colors.blueAccent,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        child: SizedBox(
                                          width: 50,
                                          height: 30,
                                          child: Text(
                                            "Item 11",
                                            style: GoogleFonts.merienda(
                                              color: Colors.blueAccent,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        child: SizedBox(
                                          width: 50,
                                          height: 30,
                                          child: Text(
                                            "Item 12",
                                            style: GoogleFonts.merienda(
                                              color: Colors.blueAccent,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        child: SizedBox(
                                          width: 50,
                                          height: 30,
                                          child: Text(
                                            "Item 13",
                                            style: GoogleFonts.merienda(
                                              color: Colors.blueAccent,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        child: SizedBox(
                                          width: 50,
                                          height: 30,
                                          child: Text(
                                            "Item 14",
                                            style: GoogleFonts.merienda(
                                              color: Colors.blueAccent,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                
*/