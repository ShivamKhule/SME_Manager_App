import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatelessWidget {
  final String orderPath; // Path to the specific order
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();

  AddProductScreen({required this.orderPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _productNameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _productPriceController,
              decoration: InputDecoration(labelText: 'Product Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final productName = _productNameController.text.trim();
                final productPrice = double.tryParse(_productPriceController.text.trim());
                if (productName.isNotEmpty && productPrice != null) {
                  FirebaseFirestore.instance
                      .doc(orderPath)
                      .set({
                        productName: {'name': productName, 'price': productPrice}
                      }, SetOptions(merge: true));
                  Navigator.pop(context);
                }
              },
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
