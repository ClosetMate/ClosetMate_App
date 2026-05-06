import 'package:flutter/material.dart';
import 'package:closet_mate/models/dynamic_section.dart';
import 'package:closet_mate/models/cm_product_model.dart';
import 'package:closet_mate/app/modules/home/views/widgets/brands_section.dart';
import 'package:closet_mate/app/modules/home/views/widgets/products_section.dart';
import 'package:closet_mate/app/modules/home/views/widgets/trending_deals_carousel.dart';
import 'package:closet_mate/app/modules/home/views/widgets/promotional_banner.dart';

class DynamicSectionWidget extends StatelessWidget {
  final DynamicSection section;
  final List<CmProductModel>? products;
  final List<BrandItem>? brands;
  final Map<String, dynamic>? promotionalData;

  const DynamicSectionWidget({
    super.key,
    required this.section,
    this.products,
    this.brands,
    this.promotionalData,
  });

  @override
  Widget build(BuildContext context) {
    if (!section.enabled) {
      return const SizedBox.shrink();
    }

    switch (section.type) {
      case 'trending_deals':
        return _buildTrendingDeals();
      case 'brands':
        return _buildBrands();
      case 'products':
        return _buildProducts();
      case 'promotional_banner':
        return _buildPromotionalBanner();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTrendingDeals() {
    if (products == null || products!.isEmpty) {
      return const SizedBox.shrink();
    }

    return TrendingDealsCarousel(
      deals: products!,
      title: section.title,
      config: section.config,
    );
  }

  Widget _buildBrands() {
    if (brands == null || brands!.isEmpty) {
      return const SizedBox.shrink();
    }

    return BrandsSection(
      brands: brands!,
      title: section.title,
      config: section.config,
    );
  }

  Widget _buildProducts() {
    if (products == null || products!.isEmpty) {
      return const SizedBox.shrink();
    }

    final category = section.config['category'] ?? 'products';
    final showViewAll = section.config['show_view_all'] ?? true;
    final itemsToShow = section.config['items_to_show'] ?? products!.length;

    // Limit products based on config
    final limitedProducts = products!.take(itemsToShow).toList();

    return ProductsSection(
      products: limitedProducts,
      sectionTitle: section.title,
      showViewAll: showViewAll,
      category: category,
    );
  }

  Widget _buildPromotionalBanner() {
    if (promotionalData == null) {
      return const SizedBox.shrink();
    }

    return PromotionalBanner(
      text: promotionalData!['text'] ?? 'Special Offer!',
      color: promotionalData!['color'] ?? '#FF6B6B',
      actionUrl: promotionalData!['action_url'] ?? '/',
    );
  }
} 