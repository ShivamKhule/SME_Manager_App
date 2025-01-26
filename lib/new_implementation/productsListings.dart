import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'productInfo.dart';

class ProductsListingPage extends StatelessWidget {
  final String categoryName;

  ProductsListingPage({required this.categoryName, Key? key}) : super(key: key);

  // Dummy data for products
  final List<Map<String, dynamic>> products = [
    {
      "category": "Electronics",
      "name": "Laptop",
      "image": "laptop.png",
      "dimensions": "15 x 10 inches",
      "price": "\$1000",
      "description":
          "A high-performance laptop with a sleek design and powerful features for professionals and gamers alike.",
          "availability": "In Stock", // or "Out of Stock"
    },
    {
      "category": "Electronics",
      "name": "Smartphone",
      "image": "smartphone.png",
      "dimensions": "6 x 3 inches",
      "price": "\$800",
      "description":
          "A smartphone with a cutting-edge camera, a high-resolution display, and long-lasting battery life.",
          "availability": "Out of Stock"
    },
    {
      "category": "Furniture",
      "name": "Dining Table",
      "image": "table.png",
      "dimensions": "120 x 80 cm",
      "price": "\$500",
      "description":
          "A sturdy dining table crafted from premium wood, perfect for family gatherings.",
          "availability": "In Stock", // or "Out of Stock"
    },
    {
      "category": "Furniture",
      "name": "Chair",
      "image": "chair.png",
      "dimensions": "60 x 60 cm",
      "price": "\$150",
      "description":
          "A comfortable chair with ergonomic support for home and office use.",
          "availability": "Out of Stock"
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter products based on the categoryName
    final filteredProducts = products
        .where((product) => product['category'] == categoryName)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryName,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Container(
        color: Colors.indigo[50],
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Adjust card layout for small vs. large screens
            final isWideScreen = constraints.maxWidth > 600;

            return filteredProducts.isNotEmpty
                ? GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          isWideScreen ? 3 : 2, // Responsive columns
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2 / 3, // Adjust card dimensions
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return _buildProductCard(product, context);
                    },
                  )
                : Center(
                    child: Text(
                      "No products available in $categoryName",
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                    ),
                  );
          },
        ),
      ),
    );
  }

  // Widget for product card
  Widget _buildProductCard(Map<String, dynamic> product, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      'assets/images/${product['image']}',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        product['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Dimensions
                      Text(
                        "Dimensions: ${product['dimensions']}",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Price Tag
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[400],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  product['price'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
