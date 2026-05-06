import 'package:closet_mate/app/routes/app_pages.dart';
import 'package:closet_mate/models/cm_product_model.dart';
import 'package:closet_mate/app/components/smart_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProductDetailCard extends StatelessWidget {
  const ProductDetailCard({super.key, required this.product});
  final CmProductModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: () => Get.toNamed(Routes.CM_PRODUCT_DETAILS, arguments: product.id),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: SmartImage(
                imageUrl: product.mainImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width / 1.2,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Allows dynamic height based on content
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ProductModel Name
                      Text(
                        product.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4), // Small spacing

                      // Price
                      Text(
                        '${product.currency} ${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Brand
                      Text(
                        product.brand,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
