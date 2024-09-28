// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart'; // For better image loading
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myshop/provider/order_provider.dart';
import 'package:myshop/screens/order_detail_screen.dart';
import 'package:myshop/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:myshop/models/order_model.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future<void>? _fetchOrdersFuture;

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      _fetchOrdersFuture = orderProvider.fetchOrders(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Center(child: Text('User not logged in'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _fetchOrdersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final orderProvider = Provider.of<OrderProvider>(context);
            return orderProvider.orders.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: orderProvider.orders.length,
                    itemBuilder: (context, index) {
                      final order = orderProvider.orders[index];
                      return buildOrderCard(order, context);
                    },
                  )
                : buildEmptyState();
          }
        },
      ),
    );
  }
}

Widget buildOrderCard(OrderModel order, BuildContext context) {
  return Card(
    margin: const EdgeInsets.only(bottom: 16.0),
    elevation: 6.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: CachedNetworkImageProvider(order.images.first),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.productTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('yyyy-MM-dd').format(order.orderDate),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Custom Status Widget
              Container(
                height: 30,
                width: 100, // Fixed width
                decoration: BoxDecoration(
                  color: getStatusColor(order.status),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey, // Border color
                    width: 1, // Border width
                  ),
                ),
                child: Center(
                  child: Text(
                    order.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey[300]),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: \$${order.price}',
                style: const TextStyle(
                  color: Colors.purple,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 128, // Fixed width for button
                height: 35, // Fixed height for button
                child: ElevatedButton(
                  onPressed: () {
                    Utils.navigateTo(context, OrderDetailScreen(order: order));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Custom color for button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white), // Consistent font size
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// Function to get custom status colors
Color getStatusColor(String? status) {
  switch (status) {
    case 'Delivered':
      return Colors.green; // Custom color for Delivered status
    case 'Processing':
      return Colors.orange; // Custom color for Processing status
    case 'Shipped':
      return Colors.blue; // Custom color for Shipped status
    case 'Pending': // Add a new color for Pending status
      return Colors.purple; // Custom color for Pending status
    default:
      return Colors.grey; // Default color for unknown statuses
  }
}

Widget buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.shopping_bag_outlined,
          size: 100,
          color: Colors.grey,
        ),
        const SizedBox(height: 20),
        const Text(
          'No Orders Yet!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          'You haven\'t placed any orders yet.\nStart shopping now!',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Navigate to shopping page
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text('Start Shopping'),
        ),
      ],
    ),
  );
}
