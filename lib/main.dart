import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:myshop/homepage_transition/homepage.dart';
import 'package:myshop/screens/main_screen.dart';
import 'package:myshop/services/app_provider.dart';
import 'package:myshop/widgets/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active &&
                snapshot.hasData) {
              return const Mainscreen();
            } else {
              return const HomePage();
            }
          },
        ),
        builder: EasyLoading.init(),
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: PrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
      ),
    );
  }
}
