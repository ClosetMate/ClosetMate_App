import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:closet_mate/app/components/smart_image.dart';
import 'package:closet_mate/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
        ),
        backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
        iconTheme: IconThemeData(color: ThemeColors.getTextPrimary(isLightTheme)),
        elevation: 0,
      ),
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
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ThemeColors.getTextPrimary(isLightTheme),
                  ),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: controller.refreshOrders,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 64.sp,
                  color: Colors.grey,
                ),
                SizedBox(height: 16.h),
                Text(
                  'No orders yet',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.getTextPrimary(isLightTheme),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Your order history will appear here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ThemeColors.getTextSecondary(isLightTheme),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshOrders,
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              final order = controller.orders[index];
              return _buildOrderCard(order, isLightTheme);
            },
          ),
        );
      }),
    );
  }

  Widget _buildOrderCard(OrderModel order, bool isLightTheme) {
    final statusColor = _getStatusColor(order.status, isLightTheme);
    final formattedDate = _formatDate(order.orderDate);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: ThemeColors.getCardBackground(isLightTheme),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order header
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.orderNumber,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.getTextPrimary(isLightTheme),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ThemeColors.getTextSecondary(isLightTheme),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    order.statusDisplay,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          // Order items
          ...order.items.map((item) => _buildOrderItem(item, isLightTheme)),
          // Order total
          Padding(
            padding: EdgeInsets.all(16.w),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.getTextPrimary(isLightTheme),
                    ),
                  ),
                  Text(
                    '${order.currency} ${order.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.getTextPrimary(isLightTheme),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item, bool isLightTheme) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: item.productImage != null
                ? SmartImage(
                    imageUrl: item.productImage!,
                    width: 80.w,
                    height: 80.h,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 80.w,
                    height: 80.h,
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.image_outlined,
                      color: Colors.grey.shade400,
                    ),
                  ),
          ),
          SizedBox(width: 12.w),
          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.getTextPrimary(isLightTheme),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                if (item.size != null || item.color != null)
                  Text(
                    [
                      if (item.size != null) 'Size: ${item.size}',
                      if (item.color != null) 'Color: ${item.color}',
                    ].join(' • '),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ThemeColors.getTextSecondary(isLightTheme),
                    ),
                  ),
                SizedBox(height: 4.h),
                Text(
                  'Qty: ${item.quantity}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: ThemeColors.getTextSecondary(isLightTheme),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '\$${item.subtotal.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.getTextPrimary(isLightTheme),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status, bool isLightTheme) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return ThemeColors.getTextSecondary(isLightTheme);
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

