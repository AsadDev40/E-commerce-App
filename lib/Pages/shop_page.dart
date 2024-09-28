// ignore_for_file: unused_field, unused_local_variable, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:myshop/models/wishlist_model.dart';
import 'package:myshop/provider/product_provider.dart';
import 'package:myshop/screens/product_detail_screen.dart';
import 'package:myshop/utils/utils.dart';
import 'package:myshop/models/product_model.dart';
import 'package:provider/provider.dart';

import 'search.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  late Future<List<ProductModel>> _productsFuture;
  late Future<WishlistModel> _wishlistFuture;

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    _productsFuture = productProvider.fetchProducts();
    _wishlistFuture = productProvider.fetchWishlist(userId);
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              scaffoldKey.currentState!
                  .showBottomSheet((context) => const ShopSearch());
            },
          )
        ],
        title: const Text('Shop'),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          List<ProductModel> products = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 products per row
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.8, // Adjust to suit the product card size
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              ProductModel product = products[index];

              return FutureBuilder<bool>(
                future: productProvider.isInWishlist(product.id, userId),
                builder: (context, wishlistSnapshot) {
                  if (wishlistSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  bool isInWishlist = wishlistSnapshot.data ?? false;

                  return GestureDetector(
                    onTap: () {
                      Utils.navigateTo(
                        context,
                        ProductDetailScreen(
                          imageUrl: product.productImageUrls,
                          title: product.title,
                          originalPrice:
                              double.parse(product.originalPrice).toString(),
                          price: double.parse(product.discountprice).toString(),
                          rating: product.rating,
                          description: product.description,
                          videoUrl: product.productvideourl,
                          id: product.id,
                          category: product.category,
                          color: product.color,
                          quantity: 1,
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            children: [
                              CachedNetworkImage(
                                height: 133,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                imageUrl: product.productImageUrls.first,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              Positioned(
                                left: 135,
                                child: Consumer<ProductProvider>(
                                    builder: (context, productProvider, child) {
                                  bool isInWishlist = productProvider
                                      .isInWishlistLocal(product.id);

                                  return IconButton(
                                    icon: Icon(
                                      isInWishlist
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isInWishlist
                                          ? Colors.red
                                          : Colors.white,
                                    ),
                                    onPressed: () {
                                      productProvider.toggleWishlist(
                                          product, userId);
                                    },
                                  );
                                }),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Text(
                              product.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '\$${product.discountprice}',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  '\$${product.originalPrice}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RatingStars(
                              value: product.averagerating ??
                                  0.0, // Provide a default value if averagerating is null
                              starSize: 14,
                              valueLabelColor: Colors.amber,
                              starColor: Colors.amber,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
