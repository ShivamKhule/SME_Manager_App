import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_connect/controller/LoginDetails.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary/cloudinary.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../db_helper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileUpdatePage extends StatefulWidget {
  @override
  _ProfileUpdatePageState createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final picker = ImagePicker();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController gstinController = TextEditingController();
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
      selectedDistrict = "",
      profileImageUrl = "";

  Map<String, List<String>> stateDistricts = {
    "Maharashtra": [
      "Mumbai",
      "Pune",
      "Nagpur",
      "Nashik",
      "Thane",
      "Aurangabad",
      "Solapur",
      "Amravati",
      "Kolhapur",
      "Nanded",
      "Sangli",
      "Jalgaon",
      "Akola",
      "Latur",
      "Dhule",
      "Ahmednagar",
      "Chandrapur",
      "Parbhani",
      "Jalna",
      "Bhiwandi",
      "Ratnagiri",
      "Satara",
      "Beed",
      "Wardha",
      "Yavatmal",
      "Osmanabad",
      "Gondia",
      "Hingoli",
      "Washim"
    ],
    "Karnataka": ["Bangalore", "Mysore", "Mangalore"],
    "Gujarat": ["Ahmedabad", "Surat", "Vadodara"],
  };

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
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 12,
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
                    const SizedBox(
                      height: 10,
                    ),
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
                            padding: const EdgeInsets.symmetric(
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
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            )));
  }

  InputDecoration _dropdownStyle(String label) {
    return InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 16, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple.shade100, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ));
  }

  // Future<String?> _uploadImageToFirebase(File imageFile) async {
  // try {
  //   String fileName =
  //       "profile_images/${Provider.of<Logindetails>(context, listen: false).userEmail}.jpg";
  //   Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
  //   UploadTask uploadTask = storageRef.putFile(imageFile);
  //   TaskSnapshot snapshot = await uploadTask;
  //   return await snapshot.ref.getDownloadURL();
  // } catch (e) {
  //   return null;
  // }
  // }

  File? _imageFile;
  dynamic _uploadedImageUrl;
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      await _uploadImage(File(pickedFile.path));
    }
  }

  // Function to upload image to Cloudinary
  Future<void> _uploadImage(File imageFile) async {
    const String cloudinaryUrl =
        "https://api.cloudinary.com/v1_1/dijjftmm8/image/upload";
    const String uploadPreset = "sme_manager"; // Securely store this

    try {
      var request = http.MultipartRequest("POST", Uri.parse(cloudinaryUrl));
      request.fields['upload_preset'] = uploadPreset;
      request.files
          .add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);

        setState(() {
          _uploadedImageUrl = jsonResponse['secure_url'];
        });

        log("Uploaded Image URL: $_uploadedImageUrl");
      } else {
        log("Failed to upload image: ${response.statusCode}");
      }
    } catch (e) {
      log("Cloudinary Upload Error: $e");
    }
  }

  Future<void> _saveDataToFirestore() async {
    try {
      Map<String, dynamic> profileData = {
        'company_name': companyNameController.text,
        'owner_name': ownerNameController.text,
        'gstin': gstinController.text,
        'email': Provider.of<Logindetails>(context, listen: false).userEmail,
        'mobile': mobileController.text,
        'address': addressController.text,
        'business_domain': businessDomainController.text,
        'address_line1': addressLine1,
        'address_line2': addressLine2,
        'landmark': landmark,
        'city': city,
        'district': selectedDistrict,
        'state': selectedState,
        'pincode': pincode,
        'profile_image': _uploadedImageUrl,
      };

      // Save to Firebase
      await FirebaseFirestore.instance
          .collection('users')
          .doc(Provider.of<Logindetails>(context, listen: false).userEmail)
          .set(profileData);
      await DBHelper().updateProfile(profileData);

      if (_uploadedImageUrl == null) {
        log("Uploaded image problem");
      }

      Provider.of<Logindetails>(context, listen: false).setUserDetails(
          companyNameController.text,
          ownerNameController.text,
          addressController.text,
          mobileController.text,
          gstinController.text,
          _uploadedImageUrl,
          businessDomainController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
      Navigator.of(context).pushReplacementNamed("/home");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
      print("Error: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    companyNameController.clear();
    ownerNameController.clear();
    gstinController.clear();
    mobileController.clear();
    businessDomainController.clear();
    addressController.clear();
  }

  Future<void> _loadProfileData() async {
    String userEmail =
        Provider.of<Logindetails>(context, listen: false).userEmail;
    // Fetch from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .get();

    if (userDoc.exists) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      setState(() {
        companyNameController.text = data['company_name'] ?? "";
        ownerNameController.text = data['owner_name'] ?? "";
        gstinController.text = data['gstin'] ?? "";
        mobileController.text = data['mobile'] ?? "";
        businessDomainController.text = data['business_domain'] ?? "";
        addressController.text = data['address'] ?? "";
        addressLine1 = data['address_line1'] ?? "";
        addressLine2 = data['address_line2'] ?? "";
        landmark = data['landmark'] ?? "";
        city = data['city'] ?? "";
        selectedDistrict = data['district'] ?? "";
        selectedState = data['state'] ?? "";
        pincode = data['pincode'] ?? "";
        profileImageUrl = data['profile_image'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Profile',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
              child: Column(children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                decoration:
                    const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    spreadRadius: 2,
                    offset: Offset(0, 3),
                  )
                ]),
                child: CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.grey[300],
                  // backgroundImage:
                  //     _image != null ? FileImage(_image!) : null,
                  // backgroundImage: _uploadedImageUrl != null
                  //     ? NetworkImage(_uploadedImageUrl!)
                  //     : _imageFile != null
                  //         ? FileImage(_imageFile!) as ImageProvider
                  //         : null,
                  // child: _imageFile == null
                  //     ? Icon(Icons.camera_alt,
                  //         color: Colors.grey[700], size: 40)
                  //     : null,
                  backgroundImage: _uploadedImageUrl != null
                      ? NetworkImage(
                          _uploadedImageUrl!) // Show new uploaded image URL first
                      : profileImageUrl != null && profileImageUrl.isNotEmpty
                          ? NetworkImage(
                              profileImageUrl) // Then show existing profile image URL
                          : _imageFile != null
                              ? FileImage(_imageFile!)
                                  as ImageProvider // Then show newly selected image
                              : null, // No image if all are null
                  child: _uploadedImageUrl == null &&
                          profileImageUrl == null &&
                          _imageFile == null
                      ? Icon(
                          Icons.camera_alt,
                          color: Colors.grey[700],
                          size: 40,
                        )
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
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 5),
                      )
                    ]),
                child: Column(children: [
                  _buildTextField(
                      "Company Name", companyNameController, Icons.business),
                  _buildTextField(
                      "Owner Name", ownerNameController, Icons.person),
                  _buildTextField(
                      "GSTIN", gstinController, Icons.confirmation_number),
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
                              ))))
                ])),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveDataToFirestore();
                setState(() {});
              },
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
            )
          ]))),
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
                labelStyle: const TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: Icon(icon, color: Colors.deepPurple),
                filled: true,
                fillColor: Colors
                    .white, // Lightened background color for better contrast
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 12), // Improved padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: Colors.deepPurple.shade200,
                      width: 1), // Lighter border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Colors.deepPurple,
                      width: 2), // Highlight border on focus
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: Colors.deepPurple.shade100,
                      width: 1), // Default border
                ))));
  }
}
