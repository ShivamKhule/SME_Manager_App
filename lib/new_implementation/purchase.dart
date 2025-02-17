import 'package:firebase_connect/controller/LoginDetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'orders.dart';

class PurchaseScreen extends StatefulWidget {
  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  String searchQuery = "";
  final FocusNode _searchFocusNode = FocusNode();

  final TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

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
      ),
    );
  }

  void openAddressDialog(
      BuildContext context, TextEditingController addressController) {
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
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

                    /// **State Dropdown**
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
                    const SizedBox(height: 10),

                    /// **District Dropdown**
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

                    /// **Action Buttons**
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

  void showAddSalesOwnerBottomSheet(BuildContext context) {
    final TextEditingController supplierNameController = TextEditingController();
    final TextEditingController gstinController = TextEditingController();
    final TextEditingController mobileController = TextEditingController();
    final TextEditingController businessDomainController =
        TextEditingController();
    final TextEditingController addressController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add Supplier',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 10),
                _buildTextField(
                    "Supplier Name", supplierNameController, Icons.person),
                _buildTextField(
                    "GSTIN", gstinController, Icons.confirmation_number),
                _buildTextField("Mobile", mobileController, Icons.phone),
                _buildTextField(
                    "Business Domain", businessDomainController, Icons.domain),
                GestureDetector(
                  onTap: () => openAddressDialog(context, addressController),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: "Address",
                        hintText: "Tap to enter address",
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
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    final supplierName = supplierNameController.text.trim();
                    if (supplierName.isNotEmpty) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(Provider.of<Logindetails>(context, listen: false)
                              .userEmail)
                          .collection('purchase')
                          .doc(supplierName)
                          .set({
                        'supplierName': supplierName,
                        'gstin': gstinController.text.trim(),
                        'mobile': mobileController.text.trim(),
                        'businessDomain': businessDomainController.text.trim(),
                        'wholeaddress': addressController.text.trim(),
                      });

                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Add Supplier',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Purchase',
          style: TextStyle(
              // fontFamily: 'Quicksand',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: TextField(
              focusNode: _searchFocusNode,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search Supplier...',
                hintStyle: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 16,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(
                      'users/${Provider.of<Logindetails>(context).userEmail}/purchase')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueAccent,
                    ),
                  );
                }
                final data = snapshot.data!.docs.where((doc) {
                  return doc.id.toLowerCase().contains(searchQuery);
                }).toList();

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          data[index].id,
                          style: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.blueAccent,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrdersScreen(
                                collectionPath:
                                    'users/${Provider.of<Logindetails>(context).userEmail}/purchase/${data[index].id}/orders',
                                ownerId: data[index].id,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showAddSalesOwnerDialog(context);
          showAddSalesOwnerBottomSheet(context);
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          prefixIcon: Icon(icon, color: Colors.blueAccent),
        ),
      ),
    );
  }
}
