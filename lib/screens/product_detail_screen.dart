import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class ProductDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;
  final double originalPrice;
  final double rating;
  final String description;

  const ProductDetailScreen(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.originalPrice,
      required this.rating,
      required this.description,
      required this.price});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 260,
                child: Hero(
                  tag: imageUrl,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: imageUrl,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text(
                                  '\$$price',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                '\$$originalPrice',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              RatingStars(
                                value: rating,
                                starSize: 16,
                                valueLabelColor: Colors.amber,
                                starColor: Colors.amber,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              'Description',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              description,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
