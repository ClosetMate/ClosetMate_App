import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:closet_mate/models/shipping_address_model.dart';
import 'package:closet_mate/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/shipping_addresses_controller.dart';

class ShippingAddressesView extends GetView<ShippingAddressesController> {
  const ShippingAddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
      appBar: AppBar(
        title: Text(
          'Shipping Addresses',
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
                  onPressed: controller.refreshAddresses,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshAddresses,
          child: controller.addresses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 64.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No addresses yet',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.getTextPrimary(isLightTheme),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Add your first shipping address',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ThemeColors.getTextSecondary(isLightTheme),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: controller.addresses.length,
                  itemBuilder: (context, index) {
                    final address = controller.addresses[index];
                    return _buildAddressCard(address, isLightTheme);
                  },
                ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.ADD_EDIT_ADDRESS),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAddressCard(ShippingAddressModel address, bool isLightTheme) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: ThemeColors.getCardBackground(isLightTheme),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: address.isDefault 
              ? Theme.of(Get.context!).colorScheme.primary 
              : Colors.grey.shade200,
          width: address.isDefault ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        address.fullName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.getTextPrimary(isLightTheme),
                        ),
                      ),
                      if (address.isDefault) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Theme.of(Get.context!).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            'Default',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(Get.context!).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: ThemeColors.getTextPrimary(isLightTheme),
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        Get.toNamed(Routes.ADD_EDIT_ADDRESS, arguments: address);
                        break;
                      case 'delete':
                        _showDeleteConfirmationDialog(address);
                        break;
                      case 'set_default':
                        if (!address.isDefault) {
                          controller.setDefaultAddress(address.id);
                        }
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18.sp),
                          SizedBox(width: 8.w),
                          const Text('Edit'),
                        ],
                      ),
                    ),
                    if (!address.isDefault)
                      PopupMenuItem(
                        value: 'set_default',
                        child: Row(
                          children: [
                            Icon(Icons.star, size: 18.sp),
                            SizedBox(width: 8.w),
                            const Text('Set as Default'),
                          ],
                        ),
                      ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18.sp, color: Colors.red),
                          SizedBox(width: 8.w),
                          const Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              address.street,
              style: TextStyle(
                fontSize: 14.sp,
                color: ThemeColors.getTextPrimary(isLightTheme),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              '${address.city}, ${address.state} ${address.zipCode}',
              style: TextStyle(
                fontSize: 14.sp,
                color: ThemeColors.getTextPrimary(isLightTheme),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              address.country,
              style: TextStyle(
                fontSize: 14.sp,
                color: ThemeColors.getTextPrimary(isLightTheme),
              ),
            ),
            if (address.phoneNumber != null) ...[
              SizedBox(height: 8.h),
              Text(
                'Phone: ${address.phoneNumber}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: ThemeColors.getTextSecondary(isLightTheme),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(ShippingAddressModel address) {
    bool isLightTheme = Get.isDarkMode == false;
    
    Get.dialog(
      Dialog(
        backgroundColor: ThemeColors.getCardBackground(isLightTheme),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Delete Address',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.getTextPrimary(isLightTheme),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Are you sure you want to delete this address?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ThemeColors.getTextPrimary(isLightTheme),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      controller.deleteAddress(address.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

