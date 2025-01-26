// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class AddOrderScreen extends StatelessWidget {
//   final String ownerId;
//   final TextEditingController _orderIdController = TextEditingController();

//   AddOrderScreen({required this.ownerId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Add Order for $ownerId')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _orderIdController,
//               decoration: InputDecoration(labelText: 'Order ID'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 final orderId = _orderIdController.text.trim();
//                 if (orderId.isNotEmpty) {
//                   FirebaseFirestore.instance
//                       .collection('users')
//                       .doc('username1')
//                       .collection('sales')
//                       .doc(ownerId)
//                       // .collection('orders')
//                       // .doc(orderId)
//                       .set({});
//                   Navigator.pop(context);
//                 }
//               },
//               child: Text('Add Order'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
