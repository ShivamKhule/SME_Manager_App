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

  void saveOrderWithProducts() async {
    final orderId = _orderIdController.text.trim();
    final orderDate = _orderDateController.text.trim();

    if (orderId.isNotEmpty && orderDate.isNotEmpty && products.isNotEmpty) {
      final orderRef = FirebaseFirestore.instance
          .collection('users')
          .doc(Provider.of<Logindetails>(context, listen: false).userEmail)
          .collection('sales')
          .doc(widget.ownerId)
          .collection('orders')
          .doc(orderId);

      try {
        await orderRef.set({
          'orderDate': orderDate,
          'totalProducts': products.length,
        });

        for (var product in products) {
          await orderRef.collection('products').add(product);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Order and products added successfully!')),
        );

        setState(() {
          _orderIdController.clear();
          _orderDateController.clear();
          products.clear();
        });

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save order or products')),
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
        title: const Text('Add Order with Products'),
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
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
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
                                DataCell(Text('\$${product['price']}')),
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
        
            // // Add Product Button
            // ElevatedButton.icon(
            //   onPressed: () => showDialog(
            //     context: context,
            //     builder: (context) => AddProductDialog(
            //       onAddProduct: addProduct,
            //     ),
            //   ),
            //   icon: const Icon(Icons.add, size: 28, color: Colors.white,),
            //   label: const Text(
            //     'Add Product',
            //     style: TextStyle(
            //         color: Colors.white,
            //         fontWeight: FontWeight.w500,
            //         fontSize: 22),
            //   ),
            //   style: ElevatedButton.styleFrom(
            //     minimumSize: const Size(double.infinity, 50),
            //     backgroundColor: Colors.blueAccent,
            //     textStyle: const TextStyle(fontSize: 16),
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8)),
            //   ),
            // ),
            // const SizedBox(height: 20),
        
            // // Save Order Button
            // ElevatedButton(
            //   onPressed: saveOrderWithProducts,
            //   style: ElevatedButton.styleFrom(
            //     minimumSize: const Size(double.infinity, 50),
            //     backgroundColor: Colors.green,
            //     textStyle: const TextStyle(fontSize: 16),
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8)),
            //   ),
            //   child: const Text(
            //     'Save Order',
            //     style: TextStyle(
            //         color: Colors.white,
            //         fontWeight: FontWeight.w500,
            //         fontSize: 22),
            //   ),
            // ),
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
    return AlertDialog(
      title: const Text(
        'Add Product',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  hintText: 'Enter the product name',
                  prefixIcon: const Icon(Icons.shopping_cart),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Product name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _productPriceController,
                decoration: InputDecoration(
                  labelText: 'Product Price',
                  hintText: 'Enter the product price',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value.trim()) == null) {
                    return 'Enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _productQuantityController,
                decoration: InputDecoration(
                  labelText: 'Product Quantity',
                  hintText: 'Enter the quantity',
                  prefixIcon: const Icon(Icons.production_quantity_limits),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade700,
            textStyle: const TextStyle(fontSize: 16),
          ),
          child: const Text('Cancel'),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
