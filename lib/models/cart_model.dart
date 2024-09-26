import 'package:myshop/models/product_model.dart';

class CartModel {
  final List<ProductModel> products;

  CartModel({required this.products});

  // Convert CartModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'products': products.map((product) => product.toJson()).toList(),
    };
  }

  // Create CartModel from JSON
  static CartModel fromJson(Map<String, dynamic> json) {
    return CartModel(
      products: (json['products'] as List<dynamic>)
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  // Update product quantity by ID
  void updateProductQuantity(String productId, int quantity) {
    final productIndex = products.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      products[productIndex].quantity = quantity;
    }
  }
}
