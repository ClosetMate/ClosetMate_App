import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:closet_mate/config/theme/colors.dart';
import 'package:closet_mate/models/product_model.dart';
import 'package:closet_mate/app/components/product_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:closet_mate/app/data/products_data.dart';

class SwipeShoppingPage extends StatefulWidget {
  const SwipeShoppingPage({super.key});

  @override
  State<SwipeShoppingPage> createState() => _SwipeShoppingPageState();
}

class _SwipeShoppingPageState extends State<SwipeShoppingPage> {
  List<ProductDetailCard> profile = [];
  List<ProductModel> products = [];
  Map<String, dynamic> swipeAction = {'opacity': 0.0};
  AxisDirection direction = AxisDirection.down;

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AppinioSwiper(
            cardBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                    bottom: 130, top: 16), // Padding around each card
                child: profile[index],
              );
            },
            cardCount: profile.length,
            onSwipeEnd: (previousIndex, targetIndex, activity) {
              setState(() {
                swipeAction = {'opacity': 0.0};
              });
            },
            onCardPositionChanged: (
              SwiperPosition position,
            ) {
              var currentDirection = position.offset.toAxisDirection();
              if (currentDirection != direction) {
                setState(() {
                  swipeAction = {'opacity': 0.0};
                });
              }
              direction = currentDirection;
              double opacity = (position.offset.distance / 5).clamp(0.0, 1.0);
              setState(() {
                if (direction == AxisDirection.right) {
                  swipeAction = {
                    'top': MediaQuery.of(context).size.height / 3,
                    'left': null,
                    'right': 10.0,
                    'color': Colors.red,
                    'icon': Icons.favorite,
                    'opacity': opacity
                  };
                } else if (direction == AxisDirection.left) {
                  swipeAction = {
                    'top': MediaQuery.of(context).size.height / 3,
                    'left': 10.0,
                    'right': null,
                    'color': ColorConstants.close,
                    'icon': Icons.close,
                    'opacity': opacity
                  };
                } else if (direction == AxisDirection.up) {
                  swipeAction = {
                    'top': 20.0,
                    'left': 10.0,
                    'right': 10.0,
                    'color': ColorConstants.brightGreen,
                    'icon': Icons.shopping_cart,
                    'opacity': opacity
                  };
                } else {
                  swipeAction = {'opacity': 0.0};
                }
              });
            },
          ),

          // **Swipe Action Overlay**
          if (swipeAction['opacity'] != 0.0)
            Positioned(
              top: swipeAction['top'],
              left: swipeAction['left'],
              right: swipeAction['right'],
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                opacity: swipeAction['opacity'],
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(196, 255, 255, 255),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    swipeAction['icon'],
                    size: 40,
                    color: swipeAction['color'],
                  ),
                ),
              ),
            ),

          Positioned(
              bottom: 50,
              right: 0,
              left: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close,
                        color: ColorConstants.close,
                        size: 32,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.shopping_cart,
                        color: ColorConstants.brightGreen,
                        size: 32,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: ColorConstants.favorite,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  void _getProducts() {
    for (Map<String, dynamic> productMap in productsData) {
      products.add(ProductModel.fromMap(productMap));
    }
    _loadCards();
  }

  void _loadCards() {
    for (ProductModel product in products) {
      profile.add(ProductDetailCard(product: product));
    }
  }
}
