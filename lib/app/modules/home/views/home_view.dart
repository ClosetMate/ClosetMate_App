import 'package:closet_mate/app/modules/home/controllers/home_controller.dart';
import 'package:closet_mate/app/modules/home/views/widgets/dynamic_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (_) => Scaffold(
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading...'),
                ],
              ),
            );
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
            return const Center(
              child: Text('No layout configuration found'),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshContent,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Render dynamic sections based on configuration
                  ...layout.sections.map((section) {
                    switch (section.type) {
                      case 'trending_deals':
                        return DynamicSectionWidget(
                          section: section,
                          products: controller.trendingDeals,
                        );
                      case 'brands':
                        return DynamicSectionWidget(
                          section: section,
                          brands: controller.featuredBrands,
                        );
                      case 'products':
                        final category = section.config['category'] ?? 'products';
                        final products = controller.getProductsForSection(category);
                        return DynamicSectionWidget(
                          section: section,
                          products: products,
                        );
                      case 'promotional_banner':
                        return DynamicSectionWidget(
                          section: section,
                          promotionalData: controller.promotionalBanner.value,
                        );
                      default:
                        return const SizedBox.shrink();
                    }
                  }),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}