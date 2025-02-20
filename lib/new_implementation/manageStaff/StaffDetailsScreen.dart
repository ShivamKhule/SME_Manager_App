import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firebase Firestore

class StaffDetailsScreen extends StatefulWidget {
  final String name;
  final String role;
  final String phone;
  final String staffId; // Add staffId to identify document in Firestore

  const StaffDetailsScreen({
    Key? key,
    required this.name,
    required this.role,
    required this.phone,
    required this.staffId,
  }) : super(key: key);

  @override
  State<StaffDetailsScreen> createState() => _StaffDetailsScreenState();
}

class _StaffDetailsScreenState extends State<StaffDetailsScreen> {
  double salary = 0.0;
  double paidAmount = 0.0;
  List<Map<String, dynamic>> paymentHistory = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _roleController.text = widget.role;
    _phoneController.text = widget.phone;
    _loadStaffData();
  }

  Future<void> _loadStaffData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('staff')
        .doc(widget.staffId)
        .get();
    if (doc.exists) {
      setState(() {
        salary = (doc['salary'] ?? 0.0).toDouble();
        paidAmount = (doc['paidAmount'] ?? 0.0).toDouble();
        paymentHistory = List<Map<String, dynamic>>.from(doc['paymentHistory'] ?? []);
      });
    }
  }

  Future<void> _deleteStaff() async {
    await FirebaseFirestore.instance
        .collection('staff')
        .doc(widget.staffId)
        .delete();
    Navigator.pop(context);
  }

  Future<void> _updateSalary(String value) async {
    double newSalary = double.parse(value);
    await FirebaseFirestore.instance
        .collection('staff')
        .doc(widget.staffId)
        .update({'salary': newSalary});
    setState(() => salary = newSalary);
  }

  Future<void> _editProfile() async {
    await FirebaseFirestore.instance
        .collection('staff')
        .doc(widget.staffId)
        .update({
      'name': _nameController.text,
      'role': _roleController.text,
      'phone': _phoneController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: const Text('Are you sure you want to delete this staff member?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        _deleteStaff();
                        Navigator.pop(context);
                      },
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.blue[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Text(
                      widget.name[0],
                      style: const TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.role,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.phone,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            _buildModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Salary Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => _buildEditProfileDialog(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Edit Profile'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildInfoRow('Total Salary', '\₹ ${salary.toStringAsFixed(2)}'),
                  _buildInfoRow('Paid', '\₹ ${paidAmount.toStringAsFixed(2)}'),
                  _buildInfoRow(
                    'Pending',
                    '\₹ ${((salary - paidAmount) > 0 ? (salary - paidAmount) : 0).toStringAsFixed(2)}',
                    color: Colors.red[400]!,
                  ),
                  const SizedBox(height: 20),
                  _buildModernTextField(
                    label: 'Update Salary',
                    onSubmitted: _updateSalary,
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      // Add your salary update logic here if needed
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Update'),
                  ),
                  const SizedBox(height: 15),
                  _buildModernTextField(
                    label: 'Add Payment',
                    onSubmitted: (value) {
                      setState(() {
                        double payment = double.parse(value);
                        paidAmount += payment;
                        paymentHistory.add({
                          'date': DateTime.now(),
                          'amount': payment,
                        });
                        FirebaseFirestore.instance
                            .collection('staff')
                            .doc(widget.staffId)
                            .update({
                          'paidAmount': paidAmount,
                          'paymentHistory': paymentHistory,
                        });
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            _buildModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  paymentHistory.isEmpty
                      ? const Center(
                          child: Text(
                            'No payments recorded',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: paymentHistory.length,
                          itemBuilder: (context, index) {
                            final payment = paymentHistory[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                '\₹ ${payment['amount'].toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                DateFormat('MMM dd, yyyy').format(payment['date']),
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              trailing: Icon(
                                Icons.check_circle,
                                color: Colors.green[400],
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditProfileDialog() {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _roleController,
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _editProfile();
            Navigator.pop(context);
            setState(() {});
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildModernCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInfoRow(String label, String value, {Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required String label,
    required Function(String) onSubmitted,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      ),
      keyboardType: TextInputType.number,
      onFieldSubmitted: onSubmitted,
    );
  }
}