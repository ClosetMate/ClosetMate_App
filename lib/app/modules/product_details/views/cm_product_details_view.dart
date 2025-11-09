import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:closet_mate/models/cm_product_model.dart';
import 'package:closet_mate/app/components/smart_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/custom_button.dart';
import '../controllers/cm_product_details_controller.dart';
import 'widgets/rounded_button.dart';
import 'widgets/size_item.dart';

class CmProductDetailsView extends GetView<CmProductDetailsController> {
  const CmProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Get.isDarkMode == false;
    
    return Scaffold(
      backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
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
                  onPressed: controller.refreshProduct,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.product.value == null) {
          return const Center(
            child: Text('Product not found'),
          );
        }

        final product = controller.product.value!;
        
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Images Section
                _buildImageSection(product, isLightTheme),
                
                20.verticalSpace,
                
                // Product Info Section
                _buildProductInfo(product, isLightTheme),
                
                20.verticalSpace,
                
                // Color Selection
                _buildColorSelection(isLightTheme),
                
                20.verticalSpace,
                
                // Size Selection
                _buildSizeSelection(isLightTheme),
                
                20.verticalSpace,
                
                // Quantity Selection
                _buildQuantitySelection(isLightTheme),
                
                20.verticalSpace,
                
                // // Tags Section
                // _buildTagsSection(product, isLightTheme),
                
                // 20.verticalSpace,
                
                // Add to Cart Button
                _buildAddToCartButton(isLightTheme),
                
