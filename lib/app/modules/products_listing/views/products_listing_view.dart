import 'package:closet_mate/app/components/cm_product_item.dart';
import 'package:closet_mate/app/modules/products_listing/controllers/products_listing_controller.dart';
import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:ui';

class ProductsListingView extends GetView<ProductsListingController> {
  const ProductsListingView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    
    return GestureDetector(
      onTap: () {
        // Close search mode when tapping outside
        if (controller.isSearchMode.value) {
          controller.exitSearchMode();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(1),
              blurRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Scaffold(
        backgroundColor: ThemeColors.getBackground(isLightTheme),
        appBar: AppBar(
          elevation: 5,
          // titleTextStyle: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
          shadowColor: Colors.black.withOpacity(0.8),
          backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
          toolbarHeight: 50.h,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isLightTheme ? Brightness.dark : Brightness.light,
          ),
          surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: ThemeColors.getSecondary(isLightTheme)),
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          if (controller.isSearchMode.value) {
            return Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isLightTheme ? Colors.grey[300]! : Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: controller.searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: isLightTheme ? Colors.grey[600] : Colors.white70,
                          ),
                          isDense: true,
                        ),
                        style: TextStyle(
                          color: isLightTheme ? Colors.black87 : Colors.white,
                          fontSize: 16,
                        ),
                        onChanged: (value) => controller.onSearchChanged(value),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: isLightTheme ? Colors.grey[600] : Colors.white70,
                        size: 18,
                      ),
                      onPressed: controller.clearSearch,
                      splashRadius: 18,
                    ),
                  ],
                ),
              ),
            );
          }
          return Obx(() => Text(controller.displayTitle.value));
        }),
        actions: [
          Obx(() => IconButton(
            icon: Icon(
              controller.isSearchMode.value ? Icons.close : Icons.search,
              color: ThemeColors.getSecondary(isLightTheme),
            ),
            onPressed: () {
              if (controller.isSearchMode.value) {
                controller.exitSearchMode();
              } else {
                controller.enterSearchMode();
              }
            },
          )),
          Obx(() {
            final hasFilters = controller.selectedCategory.value.isNotEmpty ||
                controller.selectedPriceRange.value.isNotEmpty ||
                controller.selectedSortBy.value.isNotEmpty;
            
            return IconButton(
              icon: Icon(
                Icons.filter_list,
                color: hasFilters 
                    ? ThemeColors.getSecondary(isLightTheme)
                    : ThemeColors.getSecondary(isLightTheme).withOpacity(0.6),
              ),
              onPressed: () {
                // Exit search mode if active when filter is clicked
                if (controller.isSearchMode.value) {
                  controller.exitSearchMode();
                }
                _showFilterBottomSheet(context, isLightTheme);
              },
            );
          }),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Products Grid
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading products...'),
                    ],
                  ),
                );
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
                        onPressed: controller.refreshProducts,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (controller.filteredProducts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 64.sp,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No products found',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Try adjusting your filters',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshProducts,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                        !controller.isLoading.value) {
                      controller.loadMoreProducts();
                    }
                    return false;
                  },
                  child: GridView.builder(
                    padding: EdgeInsets.all(5.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 0.w,
                      mainAxisSpacing: 0.h,
                    ),
                    itemCount: controller.filteredProducts.length + (controller.hasMoreData.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.filteredProducts.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      
                      return CmProductItem(
                        product: controller.filteredProducts[index],
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      ),
      ),
    );
  }


  void _showFilterBottomSheet(BuildContext context, bool isLightTheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: ThemeColors.getBackground(isLightTheme),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: ThemeColors.getTextHint(isLightTheme),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            
            // Header with Close Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Products',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: ThemeColors.getTextPrimary(isLightTheme),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: ThemeColors.getCardBackground(isLightTheme),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Icon(
                        Icons.close,
                        size: 20.sp,
                        color: ThemeColors.getTextSecondary(isLightTheme),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Scrollable Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Price Range Filter
                    _buildFilterSection(
                      title: 'Price Range',
                      icon: Icons.attach_money_outlined,
                      isLightTheme: isLightTheme,
                      children: ['\$0 - \$50', '\$50 - \$100', '\$100 - \$200', '\$200+']
                          .map((range) => _buildModernChip(
                                label: range,
                                isSelected: controller.selectedPriceRange.value == range,
                                onTap: () => controller.setPriceRange(range),
                                isLightTheme: isLightTheme,
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 24.h),

                    // Sort By Filter
                    _buildFilterSection(
                      title: 'Sort By',
                      icon: Icons.sort_outlined,
                      isLightTheme: isLightTheme,
                      children: ['Price: Low to High', 'Price: High to Low', 'Newest First', 'Most Popular']
                          .map((sort) => _buildModernChip(
                                label: sort,
                                isSelected: controller.selectedSortBy.value == sort,
                                onTap: () => controller.setSortBy(sort),
                                isLightTheme: isLightTheme,
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 32.h),
                  ],
                )),
              ),
            ),

            // Apply Button (Fixed at bottom)
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
              child: Container(
                width: double.infinity,
                height: 56.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ThemeColors.getButtonBackground(isLightTheme),
                      ThemeColors.getButtonBackground(isLightTheme).withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeColors.getBackground(!isLightTheme).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16.r),
                    onTap: () {
                      controller.applyFilters();
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: ThemeColors.getButtonText(isLightTheme),
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Apply Filters',
                            style: TextStyle(
                              color: ThemeColors.getButtonText(isLightTheme),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required IconData icon,
    required bool isLightTheme,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: ThemeColors.getSecondary(isLightTheme).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                size: 18.sp,
                color: ThemeColors.getTextPrimary(isLightTheme),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: ThemeColors.getTextPrimary(isLightTheme),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: children,
        ),
      ],
    );
  }

  Widget _buildModernChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isLightTheme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected 
              ? ThemeColors.getButtonBackground(isLightTheme)
              : ThemeColors.getButtonBackground(!isLightTheme),
          borderRadius: BorderRadius.circular(20.r),
          // border: Border.all(
          //   color: isSelected 
          //       ? ThemeColors.getSecondary(isLightTheme)
          //       : ThemeColors.getTextHint(isLightTheme).withOpacity(0.3),
          //   width: 1.5,
          // ),
          // boxShadow: isSelected ? [
          //   BoxShadow(
          //     color: ThemeColors.getSecondary(isLightTheme).withOpacity(0.3),
          //     blurRadius: 8,
          //     offset: const Offset(0, 2),
          //   ),
          // ] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected 
                ? ThemeColors.getTextPrimary(!isLightTheme)
                : ThemeColors.getTextPrimary(isLightTheme),
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

}
