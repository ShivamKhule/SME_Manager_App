import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../Generate_PDF/page/pdf_page.dart';
import '../model/Item_Model.dart';
import 'HomePage.dart';
import 'sales_entry_screen.dart'; // Make sure this import is correct for your app.

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  List<Item> firebaseList = [];
  List<Item> filteredList = [];
  bool _isLoading = true;
  TextEditingController searchController = TextEditingController();
  String selectedSortOption = 'Newest First';

  @override
  void initState() {
    super.initState();
    fetchItemsFromFirestore();
  }

  void fetchItemsFromFirestore() {
    try {
      CollectionReference itemsCollection =
          FirebaseFirestore.instance.collection('TrialDataStore');

      // Listen to real-time updates using snapshots()
      itemsCollection.snapshots().listen((querySnapshot) {
        setState(() {
          firebaseList.clear();
          filteredList.clear();
          firebaseList = querySnapshot.docs.map((doc) {
            return Item.fromFirestore(doc.data() as Map<String, dynamic>);
          }).toList();
          filteredList = List.from(firebaseList);
          sortFirebaseList(); // Initial sort
          _isLoading = false;
        });
      });
    } catch (e) {
      log("Error fetching items: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  /*Future<void> fetchItemsFromFirestore() async {
    try {
      CollectionReference itemsCollection =
          FirebaseFirestore.instance.collection('TrialDataStore');
      QuerySnapshot querySnapshot = await itemsCollection.get();

      setState(() {
        firebaseList.clear();
        firebaseList = querySnapshot.docs.map((doc) {
          return Item.fromFirestore(doc.data() as Map<String, dynamic>);
        }).toList();
        filteredList = List.from(firebaseList);
        _isLoading = false;
        sortFirebaseList(); // Initial sort
      });
    } catch (e) {
      print("Error fetching items: $e");
      _isLoading = false;
    }
  }*/

  // Sorting logic based on the selected option
  void sortFirebaseList() {
    setState(() {
      switch (selectedSortOption) {
        case 'Price: Low to High':
          filteredList.sort((a, b) => a.amount.compareTo(b.amount));
          break;
        case 'Price: High to Low':
          filteredList.sort((a, b) => b.amount.compareTo(a.amount));
          break;
        case 'Newest First':
          filteredList.sort((a, b) => DateFormat.yMEd()
              .parse(b.date)
              .compareTo(DateFormat.yMEd().parse(a.date)));
          break;
        case 'Oldest First':
          filteredList.sort((a, b) => DateFormat.yMEd()
              .parse(a.date)
              .compareTo(DateFormat.yMEd().parse(b.date)));
          break;
      }
    });
  }

  // Filtering the list based on search query
  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredList = List.from(firebaseList);
      });
      sortFirebaseList();
      return;
    }

    setState(() {
      filteredList = firebaseList
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      sortFirebaseList();
    });
  }

  void createFirestoreStructure() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Define username document
    String username = "username1";

    // Adding sales -> owners -> orders -> products
    await firestore
        .collection('users') // Top-level collection
        .doc(username) // Document for the user
        .collection('sales') // Sales subcollection
        .doc('owners') // Owners document
        .collection('orders') // Orders subcollection
        .doc('order2') // Specific order document
        .set({
      'product3': {'name': 'Product C', 'price': 300},
      'product4': {'name': 'Product D', 'price': 400},
    });

    // Adding purchase -> company -> orders -> products
    await firestore
        .collection('users')
        .doc(username)
        .collection('purchase')
        .doc('company')
        .collection('orders')
        .doc('order2')
        .set({
      'product1': {'name': 'Product C', 'price': 300},
      'product2': {'name': 'Product D', 'price': 400},
    });

    // Adding reports (if needed)
    await firestore
        .collection('users')
        .doc(username)
        .collection('reports')
        .doc('report2')
        .set({
      'summary': 'This is a sales report 2',
      'date': DateTime.now(),
    });
  }

  // Function to handle adding new sales entry
  void _navigateToSalesEntryScreen() async {
    createFirestoreStructure();

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SalesEntryScreen(),
      ),
    );

    // If there's new data returned, update the list
    if (result != null) {
      setState(() {
        firebaseList
            .add(Item.fromFirestore(result)); // Add new entry to the list
        filteredList = List.from(firebaseList); // Update filtered list
        sortFirebaseList(); // Reapply sorting after adding new entry
      });
    }
  }

  void _navigateToPdfPage(Item item) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => PdfPage(item: item),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text(
            "Sales",
            style: GoogleFonts.merienda(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const Homepage();
                }));
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              )),
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: SpinKitCircle(
                    color: Colors.blueAccent,
                    size: 50.0,
                  ),
                )
              : Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by name...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        onChanged: filterSearchResults,
                      ),
                    ),
                    // Sort Dropdown
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Sort by:",
                            style: GoogleFonts.merienda(
                              color: Colors.grey[800],
                              fontSize: 19,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 8),
                          DropdownButton<String>(
                            value: selectedSortOption,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedSortOption = newValue!;
                                sortFirebaseList();
                              });
                            },
                            items: [
                              'Price: Low to High',
                              'Price: High to Low',
                              'Newest First',
                              'Oldest First'
                            ].map<DropdownMenuItem<String>>((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    // Display "No Records Found" if search yields no results
                    filteredList.isEmpty
                        ? Center(
                            child: Text(
                              "No records found",
                              style: GoogleFonts.merienda(
                                color: Colors.redAccent,
                                fontSize: 22,
                              ),
                            ),
                          )
                        : Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Table(
                                // textDirection: ,
                                defaultColumnWidth:
                                    const FixedColumnWidth(140.0),
                                border: TableBorder(
                                  horizontalInside: BorderSide(
                                      color: Colors.grey.shade300, width: 1),
                                ),
                                children: [
                                  TableRow(
                                    decoration: const BoxDecoration(
                                      color: Colors.blueAccent,
                                    ),
                                    children: [
                                      _buildTableHeader("Name"),
                                      _buildTableHeader("Amount"),
                                      _buildTableHeader("Paid"),
                                      _buildTableHeader("Total Amt"),
                                      _buildTableHeader("Date"),
                                    ],
                                  ),
                                  ...filteredList.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    Item item = entry.value;

                                    Color rowColor = index.isEven
                                        ? Colors.blue.shade50
                                        : Colors.white;

                                    return TableRow(
                                      decoration:
                                          BoxDecoration(color: rowColor),
                                      children: [
                                        GestureDetector(
                                          onTap: () => _navigateToPdfPage(item),
                                          child: _buildTableCell(item.name),
                                        ),
                                        GestureDetector(
                                          onTap: () => _navigateToPdfPage(item),
                                          child: _buildTableCell(
                                              item.amount.toString()),
                                        ),
                                        GestureDetector(
                                          onTap: () => _navigateToPdfPage(item),
                                          child: _buildTableCell(
                                              item.paid.toString()),
                                        ),
                                        GestureDetector(
                                          onTap: () => _navigateToPdfPage(item),
                                          child: _buildTableCell(
                                              item.totalAmount.toString()),
                                        ),
                                        GestureDetector(
                                          onTap: () => _navigateToPdfPage(item),
                                          child: _buildTableCell(item.date),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToSalesEntryScreen,
          backgroundColor: Colors.blueAccent,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }
}
