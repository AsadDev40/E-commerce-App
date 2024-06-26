import 'package:flutter/material.dart';
import 'package:myshop/models/card_model.dart';
import 'package:myshop/payment/body.dart';
import 'package:myshop/payment/res.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<PayCard> payemnts = Res.getPaymentTypes();
    for (var element in payemnts) {
      print(element.title);
    }
    return Scaffold(
      appBar: payActionbar(),
      body: Column(
        children: [
          creditcardImage(),
          choosePaymentType(),
        ],
      ),
    );
  }
}
