import 'package:ecommerce/presentation/controller/auth_controller.dart';
import 'package:ecommerce/presentation/state_holders/main_bottom_nav_controller.dart';
import 'package:ecommerce/presentation/ui/screens/authentication/login_screen.dart';
import 'package:ecommerce/presentation/ui/screens/cart/cart_screen.dart';
import 'package:ecommerce/presentation/ui/screens/categorie/category_screen.dart';
import 'package:ecommerce/presentation/ui/screens/home/home_screen.dart';
import 'package:ecommerce/presentation/ui/screens/menu/menu_screen.dart';
import 'package:ecommerce/presentation/ui/screens/wishlist/wishlist_screen.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  final List<Widget> _selectedScreen = [
    const CategoryScreen(),
    AuthController.userLoginStatus
        ? const WishlistScreen()
        : const LoginScreen(),
    const HomeScreen(),
    AuthController.userLoginStatus
        ? const CartScreen()
        : const LoginScreen(),
    const MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainBottomNavController>(
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            body: _selectedScreen[controller.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: controller.currentIndex,
              selectedItemColor: AppColors.primaryColor,
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,

              onTap: controller.changeIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: "Categories",
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.gif_box_outlined),
                  label: "Wish List",
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
      },
    );
  }
}
