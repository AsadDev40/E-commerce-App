import 'package:myshop/models/card_model.dart';
import 'package:myshop/models/product_model.dart';

class Res {
  static const String lamp = "assets/images/lamp.png";
  static const String chair = "assets/images/chair.png";
  static const String sofa = "assets/images/sofa.png";
  static const String table = "assets/images/table.png";
  static const String table1 = "assets/images/table_1.png";

  static List<Product> fetchProducts() {
    List<Product> productList = [];
    String description =
        "A product description is the marketing copy that explains what a product is and why it’s worth purchasing. The purpose of a product description is to supply customers with important information about the features and benefits of the product so they’re compelled to buy";
    productList.add(Product(
        imageUrl: Res.sofa,
        title: "Sofa",
        price: 5000.0,
        originalPrice: 5500.0, // Assuming original price is slightly higher
        rating: 4.5,
        description: description));
    productList.add(Product(
        imageUrl: Res.table,
        title: "Table",
        price: 4000.0,
        originalPrice: 4500.0, // Assuming original price is slightly higher
        rating: 4.7,
        description: description));
    productList.add(Product(
        imageUrl: Res.lamp,
        title: "Lamp",
        price: 500.0,
        originalPrice: 600.0, // Assuming original price is slightly higher
        rating: 4.2,
        description: description));
    productList.add(Product(
        imageUrl: Res.chair,
        title: "Chair",
        price: 500.0,
        originalPrice: 650.0, // Assuming original price is slightly higher
        rating: 4.8,
        description: description));
    productList.add(Product(
        imageUrl: Res.table1,
        title: "Reading Table",
        price: 500.0,
        originalPrice: 700.0, // Assuming original price is slightly higher
        rating: 4.3,
        description: description));
    return productList;
  }

  static List<PayCard> getPaymentTypes() {
    List<PayCard> cards = [];
    cards.add(PayCard(
        title: "Net Banking",
        description: "Pay bill using card",
        image: "assets/images/paycard.png"));
    cards.add(PayCard(
        title: "Credit Card",
        description: "Pay bill using card",
        image: "assets/images/paycard.png"));
    cards.add(PayCard(
        title: "Debit Card",
        description: "Pay bill using card",
        image: "assets/images/paycard.png"));
    cards.add(PayCard(
        title: "Wallet pay",
        description: "Pay bill using card",
        image: "assets/images/paycard.png"));
    return cards;
  }
}
