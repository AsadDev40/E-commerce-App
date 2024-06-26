import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Pages/CategoryPage.dart';
import 'package:myshop/Pages/ShopPage.dart';
import 'package:myshop/Pages/cart_page.dart';
import 'package:myshop/Pages/wishlist.dart';
import 'package:myshop/screens/category_screen.dart';
import 'package:myshop/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
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
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            makeCategory(
                                image: 'assets/images/beauty.jpg',
                                title: 'Beauty',
                                tag: 'beauty'),
                            makeCategory(
                                image: 'assets/images/clothes.jpg',
                                title: 'Clothes',
                                tag: 'clothes'),
                            makeCategory(
                                image: 'assets/images/perfume.jpg',
                                title: 'Perfume',
                                tag: 'perfume'),
                            makeCategory(
                                image: 'assets/images/glass.jpg',
                                title: 'Glass',
                                tag: 'glass'),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Best Selling by Category",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text("All")
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            makeBestCategory(
                                image: 'assets/images/tech.jpg', title: 'Tech'),
                            makeBestCategory(
                                image: 'assets/images/watch.jpg',
                                title: 'Watch'),
                            makeBestCategory(
                                image: 'assets/images/perfume.jpg',
                                title: 'Perfume'),
                            makeBestCategory(
                                image: 'assets/images/glass.jpg',
                                title: 'Glass'),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget makeCategory({image, title, tag}) {
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
                        )));
          },
          child: Material(
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage(image), fit: BoxFit.cover)),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient:
                        LinearGradient(begin: Alignment.bottomRight, colors: [
                      Colors.black.withOpacity(.8),
                      Colors.black.withOpacity(.0),
                    ])),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
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
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image:
                DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
                Colors.black.withOpacity(.8),
                Colors.black.withOpacity(.0),
              ])),
          child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )),
        ),
      ),
    );
  }
}
