import 'package:closet_mate/models/product_model.dart';
import 'package:get/get.dart';
import 'package:closet_mate/app/data/products_data.dart';
import 'package:closet_mate/app/modules/home/views/widgets/brands_section.dart';

class HomeController extends GetxController {
  late String selectedValue = 'Female';
  late List<String> items = ['Men', 'Female', 'Unisex'];

  List<ProductModel> products = [];
  final Set<int> favoriteIndexes = {};

  final List<BrandItem> brands = [
    BrandItem(
      name: 'Nike',
      logoUrl: 'assets/images/brands/nike.webp',
    ),
    BrandItem(
      name: 'Adidas',
      logoUrl: 'assets/images/brands/adidas.jpg',
    ),
    BrandItem(
      name: 'Puma',
      logoUrl: 'assets/images/brands/puma.png',
    ),
    BrandItem(
      name: 'Zara',
      logoUrl: 'assets/images/brands/zara.jpg',
    ),
    BrandItem(
      name: 'H&M',
      logoUrl: 'assets/images/brands/h&m.jpg',
    ),
    BrandItem(
      name: 'Gucci',
      logoUrl: 'assets/images/brands/gucci.png',
    ),
  ];

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
