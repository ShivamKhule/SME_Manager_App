import 'package:flutter/material.dart';

class SalesEntryScreen extends StatefulWidget {
  const SalesEntryScreen({Key? key}) : super(key: key);

  @override
  _SalesEntryScreenState createState() => _SalesEntryScreenState();
}

class _SalesEntryScreenState extends State<SalesEntryScreen> {
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  String selectedProduct = '';

  // Predefined product list
  final List<String> productList = [
    'Apple', 'Banana', 'Orange', 'Mango', 'Milk', 'Bread', 'Butter', 'Eggs', 'Cheese'
  ];

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _addEntry() {
    String productName = selectedProduct;
    int quantity = int.tryParse(_quantityController.text) ?? 0;
    double price = double.tryParse(_priceController.text) ?? 0.0;
    double discount = double.tryParse(_discountController.text) ?? 0.0;
    double discountedPrice = price - (price * (discount / 100));
    double total = discountedPrice * quantity;

    if (productName.isNotEmpty && quantity > 0 && price > 0) {
      final newEntry = {
        'product': productName,
        'quantity': quantity,
        'price': price,
        'discount': discount,
        'total': total,
      };
      Navigator.pop(context, newEntry);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Sales Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Autocomplete for Product Name
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return productList.where((String item) => item
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()));
              },
              onSelected: (String selection) {
                setState(() {
                  selectedProduct = selection;
                });
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                controller.text = selectedProduct;
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            // Quantity Input
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            // Price Input
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            // Discount Input
            TextField(
              controller: _discountController,
              decoration: const InputDecoration(
                labelText: 'Discount (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            // Add Entry Button
            ElevatedButton(
              onPressed: _addEntry,
              child: const Text('Add Entry'),
            ),
          ],
        ),
      ),
    );
  }
}
