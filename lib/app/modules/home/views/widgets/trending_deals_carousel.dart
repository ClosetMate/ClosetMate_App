import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:closet_mate/models/cm_product_model.dart';
import 'package:closet_mate/app/routes/app_pages.dart';
import 'package:get/get.dart';

class TrendingDealsCarousel extends StatelessWidget {
  final List<CmProductModel> deals;
  final String? title;
  final Map<String, dynamic>? config;

  const TrendingDealsCarousel({
    super.key, 
    required this.deals,
    this.title,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
  bool isLightTheme = Get.isDarkMode == false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.getTextPrimary(isLightTheme),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to products listing page with trending deals filter
                    Get.toNamed(
                      Routes.PRODUCTS_LISTING,
                      arguments: {
                        'filter': title ?? 'Trending Deals',
                        'category': 'trending_deals',
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        "View All",
                        style: TextStyle(fontSize: 14, color: ThemeColors.getTextSecondary(isLightTheme)),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: ThemeColors.getTextSecondary(isLightTheme),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            autoPlay: config?['auto_play'] ?? true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            autoPlayInterval: Duration(seconds: config?['auto_play_interval'] ?? 3),
          ),
          items: deals.map((product) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          product.mainImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                                size: 50,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
