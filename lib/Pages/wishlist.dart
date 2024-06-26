import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class WishList extends StatefulWidget {
  const WishList({super.key});

  @override
  WishlistState createState() => WishlistState();
}

class WishlistState extends State<WishList> {
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Perfume',
      'rating': 3.0,
      'image': 'assets/images/perfume.jpg',
    },
    {
      'name': 'Glass',
      'rating': 3.0,
      'image': 'assets/images/glass.jpg',
    },
    {
      'name': 'Watch',
      'rating': 4.0,
      'image': 'assets/images/watch.jpg',
    },
    {
      'name': 'Clothes',
      'rating': 5.0,
      'image': 'assets/images/clothes.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final item = products[index];
          return Dismissible(
            key: Key(UniqueKey().toString()),
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("${item['name']} dismissed"),
                    duration: const Duration(seconds: 1)));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("${item['name']} added to cart"),
                    duration: const Duration(seconds: 1)));
              }
              setState(() {
                products.removeAt(index);
              });
            },
            background: Container(
              decoration: const BoxDecoration(color: Colors.green),
              padding: const EdgeInsets.all(5.0),
              child: const Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Icon(Icons.add_shopping_cart, color: Colors.white),
                  ),
                ],
              ),
            ),
            secondaryBackground: Container(
              decoration: const BoxDecoration(color: Colors.red),
              padding: const EdgeInsets.all(5.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ],
              ),
            ),
            child: InkWell(
              onTap: () {
                print('Card tapped.');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Divider(
                    height: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: ListTile(
                      trailing: const Icon(Icons.swap_horiz),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                          width: 56.0,
                          height: 56.0,
                          decoration: const BoxDecoration(color: Colors.blue),
                          child: Image.asset(
                            item['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        item['name'],
                        style: const TextStyle(fontSize: 14),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 2.0, bottom: 1),
                                child: Text('\$200',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 6.0),
                                child: Text('(\$400)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey,
                                        decoration:
                                            TextDecoration.lineThrough)),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              RatingStars(
                                value: item['rating'],
                                starSize: 16,
                                valueLabelColor: Colors.amber,
                                starColor: Colors.amber,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
