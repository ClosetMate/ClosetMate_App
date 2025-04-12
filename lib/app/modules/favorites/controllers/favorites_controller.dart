import 'package:closet_mate/models/product_model.dart';
import 'package:get/get.dart';
import 'package:closet_mate/app/data/products_data.dart';

class FavoritesController extends GetxController {
  late String selectedValue = 'Female';
  late List<String> items = ['Men', 'Female', 'Unisex'];

  List<ProductModel> products = [];
  final Set<int> favoriteIndexes = {};
  
  @override
  void onInit() async {
    _getProducts();
    super.onInit();
  }

  void _getProducts() {
    for (Map<String, dynamic> productMap in productsData) {
      products.add(ProductModel.fromMap(productMap));
    }
  }

  void setSelectedValue(String value) {
    selectedValue = value;
    update();
  }
}
