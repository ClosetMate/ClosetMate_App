import 'package:get/get.dart';
import 'package:closet_mate/models/order_model.dart';

class OrdersController extends GetxController {
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Replace with actual API call to fetch orders
      // For now, using mock data
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      
      // Mock orders data - replace with actual API call
      orders.value = _getMockOrders();
      
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error loading orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOrders() async {
    await loadOrders();
  }

  // Mock data - remove when implementing actual API
  List<OrderModel> _getMockOrders() {
    return [
      OrderModel(
        id: '1',
        orderNumber: 'ORD-2024-001',
        items: [
          OrderItem(
            productId: 'mock_1',
            productName: 'Classic Denim Jacket',
            productImage: 'assets/images/products/p1_0.png',
            price: 89.99,
            quantity: 1,
            size: 'M',
            color: 'Blue',
          ),
        ],
        totalAmount: 89.99,
        currency: 'USD',
        status: 'delivered',
        orderDate: DateTime.now().subtract(const Duration(days: 15)),
        deliveryDate: DateTime.now().subtract(const Duration(days: 10)),
      ),
      OrderModel(
        id: '2',
        orderNumber: 'ORD-2024-002',
        items: [
          OrderItem(
            productId: 'mock_2',
            productName: 'Slim Fit Chinos',
            productImage: 'assets/images/products/p2_0.png',
            price: 59.99,
            quantity: 2,
            size: 'L',
            color: 'Khaki',
          ),
          OrderItem(
            productId: 'mock_3',
            productName: 'Cotton T-Shirt',
            productImage: 'assets/images/products/p3_0.png',
            price: 29.99,
            quantity: 3,
            size: 'M',
            color: 'White',
          ),
        ],
        totalAmount: 209.95,
        currency: 'USD',
        status: 'shipped',
        orderDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
      OrderModel(
        id: '3',
        orderNumber: 'ORD-2024-003',
        items: [
          OrderItem(
            productId: 'mock_3',
            productName: 'Cotton T-Shirt',
            productImage: 'assets/images/products/p3_0.png',
            price: 29.99,
            quantity: 3,
            size: 'M',
            color: 'White',
          ),
        ],
        totalAmount: 89.97,
        currency: 'USD',
        status: 'processing',
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }
}

