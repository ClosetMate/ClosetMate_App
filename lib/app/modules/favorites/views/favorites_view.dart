import 'package:closet_mate/app/components/cm_product_item.dart';
import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/favorites_controller.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});
  
  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
        appBar: AppBar(
          backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.h),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: isLightTheme ? Colors.grey[200] : Colors.grey[800],
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  color: isLightTheme ? Colors.white : Colors.grey[700],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: isLightTheme ? Colors.black87 : Colors.white,
                unselectedLabelColor: isLightTheme ? Colors.grey[600] : Colors.grey[400],
                labelStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text('Favorites'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.checkroom,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text('Closet'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildTabContent(context, isLightTheme, 'favorites'),
            _buildTabContent(context, isLightTheme, 'closet'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, bool isLightTheme, String tabType) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Obx(() {
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
                  onPressed: controller.refreshProducts,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  tabType == 'favorites' ? Icons.favorite_border : Icons.checkroom_outlined,
                  size: 64.sp,
                  color: Colors.grey,
                ),
                SizedBox(height: 16.h),
                Text(
                  tabType == 'favorites' 
                    ? 'No favorites yet' 
                    : 'Your closet is empty',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  tabType == 'favorites'
                    ? 'Start adding products to your favorites'
                    : 'Add products to build your wardrobe',
                  textAlign: TextAlign.center,
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
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.60,
            ),
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              final product = controller.products[index];
              return CmProductItem(product: product);
            },
          ),
        );
      }),
    );
  }
}
