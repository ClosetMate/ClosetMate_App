import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:closet_mate/app/components/smart_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});
  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
      // appBar: AppBar(
      //   title: const Text('Shopping Cart'),
      //   backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
      //   actions: [
      //     Obx(() => Text(
      //       '${controller.totalItems} items',
      //       style: TextStyle(fontSize: 16.sp),
      //     )),
      //     SizedBox(width: 16.w),
      //   ],
      // ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.sp,
                  color: Colors.red,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Error: ${controller.errorMessage.value}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.sp),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: controller.loadCartItems,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 64.sp,
                  color: Colors.grey,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Your cart is empty',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Add some products to get started',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.cartItems.length,
                padding: EdgeInsets.all(16.w),
                itemBuilder: (context, index) {
                  return _buildCartItem(controller.cartItems[index]);
                },
              ),
            ),
            _buildCartSummary(),
          ],
        );
      }),
    );
  }

  Widget _buildCartItem(CartItem cartItem) {
    bool isLightTheme = Get.isDarkMode == false;
    final product = cartItem.product;
    
    return Card(
      color: ThemeColors.getCardBackground(isLightTheme),
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            // Product Image
            Container(
              height: 80.h,
              width: 80.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.grey[200],
              ),
              child: SmartImage(
                imageUrl: product.mainImage,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(8.r),
                width: 80.w,
                height: 80.w,
              ),
            ),
            SizedBox(width: 12.w),
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    product.brand,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ThemeColors.getTextSecondary(isLightTheme),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${product.currency} ${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: ThemeColors.getCurrency(isLightTheme),
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        'Color: ${cartItem.selectedColor}',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: ThemeColors.getTextSecondary(isLightTheme),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Size: ${cartItem.selectedSize}',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: ThemeColors.getTextSecondary(isLightTheme),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Quantity Control - Wrapped in Obx for reactivity
            Obx(() {
              // Find the current cart item to get updated quantity
              CartItem? currentItem;
              try {
                currentItem = controller.cartItems.firstWhere((item) => 
                  item.product.id == product.id && 
                  item.selectedColor == cartItem.selectedColor &&
                  item.selectedSize == cartItem.selectedSize
                );
              } catch (e) {
                currentItem = null;
              }
              final currentQuantity = currentItem?.quantity ?? cartItem.quantity;
              
              return Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, size: 20.sp),
                    onPressed: () {
                      controller.updateQuantity(
                        product.id,
                        cartItem.selectedColor,
                        cartItem.selectedSize,
                        currentQuantity + 1,
                      );
                    },
                  ),
                  Text(
                    '$currentQuantity',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline, size: 20.sp),
                    onPressed: () {
                      if (currentQuantity > 1) {
                        controller.updateQuantity(
                          product.id,
                          cartItem.selectedColor,
                          cartItem.selectedSize,
                          currentQuantity - 1,
                        );
                      }
                    },
                  ),
                ],
              );
            }),
            // Remove Button
            IconButton(
              icon: Icon(Icons.delete_outline, size: 20.sp),
              onPressed: () {
                controller.removeFromCart(
                  product.id,
                  cartItem.selectedColor,
                  cartItem.selectedSize,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary() {
    bool isLightTheme = Get.isDarkMode == false;
    return Obx(() {
      final subtotal = controller.totalPrice;
      final shipping = subtotal > 0 ? 2.0 : 0.0;
      final total = subtotal + shipping;
      final currency = controller.currency;
      
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: ThemeColors.getScaffoldBackground(isLightTheme),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSummaryRow('Subtotal', '$currency ${subtotal.toStringAsFixed(2)}'),
            SizedBox(height: 8.h),
            _buildSummaryRow('Shipping', '$currency ${shipping.toStringAsFixed(2)}'),
            Divider(height: 24.h, thickness: 1),
            _buildSummaryRow('Total', '$currency ${total.toStringAsFixed(2)}', isTotal: true),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: subtotal > 0 ? controller.checkout : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.getButtonBackground(isLightTheme),
                minimumSize: Size.fromHeight(50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: ThemeColors.getButtonText(isLightTheme),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryRow(String title, String amount, {bool isTotal = false}) {
    bool isLightTheme = Get.isDarkMode == false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 18.sp : 16.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: ThemeColors.getTextPrimary(isLightTheme),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 18.sp : 16.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: ThemeColors.getCurrency(isLightTheme),
          ),
        ),
      ],
    );
  }
}
