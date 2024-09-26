import 'package:flutter/material.dart';
import 'package:myshop/models/card_model.dart';
import 'package:myshop/models/product_model.dart';
import 'package:myshop/payment/body.dart';
import 'package:myshop/payment/res.dart';

class PaymentPage extends StatelessWidget {
  final double totalPayment; // Dynamic total payment
  final List<ProductModel> product;

  const PaymentPage(
      {Key? key, required this.totalPayment, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PayCard> payments = Res.getPaymentTypes();
    for (var element in payments) {
      print(element.title);
    }
    return Scaffold(
      appBar: payActionbar(),
      body: Column(
        children: [
          creditcardImage(),
          choosePaymentType(totalPayment: totalPayment, product: product),
        ],
      ),
    );
  }
}
