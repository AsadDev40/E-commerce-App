import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myshop/models/product_model.dart';
import 'package:myshop/models/cart_model.dart';
import 'package:myshop/models/wishlist_model.dart';

class ProductProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Set<String> _wishlistIds = {};

  // Fetch products from Firestore
  Future<List<ProductModel>> fetchProducts() async {
    QuerySnapshot querySnapshot = await _firestore.collection('products').get();
    return querySnapshot.docs
        .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProductModel>> fetchProductsByCategory(String category) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .get();
    return querySnapshot.docs
        .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProductModel>> fetchProductsBysale(String sale) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection('products')
        .where('sale', isEqualTo: sale)
        .get();
    return querySnapshot.docs
        .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Add product to wishlist
  Future<void> addToWishlist(ProductModel product, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(product.id)
        .set(product.toJson());
    notifyListeners();
  }

  // Fetch wishlist products
// Fetch wishlist products
  Future<WishlistModel> fetchWishlist(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .get();

    List<ProductModel> products = querySnapshot.docs
        .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    return WishlistModel(id: userId, products: products);
  }

  Future<bool> isInWishlist(String productId, String userId) async {
    DocumentSnapshot docSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(productId)
        .get();

    return docSnapshot.exists;
  }

  Future<void> initializeWishlistIds(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .get();
    _wishlistIds = querySnapshot.docs.map((doc) => doc.id).toSet();
    notifyListeners();
  }

  bool isInWishlistLocal(String productId) {
    return _wishlistIds.contains(productId);
  }

  Future<void> toggleWishlist(ProductModel product, String userId) async {
    bool isInWishlist = isInWishlistLocal(product.id);
    if (isInWishlist) {
      // Remove from wishlist
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(product.id)
          .delete();
      _wishlistIds.remove(product.id);
    } else {
      // Add to wishlist
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(product.id)
          .set(product.toJson());
      _wishlistIds.add(product.id);
    }
    notifyListeners();
  }

  // Delete product from wishlist
  Future<void> deleteFromWishlist(String productId, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(productId)
        .delete();
    notifyListeners();
  }

  // Add product to cart locally using SharedPreferences and CartModel
  Future<void> addToCart(ProductModel product) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    CartModel currentCart = await fetchCart(); // Get existing cart

    // Check if product already exists in cart
    if (!currentCart.products.any((p) => p.id == product.id)) {
      currentCart.products.add(product); // Add new product to cart
      await prefs.setString(
          'cart',
          jsonEncode(
              currentCart.toJson())); // Save updated cart in shared preferences
    }
    notifyListeners();
  }

  // Fetch cart from SharedPreferences using CartModel
  Future<CartModel> fetchCart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartJson = prefs.getString('cart');

    if (cartJson != null) {
      return CartModel.fromJson(jsonDecode(cartJson));
    } else {
      return CartModel(
          products: []); // Return an empty cart if no data is stored
    }
  }

  // Delete product from cart locally using SharedPreferences and CartModel
  Future<void> deleteFromCart(String productId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    CartModel currentCart = await fetchCart();

    // Remove the product with the matching ID
    currentCart.products.removeWhere((product) => product.id == productId);
    await prefs.setString(
        'cart',
        jsonEncode(
            currentCart.toJson())); // Save updated cart in shared preferences
    notifyListeners();
  }

  // Clear entire cart from SharedPreferences
  Future<void> clearCart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart');
    notifyListeners();
  }
}
