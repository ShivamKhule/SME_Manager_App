import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';
import '../utils.dart';
import 'pdf_api.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      margin: EdgeInsets.all(2 * PdfPageFormat.cm),
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(thickness: 1, color: PdfColors.grey400),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      'Payment Terms:',
      'Due Date:'
    ];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      paymentTerms,
      Utils.formatDate(info.dueDate),
    ];

    return Container(
      margin: const EdgeInsets.only(left: 0.5 * PdfPageFormat.cm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(titles.length, (index) {
          final title = titles[index];
          final value = data[index];

          return buildText(title: title, value: value);
        }),
      ),
    );
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice.supplier),
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: PdfColors.black, width: 1),
                ),
                padding: EdgeInsets.all(5),
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: invoice.info.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.customer),
              buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );

      static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text("Order Name : ${invoice.info.description}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

      static Widget buildCustomerAddress(Customer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Bill to : ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 1.1 * PdfPageFormat.mm),
          Text(customer.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Text(customer.address, style: TextStyle(fontSize: 14)),
        ],
      );

       static Widget buildSupplierAddress(Supplier supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Bill from : ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 1.1 * PdfPageFormat.mm),
          Text(supplier.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.address, style: TextStyle(fontSize: 14)),
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = ['Product', 'Quantity', 'Unit Price', 'VAT', 'Total'];
    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity * (1 + item.vat);
      return [
        item.description,
        '${item.quantity}',
        '${item.unitPrice.toStringAsFixed(2)}',
        '${item.vat}%',
        '${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: TableBorder.all(color: PdfColors.grey400, width: 0.5),
      headerStyle: TextStyle(fontWeight: FontWeight.bold, color: PdfColors.white),
      headerDecoration: BoxDecoration(color: PdfColors.blue600),
      rowDecoration: BoxDecoration(color: PdfColors.grey200),
      cellHeight: 30,
      cellAlignments: {0: Alignment.centerLeft, 1: Alignment.center, 2: Alignment.center, 3: Alignment.center, 4: Alignment.center},
    );
  }

  static Widget buildTotal(Invoice invoice) {
    final netTotal = invoice.items.map((item) => item.unitPrice * item.quantity).reduce((a, b) => a + b);
    final vatPercent = invoice.items.first.vat;
    final vat = netTotal * vatPercent;
    final total = netTotal + vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          buildText(title: 'Net Total:', value: '${netTotal.toStringAsFixed(2)}'),
          buildText(title: 'VAT (${vatPercent * 100}%):', value: '${vat.toStringAsFixed(2)}'),
          Divider(thickness: 1),
          buildText(
            title: 'Total Amount:',
            value: '${total.toStringAsFixed(2)}',
            titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: PdfColors.red800),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(thickness: 1),
          SizedBox(height: 2 * PdfPageFormat.mm),
          Text('Thank you for your business!', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'Company Address:', value: invoice.supplier.address),
        ],
      );

  static buildSimpleText({required String title, required String value}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 4),
        Text(value),
      ],
    );
  }

  static buildText({required String title, required String value, TextStyle? titleStyle}) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}





// import 'dart:io';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/widgets.dart';

// import '../model/customer.dart';
// import '../model/invoice.dart';
// import '../model/supplier.dart';
// import '../utils.dart';
// import 'pdf_api.dart';

// class PdfInvoiceApi {
//   static Future<File> generate(Invoice invoice) async {
//     final pdf = Document();

//     pdf.addPage(MultiPage(
//       build: (context) => [
//         buildHeader(invoice),
//         SizedBox(height: 3 * PdfPageFormat.cm),
//         buildTitle(invoice),
//         buildInvoice(invoice),
//         Divider(),
//         buildTotal(invoice),
//       ],
//       footer: (context) => buildFooter(invoice),
//     ));

//     return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
//   }

