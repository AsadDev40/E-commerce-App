import 'package:flutter/material.dart';
import 'package:myshop/provider/auth_provider.dart';
import 'package:myshop/provider/category_provider.dart';
import 'package:myshop/provider/file_upload_provider.dart';
import 'package:myshop/provider/image_picker.dart';
import 'package:myshop/provider/order_provider.dart';
import 'package:myshop/provider/product_provider.dart';

import 'package:provider/provider.dart';

class AppProvider extends StatelessWidget {
  const AppProvider({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ImagePickerProvider()),
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProvider(create: (context) => FileUploadProvider()),
          ChangeNotifierProvider(create: (context) => ProductProvider()),
          ChangeNotifierProvider(create: (context) => CategoryProvider()),
          ChangeNotifierProvider(create: (context) => OrderProvider()),
        ],
        child: child,
      );
}
