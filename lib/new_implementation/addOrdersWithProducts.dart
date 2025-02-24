import 'package:firebase_connect/controller/LoginDetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddOrderWithProductsScreen extends StatefulWidget {
  final String ownerId;

  AddOrderWithProductsScreen({required this.ownerId});

  @override
  _AddOrderWithProductsScreenState createState() =>
      _AddOrderWithProductsScreenState();
}

class _AddOrderWithProductsScreenState
    extends State<AddOrderWithProductsScreen> {
  final TextEditingController _orderIdController = TextEditingController();
  final TextEditingController _orderDateController = TextEditingController();
  List<Map<String, dynamic>> products = [];

  void addProduct(String name, double price, int quantity) {
    setState(() {
      products.add({'name': name, 'price': price, 'quantity': quantity});
    });
  }

  void removeProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  // void saveOrderWithProducts() async {
  //   final orderId = _orderIdController.text.trim();
  //   final orderDate = _orderDateController.text.trim();

  //   if (orderId.isNotEmpty && orderDate.isNotEmpty && products.isNotEmpty) {
  //     final orderRef = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(Provider.of<Logindetails>(context, listen: false).userEmail)
  //         .collection('sales')
  //         .doc(widget.ownerId)
  //         .collection('orders')
  //         .doc(orderId);

  //     try {
  //       await orderRef.set({
  //         'orderDate': orderDate,
  //         'totalProducts': products.length,
  //       });

  //       for (var product in products) {
  //         await orderRef.collection('products').add(product);
  //       }

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content: Text('Order and products added successfully!')),
  //       );

  //       setState(() {
  //         _orderIdController.clear();
  //         _orderDateController.clear();
  //         products.clear();
  //       });

  //       Navigator.pop(context);
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Failed to save order or products')),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //           content:
  //               Text('Please fill all fields and add at least one product')),
  //     );
  //   }
  // }
  void saveOrderWithProducts() async {
    final orderId = _orderIdController.text.trim();
    final orderDate = _orderDateController.text.trim();

    if (orderId.isNotEmpty && orderDate.isNotEmpty && products.isNotEmpty) {
      final userEmail =
          Provider.of<Logindetails>(context, listen: false).userEmail;
      final orderRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('sales')
          .doc(widget.ownerId)
          .collection('orders')
          .doc(orderId);

      // Reference to a specific document in the sales collection to store salesAmt
      final salesAmtRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('sales')
          .doc('salesData'); // Using a fixed document ID 'salesData'

      try {
        // Calculate total amount from products
        double orderTotal = 0;
        for (var product in products) {
          orderTotal += product['price'] * product['quantity'];
        }

        // Use a transaction to update both order and salesAmt atomically
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          // Get current salesAmt from the sales document
          final salesDoc = await transaction.get(salesAmtRef);

          // Get existing salesAmt or default to 0 if it doesn't exist
          double currentSalesAmt = 0;
          if (salesDoc.exists) {
            currentSalesAmt = (salesDoc.data()?['salesAmt'] ?? 0).toDouble();
          }

          // Save the order details
          transaction.set(orderRef, {
            'orderDate': orderDate,
            'totalProducts': products.length,
            'orderTotal': orderTotal,
          });

          // Update or set salesAmt in the sales document
          transaction.set(
              salesAmtRef,
              {
                'salesAmt': currentSalesAmt + orderTotal,
              },
              SetOptions(
                  merge:
                      true)); // Using merge to update existing doc or create if doesn't exist

          // Add products to subcollection
          for (var product in products) {
            await orderRef.collection('products').add(product);
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Order and sales amount updated successfully!')),
        );

        setState(() {
          _orderIdController.clear();
          _orderDateController.clear();
          products.clear();
        });

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save order: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please fill all fields and add at least one product')),
      );
    }
  }

  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add Order with Products',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Order Details Section in Card
            Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextField(
                      controller: _orderIdController,
                      focusNode: _searchFocusNode,
                      onChanged: (value) {
                        setState(() {});
                      },
                      // enabled: true, // Allow editing when necessary
                      decoration: InputDecoration(
                        labelText: 'Order ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Colors.blueAccent, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _orderDateController
                        ..text =
                            DateFormat('dd/MM/yyyy').format(DateTime.now()),
                      enabled: false, // Disable editing
                      decoration: InputDecoration(
                        labelText: 'Order Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Colors.blueAccent, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Product and Save Buttons
            Row(
              children: [
                // Add Product Button
                ElevatedButton.icon(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AddProductDialog(
                      onAddProduct: addProduct,
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 28, color: Colors.white),
                  label: const Text(
                    'Add Product',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 22),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50), // Adjust size if needed
                    backgroundColor: Colors.blueAccent,
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(width: 20), // Space between buttons

                // Save Order Button
                ElevatedButton(
                  onPressed: saveOrderWithProducts,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50), // Adjust size if needed
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Save Order',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 22),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),

            // Products Section with Horizontal Scrollable Table in Card
            Expanded(
              flex: 0,
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Added Products:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      if (products.isNotEmpty)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Sr No.')),
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Price')),
                              DataColumn(label: Text('Quantity')),
                              DataColumn(label: Text('Action')),
                            ],
                            rows: products.asMap().entries.map((entry) {
                              int index = entry.key;
                              Map<String, dynamic> product = entry.value;
                              return DataRow(cells: [
                                DataCell(Text('${index + 1}')), // Sr No.
                                DataCell(Text(product['name'])),
                                DataCell(Text('\₹ ${product['price']}')),
                                DataCell(Text('${product['quantity']}')),
                                DataCell(IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => removeProduct(index),
                                )),
                              ]);
                            }).toList(),
                          ),
                        ),
                      if (products.isEmpty)
                        const Text('No products added yet',
                            style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class AddProductDialog extends StatefulWidget {
  final Function(String, double, int) onAddProduct;

  AddProductDialog({required this.onAddProduct});

  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productQuantityController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Add Product',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _productNameController,
                    label: 'Product Name',
                    hint: 'Enter product name',
                    icon: Icons.shopping_cart,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Product name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _productPriceController,
                    label: 'Product Price',
                    hint: 'Enter product price',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          double.tryParse(value.trim()) == null) {
                        return 'Enter a valid price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _productQuantityController,
                    label: 'Product Quantity',
                    hint: 'Enter quantity',
                    icon: Icons.production_quantity_limits,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || int.tryParse(value.trim()) == null) {
                        return 'Enter a valid quantity';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final name = _productNameController.text.trim();
                      final price =
                          double.parse(_productPriceController.text.trim());
                      final quantity =
                          int.parse(_productQuantityController.text.trim());

                      widget.onAddProduct(name, price, quantity);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}




// import 'package:firebase_connect/controller/LoginDetails.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class AddOrderWithProductsScreen extends StatefulWidget {
//   final String ownerId;

//   AddOrderWithProductsScreen({required this.ownerId});

//   @override
//   _AddOrderWithProductsScreenState createState() =>
//       _AddOrderWithProductsScreenState();
// }

// class _AddOrderWithProductsScreenState
//     extends State<AddOrderWithProductsScreen> {
//   final TextEditingController _orderIdController = TextEditingController();
//   final TextEditingController _orderDateController = TextEditingController();
//   List<Map<String, dynamic>> products = [];

//   void addProduct(String name, double price, int quantity) {
//     setState(() {
//       products.add({'name': name, 'price': price, 'quantity': quantity});
//     });
//   }

//   void removeProduct(int index) {
//     setState(() {
//       products.removeAt(index);
//     });
//   }

//   void saveOrderWithProducts() async {
//     final orderId = _orderIdController.text.trim();
//     final orderDate = _orderDateController.text.trim();

//     if (orderId.isNotEmpty && orderDate.isNotEmpty && products.isNotEmpty) {
//       final orderRef = FirebaseFirestore.instance
//           .collection('users')
//           .doc(Provider.of<Logindetails>(context, listen: false).userEmail)
//           .collection('sales')
//           .doc(widget.ownerId)
//           .collection('orders')
//           .doc(orderId);

//       try {
//         await orderRef.set({
//           'orderDate': orderDate,
//           'totalProducts': products.length,
//         });

//         for (var product in products) {
//           await orderRef.collection('products').add(product);
//         }

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text('Order and products added successfully!')),
//         );

//         setState(() {
//           _orderIdController.clear();
//           _orderDateController.clear();
//           products.clear();
//         });

//         Navigator.pop(context);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to save order or products')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content:
//                 Text('Please fill all fields and add at least one product')),
//       );
//     }
//   }

//   final FocusNode _searchFocusNode = FocusNode();

//   @override
//   void dispose() {
//     _searchFocusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('Add Order with Products', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 23),),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Order Details Section in Card
//             Card(
//               elevation: 5.0,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Order Details',
//                       style: TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(
//                       height: 6,
//                     ),
//                     TextField(
//                       controller: _orderIdController,
//                       focusNode: _searchFocusNode,
//                       onChanged: (value) {
//                         setState(() {});
//                       },
//                       // enabled: true, // Allow editing when necessary
//                       decoration: InputDecoration(
//                         labelText: 'Order Name',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: const BorderSide(
//                               color: Colors.blueAccent, width: 1.5),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     TextField(
//                       controller: _orderDateController
//                         ..text =
//                             DateFormat('dd/MM/yyyy').format(DateTime.now()),
//                       enabled: false, // Disable editing
//                       decoration: InputDecoration(
//                         labelText: 'Order Date',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: const BorderSide(
//                               color: Colors.blueAccent, width: 1.5),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
        
//             // Product and Save Buttons
//             Row(
//               children: [
//                 // Add Product Button
//                 ElevatedButton.icon(
//                   onPressed: () => showDialog(
//                     context: context,
//                     builder: (context) => AddProductDialog(
//                       onAddProduct: addProduct,
//                     ),
//                   ),
//                   icon: const Icon(Icons.add, size: 28, color: Colors.white),
//                   label: const Text(
//                     'Add Product',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 22),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size(150, 50), // Adjust size if needed
//                     backgroundColor: Colors.blueAccent,
//                     textStyle: const TextStyle(fontSize: 16),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8)),
//                   ),
//                 ),
//                 const SizedBox(width: 20), // Space between buttons
        
//                 // Save Order Button
//                 ElevatedButton(
//                   onPressed: saveOrderWithProducts,
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size(150, 50), // Adjust size if needed
//                     backgroundColor: Colors.green,
//                     textStyle: const TextStyle(fontSize: 16),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8)),
//                   ),
//                   child: const Text(
//                     'Save Order',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 22),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 10,
//             ),
        
//             // Products Section with Horizontal Scrollable Table in Card
//             Expanded(
//               flex: 0,
//               child: Card(
//                 elevation: 5.0,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(4.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Text('Added Products:',
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold)),
//                       ),
//                       if (products.isNotEmpty)
//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: DataTable(
//                             columns: const [
//                               DataColumn(label: Text('Sr No.')),
//                               DataColumn(label: Text('Name')),
//                               DataColumn(label: Text('Price')),
//                               DataColumn(label: Text('Quantity')),
//                               DataColumn(label: Text('Action')),
//                             ],
//                             rows: products.asMap().entries.map((entry) {
//                               int index = entry.key;
//                               Map<String, dynamic> product = entry.value;
//                               return DataRow(cells: [
//                                 DataCell(Text('${index + 1}')), // Sr No.
//                                 DataCell(Text(product['name'])),
//                                 DataCell(Text('\₹ ${product['price']}')),
//                                 DataCell(Text('${product['quantity']}')),
//                                 DataCell(IconButton(
//                                   icon: const Icon(Icons.delete,
//                                       color: Colors.red),
//                                   onPressed: () => removeProduct(index),
//                                 )),
//                               ]);
//                             }).toList(),
//                           ),
//                         ),
//                       if (products.isEmpty)
//                         const Text('No products added yet',
//                             style: TextStyle(color: Colors.grey)),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),     
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AddProductDialog extends StatefulWidget {
//   final Function(String, double, int) onAddProduct;

//   AddProductDialog({required this.onAddProduct});

//   @override
//   _AddProductDialogState createState() => _AddProductDialogState();
// }

// class _AddProductDialogState extends State<AddProductDialog> {
//   final TextEditingController _productNameController = TextEditingController();
//   final TextEditingController _productPriceController = TextEditingController();
//   final TextEditingController _productQuantityController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 5,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Center(
//               child: Text(
//                 'Add Product',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blueAccent,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   _buildTextField(
//                     controller: _productNameController,
//                     label: 'Product Name',
//                     hint: 'Enter product name',
//                     icon: Icons.shopping_cart,
//                     validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return 'Product name is required';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 15),
//                   _buildTextField(
//                     controller: _productPriceController,
//                     label: 'Product Price',
//                     hint: 'Enter product price',
//                     icon: Icons.attach_money,
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || double.tryParse(value.trim()) == null) {
//                         return 'Enter a valid price';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 15),
//                   _buildTextField(
//                     controller: _productQuantityController,
//                     label: 'Product Quantity',
//                     hint: 'Enter quantity',
//                     icon: Icons.production_quantity_limits,
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || int.tryParse(value.trim()) == null) {
//                         return 'Enter a valid quantity';
//                       }
//                       return null;
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   style: TextButton.styleFrom(
//                     foregroundColor: Colors.grey.shade700,
//                     textStyle: const TextStyle(fontSize: 16),
//                   ),
//                   child: const Text('Cancel', style: TextStyle(color: Colors.red, fontSize: 18),),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState?.validate() ?? false) {
//                       final name = _productNameController.text.trim();
//                       final price = double.parse(_productPriceController.text.trim());
//                       final quantity = int.parse(_productQuantityController.text.trim());

//                       widget.onAddProduct(name, price, quantity);
//                       Navigator.pop(context);
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blueAccent,
//                     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   child: const Text('Add', style: TextStyle(color: Colors.white, fontSize: 20),),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//     required String? Function(String?) validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hint,
//         prefixIcon: Icon(icon, color: Colors.blueAccent),
//         filled: true,
//         fillColor: Colors.grey.shade100,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
//         ),
//       ),
//       validator: validator,
//     );
//   }
// }
