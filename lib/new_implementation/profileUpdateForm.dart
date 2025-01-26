import 'package:flutter/material.dart';

class ProfileUpdatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Information'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Owner Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _buildTextField("Company Name", "e.g., ABC Pvt. Ltd."),
                _buildTextField("Owner Name", "e.g., Rajesh Kumar"),
                _buildTextField("GSTIN", "e.g., 22AAAAA0000A1Z5"),
                _buildTextField("Email ID", "e.g., example@business.com"),
                _buildTextField("Mobile", "e.g., +91 9876543210"),
                _buildTextField("Address", "e.g., 123, Business Street, Mumbai"),
                _buildTextField("Business Domain", "e.g., Retail, Finance, Manufacturing"),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Center(child: Text("Save Details", style: TextStyle(fontSize: 16))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}





// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class ProfileUpdatePage extends StatefulWidget {
//   @override
//   _ProfileUpdatePageState createState() => _ProfileUpdatePageState();
// }

// class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
//   File? _image;
//   final _formKey = GlobalKey<FormState>();
//   final ImagePicker _picker = ImagePicker();

//   // Form fields controllers
//   final TextEditingController ownerController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController companyController = TextEditingController();
//   final TextEditingController gstinController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();

//   // Pick Image
//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueGrey.shade200,
//       appBar: AppBar(
//         title: const Text("Update Profile"),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Column(
//           children: [
//             // Profile Image Uploader with Shadow Effect
//             Center(
//               child: Stack(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.5),
//                           blurRadius: 10,
//                           spreadRadius: 3,
//                         ),
//                       ],
//                     ),
//                     child: CircleAvatar(
//                       radius: 65,
//                       backgroundColor: Colors.blueGrey.shade800,
//                       backgroundImage:
//                           _image != null ? FileImage(_image!) : null,
//                       child: _image == null
//                           ? const Icon(Icons.person,
//                               size: 70, color: Colors.white)
//                           : null,
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 10,
//                     child: GestureDetector(
//                       onTap: _pickImage,
//                       child: Container(
//                         decoration: const BoxDecoration(
//                           color: Colors.blueAccent,
//                           shape: BoxShape.circle,
//                         ),
//                         padding: const EdgeInsets.all(8),
//                         child: const Icon(Icons.camera_alt,
//                             color: Colors.white, size: 22),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Glassmorphism Form Card
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.blueGrey.shade500.withOpacity(0.6),
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.blueAccent.withOpacity(0.5),
//                     blurRadius: 10,
//                     spreadRadius: 3,
//                   ),
//                 ],
//               ),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     _buildTextField(ownerController, "Owner Name"),
//                     // _buildTextField(nameController, "Full Name"),
//                     _buildTextField(companyController, "Company Name"),
//                     _buildTextField(gstinController, "GSTIN Number"),
//                     _buildTextField(addressController, "Full Address",
//                         maxLines: 4),
//                     _buildTextField(emailController, "Email ID",
//                         keyboardType: TextInputType.emailAddress),
//                     _buildTextField(mobileController, "Mobile Number",
//                         keyboardType: TextInputType.phone),
//                     const SizedBox(height: 10),
//                     Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 30, vertical: 10),
//                         decoration: BoxDecoration(
//                           color: Colors.blueAccent.shade200,
//                           borderRadius: BorderRadius.circular(10),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.blueAccent.withOpacity(0.5),
//                               blurRadius: 10,
//                               spreadRadius: 4,
//                             ),
//                           ],
//                         ),
//                         child: const Text("Update",style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 40),
//           ],
//         ),
//       ),

//       // Floating Save Button
//       // floatingActionButton: FloatingActionButton.extended(
//       //   onPressed: () {
//       //     if (_formKey.currentState!.validate()) {
//       //       ScaffoldMessenger.of(context).showSnackBar(
//       //         const SnackBar(content: Text("Profile Updated Successfully!")),
//       //       );
//       //     }
//       //   },
//       //   backgroundColor: Colors.blueAccent,
//       //   label: const Text("Save Profile", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//       //   icon: const Icon(Icons.save),
//       // ),
//       // floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
//     );
//   }

//   // Custom Styled TextField
//   Widget _buildTextField(
//     TextEditingController controller,
//     String label, {
//     TextInputType keyboardType = TextInputType.text,
//     int maxLines = 1,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         maxLines: maxLines,
//         style: const TextStyle(color: Colors.white),
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: const TextStyle(color: Colors.white70),
//           filled: true,
//           fillColor: Colors.blueGrey.shade700.withOpacity(0.6),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           prefixIcon: const Icon(Icons.edit, color: Colors.white70),
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return "$label is required";
//           }
//           if (label == "Email ID" &&
//               !RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(value)) {
//             return "Enter a valid email";
//           }
//           if (label == "Mobile Number" &&
//               !RegExp(r"^[6-9]\d{9}$").hasMatch(value)) {
//             return "Enter a valid mobile number";
//           }
//           if (label == "GSTIN Number" &&
//               !RegExp(r"^[0-9A-Z]{15}$").hasMatch(value)) {
//             return "Enter a valid GSTIN";
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }
