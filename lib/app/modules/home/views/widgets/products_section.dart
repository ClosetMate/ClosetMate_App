import 'package:closet_mate/app/components/product_item.dart';
import 'package:closet_mate/config/theme/colors.dart';
import 'package:closet_mate/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductsSection extends StatelessWidget {
  final List<ProductModel> products;
  final String sectionTitle;

  const ProductsSection({
    super.key,
    required this.products,
    required this.sectionTitle,
  });

    @override
    Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sectionTitle,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to all products page
                    },
                    child: Row(
                      children: [
                        Text(
                          "View All",
                          style: TextStyle(fontSize: 14, color: ColorConstants.appSpecificDark),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: ColorConstants.appSpecificDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _buildProductCard(products[index]);
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
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: ProductItem(product: item),
    );
  }
}