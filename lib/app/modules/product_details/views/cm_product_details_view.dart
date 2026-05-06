import 'dart:typed_data';
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
    
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await controller.handleBackNavigation();
        if (shouldPop) {
          Get.back();
        }
        return false; // We handle navigation ourselves
      },
      child: Scaffold(
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
      ),
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
            child: Obx(() {
              final totalImages = controller.totalDisplayImageCount;
              final isLoading = controller.isTryOnLoading.value;
              
              return AbsorbPointer(
                absorbing: isLoading,
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: totalImages,
                  scrollDirection: Axis.horizontal,
                  physics: isLoading ? const NeverScrollableScrollPhysics() : const PageScrollPhysics(),
                  onPageChanged: (index) {
                    controller.currentPageIndex.value = index;
                  },
                itemBuilder: (context, index) {
                  final imageData = controller.getDisplayImage(index);
                  final isTryOnResult = controller.isTryOnResult(index);
                  
                  Widget imageWidget;
                  
                  if (imageData == null) {
                    imageWidget = Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(Icons.image, size: 64.sp, color: Colors.grey),
                      ),
                    );
                  } else if (isTryOnResult && imageData is Uint8List) {
                    // Show try-on result image
                    imageWidget = Image.memory(
                      imageData,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  } else if (imageData is String) {
                    // Show original product image
                    imageWidget = SmartImage(
                      imageUrl: imageData,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  } else {
                    imageWidget = Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(Icons.image, size: 64.sp, color: Colors.grey),
                      ),
                    );
                  }
                  
                  // Show loading overlay if generating try-on on the current image
                  if (isLoading && index == controller.currentPageIndex.value) {
                    imageWidget = Stack(
                      children: [
                        imageWidget,
                        Container(
                          color: Colors.black.withOpacity(0.7),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'Generating try-on...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  
                  // Add save/unsave button for try-on result images
                  if (isTryOnResult && !isLoading) {
                    imageWidget = Stack(
                      children: [
                        imageWidget,
                        Positioned(
                          bottom: 20.h,
                          right: 20.w,
                          child: Obx(() {
                            final isSaved = controller.isTryOnSaved(index);
                            return GestureDetector(
                              onTap: () {
                                if (isSaved) {
                                  controller.unsaveTryOnImage(index);
                                } else {
                                  controller.saveTryOnImage(index);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: isSaved 
                                      ? Colors.green
                                      : ThemeColors.getButtonBackground(isLightTheme),
                                  borderRadius: BorderRadius.circular(25.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                                      color: isSaved 
                                          ? Colors.white
                                          : ThemeColors.getButtonText(isLightTheme),
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      isSaved ? 'Unsave' : 'Save',
                                      style: TextStyle(
                                        color: isSaved 
                                            ? Colors.white
                                            : ThemeColors.getButtonText(isLightTheme),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    );
                  }
                  
                  // Wrap in GestureDetector for tap to open full screen
                  return GestureDetector(
                    onTap: isLoading ? null : () => _openFullScreenGallery(context, index, product, isLightTheme),
                    behavior: HitTestBehavior.opaque,
                    child: imageWidget,
                  );
                },
                ),
              );
            }),
          ),
        ),
        
        // Blocking overlay when try-on is loading
        Obx(() {
          final isLoading = controller.isTryOnLoading.value;
          if (isLoading) {
            return Positioned.fill(
              child: AbsorbPointer(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.r),
                      bottomRight: Radius.circular(30.r),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.white,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Generating try-on...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
        
        // Navigation arrows
        Obx(() {
          final totalImages = controller.totalDisplayImageCount;
          final isLoading = controller.isTryOnLoading.value;
          if (totalImages > 1 && !isLoading) {
            return Positioned(
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
            );
          }
          return const SizedBox.shrink();
        }),
        Obx(() {
          final totalImages = controller.totalDisplayImageCount;
          final isLoading = controller.isTryOnLoading.value;
          if (totalImages > 1 && !isLoading) {
            return Positioned(
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
            );
          }
          return const SizedBox.shrink();
        }),
        
        // Header buttons
        Positioned(
          top: 30.h,
          left: 20.w,
          right: 20.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundedButton(
                onPressed: () async {
                  final shouldPop = await controller.handleBackNavigation();
                  if (shouldPop) {
                    Get.back();
                  }
                },
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
        
        // Floating Try On Button
        Obx(() {
          final isLoading = controller.isTryOnLoading.value;
          final hasTryOnResults = controller.hasTryOnResults;
          
          return Positioned(
            bottom: 20.h,
            left: 20.w,
            child: GestureDetector(
              onTap: isLoading ? null : () => controller.generateTryOn(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isLoading 
                      ? Colors.grey[400]
                      : ThemeColors.getButtonBackground(isLightTheme),
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLoading)
                      SizedBox(
                        width: 16.sp,
                        height: 16.sp,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    else
                      Icon(
                        hasTryOnResults ? Icons.refresh : Icons.camera_alt,
                        color: ThemeColors.getButtonText(isLightTheme),
                        size: 20.sp,
                      ),
                    SizedBox(width: 8.w),
                    Text(
                      isLoading 
                          ? 'Loading...'
                          : (hasTryOnResults ? 'Try Again' : 'Try On'),
                      style: TextStyle(
                        color: ThemeColors.getButtonText(isLightTheme),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
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
  
  /// Open full-screen image gallery
  void _openFullScreenGallery(
    BuildContext context,
    int initialIndex,
    CmProductModel product,
    bool isLightTheme,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullScreenImageGallery(
          product: product,
          initialIndex: initialIndex,
          controller: controller,
          isLightTheme: isLightTheme,
        ),
      ),
    );
  }
}

/// Full-screen image gallery viewer
class _FullScreenImageGallery extends StatefulWidget {
  final CmProductModel product;
  final int initialIndex;
  final CmProductDetailsController controller;
  final bool isLightTheme;

  const _FullScreenImageGallery({
    required this.product,
    required this.initialIndex,
    required this.controller,
    required this.isLightTheme,
  });

  @override
  State<_FullScreenImageGallery> createState() => _FullScreenImageGalleryState();
}

class _FullScreenImageGalleryState extends State<_FullScreenImageGallery> {
  late PageController _pageController;
  final Map<int, TransformationController> _transformationControllers = {};
  final Map<int, bool> _isZoomed = {};
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _initializeControllers();
  }
  
  void _initializeControllers() {
    final totalImages = widget.controller.totalDisplayImageCount;
    for (int i = 0; i < totalImages; i++) {
      if (!_transformationControllers.containsKey(i)) {
        _transformationControllers[i] = TransformationController();
        _isZoomed[i] = false;
        _transformationControllers[i]!.addListener(() {
          final scale = _transformationControllers[i]!.value.getMaxScaleOnAxis();
          final wasZoomed = _isZoomed[i] ?? false;
          final isNowZoomed = scale > 1.0;
          if (wasZoomed != isNowZoomed) {
            setState(() {
              _isZoomed[i] = isNowZoomed;
            });
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _transformationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _resetZoom(int index) {
    _transformationControllers[index]?.value = Matrix4.identity();
    setState(() {
      _isZoomed[index] = false;
    });
  }

  bool _isCurrentPageZoomed() {
    return _isZoomed[_currentPageIndex] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.getScaffoldBackground(widget.isLightTheme),
      body: Stack(
        children: [
          Obx(() {
            _initializeControllers(); // Re-initialize if images changed
            final totalImages = widget.controller.totalDisplayImageCount;
            final isLoading = widget.controller.isTryOnLoading.value;
            
            return PageView.builder(
              controller: _pageController,
              physics: _isCurrentPageZoomed() 
                  ? const NeverScrollableScrollPhysics() 
                  : const PageScrollPhysics(),
              itemCount: totalImages,
              onPageChanged: (index) {
                // Reset zoom of previous page when changing pages
                if (_currentPageIndex != index) {
                  _resetZoom(_currentPageIndex);
                }
                setState(() {
                  _currentPageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final imageData = widget.controller.getDisplayImage(index);
                final isTryOnResult = widget.controller.isTryOnResult(index);
                
                Widget imageWidget;
                
                if (imageData == null) {
                  imageWidget = Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(Icons.image, size: 64.sp, color: Colors.grey),
                    ),
                  );
                } else if (isTryOnResult && imageData is Uint8List) {
                  // Show try-on result image
                  imageWidget = Image.memory(
                    imageData,
                    fit: BoxFit.contain,
                  );
                } else if (imageData is String) {
                  // Show original product image
                  imageWidget = SmartImage(
                    imageUrl: imageData,
                    fit: BoxFit.contain,
                  );
                } else {
                  imageWidget = Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(Icons.image, size: 64.sp, color: Colors.grey),
                    ),
                  );
                }
                
                // Show loading overlay if generating try-on and this is the first image
                if (isLoading && index == 0) {
                  imageWidget = Stack(
                    children: [
                      imageWidget,
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Colors.white,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'Generating try-on...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                
                // Wrap in GestureDetector for double tap
                return GestureDetector(
                  onDoubleTap: () {
                    _resetZoom(index);
                  },
                  child: InteractiveViewer(
                    transformationController: _transformationControllers[index],
                    minScale: 1.0,
                    maxScale: 5.0,
                    panEnabled: true,
                    scaleEnabled: true,
                    child: Center(
                      child: imageWidget,
                    ),
                  ),
                );
              },
            );
          }),
          // Header back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 20.h,
            left: 20.w,
            child: RoundedButton(
              onPressed: () async {
                final shouldPop = await widget.controller.handleBackNavigation();
                if (shouldPop) {
                  Get.back();
                }
              },
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: ThemeColors.getButtonText(widget.isLightTheme),
                size: 20.sp,
              ),
            ),
          ),
          // Floating Try On Button
          Obx(() {
            final isLoading = widget.controller.isTryOnLoading.value;
            final hasTryOnResults = widget.controller.hasTryOnResults;
            
            return Positioned(
              bottom: 20.h,
              left: 20.w,
              child: GestureDetector(
                onTap: isLoading ? null : () => widget.controller.generateTryOn(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isLoading 
                        ? Colors.grey[400]
                        : ThemeColors.getButtonBackground(widget.isLightTheme),
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLoading)
                        SizedBox(
                          width: 16.sp,
                          height: 16.sp,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      else
                        Icon(
                          hasTryOnResults ? Icons.refresh : Icons.camera_alt,
                          color: ThemeColors.getButtonText(widget.isLightTheme),
                          size: 20.sp,
                        ),
                      SizedBox(width: 8.w),
                      Text(
                        isLoading 
                            ? 'Loading...'
                            : (hasTryOnResults ? 'Try Again' : 'Try On'),
                        style: TextStyle(
                          color: ThemeColors.getButtonText(widget.isLightTheme),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          // Save/Unsave button for try-on results in full-screen gallery
          Obx(() {
            final isLoading = widget.controller.isTryOnLoading.value;
            final isTryOnResult = widget.controller.isTryOnResult(_currentPageIndex);
            final isSaved = widget.controller.isTryOnSaved(_currentPageIndex);
            
            if (!isTryOnResult || isLoading) {
              return const SizedBox.shrink();
            }
            
            return Positioned(
              bottom: 20.h,
              right: 20.w,
              child: GestureDetector(
                onTap: () {
                  if (isSaved) {
                    widget.controller.unsaveTryOnImage(_currentPageIndex);
                  } else {
                    widget.controller.saveTryOnImage(_currentPageIndex);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isSaved 
                        ? Colors.green
                        : ThemeColors.getButtonBackground(widget.isLightTheme),
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: isSaved 
                            ? Colors.white
                            : ThemeColors.getButtonText(widget.isLightTheme),
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        isSaved ? 'Unsave' : 'Save',
                        style: TextStyle(
                          color: isSaved 
                              ? Colors.white
                              : ThemeColors.getButtonText(widget.isLightTheme),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
