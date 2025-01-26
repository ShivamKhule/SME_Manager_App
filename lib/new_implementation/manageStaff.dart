import 'package:flutter/material.dart';

class ManageStaffScreen extends StatelessWidget {
  const ManageStaffScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Staff',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        // flexibleSpace: Container(
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //     ),
        //   ),
        // ),
        elevation: 0,
        leading: IconButton(onPressed: () => Navigator.of(context).pushReplacementNamed('/home'), icon:const Icon(Icons.arrow_back)),
      ),
      body: Container(
        color: const Color(0xFFF5F6FA), // Light background
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  EnhancedStaffCard(
                    name: 'Rahul Sharma',
                    role: 'Delivery Boy',
                    phone: '9340738544',
                    roleIcon: Icons.delivery_dining,
                    onMorePressed: () {
                      // Handle more options
                    },
                  ),
                  EnhancedStaffCard(
                    name: 'Aditya Kohli',
                    role: 'Salesman (with edit access)',
                    phone: '9340738544',
                    roleIcon: Icons.edit,
                    onMorePressed: () {
                      // Handle more options
                    },
                  ),
                  EnhancedStaffCard(
                    name: 'Divya Gupta',
                    role: 'Salesman (without access)',
                    phone: '9340738544',
                    roleIcon: Icons.lock,
                    onMorePressed: () {
                      // Handle more options
                    },
                  ),
                  EnhancedStaffCard(
                    name: 'Prince Kumar',
                    role: 'Stock Manager',
                    phone: '9340738544',
                    roleIcon: Icons.inventory,
                    onMorePressed: () {
                      // Handle more options
                    },
                  ),
                ],
              ),
            ),
            // Floating Action Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: FloatingActionButton.extended(
                onPressed: () {
                  // Handle add staff action
                },
                label: const Text(
                  'Add Staff',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white),
                ),
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: const Color(0xFF6A11CB),
                hoverColor: Colors.deepPurpleAccent,
                elevation: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EnhancedStaffCard extends StatelessWidget {
  final String name;
  final String role;
  final String phone;
  final IconData roleIcon;
  final VoidCallback onMorePressed;

  const EnhancedStaffCard({
    Key? key,
    required this.name,
    required this.role,
    required this.phone,
    required this.roleIcon,
    required this.onMorePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF6A11CB).withOpacity(0.1),
              radius: 28,
              child: Icon(
                roleIcon,
                size: 24,
                color: const Color(0xFF6A11CB),
              ),
            ),
            const SizedBox(width: 16),
            // Staff Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phone,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  // const SizedBox(height: 8),
                  const Divider(),
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // More Options Icon
            IconButton(
              onPressed: onMorePressed,
              icon: const Icon(Icons.more_vert, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
