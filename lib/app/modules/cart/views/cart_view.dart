import 'package:closet_mate/config/theme/colors.dart';
import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:closet_mate/models/product_model.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});
  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: controller.products.length, // Replace with your cart items length
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                return _buildCartItem(controller.products[index]);
              },
            ),
          ),
          _buildCartSummary(),
        ],
      ),
    );
  }

  Widget _buildCartItem(ProductModel product) {
    bool isLightTheme = Get.isDarkMode == false;
    return Card(
      color: ThemeColors.getCardBackground(isLightTheme),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Product Image
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
                image: DecorationImage(
                  image: AssetImage(product.imageUrl), // Replace with your image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${product.currency} ${product.currentPrice.toStringAsFixed(2)}',
                    style: TextStyle(color: ThemeColors.getCurrency(isLightTheme), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Quantity Control
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {},
                ),
                const Text('1'),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {},
                ),
              ],
            ),
            // Remove Button
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary() {
    bool isLightTheme = Get.isDarkMode == false;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.getScaffoldBackground(isLightTheme),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSummaryRow('Subtotal', '\$ 24.00'),
          const SizedBox(height: 8),
          _buildSummaryRow('Shipping', '\$ 2.00'),
          const Divider(height: 24, thickness: 1),
          _buildSummaryRow('Total', '\$ 26.00', isTotal: true),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // TODO: Handle checkout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.getSecondary(isLightTheme),
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Checkout', style: TextStyle(fontSize: 18, color: ThemeColors.getButtonText(isLightTheme))),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
