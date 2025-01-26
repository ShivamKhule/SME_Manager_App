import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesEntryScreen extends StatefulWidget {
  const SalesEntryScreen({super.key});

  @override
  _SalesEntryScreenState createState() => _SalesEntryScreenState();
}

class _SalesEntryScreenState extends State<SalesEntryScreen> {
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _ownerController = TextEditingController();
  final _dateController = TextEditingController();
  String selectedProduct = '';
  DateTime selectedDate = DateTime.now();

  final List<String> productList = [
    "Sofa",
    "Coffee Table",
    "Dining Table",
    "Bed Frame",
    "Nightstand",
    "Wardrobe",
    "Bookshelf",
    "TV Stand",
    "Recliner Chair",
    "Office Desk",
    "Dresser",
    "Shoe Rack",
    "Armchair",
    "Bar Stool",
    "Chest of Drawers",
    "Cabinet",
    "Ottoman",
    "Side Table",
    "Console Table",
    "Patio Chair"
  ];

  // List to store added sales entries
  List<Map<String, dynamic>> salesEntries = [];

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _ownerController.dispose();
    super.dispose();
  }

  void _addEntry() {
    String productName = selectedProduct;
    int quantity = int.tryParse(_quantityController.text) ?? 0;
    double price = double.tryParse(_priceController.text) ?? 0.0;
    double discount = double.tryParse(_discountController.text) ?? 0.0;
    double discountedPrice = price - (price * (discount / 100));
    double total = discountedPrice * quantity;
    String ownerName = _ownerController.text;

    if (productName.isNotEmpty &&
        quantity > 0 &&
        price > 0 &&
        ownerName.isNotEmpty) {
      final newEntry = {
        'product': productName,
        'quantity': quantity,
        'price': price,
        'discount': discount,
        'total': total,
        'owner': ownerName,
        'date': selectedDate,
      };

      setState(() {
        salesEntries.add(newEntry);
      });

      // Clear the fields after adding the entry
      _quantityController.clear();
      _priceController.clear();
      _discountController.clear();
      //_ownerController.clear();
      // _dateController.clear();

      selectedProduct = '';
      selectedDate = DateTime.now(); // Reset date to current date

      // Focus back to Product Name field for the next entry
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Dismiss the keyboard when tapping anywhere outside
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Sales Entry'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Owner Name Input
                TextField(
                  controller: _ownerController,
                  decoration: const InputDecoration(
                    labelText: 'Owner Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
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
                  fieldViewBuilder:
                      (context, controller, focusNode, onFieldSubmitted) {
                    // Link the controller with the TextField for input
                    controller.text = selectedProduct;
                    return TextField(
                      controller: controller,
                      focusNode: focusNode, // Focus node attached
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
                // Date Picker
                TextField(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2025),
                    );
                    String formattedDate =
                        DateFormat.yMMMd().format(pickedDate!);
                    _dateController.text = formattedDate;
                    setState(() {});
                  },
                  readOnly: true,
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: "Select Date",
                    suffixIcon: Icon(
                      Icons.calendar_month_outlined,
                      color: Color.fromRGBO(89, 57, 241, 1),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                // Add Entry Button
                ElevatedButton(
                  onPressed: _addEntry,
                  child: const Text('Add Entry'),
                ),
                const SizedBox(height: 20),
                // Display the table with added entries
                if (salesEntries.isEmpty)
                  const Center(child: Text('No entries added yet.'))
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor:
                          WidgetStateProperty.all(Colors.blueAccent),
                      columnSpacing: 12.0,
                      columns: [
                        DataColumn(label: _buildTableHeader('Product')),
                        DataColumn(label: _buildTableHeader('Quantity')),
                        DataColumn(label: _buildTableHeader('Price')),
                        DataColumn(label: _buildTableHeader('Discount')),
                        DataColumn(label: _buildTableHeader('Total')),
                        DataColumn(label: _buildTableHeader('Owner')),
                        DataColumn(label: _buildTableHeader('Date')),
                      ],
                      rows: salesEntries.map((entry) {
                        return DataRow(
                          cells: [
                            DataCell(_buildTableCell(entry['product'])),
                            DataCell(
                                _buildTableCell(entry['quantity'].toString())),
                            DataCell(
                                _buildTableCell(entry['price'].toString())),
                            DataCell(
                                _buildTableCell(entry['discount'].toString())),
                            DataCell(
                                _buildTableCell(entry['total'].toString())),
                            DataCell(_buildTableCell(entry['owner'])),
                            DataCell(_buildTableCell(entry['date']
                                .toLocal()
                                .toString()
                                .split(' ')[0])),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14),
    );
  }
}