                20.verticalSpace,
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildImageSection(CmProductModel product, bool isLightTheme) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 450.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 131, 131, 133),
                Color(0xFFDDE5F5),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: product.images.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return SmartImage(
                  imageUrl: product.images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ),
          ),
        ),
        
        // Navigation arrows
        if (product.images.length > 1) ...[
          Positioned(
            left: 10,
            top: 225.h,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                if (controller.pageController.hasClients) {
                  controller.pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
          Positioned(
            right: 10,
            top: 225.h,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onPressed: () {
                if (controller.pageController.hasClients) {
                  controller.pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
        ],
        
        // Header buttons
        Positioned(
          top: 30.h,
          left: 20.w,
          right: 20.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundedButton(
                onPressed: () => Get.back(),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: ThemeColors.getButtonText(isLightTheme),
                  size: 20.sp,
                ),
              ),
              RoundedButton(
                onPressed: controller.toggleFavorite,
                child: Icon(
                  Icons.favorite_border,
                  color: ThemeColors.getButtonText(isLightTheme),
                  size: 22,
                ).animate().scale(duration: 200.ms),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductInfo(CmProductModel product, bool isLightTheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name
          Text(
            product.name,
            style: TextStyle(
              color: ThemeColors.getTextPrimary(isLightTheme),
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fade().slideX(duration: 300.ms, begin: -1),
          
          10.verticalSpace,
          
          // Brand
          Text(
            product.brand,
            style: TextStyle(
              color: ThemeColors.getTextSecondary(isLightTheme),
              fontSize: 16.sp,
            ),
          ).animate().fade().slideX(duration: 300.ms, begin: -1),
          
          10.verticalSpace,
          
          // Price
          Text(
            '${product.currency} ${product.price.toStringAsFixed(2)}',
            style: TextStyle(
              color: ThemeColors.getCurrency(isLightTheme),
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fade().slideX(duration: 300.ms, begin: -1),
          
          10.verticalSpace,
          
          // Description
          Text(
            product.description,
            style: TextStyle(
              color: ThemeColors.getTextSecondary(isLightTheme),
              fontSize: 14.sp,
              height: 1.5,
            ),
          ).animate().fade().slideX(duration: 300.ms, begin: -1),
        ],
      ),
    );
  }

  Widget _buildColorSelection(bool isLightTheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Color:',
            style: TextStyle(
              color: ThemeColors.getTextPrimary(isLightTheme),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fade().slideX(duration: 300.ms, begin: -1),
          
          10.verticalSpace,
          
          Obx(() => Wrap(
            spacing: 10.w,
            children: controller.availableColors.map((color) {
              return GestureDetector(
                onTap: () => controller.changeSelectedColor(color),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: controller.selectedColor.value == color
                        ? ThemeColors.getButtonBackground(isLightTheme)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20.r),
                    // border: Border.all(
                    //   color: controller.selectedColor.value == color
                    //       ? ThemeColors.getAccent(isLightTheme)
                    //       : Colors.grey[300]!,
                    //   width: 2,
                    // ),
                  ),
                  child: Text(
                    color,
                    style: TextStyle(
                      color: controller.selectedColor.value == color
                          ? ThemeColors.getButtonText(isLightTheme)
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          )).animate().fade().slideX(duration: 300.ms, begin: -1),
        ],
      ),
    );
  }

  Widget _buildSizeSelection(bool isLightTheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Size:',
            style: TextStyle(
              color: ThemeColors.getTextPrimary(isLightTheme),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fade().slideX(duration: 300.ms, begin: -1),
          
          10.verticalSpace,
          
          Obx(() => Row(
            children: controller.availableSizes.map((size) {
              return Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: SizeItem(
                  onPressed: () => controller.changeSelectedSize(size),
                  label: size,
                  selected: controller.selectedSize.value == size,
                ),
              );
            }).toList(),
          )).animate().fade().slideX(duration: 300.ms, begin: -1),
        ],
      ),
    );
  }

  Widget _buildQuantitySelection(bool isLightTheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quantity:',
            style: TextStyle(
              color: ThemeColors.getTextPrimary(isLightTheme),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fade().slideX(duration: 300.ms, begin: -1),
          
          10.verticalSpace,
          
          Obx(() => Row(
            children: [
              IconButton(
                onPressed: controller.selectedQuantity.value > 1
                    ? () => controller.changeQuantity(controller.selectedQuantity.value - 1)
                    : null,
                icon: const Icon(Icons.remove),
                style: IconButton.styleFrom(
                  backgroundColor: controller.selectedQuantity.value > 1
                      ? ThemeColors.getButtonBackground(isLightTheme)
                      : Colors.grey[300],
                  foregroundColor: ThemeColors.getButtonText(isLightTheme),
                ),
              ),
              Container(
                width: 60.w,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  controller.selectedQuantity.value.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: controller.selectedQuantity.value < controller.selectedVariantStock
                    ? () => controller.changeQuantity(controller.selectedQuantity.value + 1)
                    : null,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: controller.selectedQuantity.value < controller.selectedVariantStock
                      ? ThemeColors.getButtonBackground(isLightTheme)
                      : Colors.grey[300],
                  foregroundColor: ThemeColors.getButtonText(isLightTheme),
                ),
              ),
              const Spacer(),
              Text(
                'Stock: ${controller.selectedVariantStock}',
                style: TextStyle(
                  color: controller.selectedVariantStock > 0 ? Colors.green : Colors.red,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )).animate().fade().slideX(duration: 300.ms, begin: -1),
        ],
      ),
    );
  }

  Widget _buildTagsSection(CmProductModel product, bool isLightTheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tags:',
            style: TextStyle(
              color: ThemeColors.getTextPrimary(isLightTheme),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fade().slideX(duration: 300.ms, begin: -1),
          
          10.verticalSpace,
          
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: product.tags.map((tag) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: ThemeColors.getPrimary(isLightTheme).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: ThemeColors.getPrimary(isLightTheme).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: ThemeColors.getPrimary(isLightTheme),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ).animate().fade().slideX(duration: 300.ms, begin: -1),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton(bool isLightTheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Obx(() => CustomButton(
        text: controller.isVariantAvailable ? 'Add to Cart' : 'Out of Stock',
        foregroundColor: ThemeColors.getButtonText(isLightTheme),
        onPressed: controller.isVariantAvailable ? controller.addToCart : null,
        backgroundColor: controller.isVariantAvailable 
            ? ThemeColors.getButtonBackground(isLightTheme)
            : Colors.grey[400]!,
        disabled: !controller.isVariantAvailable,
        fontSize: 16.sp,
        radius: 12.r,
        verticalPadding: 12.h,
        hasShadow: true,
        shadowColor: ThemeColors.getPrimary(isLightTheme),
        shadowOpacity: 0.3,
        shadowBlurRadius: 6,
        shadowSpreadRadius: 2,
      )).animate().fade().slideY(duration: 300.ms, begin: 1),
    );
  }
}
