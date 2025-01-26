import 'package:firebase_connect/Generate_PDF/api/pdf_api.dart';
import 'package:firebase_connect/Generate_PDF/api/pdf_invoice_api.dart';
import 'package:firebase_connect/Generate_PDF/model/customer.dart';
import 'package:firebase_connect/Generate_PDF/model/invoice.dart';
import 'package:firebase_connect/Generate_PDF/model/supplier.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class PdfPage extends StatefulWidget {
  final List<InvoiceItem> items; // Declare items property

  const PdfPage(
      {super.key, required this.items}); // Assign items in constructor

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  String amountStatus = "Paid"; // You can toggle between "Paid" or "Remain"

  List<int>? pdfFile;

  void handleDownload() async {
    final date = DateTime.now();
    final dueDate = date.add(const Duration(days: 7));

    final invoice = Invoice(
      supplier: const Supplier(
        name: 'R.K. Enterprises',
        address: 'JM Road, Sambhajinagar, Maharashtra 411023',
        paymentInfo: 'https://paypal.me/sarahfieldzz',
      ),
      customer: const Customer(
        name: 'Patil Furnitures',
        address: 'Jadhav Colony, Sambhajinagar, Maharashtra 411023',
      ),
      info: InvoiceInfo(
        date: date,
        dueDate: dueDate,
        description: 'Furniture Material Order',
        number: '${DateTime.now().year}-9478',
      ),
      items: widget.items, // Access the items here
    );

    try {
      final pdfFile = await PdfInvoiceApi.generate(invoice);
      await PdfApi.openFile(pdfFile);
    } catch (e) {
      // Handle any errors (e.g., file generation or opening errors)
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
        supplier: const Supplier(
          name: 'R.K. Enterprises',
          address: 'JM Road, Sambhajinagar, Maharashtra 411023',
          paymentInfo: 'https://paypal.me/sarahfieldzz',
        ),
        customer: const Customer(
          name: 'Patil Furnitures',
          address: 'Jadhav Colony, Sambhajinagar, Maharashtra 411023',
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

  // Helper Widget for Party Information Card
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
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Party Name: ABC Pvt Ltd",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "GSTIN: 27ABCDE1234F1Z5",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Contact: +91 9876543210",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Address: 123, Main Street, City, State, 123456",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                  const Text(
                    "Total Amount: ₹10,000",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Order Date: 20th Jan 2025",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
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
//               text: 'Generate Invoice',
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
