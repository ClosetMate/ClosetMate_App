import 'package:closet_mate/app/components/cm_product_item.dart';
import 'package:closet_mate/config/theme/colors.dart';
import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:closet_mate/models/cm_product_model.dart';
import 'package:closet_mate/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsSection extends StatelessWidget {
  final List<CmProductModel> products;
  final String sectionTitle;
  final bool showViewAll;
  final String category;

  const ProductsSection({
    super.key,
    required this.products,
    required this.sectionTitle,
    this.showViewAll = true,
    this.category = 'products',
  });

    @override
    Widget build(BuildContext context) {
    bool isLightTheme = Get.isDarkMode == false;
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
                  if (showViewAll)
                    GestureDetector(
                      onTap: () {
                        // Navigate to products listing page with category filter
                        Get.toNamed(
                          Routes.PRODUCTS_LISTING,
                          arguments: {
                            'filter': sectionTitle,
                            'category': category,
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            "View All",
                            style: TextStyle(fontSize: 14, color: ThemeColors.getTextPrimary(isLightTheme)),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: ThemeColors.getTextPrimary(isLightTheme),
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

  Widget _buildProductCard(CmProductModel item) {
    bool isLightTheme = Get.isDarkMode == false;
    return Container(
      width: 180,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: ThemeColors.getScaffoldBackground(isLightTheme),
      ),
      child: CmProductItem(product: item),
    );
  }
}