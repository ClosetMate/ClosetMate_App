import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:closet_mate/app/components/smart_image.dart';
import 'package:closet_mate/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/tried_on_controller.dart';

class TriedOnView extends GetView<TriedOnController> {
  const TriedOnView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Get.isDarkMode == false;
    
    return Scaffold(
      backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
      appBar: AppBar(
        title: const Text('Saved Try-Ons'),
        backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ThemeColors.getTextPrimary(isLightTheme),
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_border,
                  size: 64.sp,
                  color: Colors.grey,
                ),
                SizedBox(height: 16.h),
                Text(
                  'No saved try-ons',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: ThemeColors.getTextSecondary(isLightTheme),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Save try-on images to see them here',
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
          onRefresh: controller.refresh,
          child: GridView.builder(
            padding: EdgeInsets.all(16.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.75,
            ),
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              final product = controller.products[index];
              final tryOnImage = controller.getTryOnImage(product.id);
              
              return GestureDetector(
                onTap: () {
                  Get.toNamed(
                    Routes.CM_PRODUCT_DETAILS,
                    arguments: product.id,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ThemeColors.getCardBackground(isLightTheme),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product image with try-on
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12.r),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              if (tryOnImage != null)
                                Image.memory(
                                  tryOnImage,
                                  fit: BoxFit.cover,
                                )
                              else if (product.images.isNotEmpty)
                                SmartImage(
                                  imageUrl: product.images[0],
                                  fit: BoxFit.cover,
                                )
                              else
                                Container(
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.image,
                                    size: 48.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              // Remove button
                              Positioned(
                                top: 8.h,
                                right: 8.w,
                                child: GestureDetector(
                                  onTap: () => _showRemoveDialog(context, product.id, isLightTheme),
                                  child: Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: Colors.white,
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Product info
                      Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: ThemeColors.getTextPrimary(isLightTheme),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              product.brand,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: ThemeColors.getTextSecondary(isLightTheme),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${product.currency} ${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: ThemeColors.getCurrency(isLightTheme),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _showRemoveDialog(BuildContext context, String productId, bool isLightTheme) {
    Get.dialog(
      AlertDialog(
        backgroundColor: ThemeColors.getCardBackground(isLightTheme),
        title: Text(
          'Remove Try-On',
          style: TextStyle(
            color: ThemeColors.getTextPrimary(isLightTheme),
          ),
        ),
        content: Text(
          'Are you sure you want to remove this saved try-on?',
          style: TextStyle(
            color: ThemeColors.getTextSecondary(isLightTheme),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: ThemeColors.getTextSecondary(isLightTheme),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.removeTryOn(productId);
            },
            child: Text(
              'Remove',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

