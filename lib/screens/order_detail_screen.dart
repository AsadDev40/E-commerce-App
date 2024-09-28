// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors_in_immutables, use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:intl/intl.dart';
import 'package:myshop/models/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel order;

  OrderDetailScreen({super.key, required this.order});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  double _userRating = 0.0;
  bool _isRatingSubmitted = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkRatingStatus();
  }

  // Method to check if the rating has been submitted for this product by the user
  void _checkRatingStatus() async {
    String userId = _auth.currentUser!.uid;
    String productId = widget.order.productId;

    // Fetch the rating status from Firebase
    DocumentSnapshot ratingDoc = await _firestore
        .collection('ratings')
        .doc(userId)
        .collection('user_ratings')
        .doc(productId)
        .get();

    if (ratingDoc.exists) {
      setState(() {
        _isRatingSubmitted = ratingDoc['submitted'] ?? false;
        _userRating = ratingDoc['rating']?.toDouble() ?? 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Carousel at the top
              buildCarousel(widget.order),

              const SizedBox(height: 16.0),

              // Order Details (Info Cards)
              buildInfoCard(
                Icons.shopping_cart,
                'Order Title',
                widget.order.productTitle,
              ),
              buildInfoCard(
                Icons.calendar_today,
                'Order Date',
                DateFormat('yyyy-MM-dd').format(widget.order.orderDate),
              ),
              buildInfoCard(
                Icons.attach_money,
                'Total Price',
                '\$${widget.order.price}',
              ),
              buildInfoCard(
                Icons.info_outline,
                'Order Status',
                widget.order.status,
              ),

              const SizedBox(height: 16.0),

              // Rating Section (only if not submitted and order is delivered)
              if (!_isRatingSubmitted && widget.order.status == 'Delivered')
                buildRatingSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build info cards
  Widget buildInfoCard(IconData icon, String label, String value) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.purple, size: 28),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  // Helper method to build the image carousel
  Widget buildCarousel(OrderModel order) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 250.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.easeInOut,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
      ),
      items: order.images.map((imageUrl) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  // Build the rating section
  Widget buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Rate this Product:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        RatingStars(
          value: _userRating,
          onValueChanged: (v) {
            setState(() {
              _userRating = v;
            });
          },
          starBuilder: (index, color) => Icon(
            Icons.star,
            color: color,
            size: 30,
          ),
          starCount: 5,
          starSize: 30,
          valueLabelColor: const Color(0xff9b9b9b),
          valueLabelTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 12.0,
          ),
          valueLabelRadius: 10,
          maxValue: 5,
          starSpacing: 2,
          maxValueVisibility: true,
          valueLabelVisibility: true,
          animationDuration: const Duration(milliseconds: 1000),
          valueLabelPadding:
              const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
          valueLabelMargin: const EdgeInsets.only(right: 8),
          starOffColor: const Color(0xffe7e8ea),
          starColor: Colors.amber,
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            // Submit rating and update product's overall rating
            submitRating(widget.order.productId, _userRating);
          },
          child: const Text('Submit Rating'),
        ),
      ],
    );
  }

  // Method to submit the rating and save the rating status in Firebase
  void submitRating(String productId, double rating) async {
    String userId = _auth.currentUser!.uid;

    // Save the rating and submission status in Firebase
    await _firestore
        .collection('ratings')
        .doc(userId)
        .collection('user_ratings')
        .doc(productId)
        .set({
      'rating': rating,
      'submitted': true,
    });

    // Show a snackbar message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rating submitted successfully!')),
    );

    // Hide the rating section after submission
    setState(() {
      _isRatingSubmitted = true;
    });
  }
}
