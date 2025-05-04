import 'package:closet_mate/models/product_model.dart';
import 'package:get/get.dart';
import 'package:closet_mate/app/data/products_data.dart';

class CartController extends GetxController {

  List<ProductModel> products = [];

  @override
  void onInit() {
    _getProducts();
    super.onInit();
  }

  void _getProducts() {
    for (Map<String, dynamic> productMap in productsData) {
      products.add(ProductModel.fromMap(productMap));
    }
  }
}
