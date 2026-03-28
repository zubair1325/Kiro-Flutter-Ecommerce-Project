import 'package:ecommerce/presentation/controller/auth_controller.dart';
import 'package:ecommerce/presentation/ui/screens/authentication/login_screen.dart';
import 'package:ecommerce/presentation/ui/utility/snack_message.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

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
        child: TextButton(
          onPressed: () {
            AuthController.singOut();
            showSnackMessage(context, "Logged out Success");
            Get.offAll(() => LoginScreen());
          },
          child: Text("Log Out"),
        ),
      ),
    );
  }
}
