import 'package:closet_mate/app/data/products_data.dart';
import 'package:closet_mate/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:closet_mate/app/modules/base/controllers/base_controller.dart';

class SearchProductsController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  BaseController baseController = Get.find<BaseController>();
  
  String? selectedCategory;
  String? selectedPriceRange;
  String? selectedSortBy;

  @override
  void onInit() {
    super.onInit();
    _loadProducts();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _loadProducts() {
    isLoading = true;
    update();

    // Load products from the data source
    for (Map<String, dynamic> productMap in productsData) {
      allProducts.add(ProductModel.fromMap(productMap));
    }
    
    filteredProducts = List.from(allProducts);
    isLoading = false;
    update();
  }

  void onBackPressed() {
    baseController.onTabChange(0);
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      filteredProducts = List.from(allProducts);
    } else {
      filteredProducts = allProducts.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase()) ||
            product.category.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    _applyFilters();
    update();
  }

  void setCategory(String? category) {
    selectedCategory = category;
    update();
  }

  void setPriceRange(String? range) {
    selectedPriceRange = range;
    update();
  }

  void setSortBy(String? sort) {
    selectedSortBy = sort;
    update();
  }

  void applyFilters() {
    _applyFilters();
    update();
  }

  void _applyFilters() {
    List<ProductModel> tempProducts = List.from(allProducts);

    // Apply search query
    if (searchController.text.isNotEmpty) {
      tempProducts = tempProducts.where((product) {
        return product.name.toLowerCase().contains(searchController.text.toLowerCase()) ||
            product.description.toLowerCase().contains(searchController.text.toLowerCase()) ||
            product.category.toLowerCase().contains(searchController.text.toLowerCase());
      }).toList();
    }

    // Apply category filter
    if (selectedCategory != null && selectedCategory != 'All') {
      tempProducts = tempProducts.where((product) {
        return product.category.toLowerCase() == selectedCategory!.toLowerCase();
      }).toList();
    }

    // Apply price range filter
    if (selectedPriceRange != null) {
      tempProducts = tempProducts.where((product) {
        switch (selectedPriceRange) {
          case '\$0 - \$50':
            return product.currentPrice <= 50;
          case '\$50 - \$100':
            return product.currentPrice > 50 && product.currentPrice <= 100;
          case '\$100 - \$200':
            return product.currentPrice > 100 && product.currentPrice <= 200;
          case '\$200+':
            return product.currentPrice > 200;
          default:
            return true;
        }
      }).toList();
    }

    // Apply sorting
    if (selectedSortBy != null) {
      switch (selectedSortBy) {
        case 'Price: Low to High':
          tempProducts.sort((a, b) => a.currentPrice.compareTo(b.currentPrice));
          break;
        case 'Price: High to Low':
          tempProducts.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
          break;
        case 'Newest First':
          tempProducts.sort((a, b) => b.productId.compareTo(a.productId));
          break;
        case 'Most Popular':
          tempProducts.sort((a, b) => b.rating.compareTo(a.rating));
          break;
      }
    }

    filteredProducts = tempProducts;
  }
}
