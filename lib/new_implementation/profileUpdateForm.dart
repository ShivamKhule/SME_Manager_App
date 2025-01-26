import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileUpdatePage extends StatefulWidget {
  @override
  _ProfileUpdatePageState createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  File? _image;
  final picker = ImagePicker();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController gstinController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController businessDomainController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Address Fields
  String addressLine1 = "",
      addressLine2 = "",
      landmark = "",
      city = "",
      pincode = "",
      selectedState = "",
      selectedDistrict = "";

  Map<String, List<String>> stateDistricts = {
    "Maharashtra": ["Mumbai", "Pune", "Nagpur", "Nashik"],
    "Karnataka": ["Bangalore", "Mysore", "Mangalore"],
    "Gujarat": ["Ahmedabad", "Surat", "Vadodara"],
  };

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  /*void _openAddressDialog() {
    TextEditingController address1Controller =
        TextEditingController(text: addressLine1);
    TextEditingController address2Controller =
        TextEditingController(text: addressLine2);
    TextEditingController landmarkController =
        TextEditingController(text: landmark);
    TextEditingController cityController = TextEditingController(text: city);
    TextEditingController pincodeController =
        TextEditingController(text: pincode);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Enter Address",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildPopupTextField("Address Line 1", address1Controller),
                    _buildPopupTextField("Address Line 2", address2Controller),
                    _buildPopupTextField("Landmark", landmarkController),
                    _buildPopupTextField("City", cityController),
                    _buildPopupTextField("Pincode", pincodeController),
                    DropdownButtonFormField<String>(
                      value: selectedState.isEmpty ? null : selectedState,
                      decoration: _dropdownStyle("Select State"),
                      items: stateDistricts.keys.map((state) {
                        return DropdownMenuItem(
                            value: state, child: Text(state));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedState = value!;
                          selectedDistrict = "";
                        });
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedDistrict.isEmpty ? null : selectedDistrict,
                      decoration: _dropdownStyle("Select District"),
                      items: selectedState.isNotEmpty
                          ? stateDistricts[selectedState]!.map((district) {
                              return DropdownMenuItem(
                                  value: district, child: Text(district));
                            }).toList()
                          : [],
                      onChanged: (value) {
                        setState(() {
                          selectedDistrict = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: const Text("Cancel",
                              style: TextStyle(color: Colors.red)),
                          onPressed: () => Navigator.pop(context),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo),
                          child: const Text("Save",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            setState(() {
                              addressLine1 = address1Controller.text;
                              addressLine2 = address2Controller.text;
                              landmark = landmarkController.text;
                              city = cityController.text;
                              pincode = pincodeController.text;
                              addressController.text =
                                  "$addressLine1, $addressLine2, $landmark, $city, $selectedDistrict, $selectedState - $pincode";
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
*/
  void _openAddressDialog() {
    TextEditingController address1Controller =
        TextEditingController(text: addressLine1);
    TextEditingController address2Controller =
        TextEditingController(text: addressLine2);
    TextEditingController landmarkController =
        TextEditingController(text: landmark);
    TextEditingController cityController = TextEditingController(text: city);
    TextEditingController pincodeController =
        TextEditingController(text: pincode);

    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents closing the dialog by tapping outside
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation:
                12, // Adds shadow to the dialog for a more elevated effect
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Enter Address",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildPopupTextField("Address Line 1", address1Controller),
                    _buildPopupTextField("Address Line 2", address2Controller),
                    _buildPopupTextField("Landmark", landmarkController),
                    _buildPopupTextField("City", cityController),
                    _buildPopupTextField("Pincode", pincodeController),

                    // State Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedState.isEmpty ? null : selectedState,
                      decoration: _dropdownStyle("Select State"),
                      items: stateDistricts.keys.map((state) {
                        return DropdownMenuItem(
                          value: state,
                          child: Text(state),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedState = value!;
                          selectedDistrict = "";
                        });
                      },
                    ),
  const SizedBox(height: 10,),
                    // District Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedDistrict.isEmpty ? null : selectedDistrict,
                      decoration: _dropdownStyle("Select District"),
                      items: selectedState.isNotEmpty
                          ? stateDistricts[selectedState]!.map((district) {
                              return DropdownMenuItem(
                                value: district,
                                child: Text(district),
                              );
                            }).toList()
                          : [],
                      onChanged: (value) {
                        setState(() {
                          selectedDistrict = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              addressLine1 = address1Controller.text;
                              addressLine2 = address2Controller.text;
                              landmark = landmarkController.text;
                              city = cityController.text;
                              pincode = pincodeController.text;
                              addressController.text =
                                  "$addressLine1, $addressLine2, $landmark, $city, $selectedDistrict, $selectedState - $pincode";
                            });
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(fontSize: 21, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildPopupTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  // _dropdownStyle enhancement for uniformity
  InputDecoration _dropdownStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontSize: 16, color: Colors.deepPurple),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.deepPurple.shade100, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.deepPurple, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        // flexibleSpace: Container(
        //   decoration: const BoxDecoration(
        //     gradient:
        //         LinearGradient(colors: [Colors.deepPurple, Colors.indigo]),
        //   ),
        // ),
        backgroundColor: Colors.blue,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        spreadRadius: 2,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 65,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(Icons.camera_alt,
                            color: Colors.grey[700], size: 40)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTextField(
                        "Company Name", companyNameController, Icons.business),
                    _buildTextField(
                        "Owner Name", ownerNameController, Icons.person),
                    _buildTextField(
                        "GSTIN", gstinController, Icons.confirmation_number),
                    _buildTextField("Email ID", emailController, Icons.email),
                    _buildTextField("Mobile", mobileController, Icons.phone),
                    _buildTextField("Business Domain", businessDomainController,
                        Icons.domain),
                    GestureDetector(
                      onTap: _openAddressDialog,
                      child: AbsorbPointer(
                        child: TextField(
                          controller: addressController,
                          decoration: InputDecoration(
                            labelText: "Address",
                            hintText: "Click to enter address",
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: const Icon(Icons.location_on,
                                color: Colors.deepPurple),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text("Save Details",
                    style: TextStyle(fontSize: 21, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 16.0), // Increased space for clarity
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          filled: true,
          fillColor:
              Colors.white, // Lightened background color for better contrast
          contentPadding: EdgeInsets.symmetric(
              vertical: 14, horizontal: 12), // Improved padding
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: Colors.deepPurple.shade200,
                width: 1), // Lighter border color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: Colors.deepPurple,
                width: 2), // Highlight border on focus
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: Colors.deepPurple.shade100, width: 1), // Default border
          ),
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
