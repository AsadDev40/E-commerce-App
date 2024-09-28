import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Pages/category_page.dart';
import 'package:myshop/Pages/shop_page.dart';
import 'package:myshop/Pages/cart_page.dart';
import 'package:myshop/Pages/wishlist.dart';
import 'package:myshop/models/category_model.dart';
import 'package:myshop/models/product_model.dart';
import 'package:myshop/provider/category_provider.dart';
import 'package:myshop/provider/product_provider.dart';
import 'package:myshop/screens/category_screen.dart';
import 'package:myshop/screens/product_detail_screen.dart';
import 'package:myshop/utils/utils.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final categoryprovider = Provider.of<CategoryProvider>(context);
    final productprovider = Provider.of<ProductProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Container(
                  height: 500,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.jpg'),
                          fit: BoxFit.cover)),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [
                          Colors.black.withOpacity(.8),
                          Colors.black.withOpacity(.2),
                        ])),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FadeInUp(
                                  duration: const Duration(milliseconds: 1200),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Utils.navigateTo(
                                          context, const WishList());
                                    },
                                  )),
                              FadeInUp(
                                  duration: const Duration(milliseconds: 1300),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.shopping_cart,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Utils.navigateTo(
                                          context, const CartList());
                                    },
                                  )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FadeInUp(
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    child: const Text(
                                      "Our New Products",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    )),
                                const SizedBox(
                                  height: 15,
                                ),
                                FadeInUp(
                                    duration:
                                        const Duration(milliseconds: 1700),
                                    child: Row(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            Utils.navigateTo(
                                                context, const Shop());
                                          },
                                          child: const Text(
                                            "VIEW MORE",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 15,
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            FadeInUp(
                duration: const Duration(milliseconds: 1400),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "Categories",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            child: const Text("All"),
                            onTap: () {
                              Utils.navigateTo(context, const CategoryScreen());
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 150,
                        child: Consumer<CategoryProvider>(
                          builder: (context, categoryProvider, child) {
                            if (categoryProvider.categories.isEmpty) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categoryProvider.categories.length,
                              itemBuilder: (context, index) {
                                final category =
                                    categoryProvider.categories[index];
                                return makeCategory(
                                    image: category
                                        .categoryImageurl, // Assuming image path
                                    title: category.categoryName,
                                    tag: category.categoryId,
                                    category: category.categoryName);
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "Best Selling by Category",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            child: const Text("All"),
                            onTap: () {
                              Utils.navigateTo(context, const CategoryScreen());
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 150,
                        child: FutureBuilder<List<CategoryModel>>(
                          future: categoryprovider.fetchCategoriesByType(
                              'Best Selling'), // Fetch categories by type directly
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child:
                                      CircularProgressIndicator()); // Show loading spinner
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                      'Error: ${snapshot.error}')); // Show error message
                            } else if (snapshot.hasData &&
                                snapshot.data!.isNotEmpty) {
                              final categories = snapshot.data!;
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  final category = categories[index];
                                  return makeBestCategory(
                                    image: category.categoryImageurl,
                                    title: category.categoryName,
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                  child: Text('No categories found.'));
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "Summer Sale - 50% Off",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                              onTap: () {
                                Utils.navigateTo(context, const Shop());
                              },
                              child: const Text("All"))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 150,
                        child: FutureBuilder<List<ProductModel>>(
                          future: productprovider.fetchProductsBysale(
                              'Summer Sale - 50% Off'), // Fetch categories by type directly
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child:
                                      CircularProgressIndicator()); // Show loading spinner
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                      'Error: ${snapshot.error}')); // Show error message
                            } else if (snapshot.hasData &&
                                snapshot.data!.isNotEmpty) {
                              final products = snapshot.data!;
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  final ProductModel newproduct = ProductModel(
                                      id: product.id,
                                      title: product.title,
                                      category: product.category,
                                      description: product.description,
                                      productImageUrls:
                                          product.productImageUrls,
                                      productvideourl: product.productvideourl,
                                      discountprice: product.discountprice,
                                      originalPrice: product.originalPrice,
                                      rating: product.rating,
                                      color: product.color);

                                  return productwidget(product: newproduct);
                                },
                              );
                            } else {
                              return const Center(
                                  child: Text('No Sale  found.'));
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "Clearance Sale - 30% Off",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                              onTap: () {
                                Utils.navigateTo(context, const Shop());
                              },
                              child: const Text("All"))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 150,
                        child: FutureBuilder<List<ProductModel>>(
                          future: productprovider.fetchProductsBysale(
                              'Clearance Sale - 30% Off'), // Fetch categories by type directly
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child:
                                      CircularProgressIndicator()); // Show loading spinner
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                      'Error: ${snapshot.error}')); // Show error message
                            } else if (snapshot.hasData &&
                                snapshot.data!.isNotEmpty) {
                              final products = snapshot.data!;
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  final ProductModel newproduct = ProductModel(
                                      id: product.id,
                                      title: product.title,
                                      category: product.category,
                                      description: product.description,
                                      productImageUrls:
                                          product.productImageUrls,
                                      productvideourl: product.productvideourl,
                                      discountprice: product.discountprice,
                                      originalPrice: product.originalPrice,
                                      rating: product.rating,
                                      color: product.color);
                                  return productwidget(product: newproduct);
                                },
                              );
                            } else {
                              return const Center(
                                  child: Text('No Sale  found.'));
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "Winter Sale - 40% Off",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                              onTap: () {
                                Utils.navigateTo(context, const Shop());
                              },
                              child: const Text("All"))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 150,
                        child: FutureBuilder<List<ProductModel>>(
                          future: productprovider.fetchProductsBysale(
                              'Winter Sale - 40% Off'), // Fetch categories by type directly
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child:
                                      CircularProgressIndicator()); // Show loading spinner
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                      'Error: ${snapshot.error}')); // Show error message
                            } else if (snapshot.hasData &&
                                snapshot.data!.isNotEmpty) {
                              final products = snapshot.data!;
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  final ProductModel newproduct = ProductModel(
                                      id: product.id,
                                      title: product.title,
                                      category: product.category,
                                      description: product.description,
                                      productImageUrls:
                                          product.productImageUrls,
                                      productvideourl: product.productvideourl,
                                      discountprice: product.discountprice,
                                      originalPrice: product.originalPrice,
                                      rating: product.rating,
                                      color: product.color);

                                  return productwidget(product: newproduct);
                                },
                              );
                            } else {
                              return const Center(
                                  child: Text('No Sale  found.'));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget makeCategory({image, title, tag, category}) {
    return AspectRatio(
      aspectRatio: 2 / 2.2,
      child: Hero(
        tag: tag,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CategoryPage(
                          image: image,
                          title: title,
                          tag: tag,
                          category: category,
                        )));
          },
          child: Material(
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  // Network Image with loading indicator
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child; // Image is fully loaded
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          ); // Show loading indicator
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.error, color: Colors.red),
                        ); // Show error icon if image fails to load
                      },
                    ),
                  ),
                  // Gradient overlay and title
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(.8),
                          Colors.black.withOpacity(.0),
                        ],
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget makeBestCategory({image, title}) {
    return AspectRatio(
      aspectRatio: 3 / 2.2,
      child: GestureDetector(
        onTap: () {
          Utils.navigateTo(
            context,
            CategoryPage(
              image: image,
              title: title,
              tag: title,
              category: title,
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              // Network Image with loading indicator
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // Image is fully loaded
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      ); // Show loading indicator
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ); // Show error icon if image fails to load
                  },
                ),
              ),
              // Gradient overlay and title
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(.8),
                      Colors.black.withOpacity(.0),
                    ],
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget productwidget({required ProductModel product}) {
    return AspectRatio(
      aspectRatio: 3 / 2.2,
      child: GestureDetector(
        onTap: () {
          Utils.navigateTo(
              context,
              ProductDetailScreen(
                  imageUrl: product.productImageUrls,
                  videoUrl: product.productvideourl,
                  title: product.title,
                  originalPrice: product.originalPrice,
                  price: product.discountprice,
                  rating: product.rating,
                  description: product.description,
                  id: product.id,
                  category: product.category,
                  color: product.color));
        },
        child: Container(
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              // Network Image with loading indicator
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.productImageUrls.first,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // Image is fully loaded
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      ); // Show loading indicator
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ); // Show error icon if image fails to load
                  },
                ),
              ),
              // Gradient overlay and title
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(.8),
                      Colors.black.withOpacity(.0),
                    ],
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '\$${product.discountprice}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
