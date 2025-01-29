import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_connect/controller/LoginDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reports')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users/${Provider.of<Logindetails>(context).userEmail}/reports').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(data[index].id),
                subtitle: Text(data[index].data().toString()),
              );
            },
          );
        },
      ),
    );
  }
}
