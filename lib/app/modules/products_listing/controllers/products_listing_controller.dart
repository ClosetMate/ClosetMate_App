import 'package:closet_mate/models/cm_product_model.dart';
import 'package:closet_mate/app/services/products_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsListingController extends GetxController {
  // Services
  final ProductsService _productsService = ProductsService();

  // Observable data
  final RxList<CmProductModel> allProducts = <CmProductModel>[].obs;
  final RxList<CmProductModel> filteredProducts = <CmProductModel>[].obs;
  final RxString selectedCategory = ''.obs;
  final RxString selectedPriceRange = ''.obs;
  final RxString selectedSortBy = ''.obs;

  // Loading states
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Search functionality
  final TextEditingController searchController = TextEditingController();
  final RxString searchText = ''.obs;
  final RxBool isSearchMode = false.obs;

  // Pagination
  final RxInt currentPage = 0.obs;
  final RxInt itemsPerPage = 20.obs;
  final RxBool hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeFilters();
    _loadProducts();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _initializeFilters() {
    // Get initial filter from route parameters
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      final initialFilter = args['filter'] as String?;
      final isSearch = args['isSearch'] as bool? ?? false;
      
      if (isSearch) {
        isSearchMode.value = true;
        // Don't clear filters in search mode - keep them as they are
      } else if (initialFilter != null && initialFilter.isNotEmpty) {
        selectedCategory.value = initialFilter;
      }
    }
  }

  Future<void> _loadProducts({bool refresh = false}) async {
    try {
      if (refresh) {
        isLoading.value = true;
        currentPage.value = 0;
        allProducts.clear();
        filteredProducts.clear();
        hasMoreData.value = true;
      }

      if (!hasMoreData.value) return;

      final skip = currentPage.value * itemsPerPage.value;
      final loadedProducts = await _productsService.getProducts(
        skip: skip,
        limit: itemsPerPage.value,
      );

      if (refresh) {
        allProducts.assignAll(loadedProducts);
        filteredProducts.assignAll(loadedProducts);
      } else {
        allProducts.addAll(loadedProducts);
        filteredProducts.addAll(loadedProducts);
      }

      hasMoreData.value = loadedProducts.length == itemsPerPage.value;
      currentPage.value++;

      isLoading.value = false;
      hasError.value = false;
      errorMessage.value = '';
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
      print('Error loading products: $e');
    }
  }

  Future<void> refreshProducts() async {
    await _loadProducts(refresh: true);
  }

  Future<void> loadMoreProducts() async {
    if (!isLoading.value && hasMoreData.value) {
      await _loadProducts();
    }
  }

  void setCategory(String? category) {
    selectedCategory.value = category ?? '';
    _applyFilters();
  }

  void setPriceRange(String? range) {
    selectedPriceRange.value = range ?? '';
    _applyFilters();
  }

  void setSortBy(String? sort) {
    selectedSortBy.value = sort ?? '';
    _applyFilters();
  }

  void applyFilters() {
    _applyFilters();
  }

  void _applyFilters() {
    List<CmProductModel> tempProducts = List.from(allProducts);

    // Apply search query
    if (searchController.text.isNotEmpty) {
      tempProducts = tempProducts.where((product) {
        return product.name.toLowerCase().contains(searchController.text.toLowerCase()) ||
            product.description.toLowerCase().contains(searchController.text.toLowerCase()) ||
            product.brand.toLowerCase().contains(searchController.text.toLowerCase()) ||
            product.tags.any((tag) => tag.toLowerCase().contains(searchController.text.toLowerCase()));
      }).toList();
    }

    // Apply category filter
    if (selectedCategory.value.isNotEmpty && selectedCategory.value != 'All') {
      tempProducts = tempProducts.where((product) {
        return product.tags.any((tag) => tag.toLowerCase() == selectedCategory.value.toLowerCase());
      }).toList();
    }

    // Apply price range filter
    if (selectedPriceRange.value.isNotEmpty) {
      tempProducts = tempProducts.where((product) {
        switch (selectedPriceRange.value) {
          case '\$0 - \$50':
            return product.price <= 50;
          case '\$50 - \$100':
            return product.price > 50 && product.price <= 100;
          case '\$100 - \$200':
            return product.price > 100 && product.price <= 200;
          case '\$200+':
            return product.price > 200;
          default:
            return true;
        }
      }).toList();
    }

    // Apply sorting
    if (selectedSortBy.value.isNotEmpty) {
      switch (selectedSortBy.value) {
        case 'Price: Low to High':
          tempProducts.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'Price: High to Low':
          tempProducts.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'Newest First':
          tempProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
        case 'Most Popular':
          // Since we don't have rating, sort by creation date as fallback
          tempProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
      }
    }

    filteredProducts.assignAll(tempProducts);
  }

  void onSearchChanged(String query) {
    searchText.value = query;
    _applyFilters();
  }

  void clearSearch() {
    searchController.clear();
    searchText.value = '';
    _applyFilters();
  }

  void focusSearchField() {
    if (isSearchMode.value) {
      // This will be handled in the view
    }
  }
}
