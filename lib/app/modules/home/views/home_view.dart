import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:closet_mate/app/modules/home/controllers/home_controller.dart';
import 'package:closet_mate/models/cm_product_model.dart';
import 'package:closet_mate/models/dynamic_section.dart';
import 'package:closet_mate/app/modules/home/views/widgets/brands_section.dart';
import 'package:closet_mate/app/components/custom_app_bar.dart';
import 'package:closet_mate/app/modules/base/controllers/base_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    Color bgColor = isLightTheme ? Colors.white : Colors.black;
    Color textColor = isLightTheme ? const Color(0xFF1A1A1A) : Colors.white;
    Color brand500 = const Color(0xFF6B7280);
    Color cardColor = isLightTheme ? const Color(0xFFF9FAFB) : Colors.grey.shade900;

    final baseController = Get.isRegistered<BaseController>() ? Get.find<BaseController>() : null;

    return GetBuilder<HomeController>(
      builder: (_) => Scaffold(
        backgroundColor: bgColor,
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(
          previousIndex: 0,
          onTabChange: baseController?.onTabChange ?? (int index) {},
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.hasError.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${controller.errorMessage.value}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.refreshContent(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final layout = controller.homeLayout.value;
          if (layout == null) {
            return const Center(child: Text('No layout configuration found'));
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + kToolbarHeight + 16,
                    bottom: 100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAiOutfitSection(textColor, brand500),
                      ...layout.sections.map((section) {
                        if (!section.enabled) return const SizedBox.shrink();

                        switch (section.type) {
                          case 'trending_deals':
                            return _buildProductCarousel(
                              title: section.title,
                              products: controller.trendingDeals,
                              textColor: textColor,
                              brand500: brand500,
                              cardColor: cardColor,
                              isLarge: false,
                            );
                          case 'products':
                            final category = section.config['category'] ?? 'products';
                            final products = controller.getProductsForSection(category);
                            return _buildProductCarousel(
                              title: section.title,
                              products: products,
                              textColor: textColor,
                              brand500: brand500,
                              cardColor: cardColor,
                              isLarge: true,
                            );
                          case 'brands':
                            return _buildBrandsCarousel(
                              title: section.title,
                              brands: controller.featuredBrands,
                              textColor: textColor,
                              cardColor: cardColor,
                            );
                          default:
                            return const SizedBox.shrink();
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildAiOutfitSection(Color textColor, Color brand500) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AI OUTFIT OF THE DAY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.0,
                  color: brand500,
                ),
              ),
              Icon(Icons.auto_awesome, size: 16, color: brand500),
            ],
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 4 / 5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(Icons.favorite_border, color: Colors.white, size: 24),
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    left: 24,
                    right: 24,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Try On Outfit',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildProductCarousel({
    required String title,
    required List<CmProductModel> products,
    required Color textColor,
    required Color brand500,
    required Color cardColor,
    required bool isLarge,
  }) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  color: textColor,
                ),
              ),
              if (!isLarge)
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/products-listing', arguments: {'filter': title});
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: brand500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: isLarge ? 300 : 250,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (context, index) => const SizedBox(width: 20),
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed('/cm-product-details', arguments: product.id);
                },
                child: SizedBox(
                  width: isLarge ? 200 : 140,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              product.mainImage.startsWith('http')
                                  ? Image.network(
                                      product.mainImage,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade300),
                                    )
                                  : Image.asset(
                                      product.mainImage,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade300),
                                    ),
                              Positioned(
                                top: isLarge ? 12 : 8,
                                right: isLarge ? 12 : 8,
                                child: Container(
                                  padding: EdgeInsets.all(isLarge ? 8 : 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(Icons.favorite_border, color: isLarge ? textColor : Colors.red, size: isLarge ? 18 : 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.brand,
                              style: TextStyle(
                                fontSize: isLarge ? 16 : 14,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '\$${product.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: isLarge ? 16 : 14,
                              fontWeight: FontWeight.w600,
                              color: brand500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildBrandsCarousel({
    required String title,
    required List<BrandItem> brands,
    required Color textColor,
    required Color cardColor,
  }) {
    if (brands.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: brands.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final brand = brands[index];
              return Container(
                width: 100,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(brand.logoUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      brand.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}