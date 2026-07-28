import 'package:closet_mate/app/modules/swipe_shopping/views/swipe_product_card.dart';
import 'package:closet_mate/models/cm_product_model.dart';
import 'package:closet_mate/app/services/products_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:closet_mate/config/theme/theme_colors.dart';

class SwipeShoppingController extends GetxController {
  final ProductsService _productsService = ProductsService();
  
  List<Widget> productCards = [];
  final RxList<CmProductModel> products = <CmProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  Map<String, dynamic> swipeAction = {'opacity': 0.0};
  AxisDirection direction = AxisDirection.down;
  
  final AppinioSwiperController swiperController = AppinioSwiperController();

  // Filter options
  String selectedCategory = 'All';
  String selectedSize = 'All';
  String selectedPriceRange = 'All';
  String selectedBrand = 'All';
  String selectedColor = 'All';

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }


  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final fetchedProducts = await _productsService.getProducts(skip: 0, limit: 20);
      products.assignAll(fetchedProducts);
      _loadCards();
      
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error loading products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _loadCards() {
    productCards.clear();
    for (CmProductModel product in products) {
      productCards.add(SwipeProductCard(product: product));
    }
  }

  void showFilterDialog(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: ThemeColors.getCardBackground(isLightTheme),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Filter Products',
                style: TextStyle(
                  color: ThemeColors.getTextPrimary(isLightTheme),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFilterSection(
                      'Category',
                      ['All', 'Tops', 'Bottoms', 'Dresses', 'Shoes', 'Accessories'],
                      selectedCategory,
                      (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                      isLightTheme,
                    ),
                    SizedBox(height: 16),
                    _buildFilterSection(
                      'Size',
                      ['All', 'XS', 'S', 'M', 'L', 'XL', 'XXL'],
                      selectedSize,
                      (value) {
                        setState(() {
                          selectedSize = value!;
                        });
                      },
                      isLightTheme,
                    ),
                    SizedBox(height: 16),
                    _buildFilterSection(
                      'Price Range',
                      ['All', 'Under \$50', '\$50 - \$100', '\$100 - \$200', 'Over \$200'],
                      selectedPriceRange,
                      (value) {
                        setState(() {
                          selectedPriceRange = value!;
                        });
                      },
                      isLightTheme,
                    ),
                    SizedBox(height: 16),
                    _buildFilterSection(
                      'Brand',
                      ['All', 'Nike', 'Adidas', 'Zara', 'H&M', 'Uniqlo', 'Levi\'s'],
                      selectedBrand,
                      (value) {
                        setState(() {
                          selectedBrand = value!;
                        });
                      },
                      isLightTheme,
                    ),
                    SizedBox(height: 16),
                    _buildFilterSection(
                      'Color',
                      ['All', 'Black', 'White', 'Red', 'Blue', 'Green', 'Yellow', 'Pink'],
                      selectedColor,
                      (value) {
                        setState(() {
                          selectedColor = value!;
                        });
                      },
                      isLightTheme,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _resetFilters();
                    setState(() {});
                  },
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: ThemeColors.getTextSecondary(isLightTheme),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: ThemeColors.getTextSecondary(isLightTheme),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _applyFilters();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.getAccent(isLightTheme),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Apply',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String selectedValue,
    Function(String?) onChanged,
    bool isLightTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: ThemeColors.getTextPrimary(isLightTheme),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: ThemeColors.getTextHint(isLightTheme),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: ThemeColors.getTextHint(isLightTheme),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: ThemeColors.getAccent(isLightTheme),
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          dropdownColor: ThemeColors.getCardBackground(isLightTheme),
          style: TextStyle(
            color: ThemeColors.getTextPrimary(isLightTheme),
          ),
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _resetFilters() {
    selectedCategory = 'All';
    selectedSize = 'All';
    selectedPriceRange = 'All';
    selectedBrand = 'All';
    selectedColor = 'All';
  }

  void _applyFilters() {
    // TODO: Implement actual filtering logic
    // For now, just update the controller state
    update();
    Get.snackbar(
      'Filters Applied',
      'Your filters have been applied successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: ThemeColors.getAccent(true),
      colorText: Colors.white,
    );
  }
}
