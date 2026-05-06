import 'package:flutter/material.dart';

class BrandItem {
  final String name;
  final String logoUrl;

  BrandItem({required this.name, required this.logoUrl});
}

class BrandsSection extends StatelessWidget {
  final List<BrandItem> brands;
  final String? title;
  final Map<String, dynamic>? config;

  const BrandsSection({
    super.key, 
    required this.brands,
    this.title,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    final sectionTitle = title ?? 'Popular Brands';
    final showBrandNames = config?['show_brand_names'] ?? true;
    final brandsToShow = config?['brands_to_show'] ?? brands.length;
    
    // Limit brands based on config
    final limitedBrands = brands.take(brandsToShow).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            sectionTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: limitedBrands.length,
            itemBuilder: (context, index) {
              final brand = limitedBrands[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                        image: DecorationImage(
                          image: AssetImage(brand.logoUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (showBrandNames) ...[
                      const SizedBox(height: 4),
                      Text(
                        brand.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
} 