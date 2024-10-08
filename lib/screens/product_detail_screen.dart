// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:myshop/models/product_model.dart';
import 'package:myshop/provider/product_provider.dart';
import 'package:myshop/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ProductDetailScreen extends StatefulWidget {
  final List<String> imageUrl;
  final String videoUrl; // Add videoUrl parameter
  final String title;
  final String originalPrice;
  final String price;
  final double rating;
  final String description;
  final String id;
  final String category;
  final String color;
  final int? quantity;

  const ProductDetailScreen(
      {super.key,
      required this.imageUrl,
      required this.videoUrl, // Initialize videoUrl
      required this.title,
      required this.originalPrice,
      required this.price,
      required this.rating,
      required this.description,
      required this.id,
      required this.category,
      this.quantity,
      required this.color});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Ensure the first frame is shown
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productprovider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display images and video using a carousel slider
            CarouselSlider.builder(
              itemCount: widget.imageUrl.length + 1, // Include the video
              itemBuilder: (context, index, realIndex) {
                if (index < widget.imageUrl.length) {
                  // Display image
                  return CachedNetworkImage(
                    imageUrl: widget.imageUrl[index],
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  );
                } else {
                  // Display video
                  return _videoController.value.isInitialized
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_videoController.value.isPlaying) {
                                _videoController.pause();
                              } else {
                                _videoController.play();
                              }
                            });
                          },
                          child: AspectRatio(
                            aspectRatio: _videoController.value.aspectRatio,
                            child: VideoPlayer(_videoController),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator());
                }
              },
              options: CarouselOptions(
                height: 300,
                enlargeCenterPage: true,
                autoPlay: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.price}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Text(
                    '(\$${widget.originalPrice})',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RatingStars(
                    value: widget.rating,
                    starSize: 24,
                    valueLabelColor: Colors.amber,
                    starColor: Colors.amber,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 110,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final newproduct = ProductModel(
                          id: widget.id,
                          title: widget.title,
                          category: widget.category,
                          description: widget.description,
                          productImageUrls: widget.imageUrl,
                          productvideourl: widget.videoUrl,
                          discountprice: widget.price,
                          originalPrice: widget.originalPrice,
                          rating: widget.rating,
                          color: widget.color,
                          quantity: widget.quantity);
                      await productprovider.addToCart(newproduct);
                      Utils.showToast('Product added to cart successfully');
                    },
                    style: ElevatedButton.styleFrom(),
                    child: const Text('Add to Cart'),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
