import 'package:closet_mate/config/theme/colors.dart';
import 'package:closet_mate/models/product_model.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserInfoPage extends StatelessWidget {
  UserInfoPage({Key? key, required this.product, x}) : super(key: key);
  final ProductModel product;
  List<String> images = [];

  @override
  Widget build(BuildContext context) {
    images = product.otherImageUrls;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: ColorConstants.primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: IconButton(
              icon: Icon(
                Icons.more_vert,
                color: ColorConstants.primaryColor,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                margin: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.only(bottomLeft: Radius.circular(50)),
                  image: DecorationImage(
                    image: AssetImage(product.imageUrl),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                    scale: 1.1,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(product.name,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: ColorConstants.secondary)),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(product.currency + product.price.toString(),
                        style: TextStyle(
                          color: ColorConstants.secondary, fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors
                              .red, // Optional: Change color of strike-through line
                          decorationThickness: 2.0,
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(product.currency + product.currentPrice.toString(),
                        style: TextStyle(
                            color: ColorConstants.secondary,
                            fontSize: 25,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(
                      height: 32,
                    ),
                    Text('PRODUCT DESCRIPTION',
                        style: TextStyle(
                            color: ColorConstants.secondary,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(product.description,
                        style: TextStyle(
                            color: ColorConstants.secondary,
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.normal)),
                    const SizedBox(
                      height: 32,
                    ),
                    Text('CATEGORY',
                        style: TextStyle(
                            color: ColorConstants.secondary,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(
                      height: 8,
                    ),
                    Wrap(
                      spacing: 10,
                      children: [
                        _chip(
                            background: ColorConstants.lightOrange,
                            color: ColorConstants.brightOrange,
                            title: product.category),
                        // _chip(background: ColorConstants.lightBlue, color: ColorConstants.brightBlue, title: 'Dance'),
                        // _chip(background: ColorConstants.lightOrange1, color: ColorConstants.brightOrange1, title: 'Fitness'),
                        // _chip(background: ColorConstants.lightPurple, color: ColorConstants.brightPurple, title: 'Reading'),
                        // _chip(background: ColorConstants.lightPurple1, color: ColorConstants.brightPurple1, title: 'Photography'),
                        // _chip(background: ColorConstants.lightGreen, color: ColorConstants.brightGreen, title: 'Music'),
                        // _chip(background: ColorConstants.lightPink, color: ColorConstants.brightPink, title: 'Movie'),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text('MORE IMAGES',
                        style: TextStyle(
                            color: ColorConstants.secondary,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 290,
                            height: 290,
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(images[index]),
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topCenter,
                                // scale: 1.1,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 150,
                    )
                  ],
                ),
              ),
            ),
          ]),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.only(bottom: 50),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white,
                    Colors.white,
                    Colors.white.withOpacity(0.6),
                    Colors.white.withOpacity(0),
                  ],
                ),
              ),
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
                        Icons.star,
                        color: ColorConstants.star,
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
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _chip(
      {required Color background,
      required Color color,
      required String title}) {
    return Chip(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      label: Text(title, style: TextStyle(color: color)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      backgroundColor: background,
    );
  }
}
