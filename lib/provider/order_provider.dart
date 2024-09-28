import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myshop/models/order_model.dart';

class OrderProvider with ChangeNotifier {
  // Firestore collection reference for orders
  final CollectionReference orderCollection =
      FirebaseFirestore.instance.collection('orders');

  // List to hold orders
  List<OrderModel> _orders = [];

  // Getter to retrieve the orders list
  List<OrderModel> get orders => _orders;

  // Function to add a new order to Firestore and local list
  Future<void> addOrder(OrderModel newOrder) async {
    try {
      DocumentReference docRef = await orderCollection.add(newOrder.toJson());

      OrderModel updatedOrder = newOrder.copyWith(orderId: docRef.id);

      _orders.add(updatedOrder);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Function to fetch all orders from Firestore for a specific user
  Future<void> fetchOrders(String userId) async {
    try {
      QuerySnapshot snapshot =
          await orderCollection.where('customerId', isEqualTo: userId).get();
      _orders = snapshot.docs
          .map((doc) => OrderModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Function to remove an order from Firestore and local list
  Future<void> removeOrder(String orderId) async {
    try {
      await orderCollection.doc(orderId).delete();
      _orders.removeWhere((order) => order.orderId == orderId);
      notifyListeners(); // Notify UI of changes
    } catch (e) {
      rethrow;
    }
  }

  // Function to update the status of an order in Firestore and locally
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final orderIndex = _orders.indexWhere((order) => order.orderId == orderId);
    if (orderIndex != -1) {
      try {
        await orderCollection.doc(orderId).update({'status': newStatus});
        _orders[orderIndex] = _orders[orderIndex].copyWith(status: newStatus);
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }

  // Clear all orders (if needed)
  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }

  Future<void> addProductRating(String productId, double newRating) async {
    final productDoc = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();

    if (productDoc.exists) {
      final currentRatings = productDoc.data()?['rating'] ?? [];
      currentRatings.add(newRating);

      // Calculate the new average rating
      double totalRating = 0;
      for (double rating in currentRatings) {
        totalRating += rating;
      }
      double averageRating = totalRating / currentRatings.length;

      // Update the product's rating in Firestore
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .update({
        'rating': currentRatings,
        'averageRating': averageRating,
      });
    }
  }
}
