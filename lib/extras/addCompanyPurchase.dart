// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class AddCompanyScreen extends StatelessWidget {
//   final TextEditingController _companyNameController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Add Company')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _companyNameController,
//               decoration: InputDecoration(labelText: 'Company Name'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 final companyName = _companyNameController.text.trim();
//                 if (companyName.isNotEmpty) {
//                   FirebaseFirestore.instance
//                       .collection('users')
//                       .doc('username1')
//                       .collection('purchase')
//                       .doc(companyName)
//                       .set({});
//                   Navigator.pop(context);
//                 }
//               },
//               child: Text('Add Company'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
