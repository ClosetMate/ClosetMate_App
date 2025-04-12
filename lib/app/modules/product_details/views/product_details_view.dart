import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/custom_button.dart';
import '../controllers/product_details_controller.dart';
import 'widgets/rounded_button.dart';
import 'widgets/size_item.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Stack(
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
                          child: GetBuilder<ProductDetailsController>(
                            id: 'ProductImages',
                            builder:
                                (_) => PageView.builder(
                                  controller: controller.pageController,
                                  itemCount:
                                      controller.product.otherImageUrls.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Image.asset(
                                      controller.product.otherImageUrls[index],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    );
                                  },
                                ),
                          ),
                        ),
                      ),
                      // Left Arrow
                      Positioned(
                        left: 10,
                        top: 225.h, // Center vertically
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () {
                            if (controller.pageController.hasClients) {
                              controller.pageController.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                      ),
                      // Right Arrow
                      Positioned(
                        right: 10,
                        top: 225.h, // Center vertically
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (controller.pageController.hasClients) {
                              controller.pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 30.h,
                    left: 20.w,
                    right: 20.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RoundedButton(
                          onPressed: () => Get.back(),
                          // elevation: 4,
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                        GetBuilder<ProductDetailsController>(
                          id: 'FavoriteButton',
                          builder:
                              (_) => RoundedButton(
                                onPressed:
                                    () => controller.onFavoriteButtonPressed(),
                                // elevation: 4,
                                child: Icon(
                                  controller.product.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                                  color: Colors.white,
                                  size: 22.sp,
                                ).animate().scale(duration: 200.ms),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              20.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  controller.product.name,
                ).animate().fade().slideX(duration: 300.ms, begin: -1),
              ),
              10.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Text(
                      controller.product.currency +
                          controller.product.price.toString(),
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 16,
                        decoration: TextDecoration.lineThrough,
                        decorationColor:
                            Colors
                                .red, // Optional: Change color of strike-through line
                        decorationThickness: 2.0,
                      ),
                    ),
                    15.horizontalSpace,
                    Text(
                      controller.product.currency +
                          controller.product.currentPrice.toString(),
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ).animate().fade().slideX(duration: 300.ms, begin: -1),
              ),
              20.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: Colors.amberAccent,
                      size: 24.sp,
                    ),
                    5.horizontalSpace,
                    Text(controller.product.rating.toString()),
                    30.horizontalSpace,
                    Icon(
                      Icons.comment_outlined,
                      color: Colors.amberAccent,
                      size: 24.sp,
                    ),
                    5.horizontalSpace,
                    Text(controller.product.reviews),
                  ],
                ).animate().fade().slideX(duration: 300.ms, begin: -1),
              ),
              20.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Choose your size:',
                  // style: theme.textTheme.bodyText1?.copyWith(fontWeight: FontWeight.bold),
                ).animate().fade().slideX(duration: 300.ms, begin: -1),
              ),
              10.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: GetBuilder<ProductDetailsController>(
                  id: 'Size',
                  builder:
                      (_) => Row(
                        children:
                            ['S', 'M', 'L', 'XL']
                                .map(
                                  (size) => Padding(
                                    padding: EdgeInsets.only(right: 10.w),
                                    child: SizeItem(
                                      onPressed:
                                          () => controller.changeSelectedSize(
                                            size,
                                          ),
                                      label: size,
                                      selected: controller.selectedSize == size,
                                    ),
                                  ),
                                )
                                .toList(),
                      ).animate().fade().slideX(duration: 300.ms, begin: -1),
                ),
              ),
              20.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: CustomButton(
                  text: 'Add to Cart',
                  onPressed: () => controller.onAddToCartPressed(),
                  disabled: controller.product.quantity <= 0,
                  fontSize: 16.sp,
                  radius: 12.r,
                  verticalPadding: 12.h,
                  hasShadow: true,
                  shadowColor: theme.primaryColor,
                  shadowOpacity: 0.3,
                  shadowBlurRadius: 6,
                  shadowSpreadRadius: 2,
                ).animate().fade().slideY(duration: 300.ms, begin: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