//   static Widget buildHeader(Invoice invoice) => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 1 * PdfPageFormat.cm),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               buildSupplierAddress(invoice.supplier),
//               Container(
//                 height: 50,
//                 width: 50,
//                 child: BarcodeWidget(
//                   barcode: Barcode.qrCode(),
//                   data: invoice.info.number,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 1 * PdfPageFormat.cm),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               buildCustomerAddress(invoice.customer),
//               buildInvoiceInfo(invoice.info),
//             ],
//           ),
//         ],
//       );

  // static Widget buildCustomerAddress(Customer customer) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text("Bill to : ",
  //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  //         SizedBox(height: 1.1 * PdfPageFormat.mm),
  //         Text(customer.name,
  //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
  //         Text(customer.address, style: TextStyle(fontSize: 14)),
  //       ],
  //     );

  // static Widget buildInvoiceInfo(InvoiceInfo info) {
  //   final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
  //   final titles = <String>[
  //     'Invoice Number:',
  //     'Invoice Date:',
  //     'Payment Terms:',
  //     'Due Date:'
  //   ];
  //   final data = <String>[
  //     info.number,
  //     Utils.formatDate(info.date),
  //     paymentTerms,
  //     Utils.formatDate(info.dueDate),
  //   ];

  //   return Container(
  //     margin: const EdgeInsets.only(left: 0.5 * PdfPageFormat.cm),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: List.generate(titles.length, (index) {
  //         final title = titles[index];
  //         final value = data[index];

  //         return buildText(title: title, value: value, width: 200);
  //       }),
  //     ),
  //   );
  // }

  // static Widget buildSupplierAddress(Supplier supplier) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text("Bill from : ",
  //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  //         SizedBox(height: 1.1 * PdfPageFormat.mm),
  //         Text(supplier.name,
  //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
  //         SizedBox(height: 1 * PdfPageFormat.mm),
  //         Text(supplier.address, style: TextStyle(fontSize: 14)),
  //       ],
  //     );

  // static Widget buildTitle(Invoice invoice) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'INVOICE',
  //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //         ),
  //         SizedBox(height: 0.8 * PdfPageFormat.cm),
  //         Text("Order Name : ${invoice.info.description}",
  //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  //         SizedBox(height: 0.8 * PdfPageFormat.cm),
  //       ],
  //     );

//   static Widget buildInvoice(Invoice invoice) {
//     final headers = [
//       'Product',
//       // 'Date',
//       'Quantity',
//       'Unit Price',
//       'VAT',
//       'Total'
//     ];
//     final data = invoice.items.map((item) {
//       final total = item.unitPrice * item.quantity * (1 + item.vat);

//       return [
//         item.description,
//         // Utils.formatDate(item.date),
//         '${item.quantity}',
//         '${item.unitPrice}',
//         '${item.vat} %',
//         '${total.toStringAsFixed(2)}',
//       ];
//     }).toList();

//     return Table.fromTextArray(
//       headers: headers,
//       data: data,
//       border: null,
//       headerStyle: TextStyle(fontWeight: FontWeight.bold),
//       headerDecoration: BoxDecoration(color: PdfColors.grey300),
//       cellHeight: 30,
//       cellAlignments: {
//         0: Alignment.center,
//         // 1: Alignment.center,
//         2: Alignment.center,
//         3: Alignment.center,
//         4: Alignment.center,
//         5: Alignment.center,
//       },
//     );
//   }

//   static Widget buildTotal(Invoice invoice) {
//     final netTotal = invoice.items
//         .map((item) => item.unitPrice * item.quantity)
//         .reduce((item1, item2) => item1 + item2);
//     final vatPercent = invoice.items.first.vat;
//     final vat = netTotal * vatPercent;
//     final total = netTotal + vat;

//     return Container(
//       alignment: Alignment.centerRight,
//       child: Row(
//         children: [
//           Spacer(flex: 6),
//           Expanded(
//             flex: 4,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildText(
//                   title: 'Net total',
//                   value: Utils.formatPrice(netTotal),
//                   unite: true,
//                 ),
//                 buildText(
//                   title: 'Vat ${vatPercent * 100} %',
//                   value: Utils.formatPrice(vat),
//                   unite: true,
//                 ),
//                 Divider(),
//                 buildText(
//                   title: 'Total amount due',
//                   titleStyle: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   value: Utils.formatPrice(total),
//                   unite: true,
//                 ),
//                 SizedBox(height: 2 * PdfPageFormat.mm),
//                 Container(height: 1, color: PdfColors.grey400),
//                 SizedBox(height: 0.5 * PdfPageFormat.mm),
//                 Container(height: 1, color: PdfColors.grey400),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   static Widget buildFooter(Invoice invoice) => Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Divider(),
//           SizedBox(height: 2 * PdfPageFormat.mm),
//           buildSimpleText(title: 'Address', value: invoice.supplier.address),
//           // SizedBox(height: 1 * PdfPageFormat.mm),
//           // buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
//         ],
//       );

//   static buildSimpleText({
//     required String title,
//     required String value,
//   }) {
//     final style = TextStyle(fontWeight: FontWeight.bold);

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: pw.CrossAxisAlignment.end,
//       children: [
//         Text(title, style: style),
//         SizedBox(width: 2 * PdfPageFormat.mm),
//         Text(value),
//       ],
//     );
//   }

//   static buildText({
//     required String title,
//     required String value,
//     double width = double.infinity,
//     TextStyle? titleStyle,
//     bool unite = false,
//   }) {
//     final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

//     return Container(
//       width: width,
//       child: Row(
//         children: [
//           Expanded(child: Text(title, style: style)),
//           Text(value, style: unite ? style : null),
//         ],
//       ),
//     );
//   }
// }
