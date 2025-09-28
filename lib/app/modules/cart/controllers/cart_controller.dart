import 'package:closet_mate/models/cm_product_model.dart';
import 'package:closet_mate/app/services/products_service.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final ProductsService _productsService = ProductsService();
  
  // Cart items with quantity and selected variants
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    loadCartItems();
    super.onInit();
  }

  Future<void> loadCartItems() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // For now, load some sample products to demonstrate cart functionality
      // In a real app, this would load from local storage or user's cart API
      final products = await _productsService.getProducts(skip: 0, limit: 5);
      
      // Convert products to cart items with default quantities
      cartItems.assignAll(products.map((product) => CartItem(
        product: product,
        quantity: 1,
        selectedColor: product.availableColors.isNotEmpty ? product.availableColors.first : '',
        selectedSize: product.availableSizes.isNotEmpty ? product.availableSizes.first : '',
      )).toList());
      
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error loading cart items: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Add item to cart
  void addToCart(CmProductModel product, {String? color, String? size, int quantity = 1}) {
    final existingItemIndex = cartItems.indexWhere((item) => 
      item.product.id == product.id && 
      item.selectedColor == (color ?? product.availableColors.first) &&
      item.selectedSize == (size ?? product.availableSizes.first)
    );

    if (existingItemIndex != -1) {
      // Update existing item quantity
      cartItems[existingItemIndex].quantity += quantity;
    } else {
      // Add new item
      cartItems.add(CartItem(
        product: product,
        quantity: quantity,
        selectedColor: color ?? product.availableColors.first,
        selectedSize: size ?? product.availableSizes.first,
      ));
    }
  }

  // Remove item from cart
  void removeFromCart(String productId, String color, String size) {
    cartItems.removeWhere((item) => 
      item.product.id == productId && 
      item.selectedColor == color &&
      item.selectedSize == size
    );
  }

  // Update item quantity
  void updateQuantity(String productId, String color, String size, int quantity) {
    final itemIndex = cartItems.indexWhere((item) => 
      item.product.id == productId && 
      item.selectedColor == color &&
      item.selectedSize == size
    );

    if (itemIndex != -1) {
      if (quantity <= 0) {
        cartItems.removeAt(itemIndex);
      } else {
        // Create a new CartItem with updated quantity to trigger reactivity
        final currentItem = cartItems[itemIndex];
        cartItems[itemIndex] = CartItem(
          product: currentItem.product,
          quantity: quantity,
          selectedColor: currentItem.selectedColor,
          selectedSize: currentItem.selectedSize,
        );
      }
    }
  }

  // Get total price
  double get totalPrice {
    return cartItems.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  // Get total items count
  int get totalItems {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Get currency from cart items (assumes all items have same currency)
  String get currency {
    if (cartItems.isEmpty) return 'USD';
    return cartItems.first.product.currency;
  }

  // Clear cart
  void clearCart() {
    cartItems.clear();
  }

  // Checkout
  void checkout() {
    // TODO: Implement checkout logic
    Get.snackbar(
      'Checkout',
      'Checkout functionality will be implemented soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

// Cart item model
class CartItem {
  final CmProductModel product;
  int quantity;
  final String selectedColor;
  final String selectedSize;

  CartItem({
    required this.product,
    required this.quantity,
    required this.selectedColor,
    required this.selectedSize,
  });
}
