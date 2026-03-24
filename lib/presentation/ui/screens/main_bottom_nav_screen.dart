import 'package:ecommerce/presentation/ui/screens/cart_screen.dart';
import 'package:ecommerce/presentation/ui/screens/category_screen.dart';
import 'package:ecommerce/presentation/ui/screens/home_screen.dart';
import 'package:ecommerce/presentation/ui/screens/menu_screen.dart';
import 'package:ecommerce/presentation/ui/screens/offer_screen.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:flutter/material.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  final List<Widget> _selectedScreen = const [
    CategoryScreen(),
    OfferScreen(),
    HomeScreen(),
    CartScreen(),
    MenuScreen(),
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _selectedScreen[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,

          onTap: (index) {
            _selectedIndex = index;
            if (mounted) {
              setState(() {});
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Categories",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.discount_sharp),
              label: "Eid Offer",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_travel),
              label: "Cart(0)",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu"),
          ],
        ),
      ),
    );
  }
}
