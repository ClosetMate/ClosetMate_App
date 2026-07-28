import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:closet_mate/models/cm_product_model.dart';
import '../controllers/favorites_controller.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    Color bgColor = isLightTheme ? Colors.white : Colors.black;
    Color textColor = isLightTheme ? const Color(0xFF1A1A1A) : Colors.white;
    Color brand500 = const Color(0xFF6B7280);
    Color brand900 = isLightTheme ? const Color(0xFF1A1A1A) : Colors.white;
    Color brand50 = isLightTheme ? const Color(0xFFF9FAFB) : Colors.grey.shade900;
    Color cardBg = isLightTheme ? const Color(0xFFF3F4F6) : Colors.grey.shade900;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MY WARDROBE',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: brand900,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: brand50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.search, size: 20, color: brand900),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: brand900,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: brand900.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(Icons.add, size: 20, color: isLightTheme ? Colors.white : Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Segmented Control
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: brand50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Obx(() {
                      return Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.setActiveTab('closet'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: controller.activeMainTab.value == 'closet'
                                      ? (isLightTheme ? Colors.white : Colors.grey.shade800)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: controller.activeMainTab.value == 'closet'
                                      ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Closet',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: controller.activeMainTab.value == 'closet' ? brand900 : brand500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.setActiveTab('likes'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: controller.activeMainTab.value == 'likes'
                                      ? (isLightTheme ? Colors.white : Colors.grey.shade800)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: controller.activeMainTab.value == 'likes'
                                      ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Likes',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: controller.activeMainTab.value == 'likes' ? brand900 : brand500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Content Area
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.activeMainTab.value == 'closet') {
                  return _buildClosetTab(textColor, brand500, brand900, brand50, cardBg, isLightTheme);
                } else {
                  return _buildLikesTab(textColor, brand500, brand900, cardBg);
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClosetTab(Color textColor, Color brand500, Color brand900, Color brand50, Color cardBg, bool isLightTheme) {
    return Column(
      children: [
        // Categories Horizontal Scroll
        SizedBox(
          height: 50,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = controller.categories[index];
              return Obx(() {
                final isActive = controller.activeCategory.value == cat;
                return GestureDetector(
                  onTap: () => controller.setActiveCategory(cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isActive ? brand900 : brand50,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isActive ? (isLightTheme ? Colors.white : Colors.black) : brand500,
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        
        // Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 100),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemCount: controller.filteredWardrobe.length,
            itemBuilder: (context, index) {
              final item = controller.filteredWardrobe[index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed('/cm-product-details', arguments: item.id);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: item.mainImage.startsWith('http')
                            ? Image.network(
                                item.mainImage,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade300),
                              )
                            : Image.asset(
                                item.mainImage,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade300),
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: brand900,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        item.tags.isNotEmpty ? item.tags.first : '',
                        style: TextStyle(
                          fontSize: 12,
                          color: brand500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLikesTab(Color textColor, Color brand500, Color brand900, Color cardBg) {
    // Reusing products for Likes tab, but simulating "Likes" UI with price
    final likes = controller.products.where((p) => p.price > 0).toList();

    return GridView.builder(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.60, // Slightly taller to fit price
      ),
      itemCount: likes.length,
      itemBuilder: (context, index) {
        final item = likes[index];
        return GestureDetector(
          onTap: () {
            Get.toNamed('/cm-product-details', arguments: item.id);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      item.mainImage.startsWith('http')
                          ? Image.network(
                              item.mainImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade300),
                            )
                          : Image.asset(
                              item.mainImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade300),
                            ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.favorite, color: Colors.red, size: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  item.brand,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: brand900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: brand500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '\$${item.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: brand900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
