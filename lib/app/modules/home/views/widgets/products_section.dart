import 'package:closet_mate/app/components/product_item.dart';
import 'package:closet_mate/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductsSection extends StatelessWidget {
  List<ProductModel> products = [];
  
  late String sectionTitle;

  ProductsSection({super.key, required this.products, required this.sectionTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(sectionTitle, products)
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<ProductModel> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 280, // Adjust as needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildProductCard(items[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(ProductModel item) {
    return Container(
      width: 180,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 6, color: Colors.grey.shade300)],
      ),
      child: ProductItem(product: item),
      );
  }
}
