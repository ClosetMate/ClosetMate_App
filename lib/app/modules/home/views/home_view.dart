import 'package:closet_mate/app/modules/home/controllers/home_controller.dart';
import 'package:closet_mate/app/modules/home/views/widgets/products_section.dart';
import 'package:closet_mate/app/modules/home/views/widgets/trending_deals_carousel.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (_) => Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TrendingDealsCarousel(deals: controller.products),
              ProductsSection(
                products: controller.products,
                sectionTitle: 'Top Selling',
              ),
              // SizedBox(height: 24),
              ProductsSection(
                products: controller.products,
                sectionTitle: 'New Arrivals',
              ),
              // SizedBox(height: 24),
              ProductsSection(
                products: controller.products,
                sectionTitle: 'Recommended',
              ),
            ],
          ),
        ),
      ),
    );
  }
}