// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:myshop/Pages/payment_page.dart';
import 'package:myshop/utils/utils.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class CartList extends StatefulWidget {
  const CartList({super.key});

  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Perfume',
      'rating': 3.0,
      'image': 'assets/images/perfume.jpg',
      'price': '200'
    },
    {
      'name': 'Watch',
      'rating': 3.0,
      'image': 'assets/images/watch.jpg',
      'price': '200'
    },
    {
      'name': 'Sun Glass',
      'rating': 4.0,
      'image': 'assets/images/glass.jpg',
      'price': '200'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              "${products.length} ITEMS IN YOUR CART",
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final item = products[index];
                return Dismissible(
                  key: Key(item['name']),
                  onDismissed: (direction) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          direction == DismissDirection.endToStart
                              ? "${item['name']} dismissed"
                              : "${item['name']} added to cart",
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                    setState(() {
                      products.removeAt(index);
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.all(5.0),
                    alignment: AlignmentDirectional.centerStart,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.all(5.0),
                    alignment: AlignmentDirectional.centerEnd,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      print('Card tapped.');
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Container(
                        width: 56.0,
                        height: 56.0,
                        color: Colors.blue,
                        child: Image.asset(
                          item['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(item['name'],
                        style: const TextStyle(fontSize: 14)),
                    subtitle: Text(
                      'In stock',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    trailing: Text('\$${item['price']}'),
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "TOTAL",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                      Text(
                        "\$41.24",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child:
                              Text("Subtotal", style: TextStyle(fontSize: 14))),
                      Text("\$36.00",
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child:
                              Text("Shipping", style: TextStyle(fontSize: 14))),
                      Text("\$2.00",
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text("Tax", style: TextStyle(fontSize: 14))),
                      Text("\$3.24",
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: ElevatedButton(
              onPressed: () {
                Utils.navigateTo(context, const PaymentPage());
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40.0),
              ),
              child: const Text(
                "CHECKOUT",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
