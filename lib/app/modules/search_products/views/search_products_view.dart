import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:closet_mate/app/components/product_item.dart';
import 'package:closet_mate/config/theme/colors.dart';
import '../controllers/search_products_controller.dart';

class SearchProductsView extends GetView<SearchProductsController> {
  const SearchProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            // Remove focus when going back
            FocusScope.of(context).unfocus();
            controller.onBackPressed();
          },
        ),
        title: Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              // Remove focus when tapping outside
              FocusScope.of(context).unfocus();
            }
          },
          child: TextField(
            controller: controller.searchController,
            // autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            onChanged: (value) => controller.onSearchChanged(value),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () => _showFilterBottomSheet(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          GetBuilder<SearchProductsController>(
            builder: (_) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  if (controller.selectedCategory != null)
                    _buildFilterChip(
                      label: controller.selectedCategory!,
                      onDeleted: () => controller.setCategory(null),
                    ),
                  if (controller.selectedPriceRange != null)
                    _buildFilterChip(
                      label: controller.selectedPriceRange!,
                      onDeleted: () => controller.setPriceRange(null),
                    ),
                  if (controller.selectedSortBy != null)
                    _buildFilterChip(
                      label: controller.selectedSortBy!,
                      onDeleted: () => controller.setSortBy(null),
                    ),
                ],
              ),
            ),
          ),

          // Products Grid
          Expanded(
            child: GetBuilder<SearchProductsController>(
              builder: (_) => controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : controller.filteredProducts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No products found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: controller.filteredProducts.length,
                          itemBuilder: (context, index) {
                            return ProductItem(
                              product: controller.filteredProducts[index],
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onDeleted,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: onDeleted,
        backgroundColor: ColorConstants.appSpecificDark.withOpacity(0.5),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filters',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Category Filter
            const Text(
              'Category',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['All', 'Shirts', 'Pants', 'Dresses', 'Shoes']
                  .map((category) => ChoiceChip(
                        label: Text(category),
                        selected: controller.selectedCategory == category,
                        onSelected: (selected) {
                          if (selected) {
                            controller.setCategory(category);
                          }
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),

            // Price Range Filter
            const Text(
              'Price Range',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                '\$0 - \$50',
                '\$50 - \$100',
                '\$100 - \$200',
                '\$200+'
              ]
                  .map((range) => ChoiceChip(
                        label: Text(range),
                        selected: controller.selectedPriceRange == range,
                        onSelected: (selected) {
                          if (selected) {
                            controller.setPriceRange(range);
                          }
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),

            // Sort By Filter
            const Text(
              'Sort By',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                'Price: Low to High',
                'Price: High to Low',
                'Newest First',
                'Most Popular'
              ]
                  .map((sort) => ChoiceChip(
                        label: Text(sort),
                        selected: controller.selectedSortBy == sort,
                        onSelected: (selected) {
                          if (selected) {
                            controller.setSortBy(sort);
                          }
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.applyFilters();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.appSpecificDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
