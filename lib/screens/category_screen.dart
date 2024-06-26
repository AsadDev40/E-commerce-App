import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
  final List<Map<String, String>> categories = [
    {'title': 'Beauty', 'tag': 'beauty', 'image': 'assets/images/beauty.jpg'},
    {
      'title': 'Clothes',
      'tag': 'clothes',
      'image': 'assets/images/clothes.jpg'
    },
    {
      'title': 'Clothes',
      'tag': 'clothes',
      'image': 'assets/images/clothes.jpg'
    },
    {'title': 'Glass', 'tag': 'glass', 'image': 'assets/images/glass.jpg'},
    {
      'title': 'Perfume',
      'tag': 'perfume',
      'image': 'assets/images/perfume.jpg'
    },
    {'title': 'Watch', 'tag': 'watch', 'image': 'assets/images/watch.jpg'},
    {
      'title': 'Fashion',
      'tag': 'fashion',
      'image': 'assets/images/background.jpg'
    },
    {
      'title': 'Clothes',
      'tag': 'clothes',
      'image': 'assets/images/clothes.jpg'
    },
    // Add more categories as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 5, // Space between items horizontally
          mainAxisSpacing: 5, // Space between items vertically
          childAspectRatio: 1 / 1, // Aspect ratio of the tiles
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: makeCategory(
              image: categories[index]['image']!,
              title: categories[index]['title']!,
              tag: categories[index]['tag']!,
            ),
          );
        },
      ),
    );
  }

  Widget makeCategory(
      {required String image, required String title, required String tag}) {
    return AspectRatio(
      aspectRatio: 2 / 2,
      child: Hero(
        tag: tag,
        child: GestureDetector(
          onTap: () {
            // Navigate to a detailed page or perform another action
          },
          child: Material(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage(image), fit: BoxFit.cover)),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient:
                        LinearGradient(begin: Alignment.bottomRight, colors: [
                      Colors.black.withOpacity(.8),
                      Colors.black.withOpacity(.0),
                    ])),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
