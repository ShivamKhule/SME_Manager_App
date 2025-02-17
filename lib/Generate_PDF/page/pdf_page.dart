import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_connect/Generate_PDF/api/pdf_api.dart';
import 'package:firebase_connect/Generate_PDF/api/pdf_invoice_api.dart';
import 'package:firebase_connect/Generate_PDF/model/customer.dart';
import 'package:firebase_connect/Generate_PDF/model/invoice.dart';
import 'package:firebase_connect/Generate_PDF/model/supplier.dart';
import 'package:firebase_connect/controller/LoginDetails.dart';
import 'package:firebase_connect/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class PdfPage extends StatefulWidget {
  final List<InvoiceItem> items;
  // final String partyname;
  // final String partygstin;
  // final String partynumber;
  // final String partyaddress;
  final String? owner;
  final String? order;
  final double? totalAmt;
  final dynamic date;

  const PdfPage({super.key, required this.items, this.owner, this.order, this.totalAmt, this.date});

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  String amountStatus = "Paid";

  List<int>? pdfFile;

  DBHelper dbHelper = DBHelper();

  dynamic data;

  Future<void> profileData() async {
    data = await dbHelper.getProfile();
    log("Fetched Data: $data");
    setState(() {});
  }

  dynamic detailsData;

  Future<void> getDetails() async {
    final detailsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Logindetails>(context, listen: false).userEmail)
        .collection('sales')
        .doc(widget.owner)
        .get();

    if (detailsSnapshot.exists) {
      setState(() {
        detailsData = detailsSnapshot.data();
      });
      log("Data on PDF page: $detailsData");
    } else {
      log("Document does not exist.");
    }
  }

  @override
  void initState() {
    super.initState();

    profileData();
    getDetails();
  }

  void handleDownload() async {
    final date = DateTime.now();
    final dueDate = date.add(const Duration(days: 7));

    final invoice = Invoice(
      supplier: Supplier(
        name: data['company_name'] ?? "Loading...",
        address: data['address'],
        // paymentInfo: 'https://paypal.me/sarahfieldzz',
      ),
      customer: Customer(
        name: detailsData['ownerName'],
        address: detailsData['wholeaddress'],
      ),
      info: InvoiceInfo(
        date: date,
        dueDate: dueDate,
        description: widget.order!,
        number: '${DateTime.now().year}-9478',
      ),
      items: widget.items, // Access the items here
    );

    try {
      final pdfFile = await PdfInvoiceApi.generate(invoice);
      await PdfApi.openFile(pdfFile);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void handleShare() async {
    try {
      final date = DateTime.now();
      final dueDate = date.add(const Duration(days: 7));

      final invoice = Invoice(
        supplier: Supplier(
          name: data['company_name'] ?? "Loading...",
          address: data['address'],
          // paymentInfo: 'https://paypal.me/sarahfieldzz',
        ),
        customer: Customer(
          name: detailsData['ownerName'],
          address: detailsData['wholeaddress'],
        ),
        info: InvoiceInfo(
          date: date,
          dueDate: dueDate,
          description: 'Furniture Material Order',
          number: '${DateTime.now().year}-9478',
        ),
        items: widget.items, // Access the items here
      );

      final pdfFile = await PdfInvoiceApi.generate(invoice);

      // Share the generated PDF file
      await Share.shareXFiles(
        [
          XFile(pdfFile.path), // Using the file path directly from pdfFile
        ],
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Invoice Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card 1: Party Information
            _buildPartyInfoCard(),
            const SizedBox(height: 16),
            // Card 2: Order Information
            _buildOrderInfoCard(),
            const SizedBox(height: 16),
            // Action Buttons: Download, Print, Share
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircularIconButton(
                    Icons.download, "Download", handleDownload),
                _buildCircularIconButton(Icons.print, "Print", () {}),
                _buildCircularIconButton(Icons.share, "Share", handleShare),
              ],
            ),
            const Spacer(),
            // Done Button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A11CB),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Done",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartyInfoCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFF6A11CB).withOpacity(0.1),
              child: const Icon(
                Icons.business,
                color: Color(0xFF6A11CB),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Party Name: ${detailsData != null ? detailsData['ownerName'] : "Loading..."}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "GSTIN: ${detailsData != null ? detailsData['gstin'] : "Loading..."}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Contact: ${detailsData != null ? detailsData['mobile'] : "Loading..."}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Address: ${detailsData != null ? detailsData['wholeaddress'] : "Loading..."}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // // Helper Widget for Party Information Card
  // Widget _buildPartyInfoCard() {
  //   return Card(
  //     elevation: 6,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           CircleAvatar(
  //             radius: 28,
  //             backgroundColor: const Color(0xFF6A11CB).withOpacity(0.1),
  //             child: const Icon(
  //               Icons.business,
  //               color: Color(0xFF6A11CB),
  //               size: 28,
  //             ),
  //           ),
  //           const SizedBox(width: 16),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   "Party Name: ${detailsData['ownerName']}" ?? "Loading...",
  //                   style: const TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.black87,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Text(
  //                   "GSTIN: ${detailsData['gstin']}",
  //                   style: const TextStyle(fontSize: 14, color: Colors.grey),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Text(
  //                   "Contact: ${detailsData['mobile']}",
  //                   style: const TextStyle(fontSize: 14, color: Colors.grey),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Text(
  //                   "Address: ${detailsData['wholeaddress']}",
  //                   style: const TextStyle(fontSize: 14, color: Colors.grey),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Helper Widget for Order Information Card
  Widget _buildOrderInfoCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFF6A11CB).withOpacity(0.1),
              child: const Icon(
                Icons.receipt,
                color: Color(0xFF6A11CB),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Amount: ₹ ${widget.totalAmt}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Order Date: ${widget.date}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        amountStatus == "Paid"
                            ? Icons.check_circle
                            : Icons.warning_amber,
                        color:
                            amountStatus == "Paid" ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Amount Status: $amountStatus",
                        style: TextStyle(
                          fontSize: 14,
                          color: amountStatus == "Paid"
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularIconButton(
      IconData icon, String tooltip, VoidCallback onPressed) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  // BoxShadow(
                  //   color: Colors.black.withOpacity(0.1),
                  //   blurRadius: 8,
                  //   spreadRadius: 2,
                  //   offset: const Offset(0, 4),
                  // ),
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          tooltip,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}


        



// body: Column(
//           // mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const TitleWidget(
//               icon: Icons.picture_as_pdf,
//               text: ' Invoice',
//             ),
//             const Icon(
//               Icons.picture_as_pdf,
//               color: Colors.black,
//               size: 100,
//             ),
//             const Text(
//               "Invoice",
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 40,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 48),
        
//             ElevatedButton.icon(
//               onPressed: () async {
//                 final date = DateTime.now();
//                 final dueDate = date.add(const Duration(days: 7));
        
//                 final invoice = Invoice(
//                   supplier: const Supplier(
//                     name: 'R.K. Enterprises',
//                     address: 'JM Road, Sambhajinagar, Maharashtra 411023',
//                     paymentInfo: 'https://paypal.me/sarahfieldzz',
//                   ),
//                   customer: const Customer(
//                     name: 'Patil Furnitures',
//                     address:
//                         'Jadhav Colony, Sambhajinagar, Maharashtra 411023',
//                   ),
//                   info: InvoiceInfo(
//                     date: date,
//                     dueDate: dueDate,
//                     description: 'Furniture Material Order',
//                     number: '${DateTime.now().year}-9478',
//                   ),
//                   items: widget.items, // Use passed product list
//                 );
//                 final pdfFile = await PdfInvoiceApi.generate(invoice);
//                 PdfApi.openFile(pdfFile);
//               },
//               icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
//               label: const Text(
//                 "Generate E-Copy",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 24, vertical: 12),
//                 backgroundColor: Colors.blueAccent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 elevation: 6,
//                 shadowColor: Colors.black45,
//                 foregroundColor: Colors.white,
//               ),
//             ), 
//           ],
//         ),



// ButtonWidget(
            //   text: 'Invoice PDF',
            //   onClicked: () async {
            //     final date = DateTime.now();
            //     final dueDate = date.add(const Duration(days: 7));
        
            //     final invoice = Invoice(
            //       supplier: const Supplier(
            //         name: 'R.K. Enterprises',
            //         address: 'JM Road, Sambhajinagar, Maharashtra 411023',
            //         paymentInfo: 'https://paypal.me/sarahfieldzz',
            //       ),
            //       customer: const Customer(
            //         name: 'Patil Furnitures',
            //         address:
            //             'Jadhav Colony, Sambhajinagar, Maharashtra 411023',
            //       ),
            //       info: InvoiceInfo(
            //         date: date,
            //         dueDate: dueDate,
            //         description: 'Furniture Material Order',
            //         number: '${DateTime.now().year}-9478',
            //       ),
            //       items: widget.items, // Use passed product list
            //     );
        
            //     final pdfFile = await PdfInvoiceApi.generate(invoice);
        
            //     PdfApi.openFile(pdfFile);
            //   },
            // ),





// import 'package:flutter/material.dart';
// import '../../model/Item_Model.dart';
// import '../api/pdf_api.dart';
// import '../api/pdf_invoice_api.dart';
// import '../model/customer.dart';
// import '../model/invoice.dart';
// import '../model/supplier.dart';
// import '../widget/button_widget.dart';
// import '../widget/title_widget.dart';

// class PdfPage extends StatefulWidget {
//   // final Item item;
//   const PdfPage({required List<InvoiceItem> items});
//   @override
//   _PdfPageState createState() => _PdfPageState();
// }

// class _PdfPageState extends State<PdfPage> {
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           title: const Text("Generate PDF"),
//           centerTitle: true,
//         ),
//         body: Container(
//           padding: const EdgeInsets.all(32),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 const TitleWidget(
//                   icon: Icons.picture_as_pdf,
//                   text: 'Generate Invoice',
//                 ),
//                 const SizedBox(height: 48),
//                 ButtonWidget(
//                   text: 'Invoice PDF',
//                   onClicked: () async {
//                     final date = DateTime.now();
//                     final dueDate = date.add(const Duration(days: 7));

//                     final invoice = Invoice(
//                       supplier: const Supplier(
//                         name: 'R.K. Enterprises',
//                         address: 'JM Road, Sambhajinagar, Maharashtra 411023',
//                         paymentInfo: 'https://paypal.me/sarahfieldzz',
//                       ),
//                       customer: const Customer(
//                         name: 'Patil Furnitures',
//                         address:
//                             'Jadhav Colony, Sambhajinagar, Maharashtra 411023',
//                       ),
//                       info: InvoiceInfo(
//                         date: date,
//                         dueDate: dueDate,
//                         description: 'Furniture Material Order',
//                         number: '${DateTime.now().year}-9478',
//                       ),
//                       items: [
//                         InvoiceItem(
//                           description: 'Sofa',
//                           date: DateTime.now(),
//                           quantity: 2,
//                           vat: 0.18,
//                           unitPrice: 12000,
//                         ),
//                         InvoiceItem(
//                           description: 'Wall Drop',
//                           date: DateTime.now(),
//                           quantity: 3,
//                           vat: 0.18,
//                           unitPrice: 10500,
//                         ),
//                         InvoiceItem(
//                           description: 'Double Bed',
//                           date: DateTime.now(),
//                           quantity: 2,
//                           vat: 0.18,
//                           unitPrice: 6450,
//                         ),
//                         InvoiceItem(
//                           description: 'Tables 6x6',
//                           date: DateTime.now(),
//                           quantity: 5,
//                           vat: 0.18,
//                           unitPrice: 5830,
//                         ),
//                         InvoiceItem(
//                           description: 'Showcase',
//                           date: DateTime.now(),
//                           quantity: 6,
//                           vat: 0.18,
//                           unitPrice: 17600,
//                         ),
//                         InvoiceItem(
//                           description: 'Cupboard',
//                           date: DateTime.now(),
//                           quantity: 3,
//                           vat: 0.18,
//                           unitPrice: 15450,
//                         ),
//                         InvoiceItem(
//                           description: 'Single Bed',
//                           date: DateTime.now(),
//                           quantity: 4,
//                           vat: 0.18,
//                           unitPrice: 3640,
//                         ),
//                       ],
//                     );

//                     final pdfFile = await PdfInvoiceApi.generate(invoice);

//                     PdfApi.openFile(pdfFile);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
// }
