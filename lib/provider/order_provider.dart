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
      // Step 1: Add new order to Firestore and get document reference
      DocumentReference docRef = await orderCollection.add(newOrder.toJson());

      // Step 2: Update the order object with the generated Firestore document ID
      OrderModel updatedOrder = newOrder.copyWith(orderId: docRef.id);

      // Step 3: Add the updated order to the local orders list
      _orders.add(updatedOrder);

      // Step 4: Notify the listeners/UI that the list has been updated
      notifyListeners();
    } catch (e) {
      print('Error adding order to Firestore: $e');
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
      notifyListeners(); // Notify UI of changes
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  // Function to remove an order from Firestore and local list
  Future<void> removeOrder(String orderId) async {
    try {
      await orderCollection.doc(orderId).delete();
      _orders.removeWhere((order) => order.orderId == orderId);
      notifyListeners(); // Notify UI of changes
    } catch (e) {
      print('Error removing order: $e');
    }
  }

  // Function to update the status of an order in Firestore and locally
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final orderIndex = _orders.indexWhere((order) => order.orderId == orderId);
    if (orderIndex != -1) {
      try {
        // Update in Firestore
        await orderCollection.doc(orderId).update({'status': newStatus});
        // Update locally
        _orders[orderIndex] = _orders[orderIndex].copyWith(status: newStatus);
        notifyListeners(); // Notify UI of changes
      } catch (e) {
        print('Error updating order status: $e');
      }
    }
  }

  // Clear all orders (if needed)
  void clearOrders() {
    _orders.clear();
    notifyListeners(); // Notify UI of changes
  }
}
