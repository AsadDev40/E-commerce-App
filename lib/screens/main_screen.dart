import 'package:flutter/material.dart';
import 'package:myshop/Pages/shop_page.dart';
import 'package:myshop/screens/home_screen.dart';
import 'package:myshop/screens/profile_screen.dart';
import 'package:myshop/widgets/bottom_nav.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int _currentIndex = 0;
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> _buildScreen() {
    return [
      const HomeScreen(),
      const Shop(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: _buildScreen()[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
