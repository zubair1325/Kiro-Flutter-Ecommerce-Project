import 'package:ecommerce/presentation/controller/auth_controller.dart';
import 'package:ecommerce/presentation/ui/screens/authentication/login_screen.dart';
import 'package:ecommerce/presentation/ui/screens/menu/login_state.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AuthController.userLoginStatus
            ? const LoginState()
            : const LoginScreen(),
      ),
    );
  }
}
