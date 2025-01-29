import 'package:firebase_connect/controller/LoginDetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class AddSalesOwnerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Sales Owner Dialog Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => showAddSalesOwnerDialog(context),
          child: const Text('Show Dialog'),
        ),
      ),
    );
  }

  void showAddSalesOwnerDialog(BuildContext context) {
    final TextEditingController _ownerNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Add Sales Owner',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _ownerNameController,
                decoration: InputDecoration(
                  labelText: 'Owner Name',
                  labelStyle: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  final ownerName = _ownerNameController.text.trim();
                  if (ownerName.isNotEmpty) {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(Provider.of<Logindetails>(context).userEmail)
                        .collection('sales')
                        .doc(ownerName)
                        .set({});

                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Add Owner',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
