import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:closet_mate/models/product_model.dart';

class TrendingDealsCarousel extends StatelessWidget {
  final List<ProductModel> deals;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
                        Image.asset(
                          product.imageUrl,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              product.name,
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
