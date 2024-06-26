import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:myshop/payment/close_activity.dart';

Container choosePaymentType() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose payemnt method',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 20),
        paymenOptions(),
        const SizedBox(height: 30),
        const Text(
          'Promo Code',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 20),
        promoCodeWidget(),
        const SizedBox(height: 120),
        const Row(
          children: [
            Text(
              'Total payment',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            Spacer(),
            Text(
              '\$500.99',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: 45,
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              side: BorderSide(width: 2, color: Colors.grey.shade500),
            ),
            onPressed: () {
              Get.snackbar("Processing", 'Payment is processing',
                  animationDuration: const Duration(seconds: 2));
            },
            child: const Text(
              'PAY',
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    ),
  );
}

Row paymenOptions() {
  return const Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CircleAvatar(
          maxRadius: 25, child: FaIcon(FontAwesomeIcons.amazonPay, size: 35)),
      FaIcon(FontAwesomeIcons.ccVisa, size: 35),
      FaIcon(FontAwesomeIcons.paypal, size: 35),
      FaIcon(FontAwesomeIcons.apple, size: 35),
      // ignore: deprecated_member_use
      FaIcon(FontAwesomeIcons.donate, size: 35),
    ],
  );
}

Padding creditcardImage() {
  return Padding(
    padding: const EdgeInsets.all(30),
    child: Container(
      padding: const EdgeInsets.all(20),
      height: 200,
      width: double.infinity,
      decoration: creditcardDecoration(),
      child: creditCardView(),
    ),
  );
}

AppBar payActionbar() {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    leading: closeActivity(),
  );
}

Container promoCodeWidget() {
  return Container(
    width: double.infinity,
    height: 40,
    clipBehavior: Clip.none,
    decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: const BorderRadius.all(Radius.circular(20))),
    child: Align(
      alignment: Alignment.centerRight,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          side: const BorderSide(width: 2, color: Colors.black),
        ),
        onPressed: () {},
        child: const Text(
          'Apply',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}

Column creditCardView() {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Credit Card',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      Spacer(),
      Text(
        '3709 4378 5546 8899',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      SizedBox(height: 10),
      Row(
        children: [
          Text(
            'Muhammad Asad',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Spacer(),
          Icon(
            Icons.ac_unit_outlined,
          )
        ],
      )
    ],
  );
}

BoxDecoration creditcardDecoration() {
  return BoxDecoration(
      color: Colors.grey.shade800,
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ));
}
