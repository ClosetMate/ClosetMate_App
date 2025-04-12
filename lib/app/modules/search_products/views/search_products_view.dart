import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/search_products_controller.dart';

class SearchProductsView extends GetView<SearchProductsController> {
  const SearchProductsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Search Page!!!!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
