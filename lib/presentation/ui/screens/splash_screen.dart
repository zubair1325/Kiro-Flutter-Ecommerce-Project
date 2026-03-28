import 'package:ecommerce/presentation/controller/auth_wrapper.dart';
import 'package:ecommerce/presentation/ui/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.offAll(AuthWrapper());
  }

  @override
  void initState() {
    super.initState();
    moveToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Spacer(),
              AppLogo(width: 120),
              Spacer(),
              CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                "Version 1.0.0",
                // style: TextStyle(fontWeight: FontWeight.w100),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
// Kiro