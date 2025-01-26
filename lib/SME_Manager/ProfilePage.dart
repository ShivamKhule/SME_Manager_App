import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  ProfilePage({super.key}); // Fetch the logged-in user
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile picture (placeholder for now)
            CircleAvatar(
              radius: 50,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : const AssetImage('assets/profile_placeholder.png') as ImageProvider,
            ),
            const SizedBox(height: 20),
            
            // Display user email
            Text(
              user != null ? 'Email: ${user!.email}' : 'No user logged in',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            
            // Display user UID
            Text(
              user != null ? 'UID: ${user!.uid}' : 'No user logged in',
              style: const TextStyle(fontSize: 18),
            ),
            
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Return to home page
              },
              child: const Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }
}
