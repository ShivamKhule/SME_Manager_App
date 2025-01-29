import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_connect/controller/LoginDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String ownerId;
  final String orderId;

  ProductDetailsScreen({required this.ownerId, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final productsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Logindetails>(context, listen: false).userEmail)
        .collection('sales')
        .doc(ownerId)
        .collection('orders')
        .doc(orderId)
        .collection('products');

    return Scaffold(
      appBar: AppBar(title: Text('Products:- $orderId')),
      body: StreamBuilder<QuerySnapshot>(
        stream: productsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          final products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(product['name']),
                  subtitle: Text(
                      'Price: ${product['price']}, Quantity: ${product['quantity']}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
