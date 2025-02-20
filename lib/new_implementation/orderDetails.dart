import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_connect/Generate_PDF/page/pdf_page.dart';
import 'package:firebase_connect/controller/LoginDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Generate_PDF/model/invoice.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String documentPath;
  final String ownerId;
  final String orderId;

  const OrderDetailsScreen({
    super.key,
    required this.documentPath,
    required this.ownerId,
    required this.orderId,
  });

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _showProducts = true; // Controls whether the products table is shown

  double priceSum = 0;
  dynamic date;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Logindetails>(context, listen: false).userEmail)
        .collection('sales')
        .doc(widget.ownerId)
        .collection('orders')
        .doc(widget.orderId)
        .collection('products');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.doc(widget.documentPath).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Order Details Card
                Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.orderId,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...data.entries.map((entry) {
                          if (entry.key == 'orderDate') {
                            date = entry.value.toString();
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Flexible(
                                  child: Text(
                                    entry.value.toString(),
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Show/Hide Products Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showProducts =
                              !_showProducts; // Toggle product table visibility
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        // minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blueAccent,
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _showProducts ? 'Hide Products' : 'Show Products',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 19),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final productsSnapshot = await FirebaseFirestore
                            .instance
                            .collection('users')
                            .doc(Provider.of<Logindetails>(context,
                                    listen: false)
                                .userEmail)
                            .collection('sales')
                            .doc(widget.ownerId)
                            .collection('orders')
                            .doc(widget.orderId)
                            .collection('products')
                            .get();

                        // Map Firestore data to InvoiceItem objects
                        priceSum = 0;
                        final products = productsSnapshot.docs.map((doc) {
                          final data = doc.data();
                          priceSum += (data['price'] * data['quantity']) ?? 0.0;
                          return InvoiceItem(
                            description: data['name'] ?? '',
                            date: DateTime.now(),
                            quantity: data['quantity'] ?? 0,
                            vat: 0.18, // Assuming a default VAT value of 18%
                            unitPrice: data['price']?.toDouble() ?? 0.0,
                          );
                        }).toList();

                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          log("$priceSum");
                          return PdfPage(
                              items: products,
                              owner: widget.ownerId,
                              order: widget.orderId,
                              totalAmt: priceSum,
                              date: date);
                        }));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Invoice',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 19),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Products Table Section
                if (_showProducts)
                  Expanded(
                    flex: 0,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: productsRef.snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text(
                              'No products found.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }

                        final products = snapshot.data!.docs;

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: DataTable(
                                  columnSpacing: 20.0,
                                  headingRowColor: WidgetStateColor.resolveWith(
                                    (states) =>
                                        // ignore: deprecated_member_use
                                        Colors.blueAccent.withOpacity(0.1),
                                  ),
                                  columns: const [
                                    DataColumn(
                                      label: Text(
                                        'Sr No.',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Price',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Quantity',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                  rows: products.asMap().entries.map((entry) {
                                    final index =
                                        entry.key + 1; // Sr No. starts from 1
                                    final product = entry.value.data()
                                        as Map<String, dynamic>;
                                    return DataRow(cells: [
                                      DataCell(Text(index.toString())),
                                      DataCell(Text(product['name'])),
                                      DataCell(Text('₹ ${product['price']}')),
                                      DataCell(
                                          Text(product['quantity'].toString())),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// import 'productsDetails.dart';

// class OrderDetailsScreen extends StatelessWidget {
//   final String documentPath;
//   final String ownerId;
//   final String orderId;

//   OrderDetailsScreen(
//       {super.key, required this.documentPath, required this.ownerId, required this.orderId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Order Details')),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance.doc(documentPath).snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final data = snapshot.data!.data() as Map<String, dynamic>;
//           return ListView(
//             children: data.entries.map((entry) {
//               return GestureDetector(
//                 onTap: () {
//                   // log('${ownerId}');
//                   Navigator.of(context)
//                       .push(MaterialPageRoute(builder: (contect) {
//                     return ProductDetailsScreen(ownerId: ownerId, orderId: orderId);
//                   }));
//                 },
//                 child: ListTile(
//                   title: Text(entry.key), // Product ID
//                   subtitle: Text(entry.value.toString()), // Product details
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }
